# A Dorian sparkles

This is a proposed child Script for the existing `KymaSystem` parent. The parent supplies `findInput` and schedules the child. It has not yet been compiled or auditioned in Kyma.

Create a child Script named `ADorianSparkles`. In its Inputs, drop these existing AI prototypes and give each instance the exact name shown. Order does not matter:

| Prototype | Instance name |
| --- | --- |
| Initializer | `Initializer` |
| Oscillator | `Oscillator` |
| VCF | `VCF` |
| Level | `Level` |
| DelayWithFeedback | `DelayWithFeedback` |

Paste the entire [child script](build-shared-child.st) into `ADorianSparkles`. Keep Script Left and Right at 1. Drop `ADorianSparkles` into the Inputs of the existing `KymaSystem` parent; it receives the parent helper bindings there. Play the parent. The existing parent implementation is [parent.st](../shared-support/parent.st). No new prototype is needed.

The Markov chain starts at the scale position for A4. At each eighth-note pulse, one random draw chooses a step: roughly 30% down, 40% stay, and 30% up. The accumulated state is restricted to the ten scale positions E4-G5, so boundaries hold instead of jumping across the range. Every next note is the current note or an adjacent A Dorian scale note.

The sound blends a sine fundamental with a filtered saw layer. An adjustable attack ramps each note in to prevent a click, followed by a short decay. Slow cutoff movement shapes the bright layer, which feeds a light delay with adjustable time.

Suggested VCS widget ranges and script-initialized values:

| Control | Range | Initial | Units |
| --- | --- | --- | --- |
| SparkleBPM | 40-200 | 110 | Quarter-note beats/minute |
| SparkleLevel | 0-1 | 0.45 | Relative level |
| SparkleBrightness | 0-1 | 0.55 | Relative cutoff |
| SparkleResonance | 0-1 | 0.2 | Relative resonance |
| SparkleWet | 0-1 | 0.27 | Relative echo level |
| SparkleFeedback | 0-1 | 0.25 | Relative feedback |
| SparkleDelayTime | 0.05-2 | 0.41 | Seconds |
| SparkleAttack | 0.002-0.08 | 0.02 | Seconds |

The Initializer sets the current values when playback starts but does not set VCS widget-range metadata. The shared parent's all-child iteration is documented but still awaits explicit playback confirmation. Record any compile diagnostics or playback result before calling this patch verified.
