# Kyma Sound creation

Create native Kyma Sounds from descriptions using agent-authored Smalltalk and Capytalk. Reusable custom prototypes provide the building blocks; a Script constructs the graph and supplies its parameters and live controls.

## Working baseline

[Full D Dorian sequence script](sounds/d-dorian-sequence/build-all-prototypes.st) is user-confirmed working with all four base prototypes: Oscillator, VCF, Level, and delay. It plays eight eighth notes, with a cutoff LFO spanning four repetitions and a tempo-synchronized feedback delay.

Start with the [complete setup and VCS settings](sounds/d-dorian-sequence/README.md). See the [current template inventory](sounds/TEMPLATES.md) for exact user-confirmed names. Prototype recipes:

- [Oscillator and Oscillator FM](sounds/oscillator-prototypes.md)
- [VCF](sounds/vcf-prototype.md)
- [Level](sounds/level-prototype.md)
- [delay](sounds/delay-prototype.md)
- [EUVerb](sounds/euverb-prototype.md) — setup prepared; not yet tested

## New sound tests

[Ambient drone](sounds/ambient-drone/README.md): sustained D-A-E voices with slow modulation and long echoes, using the same four prototypes. User-confirmed playback.

[Dorian bass with Euverb Stereo](sounds/dorian-bass-euverb/README.md): slowly progressing bass notes and a first test of the stereo reverb template. Awaiting playback confirmation.

## Custom prototypes

The user's prototype file is `/Volumes/Kyma/SH-Kyma/Classes/Custom Collections.kym`, containing SH Spectral and SH Utility. The new templates are organized in its AI collection. AI is the category name, not an object-name prefix.

Open that file as a regular Sound file to edit it. Select Sounds and choose Action > Collect to create a category. Open it as Custom Prototypes to use the collections in the prototype bar. Prepared Sounds can be prototypes; encapsulated custom classes are optional.

This repository contains source and setup notes, not a self-contained native Sound. The prototype file and assets remain in their original locations. The saved location of the working sequencer has not been recorded; save/reopen validation has not been independently established.

## Local references

- `/Volumes/Kyma/Kyma 7 Folder`: installed libraries, examples, documentation.
- `/Volumes/Kyma/SH-Kyma`: Steve Horne's personal Sounds and assets.
- `/Volumes/Kyma/kyma-kata`: community contributions; preserve attribution and consult redistribution terms before adapting code.

[Workflow and evidence](CREATING-SOUNDS.md) · [Agent instructions](AGENTS.md) · [Historical investigations](experiments/README.md)
