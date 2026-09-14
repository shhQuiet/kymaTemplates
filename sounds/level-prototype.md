# Level prototype

User-confirmed working with independent channel bindings. Save as Level in the AI collection.

| Field | Setting |
| --- | --- |
| Input | Variable Sound named source |
| Left | ?left |
| Right | ?right |
| Interpolation | Enabled/Linear |
| NoGain | Checked |

For centered output, the script supplies equal left and right values. Independent values allow stereo level control without editing the prototype. The latest complete example is [build-all-prototypes.st](d-dorian-sequence/build-all-prototypes.st); all three Level instances use left: and right:, not the earlier amp: binding.

NoGain and interpolation remain fixed choices; alternative configurations have not been tested. Source: Sound Class Reference, printed 120.
