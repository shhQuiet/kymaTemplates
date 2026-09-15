| findInput filterTemplate oscillatorTemplate levelTemplate delayTemplate initializerTemplate
  noteSlot motion master brightness depth resonance width
  delaySeconds feedback wet outputFade on fadeLevel clearNotes noteTrigger noteCount |

"Resolve exact role names; input order does not matter."
findInput := [:requiredName |
    | matches |
    matches := inputs select: [:candidate |
        candidate name printString = requiredName].
    (matches size = 1) ifFalse: [
        self debugWithLabel: ('Expected exactly one input named ', requiredName)
            value: matches size.
        self abortForKyma].
    matches at: 1
].

initializerTemplate := findInput value: 'Initializer'.
filterTemplate := findInput value: 'VCF'.
oscillatorTemplate := findInput value: 'Oscillator'.
levelTemplate := findInput value: 'Level'.
delayTemplate := findInput value: 'DelayWithFeedback'.

"Initialize each control once, then allow live VCS adjustment."
initializerTemplate start: 0 s event: !DroneOn value: 1.
initializerTemplate start: 0 s event: !DroneLevel value: 0.5.
initializerTemplate start: 0 s event: !DroneMotion value: 0.2.
initializerTemplate start: 0 s event: !DroneResonance value: 0.41.
initializerTemplate start: 0 s event: !DroneFeedback value: 0.71.
initializerTemplate start: 0 s event: !DroneWet value: 0.5.
initializerTemplate start: 0 s event: !DroneWidth value: 0.8.

"Supply physical controls directly: Hz and seconds."
initializerTemplate start: 0 s
    event: !DroneBrightness
    value: 180.
initializerTemplate start: 0 s
    event: !DroneDepth
    value: 500.
initializerTemplate start: 0 s
    event: !DroneDelay
    value: 1.8.

"Clear the note slots only after the six-second fade reaches silence."
on := !DroneOn gt: 0.5.
fadeLevel := on smooth: 6 s.
clearNotes := (1 - on) * (fadeLevel le: 0.0001).

"Accept fresh note-ons only while the drone is enabled."
noteTrigger := (!KeyDown switchedOn) * on.
noteCount := noteTrigger countTriggersReset: clearNotes.
noteSlot := (noteCount - 1) mod: 3.
"Relative controls use 0-1; frequency is Hz and delay is seconds."
motion := 20 + (100 * ((!DroneMotion vmax: 0) vmin: 1)).
master := (0.7 * ((!DroneLevel vmax: 0) vmin: 1))
    smooth: 0.3 s.
brightness := (!DroneBrightness vmax: 40) smooth: 0.3 s.
depth := (!DroneDepth vmax: 0) smooth: 0.3 s.
resonance := (0.85 * ((!DroneResonance vmax: 0) vmin: 1))
    smooth: 0.3 s.
delaySeconds := (!DroneDelay vmax: 0.1) vmin: 3.
feedback := (0.7 * ((!DroneFeedback vmax: 0) vmin: 1))
    smooth: 0.3 s.
wet := (0.6 * ((!DroneWet vmax: 0) vmin: 1)) smooth: 0.3 s.

width := ((!DroneWidth vmax: 0) vmin: 1) smooth: 0.3 s.

"Keep all output silent after clearing until a new MIDI note arrives."
outputFade := fadeLevel * (noteCount gt: 0).

"Three note slots, each with two alternating voices for crossfades."
1 to: 3 do: [:i |
    | phase cycle breath drift pan capture bank hasNote slotCount
      cutoff voiceGain leftGain rightGain |

    phase := (i - 1) / 3.
    capture := (noteSlot eq: (i - 1)) * noteTrigger.
    slotCount := capture countTriggersReset: clearNotes.
    bank := slotCount mod: 2.
    hasNote := slotCount gt: 0.

    cycle := 1 repeatingRamp: (motion * (1 + (i * 0.17))) s.
    breath := (1 - ((2 * Double pi * (cycle + phase)) cos)) * 0.5.

    drift := (2 * Double pi *
        ((1 repeatingRamp: (motion * (0.31 + (i * 0.07))) s)
            + phase)) cos.

    pan := (1 - ((2 * Double pi *
        ((1 repeatingRamp: (motion * (1.4 + (i * 0.23))) s)
            + phase)) cos)) * 0.5.

    cutoff := (brightness + (depth * breath)) vmax: 40.
    voiceGain := 1.25 * master * (0.45 + (0.55 * breath)).
    leftGain := voiceGain * (0.5 + (width * (0.5 - pan))).
    rightGain := voiceGain * (0.5 + (width * (pan - 0.5))).

    0 to: 1 do: [:j |
        | bankCapture capturedNote fade pitch oscillator filtered voice echoInput echoes |

        bankCapture := capture * (bank eq: j).
        capturedNote := bankCapture sampleAndHold: !KeyNumber.

        "Fade amplitude, not pitch. The other bank keeps its old note."
        fade := (hasNote * (bank eq: j)) smooth: 0.7 s.
        pitch := (capturedNote + (0.026 * drift)) nn.

        oscillator := oscillatorTemplate
            wave: 'Saw0064.aif'
            index: 0
            amp: (0.15 * fade)
            freq: pitch
            formant: 1
            maxMI: 0
            reset: 0.

        filtered := filterTemplate
            source: oscillator
            amp: 1
            cutoff: cutoff hz
            modRange: 0 hz
            modulator: oscillator
            resonance: resonance.

        voice := levelTemplate
            source: filtered
            left: leftGain
            right: rightGain.

        "Feed the echoes with the opposite stereo placement."
        echoInput := levelTemplate
            source: filtered
            left: rightGain
            right: leftGain.

        echoes := delayTemplate
            source: echoInput
            maxDelay: 3 s
            scale: 1
            slewRate: 1
            delayFraction: (delaySeconds * (0.5 + (i / 6)) / 3)
            feedback: feedback.

        levelTemplate start: 0 s
            source: voice
            left: outputFade
            right: outputFade.

        levelTemplate start: 0 s
            source: echoes
            left: (wet * outputFade)
            right: (wet * outputFade).
    ].
].
