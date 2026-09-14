# D Dorian sequence: verified prototype baseline

Use [build-all-prototypes.st](build-all-prototypes.st), the full user-confirmed script. Paste the entire file into the Script field.

## Script Inputs

Keep these four separate entries in this exact order:

| Position | Prototype | Recipe |
| --- | --- | --- |
| 1 | VCF | [Setup](../vcf-prototype.md) |
| 2 | Oscillator | [Setup](../oscillator-prototypes.md) |
| 3 | Level | [Setup](../level-prototype.md) |
| 4 | delay | [Setup](../delay-prototype.md) |

Keep Script Left and Right at 1. The delay entry is the working single-input Mixer wrapper, not the bare DelayWithFeedback. Templates are available in the AI collection in `/Volumes/Kyma/SH-Kyma/Classes/Custom Collections.kym`.

## VCS settings

Set these ranges and starting values manually and save a preset. The script does not initialize the widgets.

| Control | Range | Start | Units |
| --- | --- | --- | --- |
| BPM | 40-200 | 100 | Beats/minute |
| CutoffOffset | -150 to 3000 | 0 | Hz |
| Resonance | 0-0.9 | 0.55 | Unitless |
| LFODepth | 0-4000 | 1400 | Hz |
| DelayBeats | 0.125-2 | 0.75 | Quarter-note beats |
| DelayFeedback | 0-0.75 | 0.35 | Unitless |
| DelayLevel | 0-0.6 | 0.3 | Linear gain |

CutoffOffset and LFODepth require Hz-sized ranges, not 0-1. DelayLevel is additional wet output, not a dry/wet crossfade.

## Sound and timing

Notes are MIDI 38, 40, 41, 45, 43, 47, 48, 45: D2 E2 F2 A2 G2 B2 C3 A2. Oscillator uses search-resolved Saw0064.aif. At 100 BPM, eighth notes last 0.3 seconds and the eight-note loop lasts 2.4 seconds. The raised-cosine cutoff LFO spans four loops: 960 / BPM seconds, 9.6 seconds at 100 BPM.

DelayBeats 0.75 gives a dotted eighth (450 ms at 100 BPM); 0.5 is an eighth, 1 a quarter, 2 a half note. The script allocates 3 seconds and uses DelayScale = DelayBeats * 20 / BPM, capped at 1. If changing maxDelay in a future script, also update the fraction calculation; 20 is 60 / 3. The full VCS timing range fits at BPM 40-200; below 40 the 3-second cap may apply.

Delay follows the note envelope so echoes ring between notes. Comb produces only delayed audio; Script schedules dry and wet branches separately. Changing timing can bend echo pitch while the delay slews. VCF modulator is supplied but modRange is 0; the current LFO is in the cutoff expression.

## Verification

User confirmed the musical sequence, four-loop LFO, VCS controls, wrapped delay, and then each of Oscillator, VCF, Level, and delay prototypes. Latest result: "works good" for build-all-prototypes.st.

Optional variants, Oscillator FM, nonzero audio-rate VCF modulation, and live tempo phase alignment are untested. Mathematical LFO continuity does not imply a sample-exact audio loop. Native save/reopen and the working sequencer's saved location are not documented.

## Earlier scripts

The other .st files preserve earlier stages and require different template bindings. Do not mix their setup with the current baseline. build-vcs-delay-prototypes.st is the prior stereo-Level version with the older delay bindings; build-vcs-delay.st predates expanded VCF and stereo Level. Use build-all-prototypes.st for new work.
