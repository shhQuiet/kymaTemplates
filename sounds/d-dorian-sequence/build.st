| filterTemplate oscillatorTemplate levelTemplate
  bpm notes gate step pitch filterEnvelope ampEnvelope
  oscillator filtered |

filterTemplate := inputs at: 1.
oscillatorTemplate := inputs at: 2.
levelTemplate := inputs at: 3.

bpm := 100.
notes := #(38 40 41 45 43 47 48 45).

"Two eighth notes per quarter-note beat."
gate := (1 bpm: (bpm * 2) dutyCycle: 0.65) abs.
step := gate nextIndexMod: 8.
pitch := (step of: notes) nn.

filterEnvelope := (1 - (gate ramp: 0.18 s)) squared.
ampEnvelope :=
    (gate * (0.25 + (0.75 * filterEnvelope))) smooth: 0.005 s.

oscillator := oscillatorTemplate freq: pitch.
filtered := filterTemplate
    source: oscillator
    cutoff: ((180 + (2200 * filterEnvelope)) hz)
    resonance: 0.55.

levelTemplate start: 0 s
    source: filtered
    amp: (0.4 * ampEnvelope).
