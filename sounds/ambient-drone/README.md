# Ambient drone test

Status: original sound user-confirmed ("very nice"). Current build.st normalizes relative VCS controls to 0-1 while retaining natural Hz and seconds and awaits playback confirmation. The original confirmed version is preserved as build-physical-controls.st. This is a separate test from the confirmed D Dorian sequencer.

Save a separate native Sound file as Ambient Drone.kym using a copy of the working four-template wrapper. Native file creation is performed in Kyma; this folder contains source and setup only. Script Inputs: VCF, Oscillator, Level, delay in that order. Use the verified base prototypes; no changes to their fields. Script Left and Right 1. Paste the complete build.st.

Three saw voices sustain D2, A2, E3 (73.4162, 110, 164.8138 Hz), compatible with the D Dorian sequence. No rhythmic gate. Each has slow cutoff/amplitude motion, stereo balance movement, and approximately +/-2.6 cents of pitch drift. Motion periods have different multipliers to avoid all voices rising together. Echo times are 2/3, 5/6, and 1 times DroneDelay, with independent private delay memories. There is no reverb stage.

## VCS

Relative controls use 0-1; frequencies and explicit delay time use natural Hz and seconds as requested. DroneMotion is a relative slowness control, not a literal duration: it maps 0-1 to a 20-120 second base period. Existing custom widget ranges and presets are not automatically converted by the script; return relative controls to 0-1 once.

| Control | Range | Start | Units/meaning |
| --- | --- | --- | --- |
| DroneLevel | 0-1 | 0.5 | Relative level; gain 0-0.7 |
| DroneMotion | 0-1 | 0.2 | Relative slowness |
| DroneBrightness | 80-1500 | 180 | Hz |
| DroneDepth | 0-3000 | 900 | Hz |
| DroneResonance | 0-1 | 0.41 | Relative resonance; internal 0-0.85 |
| DroneDelay | 0.1-3 | 1.8 | Seconds |
| DroneFeedback | 0-1 | 0.71 | Relative feedback; internal 0-0.7 |
| DroneWet | 0-1 | 0.5 | Relative wet level; gain 0-0.6 |

Rounded resonance and feedback starts closely match the original values; the others reproduce them exactly.

Drone prefixes keep these EventValues independent of the sequencer's controls. BPM is intentionally unused: this drone is free-running. Each voice's actual motion periods are multiples of DroneMotion; larger values slow movement. At DroneDelay 1.8 seconds, echo times are 1.2, 1.5, and 1.8 seconds. Delay changes can create transient pitch movement.

Listen for a sustained chord with gradual brightness and stereo movement over at least a minute. No missing-variable prompts are expected. DroneWet 0 isolates the direct voices; DroneDepth 0 removes the cutoff sweep; DroneLevel 0 silences the input and existing echoes then decay. Stop normally in Kyma. Three filters/delays and six scheduled output branches add DSP use compared with the sequence.

Static review: template bindings match the verified recipes, maximum delay fraction <=1, feedback <=0.7, oscillator voices scaled to 0.15 each. User playback confirms the original physical-control script runs and sounds good; the normalized revision has not yet been played. Native save/reopen, resource usage measurements, and individual VCS control tests have not been separately documented. Loop construction is documented in Kyma X Revealed's Script examples; Capytalk cos/repeatingRamp/smooth and nested construction reuse the working sequence mechanisms.

## Startup initialization test in the existing drone

User prefers adding to this four-template drone instead of creating a standalone oscillator test. Full build-startup-test.st adds TriggeredSoundToGlobalController as input 5. Configure GeneratedEvent !DroneLevel, Value ?value, Trigger 1, Gated unchecked, Silent checked, AllowLiveOverride checked, ShowInVCS checked. Keep DroneLevel range 0-1/grid0 and all other controls at their existing values.

Expected: playback sets DroneLevel to 0.5; manual changes remain effective. Set DroneLevel 0 (delay tails may persist), stop, replay, and check it returns to 0.5. Not yet confirmed. This test only initializes DroneLevel; a generic target binding and multi-control initialization remain future tests.

Current startup-test revision uses a generic initializer: GeneratedEvent ?event, Value ?value. The full script supplies event: !DroneLevel and value: 0.5. This supersedes the fixed GeneratedEvent instruction above. User prompt for ?event was from the earlier script omitting that binding. Updated test awaits playback.

Startup-test result: user confirmed "works" with the generic event: !DroneLevel binding and value: 0.5. See ../vcs-initialization.md for the verified template recipe and range caveat.

## All-control startup initialization

build-initialized.st extends the confirmed generic initializer to all eight drone controls. Inputs VCF, Oscillator, Level, delay, Initialize; same template settings. Prepared, awaiting playback confirmation. Each play is intended to reset all controls to the starting settings in the table above.

The five relative controls must have range 0-1/grid0. Physical controls assume exactly DroneBrightness 80-1500 Hz, DroneDepth 0-3000 Hz, DroneDelay 0.1-3 seconds; initialization sends normalized values (180-80)/(1500-80), 900/3000, and (1.8-0.1)/(3-0.1). The initializer does not configure widget ranges. Different ranges or grid rounding alter resulting values. Multiple target initialization and these physical conversions are the new test; single-target DroneLevel startup was previously confirmed.

User requested initialized DroneDepth around 500 after reporting no sound until raising that control. build-initialized.st now targets 500 Hz via 500/3000, assuming the documented VCS range 0-3000. Verify the widget displays 500 on playback; actual widget range has not been inspected, and initialization scaling remains unconfirmed. This supersedes the earlier 900-Hz initialization.

Initializer scaling correction: user observed DroneDepth 0.16667 when supplying 500/3000. In this actual setup, that value passes through rather than mapping to 500. Do not repeat the assumed inverse-range conversion. Current ambient-drone/build-initialized.st sends physical values directly: DroneDepth 500, DroneBrightness 180, DroneDelay 1.8. Verify displayed values after playback; actual widget metadata has not been inspected. This supersedes earlier conversion guidance for this test.

Confirmed result: user reported "yep, that worked" after the direct-value revision of ambient-drone/build-initialized.st. This is now the confirmed all-control initializer baseline in the user's setup: physical values sent directly (DroneBrightness 180, DroneDepth 500, DroneDelay 1.8), relative values sent in 0-1. Do not apply the earlier inverse-range conversion here. Broader behavior under different widget configurations remains untested.

## MIDI note input

[build-midi-latch.st](build-midi-latch.st) is a new three-note latch test; see [MIDI-LATCH.md](MIDI-LATCH.md). User requested notes to continue after release. Same five prototypes and initializer, no new fields. Awaiting MIDI/playback confirmation.
