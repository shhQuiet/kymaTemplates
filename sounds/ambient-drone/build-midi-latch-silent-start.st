| filterTemplate oscillatorTemplate levelTemplate delayTemplate initializerTemplate
  noteSlot motion master brightness depth resonance
  delaySeconds feedback wet |

filterTemplate := inputs at: 1.
oscillatorTemplate := inputs at: 2.
levelTemplate := inputs at: 3.
delayTemplate := inputs at: 4.
initializerTemplate := inputs at: 5.

"Initialize each control once, then allow live VCS adjustment."
initializerTemplate start: 0 s event: !DroneLevel value: 0.5.
initializerTemplate start: 0 s event: !DroneMotion value: 0.2.
initializerTemplate start: 0 s event: !DroneResonance value: 0.41.
initializerTemplate start: 0 s event: !DroneFeedback value: 0.71.
initializerTemplate start: 0 s event: !DroneWet value: 0.5.

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

"MIDI note-ons replace the three drone pitches in rotation."
noteSlot := !KeyDown nextIndexMod: 3.
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

"Start silent. Each slot sounds only after receiving its first MIDI note."
1 to: 3 do: [:i |
    | phase cycle breath drift pan oscillator cutoff filtered
      voice leftGain rightGain echoes capture capturedNote hasNote pitch |

    phase := (i - 1) / 3.

    capture := (noteSlot eq: (i - 1)) * (!KeyDown gt: 0).
    capturedNote := capture sampleAndHold: !KeyNumber.
    hasNote := capture countTriggers gt: 0.

    cycle := 1 repeatingRamp: (motion * (1 + (i * 0.17))) s.
    breath := (1 - ((2 * Double pi * (cycle + phase)) cos)) * 0.5.

    drift := (2 * Double pi *
        ((1 repeatingRamp: (motion * (0.31 + (i * 0.07))) s)
            + phase)) cos.

    pan := (1 - ((2 * Double pi *
        ((1 repeatingRamp: (motion * (1.4 + (i * 0.23))) s)
            + phase)) cos)) * 0.5.

    pitch := ((capturedNote smooth: 0.3 s) + (0.026 * drift)) nn.

    oscillator := oscillatorTemplate
        wave: 'Saw0064.aif'
        index: 0
        amp: ((0.15 * hasNote) smooth: 0.3 s)
        freq: pitch
        formant: 1
        maxMI: 0
        reset: 0.

    cutoff := (brightness + (depth * breath)) vmax: 40.

    filtered := filterTemplate
        source: oscillator
        amp: 1
        cutoff: cutoff hz
        modRange: 0 hz
        modulator: oscillator
        resonance: resonance.

    leftGain := master * (0.45 + (0.55 * breath)) *
        (0.25 + (0.75 * (1 - pan))).
    rightGain := master * (0.45 + (0.55 * breath)) *
        (0.25 + (0.75 * pan)).

    voice := levelTemplate
        source: filtered
        left: leftGain
        right: rightGain.

    "Each voice has a different echo time."
    echoes := delayTemplate
        source: voice
        maxDelay: 3 s
        scale: 1
        slewRate: 1
        delayFraction: (delaySeconds * (0.5 + (i / 6)) / 3)
        feedback: feedback.

    levelTemplate start: 0 s
        source: voice
        left: 1
        right: 1.

    levelTemplate start: 0 s
        source: echoes
        left: wet
        right: wet.
].
