# Oscillator prototype setup

Prepared from Sound Class Reference printed 255-256; base Oscillator expanded variable set user-confirmed working. User wants broad one-time parameterization to avoid future UI context switching.

## Oscillator

Wavetable ?wave; Index ?index; Envelope ?amp; Frequency ?freq; Formant ?formant; MaxMI ?maxMI; Reset ?reset. Fixed Modulation None, Interpolation Linear, FromMemoryWriter unchecked. Modulator Constant Value 0. Do not expose legacy PitchBend: if the UI still shows it, leave it at 0. User has current hardware. AI is the collection name only, not a prototype-name prefix.

Complete base call:

```smalltalk
oscillator := oscillatorTemplate
    wave: 'Saw0064.aif'
    index: 0
    amp: 0.2
    freq: pitch
    formant: 1
    maxMI: 0
    reset: 0.
```

## Oscillator FM

Duplicate the fully parameterized base. Set Modulation Frequency. Replace Modulator Constant with Variable Sound named modulator (without ?). Script must also supply modulator: with a constructed Sound. This audio input binding has not yet been tested for this oscillator; reuse the template substitution approach proven for processor source bindings.

## Fixed-setting variants

Menus and checkbox variable binding is not established: preserve fixed settings and use variants. From the base and FM templates create versions with Interpolation None (suffix NoInterp), FromMemoryWriter checked (suffix Memory), and both (suffix Memory NoInterp). This gives eight variants for the documented None/Frequency modulation, Linear/None interpolation, and disk/memory choices. Memory playback requires a matching MemoryWriter graph; these variants are not standalone live capture. Keep any additional Modulation choices in the installed UI unclaimed until inspected.

Use these bindings with the configured Oscillator prototype. The full working example is d-dorian-sequence/build-all-prototypes.st. Each future script must explicitly supply all exposed scalar values; no automatic omitted-parameter defaults are established.

Script Inputs naming: use unique identifier-style Sound names without spaces/punctuation (OscillatorFM, EuverbStereo, etc.). User confirmed renaming Delay fixed a rejected drop. This supersedes spaced display-name suggestions above; prototype internals and variable bindings are unchanged.
