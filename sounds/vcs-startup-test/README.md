# Startup VCS value test

Status: prepared, awaiting user playback. Standalone test rather than modifying the drone.

Create a Script with Inputs ordered Oscillator (verified base prototype), TriggeredSoundToGlobalController. Keep Script Left/Right 1. Name the second template Initialize for convenience.

| Initializer field | Setting |
| --- | --- |
| GeneratedEvent | !TestLevel |
| Value | ?value |
| Trigger | 1 |
| Gated | Unchecked |
| Silent | Checked |
| AllowLiveOverride | Checked |
| ShowInVCS | Checked |

Keep TestLevel VCS range 0-1, grid 0 (standard defaults). Paste the complete build.st. Expected: on playback, TestLevel becomes 0.5 and a quiet 110 Hz saw sounds. Drag TestLevel to 0: silence; raise it: tone returns, without snapping back. Stop with TestLevel 0, restart: expected 0.5 again. Startup timing, preset interaction, and restart behavior must be verified.

Fixed GeneratedEvent deliberately isolates startup/live-override semantics. This is not yet a generic target-name initializer; binding the GeneratedEvent itself is a later test. Trigger 1 is a proposed startup trigger, not yet confirmed in this class. Silent must be checked because the controller's Value can otherwise appear as DC audio.

Source: Sound Class Reference printed 400. Value is scaled by the target VCS range; with 0-1/grid0, 0.5 remains 0.5. This sets playback values, not widget ranges or saved preset defaults.
