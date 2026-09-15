# Creating native Kyma Sounds for Steve Horne

## Start here

Read CURRENT.md before starting a new sound, then sounds/shared-support/README.md and sounds/TEMPLATES.md. The user has finished the drone and intends to create a different sound in a new chat. Preserve the finished drone; create a new sound folder for the next patch. This repository is /Users/stevehorne/dev/kyma; GitHub origin is https://github.com/shhQuiet/kymaTemplates.git. Do not imply local edits are pushed unless a push is actually performed.

## Objective and workflow

Turn the user's description into playable native Kyma Sounds. The user builds minimal wrappers through Kyma's UI; the agent writes Smalltalk graph construction and Capytalk live behavior. Use the existing custom prototypes and the proven common-parent/patch-child arrangement. No public graph-creation API is established or needed. A Sound template is copied into each constructed instance; shared functions do not require shared mutable references.

- Parent Script defines reusable helper blocks and schedules the child, passing helpers as template bindings. Child Script contains patch-specific musical code and its own template Inputs. Audio passes through the parent.
- Current generic parent example: sounds/shared-support/parent.st. Current child: sounds/ambient-drone/build-midi-shared-child.st.
- Exactly two Scripts in the current drone: child drone -> parent KymaSystem -> existing MIDI voice/wrapper. There is NO separate brightness Script. Brightness walk belongs to the child.
- Reuse stable helpers. Do not put patch-specific musical behavior into the generic support layer by default. For a new patch, specify the child name for clarity; the latest generic parent iterates all input Scripts without name lookup. Each receives findInput and starts at zero; outputs mix. Parent inputs must be patch Scripts accepting findInput, not raw templates. This all-input iteration revision awaits playback.
- Kyma Script requires at least one input. The minimal block-passing test used an unused Oscillator in the child.

## User requirements

- ALWAYS give complete scripts inline when changing code. Never require merging snippets; links supplement rather than replace full copy/paste code.
- Explicitly state which prototype to drop into WHICH Script and the exact instance name. Announce any new template requirement before relying on it. Prefer existing templates; avoid repetitive human setup and context switches.
- Resolve inputs by exact names, not positions. User may shuffle them. Prefix identifies family/type, suffix identifies role (OscillatorModulator, InitializerGated). Never silently choose the first prefix match; variants can have different interfaces. Use unique Smalltalk-friendly names, no spaces/punctuation. Uppercase names work in this user's setup.
- Relative VCS controls should use 0-1. Time and frequency may use natural units. State ranges, units, and scripted defaults for new controls. Initialize values in code using Initializer; do not ask the user to set starting values manually.
- Complete useful bindable prototype fields upfront. Menus/checkboxes/structural differences can be separate variants. User has current hardware: omit legacy Oscillator PitchBend binding.
- AI is the collection/category name, not an object-name prefix.
- User performs minimal UI setup and playback. Do not use UI automation as the main authoring mechanism. Ask for exact errors/results when needed, not repeated broad setup checks.
- Distinguish verified playback, documented behavior, and proposed experiments. Never claim to have heard/compiled/saved/reopened a Kyma Sound without evidence.

## Verified lookup and shared functions

Use candidate name printString for exact role-string comparisons. Direct name returned an object printed as VCF; name asString FAILED on SoundWithVariables. recognizes: #name returned false even though direct name worked. Empty selectors and recognizes: false are not reliable evidence against dynamic access. Arbitrary other getters and graph mutation remain unverified.

The parent defines findInput := [:availableInputs :requiredName | ...] and passes it with child start: 0 s findInput: findInput. The child binds findInput := ?findInput, then calls findInput value: inputs value: 'Oscillator'. Explicit input-collection argument avoids capturing the parent's collection. Exact implementation in sounds/shared-support/parent.st checks one match and aborts with a diagnostic otherwise. Successful lookup/playback is verified; missing/duplicate error branches have not been separately tested.

Parent-to-child block passing first returned 42 in experiments/shared-helper/. It then worked in the actual drone. This is explicit parameter passing, not automatic lexical inheritance or a general import facility.

## Binding and scheduling rules

?freq exposes a template variable; freq: supplies its value. These are not arbitrary object setters. Supply all required fields. Binding names are local to instantiated templates; repeated variables inside one composite share a binding. !EventValues of the same name share a live controller within the relevant routing scope.

Variable Sounds source/modulator are actual named input objects. Construct intermediate instances without start:, then schedule final output branches with start: 0 s. Scheduled branches mix. Wavetables use search-resolved names such as 'Saw0064.aif', not absolute paths.

Parenthesize successive keyword messages: (x vmax: low) vmin: high. Unparenthesized vmax: low vmin: high caused a confirmed nonexistent vmax:vmin: error. Other Smalltalk APIs must be checked against local documentation/examples before assuming them.

## Templates and control initialization

See sounds/TEMPLATES.md and individual prototype recipes for full interfaces. Initializer is the verified TriggeredSoundToGlobalController recipe with ?event, ?value, Trigger 1, Gated off, Silent/AllowLiveOverride/ShowInVCS on. InitializerGated is the independent Gated-on copy used successfully for the continuous brightness walk. Put it in the Script that schedules it, currently the child. Leaving it in the parent caused the user's restored-brightness setup problem.

Initializer start: 0 s event: !DroneDepth value: 500 sets 500 in the user's setup. DO NOT divide physical values by widget ranges; an earlier 500/3000 produced 0.16667 and was wrong. Multiple initialization targets and direct physical values are user-confirmed. Widget range metadata is not automatically configured by this mechanism. Details: sounds/vcs-initialization.md.

## Current evidence and limitations

- Four base prototypes and D Dorian sequencer verified: sounds/d-dorian-sequence/build-all-prototypes.st (historical positional inputs).
- Named stereo MIDI drone verified: sounds/ambient-drone/build-midi-stereo-named.st.
- Shared-parent drone and restored child brightness walk verified after placing InitializerGated in the child.
- Latest shared child adds a requested 30-second +/-0.02-second delay LFO. The original +/-0.1-second sweep was audible but too dramatic; reduced depth awaits explicit playback confirmation. Preserve it as latest delivered source and label accurately.
- EuverbStereo prepared; playback not explicitly confirmed. OscillatorFM and optional delay variants are inventory-confirmed, not separately playback-verified.
- Current MIDI keyboard: channel 1, MPE DISABLED. Generic MPE prevented response even though note messages arrived in monitor. Existing MIDIVoice Live MIDI, channel1, polyphony1 wraps whole three-slot drone. Polyphony3 would duplicate the entire script. No need to repeat this troubleshooting for a new patch unless symptoms justify it.
- Historical tests and chronological notes may describe superseded names, ordering, or architecture. CURRENT.md and these instructions govern new work.

## Files and local references

- /Volumes/Kyma/SH-Kyma/Classes/Custom Collections.kym: user's custom prototypes, AI collection alongside SH Spectral/SH Utility. Open as regular Sound file to edit/Action > Collect; Custom Prototypes to show prototype bar.
- /Volumes/Kyma/Kyma 7 Folder/Documentation: installed manuals. Kyma X Revealed 283-290 Script construction; Sound Class Reference Script308-309, DelayWithFeedback49-50, Level120, Oscillator255-256, VCF414, TriggeredSoundToGlobalController400. Capytalk Reference for live expressions.
- /Volumes/Kyma/Kyma 7 Folder/Kyma Sound Library: factory examples. Scripts, constructors, sequencers & composition/Scripts*.kym has a literal asterisk; quote paths.
- /Volumes/Kyma/SH-Kyma: Steve's personal assets. /Volumes/Kyma/kyma-kata: community contributions; preserve attribution and consult its README.
- /private/tmp/kyma-doc-review may contain extracted manual text; recreate if missing.

Native .kym files are binary BOSS objects. Readable strings are useful references, not a safe editable representation. Do not fabricate or patch native graphs or copy whole proprietary/personal asset libraries. User saves native Sounds through Kyma. Store authored .st and setup/evidence in this repo. Native file location/save-reopen for the finished drone is not recorded. Do not invent it.

User-approved standard parent behavior: treat every parent input as a child patch Script, pass the common helper bindings to each, schedule all at start: 0 s, and mix their audio outputs. No hard-coded child name or special single-child path. Keep raw prototypes inside the children. This is the intended architecture; the latest all-child iteration implementation is still awaiting explicit playback confirmation.
