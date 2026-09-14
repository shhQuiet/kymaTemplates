"Proposed read-only Tool Response. Run once, not on a repeating trigger."
| file points |
file := HostDriverInterface
    getFileWithPrompt: 'Select a Sound file to inspect'
    fileTypes: HostDriverInterface soundPlaneFileTypes
    ifCancel: [nil].

file isNil ifFalse: [
    points := KymaSoundPlaneView obtainSoundPointsFrom: file.
    self debugWithLabel: 'Loaded object classes'
        value: (points collect: [:point | point class])].
