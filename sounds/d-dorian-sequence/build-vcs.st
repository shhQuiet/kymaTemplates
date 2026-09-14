| filterTemplate oscillatorTemplate levelTemplate
  bpm notes gate step pitch filterEnvelope ampEnvelope
  lfoDuration lfo cutoff oscillator filtered |

filterTemplate := inputs at: 1.
oscillatorTemplate := inputs at: 2.
levelTemplate := inputs at: 3.

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
    freq: pitch
    wave: 'Saw0064.aif'.

cutoff := (180 + (!CutoffOffset smooth: 0.03 s) +
    (((!LFODepth vmax: 0) smooth: 0.03 s) * lfo) +
    (2200 * filterEnvelope)) vmax: 30.

filtered := filterTemplate
    source: oscillator
    cutoff: cutoff hz
    resonance: (((!Resonance vmax: 0) vmin: 0.9)
        smooth: 0.03 s).

levelTemplate start: 0 s
    source: filtered
    amp: (0.4 * ampEnvelope).
