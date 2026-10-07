# Generative Pentatonic Machine

A new, independent, self-running C-major-pentatonic arpeggio demo. Six instances of one Oscillator prototype traverse C3-A4 in different algorithmic orders, with eighth-, quarter-, and half-note clocks. Eight-step Euclidean patterns give interlocking rests; this is deterministic generative music, not random note selection. Each voice has a moving filter and stereo position. Echoes are dotted eighths, quarters, and dotted quarters of the global tempo.

## Exact drag-and-drop setup

Create a NEW native Sound with two Scripts. Do not add this child to the existing drone parent unless you deliberately want both sounds mixed.

1. Name the outer Script **KymaSystem**. Paste the existing, unchanged `../shared-support/parent.st` into it. Set Left and Right to 1.
2. Name its sole child Script **PentatonicMachine**. Paste the ENTIRE `build-shared-child.st` into that child. Set Left and Right to 1. Put this child in KymaSystem's Inputs.
3. Drag ONE copy of each of these existing AI custom prototypes into **PentatonicMachine's Inputs**, then ensure its instance name matches exactly:

| Existing prototype | Exact child input instance name |
| --- | --- |
| Oscillator | Oscillator |
| VCF | VCF |
| Level | Level |
| DelayWithFeedback (base stereo Comb version) | DelayWithFeedback |
| Initializer (one-shot, Gated OFF) | Initializer |

Input order is arbitrary; each name must appear exactly once. No InitializerGated, MIDI voice, Mixer, extra oscillator prototype, or new template is required. KymaSystem's Inputs contain only PentatonicMachine, not raw prototypes. The child uses `?findInput` supplied by the parent; playing the child directly will omit that binding.

Use the parameterized custom prototypes, not bare factory versions. Required interfaces:

- Oscillator: wave, index, amp, freq, formant, maxMI, reset; Modulation None, Linear interpolation, Constant 0 modulator.
- VCF: source and modulator Variable Sounds; amp, cutoff, modRange, resonance scalar variables. This script supplies the oscillator as modulator with zero modulation range.
- Level: source Variable Sound, left and right scalar variables; existing NoGain and interpolation settings.
- DelayWithFeedback: source Variable Sound; maxDelay, delayFraction, feedback, scale, slewRate; Comb, Stereo, Linear, SmoothDelayChanges, Prezero, Private memory. Use the existing verified base prototype; do not substitute AllPass.
- Initializer: event and value variables; Trigger 1; Gated OFF; Silent, AllowLiveOverride, ShowInVCS ON.

## VCS

The Initializer sets these values on every playback. Set the VCS widget ranges below once; initialization supplies values, not widget metadata. Physical values are supplied directly, without range normalization.

| Event / widget name | Startup value | Widget range | Units / effect |
| --- | ---: | --- | --- |
| PentaTempo | 96 | 30-180 | BPM; global rhythm and echo tempo |
| PentaDensity | 0.65 | 0-1 | Quantized 1-8 pulses per eight clock steps; exactly 0 mutes new notes |
| PentaBrightness | 1800 | 150-6000 | Hz; base filter cutoff |
| PentaMotion | 0.4 | 0-1 | Filter sweep depth, up to +/-70% of base cutoff; 16-second cycle |
| PentaSpread | 0.8 | 0-1 | 0 centers voices; 1 allows full stereo travel; 24-second cycle |
| PentaDelay | 0.3 | 0-1 | Echo return level; feedback remains 0.3 |
| PentaAttack | 0.01 | 0.005-1 | Seconds; linear rise from zero to peak |
| PentaDecay | 0.18 | 0.02-3 | Seconds; linear fall from peak to zero |
| PentaVolume | 0.65 | 0-1 | Dry and echo output gain |

Density pulse count is `floor(8 * Density)`, clamped to 1-8, with a separate zero mute. It starts at five pulses. Each voice counts its own clock even during rests, advancing through a ten-note array with strides 1,3,7,9,3,7 and different starting offsets. All strides visit every array position. Tempo multipliers are 2,1,0.5,2,1,0.5. This produces a repeating, interlocking texture with no MIDI requirement.

## AD amplitude envelope

Each active rhythmic step triggers a linear attack/decay envelope. Attack defaults to 10 ms and decay to 180 ms. Both controls use seconds. A 2 ms smoothing stage softens retrigger discontinuities. The envelope continues after the rhythmic gate closes; it has no sustain stage. A new active step retriggers the same voice, so long envelopes are interrupted rather than adding extra polyphony. Each voice holds its selected pitch until its next active step, allowing tails to continue through rests without changing pitch. Live duration changes may reshape a running envelope. Density 0 prevents new attacks while existing AD tails and echoes finish.

This AD revision uses the documented ramp: (217) and sampleAndHold: (245) messages, but still requires Kyma compilation and audition.

## Playback and demonstration

Play **KymaSystem**, route its stereo output to the usual audio output, and open its VCS. Begin with monitor volume low. Notes should start automatically. Let it run for at least 24 seconds to hear stereo travel and filter motion.

Suggested demonstration: set Spread to 0 then 1; sweep Density from 0.25 to 1; raise Motion; adjust Brightness; mute the echo with Delay 0 then restore it; change Tempo and hear the note clocks and echoes follow. Delay 0 mutes the return but does not erase its memory. Density 0 allows existing echoes to decay. PentaVolume 0 mutes all output. Stop and replay to restore scripted startup values.

Save this as a new native `.kym` Sound under a new filename using Kyma. This repository contains authored text, not a fabricated binary Sound.

## Evidence and limits

Prototype interfaces and parent-to-child helper passing are established in the repository's verified setup. Capytalk expressions were checked against the installed Capytalk Reference: bpm:dutyCycle: (37), euclideanForBeats:pulses:offset: (80), nextIndexMod: (157), of: (194), repeatingRamp: (237), sin (256), smooth: (260), and nn/unit conversion. The current generic parent that iterates all children still awaits explicit playback confirmation; it is reused unchanged.

This new child has NOT been compiled or auditioned in Kyma. Check that playback raises no unbound-variable prompt, all nine VCS controls initialize, stereo movement is audible, and tempo changes update the echo timing. SmoothDelayChanges can produce a brief pitch transition when tempo changes; exact transient behavior awaits audition. Each voice allocates its own three-second stereo delay; hardware resource use also awaits compilation. Report any exact compile error or audio issue for a complete-script revision.

No existing sound folder or shared-support source was changed.
