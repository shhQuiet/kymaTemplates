# VCF prototype

Source: Sound Class Reference printed 414. All six documented fields exposed; user-confirmed in the sequence. Save as VCF in the AI custom prototype collection.

| Field | Setting |
| --- | --- |
| Input | Variable Sound named source |
| Amplitude | ?amp |
| Cutoff | ?cutoff |
| CutoffModRange | ?modRange |
| CutoffModulator | Variable Sound named modulator |
| Resonance | ?resonance |

Replace the existing LFO in CutoffModulator with the Variable Sound. Variable names have no question mark; scalar field variables do. No fixed-setting variants are needed for these documented fields.

Script Inputs order remains VCF, Oscillator, Level, delay. Current verified full script is d-dorian-sequence/build-all-prototypes.st. New filter construction:

```smalltalk
filtered := filterTemplate
    source: oscillator
    amp: 1
    cutoff: cutoff hz
    modRange: 0 hz
    modulator: oscillator
    resonance: (((!Resonance vmax: 0) vmin: 0.9)
        smooth: 0.03 s).
```

Reuses the existing oscillator as the required modulator Sound with zero range, so it does not alter cutoff. Existing four-loop LFO remains in the cutoff expression. In future scripts modulator can be another constructed Sound and modRange a nonzero frequency amount. amp and modulator bindings are scoped to this instance independently from oscillator template bindings. No new VCS controls; prior ranges remain unchanged. Test for no variable prompts and unchanged sequence/filter/delay sound.

Playback result: user confirmed "ok, works" after replacing the VCF with this prototype and pasting the complete build-vcs-delay-prototypes.st script. This validates the full VCF bindings, including the zero-range modulator input, in the existing sequence. Nonzero audio-rate cutoff modulation remains untested.
