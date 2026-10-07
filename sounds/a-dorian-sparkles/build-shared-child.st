| findInput initializerTemplate oscillatorTemplate filterTemplate levelTemplate delayTemplate
  bpm gate draw move state index pitch attack decay envelope shimmer cutoff resonance sine bright filtered
  dry echoes wet |

"The shared parent supplies exact-name lookup."
findInput := ?findInput.
initializerTemplate := findInput value: inputs value: 'Initializer'.
oscillatorTemplate := findInput value: inputs value: 'Oscillator'.
filterTemplate := findInput value: inputs value: 'VCF'.
levelTemplate := findInput value: inputs value: 'Level'.
delayTemplate := findInput value: inputs value: 'DelayWithFeedback'.

"Set playable VCS values on startup; the controls remain live."
initializerTemplate start: 0 s event: !SparkleBPM value: 110.
initializerTemplate start: 0 s event: !SparkleLevel value: 0.45.
initializerTemplate start: 0 s event: !SparkleBrightness value: 0.55.
initializerTemplate start: 0 s event: !SparkleResonance value: 0.2.
initializerTemplate start: 0 s event: !SparkleWet value: 0.27.
initializerTemplate start: 0 s event: !SparkleFeedback value: 0.25.
initializerTemplate start: 0 s event: !SparkleDelayTime value: 0.41.
initializerTemplate start: 0 s event: !SparkleAttack value: 0.02.

"The pulse occurs twice per quarter-note beat. The discrete Markov chain
stays, rises one scale note, or falls one scale note."
bpm := (!SparkleBPM vmax: 40) vmin: 200.
gate := (1 bpm: (bpm * 2) dutyCycle: 0.55) abs.
draw := gate nextRandom.
move := (draw gt: 0.4) - (draw lt: -0.4).
state := (move / 9) accumulate01If: gate
    initialValue: (3 / 9)
    reset: 0.
index := (state * 9) rounded.

"E4 through G5, with A4 at index 3. All notes belong to A Dorian."
pitch := (index of: #(64 66 67 69 71 72 74 76 78 79)) nn.

"Ramp in each note to avoid an amplitude step at its attack."
attack := ((!SparkleAttack vmax: 0.002) vmin: 0.08) s.
"Finish the decay before the next eighth note, even at faster tempos."
decay := (((27 / bpm) vmax: 0.1) vmin: 0.23) s.
envelope := (gate ramp: attack) *
    ((1 - (gate ramp: decay)) squared).
shimmer := (1 - ((2 * Double pi *
    (1 repeatingRamp: 7 s)) cos)) * 0.5.
cutoff := (600 +
    (2700 * (((!SparkleBrightness vmax: 0) vmin: 1)
        smooth: 0.05 s)) +
    (3100 * envelope) +
    (300 * shimmer)) vmax: 80.
resonance := (0.65 * (((!SparkleResonance vmax: 0) vmin: 1)
    smooth: 0.05 s)).

"A clear fundamental and a filtered bright layer make the bell-like ping."
sine := oscillatorTemplate
    wave: 'Sine.aif'
    index: 0
    amp: (0.17 * envelope)
    freq: pitch
    formant: 1
    maxMI: 0
    reset: 0.

bright := oscillatorTemplate
    wave: 'Saw0064.aif'
    index: 0
    amp: (0.055 * envelope)
    freq: pitch
    formant: 1
    maxMI: 0
    reset: 0.

filtered := filterTemplate
    source: bright
    amp: 1
    cutoff: cutoff hz
    modRange: 0 hz
    modulator: bright
    resonance: resonance.

dry := levelTemplate
    source: sine
    left: (0.38 * (((!SparkleLevel vmax: 0) vmin: 1)
        smooth: 0.05 s))
    right: (0.38 * (((!SparkleLevel vmax: 0) vmin: 1)
        smooth: 0.05 s)).

"The delay follows the bright layer only, so its echoes sparkle lightly."
echoes := delayTemplate
    source: filtered
    maxDelay: 2 s
    scale: 1
    slewRate: 1
    delayFraction: (((!SparkleDelayTime vmax: 0.05) vmin: 2) / 2)
    feedback: (0.55 * (((!SparkleFeedback vmax: 0) vmin: 1)
        smooth: 0.05 s)).
wet := 0.28 * (((!SparkleWet vmax: 0) vmin: 1)
    smooth: 0.05 s) * (((!SparkleLevel vmax: 0) vmin: 1)
    smooth: 0.05 s).

"The Script mixes the three scheduled stereo branches."
levelTemplate start: 0 s source: dry left: 1 right: 1.
levelTemplate start: 0 s
    source: filtered
    left: (0.24 * !SparkleLevel)
    right: (0.24 * !SparkleLevel).
levelTemplate start: 0 s source: echoes left: wet right: wet.
