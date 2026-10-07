# emptyTest

Separate test copy of the current MIDI ambient drone, requested 2026-10-05. The child source is unchanged from ambient-drone/build-midi-shared-child.st, including the 30-second delay modulation with +/-5 ms depth. This test has not been compiled or auditioned in Kyma.

## Setup

Name the child Script exactly `emptyTest`. Paste build-shared-child.st into it. Set Left and Right to 1.

Put these prototypes inside emptyTest, with exact instance names matching each prototype: Initializer, InitializerGated, Oscillator, VCF, Level, DelayWithFeedback. Order does not matter.

Use emptyTest as the test input of the existing KymaSystem parent, using ../shared-support/parent.st; set Left and Right to 1. For a test of this patch alone, use only emptyTest as its input. The parent schedules every child and mixes outputs.

Route through the existing MIDIVoice wrapper: Live MIDI, channel 1, MPE off, polyphony 1. Play the parent/wrapper and send MIDI notes. Starts silent and latches the last three note-ons.

Controls retain the Drone names and defaults from ../ambient-drone/README.md. Running both copies together may share these controllers; this copy is intended for testing on its own. The original drone files are preserved.

Core drone playback was previously confirmed. The +/-5 ms delay adjustment and latest all-child parent iteration still await explicit playback confirmation. No native .kym file is created by this source copy.
