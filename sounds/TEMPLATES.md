# Current user template inventory

Confirmed by user screenshot, in display order:

- Oscillator
- OscillatorFM
- VCF
- Level
- DelayWithFeedback
- DelayAllPass
- DelayNoInterp
- DelayImmediate
- DelayMono
- DelayKeepMemory
- EuverbStereo
- Initializer
- InitializerGated

The current screenshot confirms both Initializer and InitializerGated exist. User names variants with the original type/name first, followed by the variant suffix: InitializerGated, not GatedInitializer. Follow this convention for future variants.

Initializer is the one-shot startup controller; InitializerGated is its independent gated copy for continuous control. Both are working in the current drone. See vcs-initialization.md for settings and actual value scaling.

## Exact names and roles

For each patch specify the prototype and exact instance name. Names begin with family/type and optionally add a role suffix, e.g. OscillatorModulator. Prefix alone is not sufficient to distinguish OscillatorFM from Oscillator or InitializerGated from Initializer. Never silently choose the first prefix match.

Resolve names with the verified shared findInput helper using candidate name printString. Inputs may be in any order. Missing or duplicate exact role names should report a clear diagnostic. Historical positional scripts still require their own documented order.

Current drone child Inputs: Initializer, InitializerGated, Oscillator, VCF, Level, DelayWithFeedback. Parent KymaSystem has only child drone. No separate brightness Script.

Inventory confirms existence of optional variants; it does not establish playback of every variant. Oscillator, VCF, Level, DelayWithFeedback, Initializer, and InitializerGated are working in the drone. OscillatorFM, optional delay variants, and EuverbStereo are not separately playback-confirmed.
