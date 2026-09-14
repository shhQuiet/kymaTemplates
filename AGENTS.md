# Project: Create native Kyma Sounds through code

## Objective

Create playable native Kyma Sounds for Steve Horne. The agent should design and write the sound-generating logic, signal-flow construction, parameter relationships, and live controls. This project is about making Sounds that work inside Kyma, not merely explaining synthesis or generating audio in a separate synthesizer.

The user reports that Kyma has no public interface for creating Sounds. Our working approach is a minimal wrapper the user builds through Kyma's UI, followed by agent-authored Smalltalk in its Script field. Use Capytalk for real-time parameter behavior where appropriate. Keep the manual setup as small and reusable as possible, and put as much of each design as the proven mechanisms allow into the script.

## Proven first test

The user successfully ran this setup in Kyma:

- A Script Sound with one Oscillator in its Inputs field.
- Oscillator Wavetable: `Sine`.
- Oscillator Frequency: `?freq`.
- Oscillator Envelope: `0.05`.
- Frequency modulation off.
- Script field:

```smalltalk
(inputs at: 1) start: 0 s freq: 220 hz.
```

The user reported that it works. Treat this as the established baseline; do not restart the investigation into whether Script Sounds can work. Saving and reopening the resulting `.kym` have not been confirmed.

Referencing `(inputs at: 1)` avoids requiring the user to rename the input Sound. A Sound's own name is not an Oscillator parameter named "Name"; do not repeat that confusing instruction.

## Construction model

- Script Inputs are templates for constructing instances. They are not necessarily a conventional audio input chain.
- Smalltalk in the Script field supplies start times, substitutes exposed variables, and builds combinations of template Sounds.
- `?freq` is a parameter variable exposed by the template; `freq:` in the tested script supplies its value. This is not evidence that arbitrary parameters can be set through invented setters.
- Capytalk expressions and `!EventValues` provide real-time controls. Keep them distinct from Smalltalk construction and `?parameterVariables`.
- The manuals document loops, parallel scheduling, and nested template instances for building larger structures. Verify each new technique in small steps.
- Direct class instantiation, arbitrary internal evaluation, and programmatic import/export have not been established. Investigate when useful, but do not present guessed APIs as working solutions or delay a simple Sound to develop a general framework.

## Working style

1. Start from the proven wrapper and the user's requested sonic result. Reuse existing template inputs when possible.
2. Consult local documentation and working examples for unfamiliar messages, Sound classes, or fields. Prefer observed syntax over assumptions from other Smalltalk implementations or audio systems.
3. Deliver exact, paste-ready code. State every required input template, its order, and the fields the user must set. Separate UI setup from code for the Script field and code for other parameter fields.
4. Make one small test at a time when introducing an unverified mechanism. Say what the user should hear and how to stop or change the test. Use modest output levels and account for level buildup when mixing voices.
5. Let the user perform the minimal UI steps and report the result. If a test fails, request the exact compiler message or the specific missing field, then revise the code. Do not require elaborate screenshots or unrelated setup to diagnose a simple problem.
6. Clearly distinguish documented behavior, untested proposed code, and user-confirmed or directly observed results. Do not claim to have compiled, heard, saved, or reopened a Sound without evidence.
7. Persist working source, wrapper requirements, and test results in this repository so future agents can continue without repeating solved experiments.

Bias toward producing a usable Sound, not extended planning or infrastructure. Keep explanations practical and concise. Do not repeatedly ask permission for routine research, source edits, or preparation already within the user's request.

## Local resources and ownership

- `/Users/stevehorne/dev/kyma`: this development repository; keep authored source and project notes here.
- `/Volumes/Kyma/Kyma 7 Folder/Documentation`: installed manuals.
- `/Volumes/Kyma/Kyma 7 Folder/Kyma Sound Library`: extensive factory/example Sounds, including scripting examples.
- `/Volumes/Kyma/SH-Kyma`: Steve's personal Sounds, classes, samples, and analyses.
- `/Volumes/Kyma/kyma-kata`: contributed code from the Kyma Kata user community, not Steve's original code. Consult its README and preserve attribution when adapting contributions.

Useful installed example collection:

`/Volumes/Kyma/Kyma 7 Folder/Kyma Sound Library/Scripts, constructors, sequencers & composition/Scripts*.kym`

The asterisk is a literal character in the filename; quote the path when accessing it. Readable strings in this collection include the tutorial's template-based construction syntax.

Use personal and community files as references. Save experiments as new files; do not overwrite existing Sounds or copy entire asset libraries into the repository by default.

## Documentation map

- `Kyma X Revealed.pdf`, printed pages 283-290: constructing Sounds algorithmically with Script, template variables, chains, mixing, debugging, and expansion. The older book also contains substantial Smalltalk and Capytalk tutorials.
- `Sound Class Reference.pdf`, printed pages 308-309 (PDF pages 309-310): Script class. Printed pages 255-256: Oscillator.
- `Capytalk Reference.pdf`: control messages, ranges, and examples.
- `Kyma_7_Revealed.pdf`: Kyma 7 UI behavior, parameters, Multigrid, and OSC. This February 2015 edition contains unfinished sections; use the other manuals to fill gaps while checking version-specific UI behavior.
- `TAU ReadMe.pdf` and `Batch Analysis Tool.pdf`: analysis, morphing, and resynthesis workflows when relevant.

OSC is a documented control mechanism, but it is not an established Sound-creation interface. Do not substitute external control for the objective of constructing native Sounds.

## Files and validation

Sampled `.kym` files contain binary object data beginning with `BOSS 980001`. Readable strings can reveal examples but are not a complete, editable representation. Do not blindly patch or fabricate native binary files. Let Kyma create and save native files unless a reliable alternative is demonstrated.

Keep scripts as readable text with their exact wrapper setup. A script alone is not a self-contained `.kym`. Record dependencies on templates, custom classes, wavetables, samples, and analysis files. Use Kyma's File Archivist when a portable native package is needed.

The definitive test is compilation and playback in Kyma. Saving and reopening is a separate validation step when delivering a reusable native Sound. Static inspection or successful code generation alone does not establish that a Sound works.

## Accepted approach after integration investigation

The user explicitly accepted constructing graphs from prepared templates and recreating them from edited scripts. Arbitrary named-node mutation is no longer a prerequisite: the script is the source of the generated graph. Focus on proving composition and then extending the reusable construction kit. User performs the minimal wrapper setup; avoid making UI automation the primary authoring mechanism.

The oscillator-filter experiment is historical. Current work uses the verified four-prototype baseline described below.

## Script input order

`inputs at: n` refers to the order in the Script Sound's Inputs field. Always state the required order alongside positional scripts, and check the actual field when diagnosing unexpected variable prompts. Do not infer order from creation order or the visual signal-flow layout.

In the oscillator-filter experiment, the user's actual order was Filter first, Oscillator second. Correct code instantiates `(inputs at: 2)` as the oscillator and schedules `(inputs at: 1)` as the filter. The reversed references caused an unbound frequency prompt and reuse of the value entered through that dialog. The user acknowledged the ordering dependency after the correction. Do not repeat the earlier unsupported capitalization diagnosis.

Prefer assigning descriptive local variables at the start of multi-template scripts (for example, `filterTemplate := inputs at: 1. oscillatorTemplate := inputs at: 2.`) so positional assumptions are centralized and the rest of the graph-building code is readable. These local names do not perform lookup by Sound display name.

## Confirmed musical example

`sounds/d-dorian-sequence/build-four-loop-lfo.st` was played successfully by the user, who reported "very nice, plays well." It constructs Oscillator -> VCF -> Level from three templates ordered VCF, Oscillator, Level. The oscillator exposes `?wave` and receives the search-resolved filename `'Saw0064.aif'`. Capytalk supplies the eight-note D Dorian sequence, per-note filter and amplitude contours, and a raised-cosine cutoff LFO over four sequence repetitions (9.6 seconds at 100 BPM). Reuse this as a working construction example. Native saving/reopening and live tempo-change phase behavior have not been verified.

## VCS control setup requirements

Whenever exposing controls in the VCS, explicitly provide each control's numeric range, units, and starting value alongside the script. Do not assume Kyma infers useful widget ranges. Explain any required range adjustment as part of setup, not only after troubleshooting. Distinguish numeric Hz values from normalized 0-1 controls and state whether initial values must be set in the VCS or are supplied by code.

The user confirmed the D Dorian build-vcs.st variant works after using appropriate ranges for CutoffOffset and LFODepth. Their apparent lack of effect was resolved by using values in the thousands rather than a tiny Hz range. Reference settings: BPM 40-200, start 100; CutoffOffset -150 to 3000 Hz, start 0; Resonance 0-0.9, start 0.55; LFODepth 0-4000 Hz, start 1400. The user reported "all is good" and specifically requested that ranges accompany future VCS controls.

## Custom prototype collection

The user clarified that the desired delivery is a custom prototype collection. Prepared Sounds are sufficient; encapsulated classes are optional. Use the AI SoundCollection in `/Volumes/Kyma/SH-Kyma/Classes/Custom Collections.kym`, which also contains SH Spectral and SH Utility. Open as a regular Sound file to edit/collect Sounds and as Custom Prototypes to expose categories in the prototype bar. No encapsulated classes have been created for this project.

Kyma X Revealed printed 294-302 documents optional New Class from example. If using classes later, distinguish class fields from free variables bound by Script; arbitrary field setters remain unproven.

The wrapped delay with VCS DelayBeats is user-confirmed. Retain the single-input Mixer wrapper named delay; direct DelayWithFeedback insertion rejection remains unexplained.

## One-time prototype parameter coverage

User explicitly prioritizes completing repetitive prototype setup once to avoid future human context switches. Expose all useful bindable fields upfront, supply complete parameter values in agent-authored scripts, and use separate variants for fixed menus/checkboxes or structural choices. Do not defer ordinary fields such as Oscillator Formant merely for simplicity. Custom prototype collection can contain prepared Sounds; encapsulated custom classes are optional. Oscillator setup is in sounds/oscillator-prototypes.md; base prototype playback is confirmed.

Prototype naming and hardware: user has current Kyma hardware and explicitly requests excluding legacy parameters. Do not expose Oscillator PitchBend or supply pitchBend: in new template calls. Use Oscillator and Oscillator FM as prototype names; AI belongs only in the collection name, not each object name.

User confirmed the expanded Oscillator prototype plays correctly in the existing sequencer. build-vcs-delay.st now includes that full oscillator call. Fully parameterized VCF setup is sounds/vcf-prototype.md; playback is confirmed.

## Deliver complete scripts

User explicitly requires the full copy-and-paste script whenever making script changes. Do not give replacement sections or require manual merging. Include the complete script inline in the response; a saved-file link may supplement but must not replace it. Partial edits waste user time and introduce errors.

User confirmed build-vcs-delay-prototypes.st works with both the expanded Oscillator and VCF prototypes. This is an intermediate confirmed script, superseded by build-all-prototypes.st. VCF prototype binding at zero modulation range is confirmed; nonzero audio-rate modulation is not yet tested.

Level prototype with separate ?left and ?right was user-confirmed working; build-vcs-delay-prototypes.st now reflects that successful script. Full numeric Delay prototype setup is sounds/delay-prototype.md; sounds/d-dorian-sequence/build-all-prototypes.st is user-confirmed working.

Latest confirmed baseline: sounds/d-dorian-sequence/build-all-prototypes.st. User reported "works good" after testing the fully parameterized base delay wrapper. Oscillator, VCF, stereo Level, and base delay are all confirmed in this script, ordered VCF, Oscillator, Level, delay. Oscillator FM and optional fixed-setting variants remain unverified. Use this full script as the starting point for future sound revisions.
