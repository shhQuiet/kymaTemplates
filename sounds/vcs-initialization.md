# Generic VCS startup initializer

User confirmed "works" for ambient-drone/build-startup-test.st after supplying event: !DroneLevel and value: 0.5. This confirms the generic target binding in the drone test. The requested test included startup, live adjustment, and replay; the user gave a combined confirmation rather than separate observations.

## Template

Save TriggeredSoundToGlobalController as Initialize in the AI collection.

| Field | Setting |
| --- | --- |
| GeneratedEvent | ?event |
| Value | ?value |
| Trigger | 1 |
| Gated | Unchecked |
| Silent | Checked |
| AllowLiveOverride | Checked |
| ShowInVCS | Checked |

The full confirmed script is [build-startup-test.st](ambient-drone/build-startup-test.st), with Inputs VCF, Oscillator, Level, delay, Initialize. It supplies event: !DroneLevel and value: 0.5. Omitting event: causes a prompt for ?event.

One template can be instantiated for different targets; multiple target initialization has not yet been tested. Use the confirmed single-control pattern as the next step toward complete scripted starting settings.

## Range handling

Sound Class Reference printed 400 documents that Value is scaled by the target VCS min/max/grid. With range 0-1 and grid 0 it passes through unchanged. Physical-unit controls require conversion based on the actual widget range; the initializer does not set widget range metadata. This sets playback values, not a saved Default preset.

The standalone vcs-startup-test/ example was superseded by the user-preferred test in the existing drone.

Next prepared test: ambient-drone/build-initialized.st initializes all eight controls with the same template, including three conversions for known physical widget ranges. Not yet confirmed.

Initializer scaling correction: user observed DroneDepth 0.16667 when supplying 500/3000. In this actual setup, that value passes through rather than mapping to 500. Do not repeat the assumed inverse-range conversion. Current ambient-drone/build-initialized.st sends physical values directly: DroneDepth 500, DroneBrightness 180, DroneDelay 1.8. Verify displayed values after playback; actual widget metadata has not been inspected. This supersedes earlier conversion guidance for this test.

Confirmed result: user reported "yep, that worked" after the direct-value revision of ambient-drone/build-initialized.st. This is now the confirmed all-control initializer baseline in the user's setup: physical values sent directly (DroneBrightness 180, DroneDepth 500, DroneDelay 1.8), relative values sent in 0-1. Do not apply the earlier inverse-range conversion here. Broader behavior under different widget configurations remains untested.
