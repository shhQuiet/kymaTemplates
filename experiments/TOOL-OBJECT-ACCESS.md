# Tool access to native Sound objects

## Scope

The requirement is to find existing nodes by their display names and change ordinary parameters without preparing each target with question-mark variables. This investigation has found concrete factory Tool access to Sound objects, but has not established nested-node lookup or arbitrary parameter setters.

## Evidence from installed factory files

Read-only extraction of printable code from binary `.pci` files reveals the following. Extracted data can contain multiple versions and stale editor text; these are observed source fragments, not live execution results.

### Design Alternate Tunings

Source: `/Volumes/Kyma/Kyma 7 Folder/Zona Non Videre/Tools/tuning.pci`.

The MakeExampleSound block includes:

```smalltalk
snd :=
    Waveform = 'Use Sample:'
        ifTrue: [SSound soundNamed: 'SampleExample']
        ifFalse: [SSound soundNamed: 'OscExample'].
snd isNil
    ifTrue: [nil]
    ifFalse: [MIDIVoice createWithPolyphony: 8
        input: (snd applyBindings: bindings usingMap: FastIdentityDictionary new)].
```

Other blocks pass the result to:

```smalltalk
SoundSelection playSoundWithSubstitutions: snd.
KymaSoundPlaneWindow openNewSoundPlaneOnSound: snd.
```

`SSound` is a variable in that Tool, not a globally available object. Its associated installed grid is `Zona Non Videre/Tools/tuning.prg`. The calls show retrieval of a named top-level Sound from a Tool-associated collection, use in construction, and opening a Sound file window. `applyBindings:` still substitutes exposed variables; it does NOT meet the requirement to change unprepared target parameters.

### File Archivist

Source: `/Volumes/Kyma/Kyma 7 Folder/Zona Non Videre/Tools/Archive.pci`.

A file-reading branch includes:

```smalltalk
sounds addAllLast: (KymaSoundPlaneView obtainSoundPointsFrom: file).
```

This provides an observed entry point for reading saved `.kym` contents without modifying the source file. The returned collection element classes and their access methods must be checked. Do not assume a SoundPoint is a Sound or that a guessed `sound` getter exists.

### Other analysis Tools

`gaan.pci`, `rean.pci`, and `syncspec.pci` call Sound-producing methods and open the result using `KymaSoundPlaneWindow openNewSoundPlaneOnSound:` or `KymaSoundPlaneView openNewSoundPlaneOnSound:`. Both variants appear in extracted text; do not assume which variant is available in user-authored code until tested.

## Proposed next test

`read-sound-file-tool.st` uses the file selection and loader calls observed in Archive.pci and the documented debug dialog. Put it in a Tool Response that executes once (for example, an onEntry response), choose a saved Sound file, and report the returned object classes or exact compile error. It does not edit parameters, save files, or schedule audio. Do not put it behind a continuously true periodic trigger.

This tests whether user-authored Tool code can access the same loader as the factory Tool. Factory code may have different access; current evidence does not settle that. If the loader is available, inspect the actual returned objects and seek evidence for graph traversal and field access. Do not interpret named top-level retrieval as proof of nested-node lookup.

## Live validation status

An attempt to open a separate diagnostic text file through Kyma's UI did not complete. Application menus were accessible, but file-navigation text and dismissal actions were unreliable. No diagnostic was executed through this route, no Sound was changed, and no native file was saved. A file-navigation dialog may remain open.

## Documentation and external corroboration

Kyma X Revealed, printed pages 309-315 and 325-328, describes Tools, Tool variables, named playback, and EventValue control. This documentation does not establish arbitrary graph editing.

An SSC answer also confirms that Tools can evaluate Smalltalk live, whereas Script Smalltalk is evaluated before playback:
https://kyma.symbolicsound.com/qa/1403/is-it-possible-to-use-bpm-hotvalue-smalltalk-script-instead?show=1410

That confirms the execution-context distinction, not nested-node access.

## File-picker retry and text-editor test

The picker retry succeeded. Reliable sequence observed: invoke Open, inspect state, invoke Go to Folder, inspect state, set the path field directly with the accessibility setValue operation, verify the exact value, press Return, verify selection, then click Open. Keep actions and observations in separate calls. Clipboard paste timed out, while direct setValue worked.

Opened `/private/tmp/kyma-doc-review/tool-access-probe.txt` in Kyma and selected/evaluated this expression with Command+Y:

```smalltalk
self debugWithLabel: 'Sound-file loader available'
    value: (KymaSoundPlaneView recognizes: #obtainSoundPointsFrom:).
```

Observed result: the editor inserted `variable undeclared ->` at `KymaSoundPlaneView`, with `nil` selected as a suggested replacement. The internal class name is not resolved in this text-editor evaluation context. The loader was not called. This is not a Tool Response test and does not establish whether user-authored Tools have access. No native Sound was modified. The diagnostic text window remains open with the compiler annotation, unsaved.
