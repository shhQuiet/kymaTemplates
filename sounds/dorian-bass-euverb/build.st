| filterTemplate oscillatorTemplate levelTemplate reverbTemplate
  notes noteSeconds gate step pitch motion breath pan
  master brightness depth resonance cutoff oscillator filtered voice
  leftGain rightGain reverbAmount reverbDecay reverbTone diffusion |

filterTemplate := inputs at: 1.
oscillatorTemplate := inputs at: 2.
levelTemplate := inputs at: 3.
reverbTemplate := inputs at: 4.

"D2, A1, C2, E2, F2, B1, G2, A1: all in D Dorian."
notes := #(38 33 36 40 41 35 43 33).
noteSeconds := (!DroneNoteSeconds vmax: 2) vmin: 30.
gate := (1 bpm: (60 / noteSeconds) dutyCycle: 0.5) abs.
step := gate nextIndexMod: 8.
pitch := ((step of: notes) smooth: 0.8 s) nn.

"Slow movement continues independently of the note changes."
motion := 20 + (100 * ((!DroneMotion vmax: 0) vmin: 1)).
breath := (1 - ((2 * Double pi *
    (1 repeatingRamp: motion s)) cos)) * 0.5.
pan := (1 - ((2 * Double pi *
    ((1 repeatingRamp: (motion * 1.7) s) + 0.25)) cos)) * 0.5.

master := (0.7 * ((!DroneLevel vmax: 0) vmin: 1))
    smooth: 0.3 s.
brightness := (!DroneBrightness vmax: 40) smooth: 0.3 s.
depth := (!DroneDepth vmax: 0) smooth: 0.3 s.
resonance := (0.85 * ((!DroneResonance vmax: 0) vmin: 1))
    smooth: 0.3 s.

reverbAmount := (0.6 * ((!DroneReverb vmax: 0) vmin: 1))
    smooth: 0.3 s.
reverbDecay := (0.95 * ((!DroneReverbDecay vmax: 0) vmin: 1))
    smooth: 0.3 s.
reverbTone := ((!DroneReverbTone vmax: 0) vmin: 1)
    smooth: 0.3 s.
diffusion := ((!DroneDiffusion vmax: 0) vmin: 1)
    smooth: 0.3 s.

oscillator := oscillatorTemplate
    wave: 'Saw0064.aif'
    index: 0
    amp: 0.2
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

"Keep the bass present in both channels, with gentle stereo movement."
leftGain := master * (0.6 + (0.4 * breath)) * (1 - (0.25 * pan)).
rightGain := master * (0.6 + (0.4 * breath)) * (0.75 + (0.25 * pan)).

voice := levelTemplate
    source: filtered
    left: leftGain
    right: rightGain.

"The stereo reverb template includes its own dry branch."
reverbTemplate start: 0 s
    source: voice
    decay: reverbDecay
    cutoff: reverbTone
    diffusion: diffusion
    reverb: reverbAmount
    direct: 1.
