# Creating native Kyma Sounds

## Established workflow

1. Prepare reusable Sounds in the AI custom-prototype collection, exposing bindable fields once.
2. Create a patch-specific child Script and common parent Script. Drop required prototypes into the child using the exact role names specified for the patch; order is irrelevant with the shared lookup helper. See sounds/shared-support/README.md.
3. Paste the complete agent-authored script. Smalltalk constructs instances; Capytalk supplies live expressions.
4. Supply starting values through Initializer; specify VCS ranges/units for the user. Play through the parent and any existing MIDI wrapper.
5. Save the working Sound and prototype file. Record the result and any limitations.

The agent must deliver full scripts inline, not replacement sections. Expose useful fields broadly to avoid repeated human setup; supply every free variable in each call. Automatic defaults for omitted bindings are not established. Menus, checkboxes, and structural choices can use separate prototype variants.

## Binding and graph construction

`?freq` is a free variable in a template; `freq:` supplies its binding. It is not an arbitrary object setter. Bindings are local to template instantiation: separate templates can reuse names. Repeated variable names within a composite template share a binding. Repeated `!EventValue` names share a live control.

Variable Sounds such as source or modulator are actual input objects with names lacking a question mark. Intermediate instances omit start: and become inputs to later instances. Schedule output branches with start: 0 s; the Script mixes them.

Older scripts use positions from the Script Inputs field; new scripts use exact name lookup. Reversed positions caused earlier missing-frequency prompts, not capitalization.

Use search-resolved asset filenames such as 'Saw0064.aif', not absolute paths in wavetable fields. The user has current hardware; exclude legacy PitchBend bindings.

## Historical sequence validation

[build-all-prototypes.st](sounds/d-dorian-sequence/build-all-prototypes.st) is the earlier user-confirmed sequence baseline; CURRENT.md describes the current shared-parent drone. Oscillator, VCF, stereo Level, and the wrapped delay all work with their expanded bindings. VCS tempo, cutoff offset, resonance, LFO depth, delay beats, feedback, and level have worked in this sequence.

The delay was tested inside a single-input Mixer wrapper. User later resolved direct insertion by renaming the Sound Delay: Script Inputs require Smalltalk-friendly names. A wrapper is optional. Use unique names without spaces or punctuation, such as OscillatorFM and EuverbStereo; positional references do not bypass this requirement.

Oscillator FM, nonzero audio-rate VCF modulation, optional fixed-setting variants, live-tempo phase alignment, and native save/reopen are not established by those playback confirmations.

## Documentation

Installed manuals live in `/Volumes/Kyma/Kyma 7 Folder/Documentation`.

- Kyma X Revealed, printed 283-290: Script construction and bindings; 294-302: custom classes and prototype collections.
- Sound Class Reference: DelayWithFeedback 49-50, Level 120, Oscillator 255-256, Script 308-309, Variable 412, VCF 414.
- Capytalk Reference: bpm:dutyCycle: 37, cos 62, nextIndexMod: 157, of: 194, ramp: 217, repeatingRamp: 237, smooth: 260, vmax/vmin 319-320.
- Kyma 7 guide: File Archivist for collecting dependencies.

Factory examples: `Kyma Sound Library/Scripts, constructors, sequencers & composition/Scripts*.kym`. The asterisk is literal; quote the filename.

## Historical investigation

See experiments/ for historical reflection tests and internal Tool research. Direct name printString lookup and explicit parent-to-child callable blocks are now verified; see CURRENT.md. Programmatic import/export, arbitrary graph mutation, and internal class access have not been established. They are not prerequisites for the accepted template workflow.

Native .kym files contain binary BOSS object data. Readable strings are useful evidence, not a complete editable representation. Do not fabricate or patch native graphs; let Kyma save them. Do not copy proprietary libraries or personal assets into this repository by default.
