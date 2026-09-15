# Handoff: ready for a new sound

Updated 2026-09-15. Steve is finished with the MIDI ambient drone and wants to create another sound in a new chat. Use this repository and preserve the drone. Start a new sound folder when the new musical request arrives; do not keep refining the drone unless asked.

## Proven architecture

Two Scripts: patch-specific child -> common parent -> optional MIDI wrapper/output. The parent defines shared functions, passes blocks to the child, and schedules its audio. Each Sound contains its own copy; no external import or shared mutable state is required.

Current parent is KymaSystem, using [parent.st](sounds/shared-support/parent.st). Its current input is the child named drone. The latest generic parent iterates every input Script, passes findInput, and starts it at zero; multiple child outputs mix. This generalization has not yet been playback-tested. The current child uses [build-midi-shared-child.st](sounds/ambient-drone/build-midi-shared-child.st), with these six inputs in ANY order:

- Initializer
- InitializerGated
- Oscillator
- VCF
- Level
- DelayWithFeedback

The parent passes findInput; the child calls it with its own inputs and an exact role name. Names use type/family first and optional role suffix. Give Steve explicit prototype-to-instance-name instructions for each new patch. The parent no longer hard-codes drone: use it unchanged with any child name. Parent inputs must be patch Scripts accepting findInput; their raw templates stay in the children.

## What the drone does

Latches the last three MIDI note-ons, sustaining after release. Two alternating banks per slot crossfade notes over 0.7 seconds instead of gliding. Slow filter/amplitude breathing, subtle detune drift, moving stereo voices and oppositely placed echoes. DroneOn fades the whole output over six seconds; once faded out it clears note assignments. Reenable waits for fresh MIDI notes. Delay memory itself is not erased.

Brightness random walk is INSIDE the child. BrightnessLow/High initialize to120/700Hz, suggested range40-5000Hz, and InitializerGated drives DroneBrightness continuously. DroneDepth adds breathing above that base. There is no third brightness Script. Missing bounds were resolved by moving InitializerGated from parent to child Inputs.

Last delivered change adds a 30-second sinusoidal +/-0.02-second delay modulation to each slot after its delay offset; actual times clamp0.01-3s. The original +/-0.1-second sweep was audible but too dramatic; the reduced +/-0.02-second revision awaits explicit playback confirmation. Shared functions, stereo drone, and restored brightness walk were explicitly confirmed working.

## Reuse and preferences

Always deliver FULL scripts inline. Use existing prototypes and helper code; don't make Steve assemble snippets. Relative controls0-1, physical time/frequency in natural units. Supply defaults via Initializer using direct values (500 means500Hz here). Give widget ranges when exposing controls. Name-based lookup uses candidate name printString; name asString fails and recognizes: falsely denied name. See AGENTS.md for full instructions.

Use [template inventory](sounds/TEMPLATES.md), [shared support](sounds/shared-support/README.md), and individual prototype recipes. Most older .st files are retained experiments with old names/order. Do not choose them over the current source by filename guesswork.

Existing conventional MIDI setup is channel1, MPE off, single outer MIDIVoice with polyphony1. No native .kym location is recorded. Repo: /Users/stevehorne/dev/kyma, remote https://github.com/shhQuiet/kymaTemplates.git. Check Git status and the remote for publication state.

User-approved standard parent behavior: treat every parent input as a child patch Script, pass the common helper bindings to each, schedule all at start: 0 s, and mix their audio outputs. No hard-coded child name or special single-child path. Keep raw prototypes inside the children. This is the intended architecture; the latest all-child iteration implementation is still awaiting explicit playback confirmation.

Latest follow-up: user found the initial delay LFO too dramatic, confirming it was audible. Current child reduces its depth to +/-0.02 seconds (20 ms), retaining the 30-second period. Reduced-depth revision awaits playback.
