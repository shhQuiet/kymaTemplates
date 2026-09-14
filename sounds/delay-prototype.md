# Delay prototype

Retain the proven single-input Mixer wrapper, named delay, with Left and Right 1. Inside DelayWithFeedback: Input Variable named source; Delay ?maxDelay; DelayScale ?delayFraction; Feedback ?feedback; Scale ?scale; SlewRate ?slewRate. maxDelay must be supplied at compile time; live timing is delayFraction * maxDelay. Verified baseline supplies maxDelay 3 s, scale 1, slewRate 1.

Fixed settings: Type Comb, Interpolation Linear, SmoothDelayChanges checked, Stereo checked, Prezero checked, Wavetable Private. Private is the special allocation choice; script binding of that choice is not established. Named shared memory needs a separately prepared prototype.

Optional copies can cover fixed choices now: delay Allpass (Type Allpass), delay NoInterp (Interpolation None), delay Immediate (SmoothDelayChanges unchecked), delay Mono (Stereo unchecked), delay KeepMemory (Prezero unchecked). Each copy otherwise retains base settings. These are individual variants, not every combination. Allpass contains direct audio; do not substitute into the current wet-only mix without changing the script. KeepMemory contents are not guaranteed to be useful previous audio.

Source: Sound Class Reference printed 49-50. build-all-prototypes.st is the full user-confirmed baseline. Existing VCS settings unchanged.

Playback confirmation: user reported "works good" for build-all-prototypes.st with the base delay wrapper. Bindings source, maxDelay, scale, slewRate, delayFraction, and feedback are now confirmed in this sequence. Optional fixed-setting variants have not been tested.
