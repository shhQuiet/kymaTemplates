# MIDI ambient drone — finished sound

User has finished this sound and plans a new patch. Latest delivered child: [build-midi-shared-child.st](build-midi-shared-child.st). Common parent: [../shared-support/parent.st](../shared-support/parent.st). Setup: [shared support](../shared-support/README.md). Earlier build files and [MIDI-LATCH.md](MIDI-LATCH.md) are historical development records.

Two Scripts only: child drone -> parent KymaSystem -> existing MIDI voice/wrapper. Child Inputs in any order: Initializer, InitializerGated, Oscillator, VCF, Level, DelayWithFeedback. Parent has only drone. Both Script Left/Right1. Conventional MIDI channel1, MPE off, MIDIVoice Live MIDI/polyphony1.

Three MIDI-latched note slots, two crossfading banks per slot. Starts silent; notes persist after release. New notes replace old ones with0.7s amplitude crossfades, not pitch glides. Slow filter breathing, amplitude motion, subtle pitch drift, stereo panning, and opposite-side echo input. DroneOn fades whole output over6s and clears slots at silence; turning on again waits for new note-ons. Delay buffers are not erased. Extremely rapid slot reuse may reach a bank before its fade finishes.

## Controls

Defaults are sent by the child each play; physical values are direct, not normalized by widget range.

| Control | Suggested range | Start | Meaning |
| --- | --- | --- | --- |
| DroneOn | 0-1 toggle | 1 | Whole output fade and note reset |
| DroneLevel | 0-1 | 0.5 | Overall voice level |
| DroneMotion | 0-1 | 0.2 | Larger values slow breathing/panning |
| DroneWidth | 0-1 | 0.8 | Centered to full stereo travel |
| BrightnessLow | 40-5000 Hz | 120 | Lower random-walk base cutoff |
| BrightnessHigh | 40-5000 Hz | 700 | Upper random-walk base cutoff |
| DroneBrightness | 40-5000 Hz | Driven by walk | Generated base cutoff |
| DroneDepth | 0-3000 Hz | 500 | Added breathing depth |
| DroneResonance | 0-1 | 0.41 | Scales to0-0.85 |
| DroneDelay | 0.1-3 seconds | 1.8 | Base delay before slot offsets |
| DroneFeedback | 0-1 | 0.71 | Scales to0-0.7 |
| DroneWet | 0-1 | 0.5 | Added echoes, scales to0-0.6; NOT dry/wet crossfade |

Brightness walk steps once per second, folds signed random walk with abs, smooths0.8s, and maps to sorted bounds. InitializerGated drives DroneBrightness; there is no competing one-shot initializer for it. DroneDepth is added after base brightness, so bounds do not limit final cutoff.

Latest change: common 30-second sinusoid adds +/-0.02 seconds AFTER slot offsets (2/3,5/6,1 times DroneDelay), giving all slots the full modulation. Times clamp0.01-3s. Existing delay Stereo/Linear/SmoothDelayChanges settings retained; no new controls.

Shared lookup, stereo drone, and restored child brightness walk were explicitly confirmed working. User heard the original +/-0.1-second delay LFO and requested less depth. The reduced +/-0.02-second version awaits explicit playback confirmation. Native file path and save/reopen not recorded. Do not claim this source alone is a native .kym.
