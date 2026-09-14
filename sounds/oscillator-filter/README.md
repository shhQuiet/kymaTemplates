> Historical proof of concept. For current work use [the verified four-prototype baseline](../d-dorian-sequence/README.md). Status notes below describe this earlier experiment.

# Oscillator into filter: graph-construction proof of concept

Status: prepared from the documented construction syntax and installed sound builder example; not yet tested in Kyma. The earlier single-oscillator script was user-confirmed.

## Wrapper

Create or reuse a Script Sound. Its Inputs field must contain two separate templates in this order:

1. Oscillator: Wavetable Sine; Frequency `?freq`; Envelope `0.05`; modulation off. Other fields can retain the working oscillator defaults.
2. Filter: Type LowPass; Frequency `?cutoff`; Scale `1`; Feedback `0`; Order `2`. Its Input must contain a Variable Sound named `source`.

`source` is the Variable Sound's own name, with no question mark. It is not text entered into the Filter's Input field. Create a Variable from Prototypes, rename it in a Sound file window (select it and press Return/Enter), then place it in the Filter's Input. Do not connect the Oscillator to the Filter manually: the script supplies that connection.

Keep the Script's Left and Right levels at `1`. Paste build.st into the Script field and compile/play the Script.

## Expected result and test

The script creates a 220 Hz sine oscillator instance, stores it in a local variable, and supplies it as the Filter's source. Only the filtered output is scheduled at time zero. There should be no separately scheduled dry oscillator.

At a cutoff of 1000 Hz, expect a quiet steady tone. Change only `1000 hz` in the script to `50 hz`, then recompile/replay. The tone should be substantially quieter. Restore 1000 Hz and recompile to restore the level. Use Kyma's Stop command when finished.

This establishes nested construction, Sound-input substitution, and rebuilding from source. It does not depend on lookup of existing graph nodes. If compilation fails, record the exact error before changing anything else. Saving/reopening a native `.kym` is a later validation step.

## Sources

Kyma X Revealed, printed page 288, demonstrates nested template instances without start times, followed by scheduling the final processor. The installed Scripts*.kym contains the same sound builder pattern. Sound Class Reference, printed pages 70-71, documents Filter; page 412 documents Variable; pages 255-256 document Oscillator.

## Observed setup and correction

Live screenshot of the user's Script shows Inputs ordered Filter first, Oscillator second. The original code assumed Oscillator first, Filter second, so its frequency binding was applied to the wrong template and the scheduled Oscillator retained an unbound frequency variable. The user reported a prompt on the first play after edits and reuse of the dialog value on subsequent playback.

Use build-filter-first.st for the observed layout; it instantiates input 2 as the oscillator and schedules input 1 as the filter. This correction is based on the visible Inputs field. Playback of the corrected code is not yet confirmed. The previous speculation about capitalization was not established and should not be treated as the diagnosis.
