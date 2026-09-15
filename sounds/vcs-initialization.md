# VCS initialization and continuous control

Both are working in the current drone. Exact library names: Initializer and InitializerGated.

| Field | Initializer | InitializerGated |
| --- | --- | --- |
| Class recipe | TriggeredSoundToGlobalController | Independent copy of same |
| GeneratedEvent | ?event | ?event |
| Value | ?value | ?value |
| Trigger | 1 | 1 |
| Gated | Unchecked | Checked |
| Silent | Checked | Checked |
| AllowLiveOverride | Checked | Checked |
| ShowInVCS | Checked | Checked |

Initializer is scheduled for each starting control with event: !ControlName and value: itsStartingValue. It initializes on playback and permits live changes. Multiple controls and direct physical values are user-confirmed. InitializerGated drives a continuously changing expression, currently !DroneBrightness from the child brightness walk. Put the template in the Inputs of the Script scheduling it.

## Actual range behavior

Supply physical values directly in this setup: DroneDepth500, DroneDelay1.8. Earlier attempted inverse-range normalization gave DroneDepth0.16667 instead of500; do not repeat it. Relative controls use0-1. The script initializes current values, not widget range metadata or a saved default preset. Always provide ranges/units to the user when exposing controls. Behavior under different widget configurations has not been generalized.

Current source: ambient-drone/build-midi-shared-child.st. Historical startup tests retain old names and input ordering; they are evidence, not current setup instructions.
