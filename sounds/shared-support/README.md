# Shared Script support

Helper passing and named lookup are user-confirmed in the actual drone. The latest parent generalization to scheduling every input Script awaits playback. [parent.st](parent.st) supplies a callable two-argument findInput block and schedules each input Script. The child receives it through ?findInput and supplies its own input collection when calling it. This prevents lookup from accidentally searching the parent's Inputs.

## Current setup

- Parent Script: KymaSystem. Left1, Right1. Current input: drone. The parent may contain multiple patch Scripts; all receive findInput and start at zero, mixing their outputs.
- Child Script: drone. Source: [build-midi-shared-child.st](../ambient-drone/build-midi-shared-child.st).
- Child Inputs, any order: Initializer, InitializerGated, VCF, Oscillator, Level, DelayWithFeedback.
- Audio: drone -> KymaSystem -> existing MIDI voice/wrapper -> output.

There is no separate brightness Script. The child owns brightness random walk and its continuous controller. InitializerGated must be a child input. Generic parent only supplies functions and passes through the resulting sound.

## New patches

Reuse the parent's helper implementation. Choose and document child names for clarity; the parent has no hard-coded child name and iterates all its inputs. All parent inputs must be patch Scripts accepting findInput; keep raw templates inside their respective children. Build patch-specific behavior in a new child source file/folder. Give full scripts and exact per-Script input names; order does not matter. Common helpers should take necessary inputs explicitly rather than capture patch-specific objects.

Exact lookup compares candidate name printString to a role string, validates exactly one match, and reports count/aborts otherwise. Successful selection and audio construction verified; error branches not separately exercised. Prefixes identify template families but never resolve ambiguous roles silently.

The initial minimal block test returned42; see ../../experiments/shared-helper/. No automatic inheritance/import mechanism is claimed. Play through the parent; a ?findInput prompt means the binding did not reach the child or the child was played directly. Script requires an input even in no-audio tests.

Current child includes the reduced +/-0.02-second delay LFO; user found the original +/-0.1-second sweep too dramatic. Reduced depth awaits explicit playback confirmation.

User-approved standard parent behavior: treat every parent input as a child patch Script, pass the common helper bindings to each, schedule all at start: 0 s, and mix their audio outputs. No hard-coded child name or special single-child path. Keep raw prototypes inside the children. This is the intended architecture; the latest all-child iteration implementation is still awaiting explicit playback confirmation.

The local child variable findInput is a convenient alias for ?findInput, which receives the supplied block. Passing a block does not install a method: self findInput is not an established substitute.
