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

Initializer is the only controller template the user has created. Earlier instructions used Initialize and proposed Control; neither is a separate confirmed library template. Previous verified recipe for Initializer used TriggeredSoundToGlobalController with GeneratedEvent ?event, Value ?value, Trigger 1, Gated off, Silent/AllowLiveOverride/ShowInVCS on. User calls it SoundToGlobalController generically; this screenshot alone does not establish its exact class or current Gated setting.

For the random-walk wrapper, continuous output needs an independently configured copy (Gated on for the triggered class), or a future generalization of the template. Do not assume a Control template exists. Announce any copy or parameter changes explicitly before supplying code that depends on them. Preserve the original startup initializer behavior. Current local object class and parameters must be checked before treating the inventory screenshot as confirmation of them.

Use the exact names above in setup instructions. Script positional references remain valid after display renames when input order is preserved. Initializer goes first. Current inner drone order: Initializer, VCF, Oscillator, Level, DelayWithFeedback. Historical scripts and notes use earlier display names.
