> Historical research; the accepted workflow is documented in [CREATING-SOUNDS.md](../CREATING-SOUNDS.md).

# Named-object investigation

## inspect-script-input.st

Status: user tested the diagnostic and supplied screenshots. The input object class is `Instrument`. The supported-message result is empty: `()`. None of `name`, `input`, `inputs`, `soundNamed:`, `allInputs`, or `allSounds` was recognized by this object.

Use a Script Sound with one input template, such as the working Oscillator wrapper. Temporarily replace the Script field with this file's contents. Compile/play the Script, record the two dialog results, and click OK to continue after each. The final abortForKyma deliberately ends evaluation without scheduling audio. No parameter changes are attempted.

This checks the class of the object exposed through `inputs at: 1` and whether it recognizes candidate messages. The names in the candidate list are hypotheses, not established graph APIs. A supported message does not establish its semantics, and an empty list does not prove named lookup is impossible. Follow the observed class and supported messages to design the next test.

Kyma X Revealed, printed page 375, documents `class`, `recognizes:`, and `printString`. Printed pages 220 and 387 document `debugWithLabel:value:`; page 387 also documents `abortForKyma`. The PDF is in `/Volumes/Kyma/Kyma 7 Folder/Documentation`.

Research so far: the manual documents named Script input templates and named playback of precompiled Sounds, but neither establishes arbitrary named-node lookup or mutation within an existing graph. A search for likely lookup/traversal calls in readable fragments of 201 factory, personal, and community `.kym` files did not identify a suitable example. This search is not a complete analysis of the binary files.


## inspect-instrument-methods.st

Status: tested; result recorded below. Same Script wrapper, with one input.

Tests whether the observed Instrument class exposes `selectors` and, if so, displays its directly defined instance-method names. The `selectors` reflection method is a hypothesis guarded by the previously working `recognizes:` method. If supported, the result can guide the next investigation without guessing more graph-access method names. This does not enumerate inherited methods or establish the meaning of the listed methods. Evaluation deliberately aborts without audio.

User result for inspect-instrument-methods.st: screenshot shows `Instrument methods = ()`. Thus the class recognizes `selectors`, but returned an empty collection. This does not distinguish inherited methods from restricted reflection.

## inspect-instrument-parent.st

Status: tested; result recorded below. Checks whether the class exposes `superclass`, then displays that parent and its directly defined selectors if available. No graph edits or audio scheduling. This tests inheritance as an explanation for the empty Instrument selector list; it does not assume unrestricted access to Kyma internals.

User result for inspect-instrument-parent.st: `Instrument parent class = Object`; `Parent methods = ()`. Both observed classes return empty direct selector lists. Reflection has not revealed graph access; this does not prove absence of named-object lookup. Further selector guessing is not justified by these results alone.

A documented alternative is exposing uniquely named green parameter variables inside a composite input graph and supplying them from its Script. Kyma X Revealed, printed pages 281-290, describes template variables and composite construction. This addresses parameters rather than looking up existing nodes by their display names. For a proposed test, mix two Oscillators, set their Frequency fields to `?osc1Freq` and `?osc2Freq`, set each Envelope to `0.025`, use Sine wavetables, and put the entire Mixer graph as the Script's only input. The corresponding script is in `two-oscillator-parameters.st`. This composite test has not yet been run by the user.

## Factory Tool investigation

See TOOL-OBJECT-ACCESS.md for concrete factory source calls: named top-level Sound retrieval, Sound construction, opening a Sound file window, and reading Sound points from a saved `.kym`. These are stronger evidence than reflection guesses, but do not yet establish nested-node lookup or ordinary parameter mutation. The proposed read-only gateway test is read-sound-file-tool.st; live execution remains unverified.
