| filterTemplate oscillatorTemplate levelTemplate delayTemplate
  bpm notes gate step pitch filterEnvelope ampEnvelope
  lfoDuration lfo cutoff oscillator filtered dry echoes wetLevel |

filterTemplate := inputs at: 1.
oscillatorTemplate := inputs at: 2.
levelTemplate := inputs at: 3.
delayTemplate := inputs at: 4.

bpm := !BPM vmax: 20.
notes := #(38 40 41 45 43 47 48 45).

gate := (1 bpm: (bpm * 2) dutyCycle: 0.65) abs.
step := gate nextIndexMod: 8.
pitch := (step of: notes) nn.

"One LFO cycle spans four repetitions of the sequence."
lfoDuration := (960 / bpm) s.
lfo := (1 - ((2 * Double pi *
    (1 repeatingRamp: lfoDuration)) cos)) * 0.5.

filterEnvelope := (1 - (gate ramp: 0.18 s)) squared.
ampEnvelope :=
    (gate * (0.25 + (0.75 * filterEnvelope))) smooth: 0.005 s.

oscillator := oscillatorTemplate
    wave: 'Saw0064.aif'
    index: 0
    amp: 0.2
    freq: pitch
    formant: 1
    maxMI: 0
    reset: 0.

cutoff := (180 + (!CutoffOffset smooth: 0.03 s) +
    (((!LFODepth vmax: 0) smooth: 0.03 s) * lfo) +
    (2200 * filterEnvelope)) vmax: 30.

filtered := filterTemplate
    source: oscillator
    amp: 1
    cutoff: cutoff hz
    modRange: 0 hz
    modulator: oscillator
    resonance: (((!Resonance vmax: 0) vmin: 0.9)
        smooth: 0.03 s).

dry := levelTemplate
    source: filtered
    left: (0.4 * ampEnvelope)
    right: (0.4 * ampEnvelope).

"DelayBeats is measured in quarter-note beats; 0.75 is a dotted eighth.
The template reserves 3 seconds; limit DelayScale to that allocation."
echoes := delayTemplate
    source: dry
    maxDelay: 3 s
    scale: 1
    slewRate: 1
    delayFraction: ((((!DelayBeats vmax: 0.125) vmin: 2)
        * 20 / bpm) vmin: 1)
    feedback: (((!DelayFeedback vmax: 0) vmin: 0.75)
        smooth: 0.03 s).

wetLevel := ((!DelayLevel vmax: 0) vmin: 0.6) smooth: 0.03 s.

"Schedule both branches: the Script mixes them."
levelTemplate start: 0 s
    source: dry
    left: 1
    right: 1.

levelTemplate start: 0 s
    source: echoes
    left: wetLevel
    right: wetLevel.
