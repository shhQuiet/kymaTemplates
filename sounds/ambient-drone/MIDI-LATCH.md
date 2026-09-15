# MIDI-latched ambient drone

Status: prepared, awaiting user MIDI/playback test. Full script: build-midi-latch.st. Same Inputs: VCF, Oscillator, Level, delay, Initialize. No new prototype fields or VCS controls. All eight starting controls use the verified direct-value initializer.

Requested behavior: latch the last three notes played and sustain after release. Startup chord D2 A2 E3 fills slots until replaced. !KeyDown nextIndexMod: 3 rotates replacement slots; each slot gates sampleAndHold: !KeyNumber, with countTriggers tracking whether it has received a note. Each new note replaces the oldest slot once three have been entered. Repeated note-ons count separately; this is not a deduplicated chord set or held-key polyphony. Pitch changes glide for 0.3 seconds with +/-0.026 semitone drift. Existing filter breathing, stereo movement, and delays remain.

Reference: Kyma X Revealed printed 261-262 demonstrates capturing the last five MIDI notes using !KeyDown, !KeyNumber, countTriggersMod:, eq:, and sampleAndHold:. Capytalk Reference nextIndexMod: starts at -1 then 0 on first trigger, countTriggers starts at 0, sampleAndHold: captures on positive transition. This adaptation uses three slots and preserves starting pitches until a slot receives a MIDI note.

Test: Kyma must receive the keyboard's MIDI through its normal configuration. Play three distinct notes one at a time, release each, and listen for replacement and sustained pitches. Play a fourth to replace the first; repeated pitches also occupy slots. Simultaneous chords, legato note-ons, sustain pedal behavior, pitch bend, and MIDI channel routing are not verified by source inspection. !KeyNumber latches note numbers, not continuous pitch bend or velocity. Restart returns to startup notes unless incoming MIDI changes them. No held-note envelope gating is added.

Keep existing VCS ranges and initializer configuration. Save as a separate native Sound copy if retaining the original drone.

## MIDI diagnosis

User sees MIDI note messages on channel 1 in Kyma's monitor; default input channel is already 1. Adding an outer MIDIVoice (Live MIDI, Channel 1, Polyphony 1) and simplifying VCS modulation did not produce an audible note response. Latch script remains unverified/nonworking in this setup; do not claim success.

Next test: build-midi-direct-test.st, complete replacement Script using only Oscillator at input 2, with freq: !KeyNumber nn and fixed amp 0.05. Keep five existing input templates in place, and play the outer MIDIVoice. No initializer or other branches are scheduled. Expect immediate octave change between C3 and C4; no note-off gate, so it may continue at the last pitch after release. Before the first received note, pitch depends on the MIDI state and may be too low to hear. This tests note-event access plus Script frequency binding without the latch. No runtime result yet.

Confirmed setup fix: user disabled MPE and reported it fixed MIDI response. Prior configuration was Manual / Generic MPE despite ordinary channel-1 note messages. This explains the factory/direct test failures; it does not yet establish that the complete latch works. Next restore build-midi-latch.st and test three individual notes plus a fourth replacement.

## Silent-start revision

After disabling MPE, user confirms MIDI reception in the full drone but reports an impression that the startup chord remains while new notes are added. Cause not established; do not claim defaults or delay are definitively responsible. build-midi-latch-silent-start.st removes all default pitches and silences each oscillator until its slot captures a note. Three oscillators total in the Script; an outer MIDIVoice must have Polyphony 1 to avoid duplicating that graph. Same five inputs and initialization. New revision awaiting playback.

Test after Play: set DroneWet to 0 (startup resets it to 0.5), then play three high identical notes individually. No low default chord should exist, and a fourth note should replace one voice rather than add a fourth. Delay tails in the normal wet mix may preserve previous pitches temporarily. Voices stay latched after release by design.

## Crossfaded note replacement

User described silent-start MIDI version as "pretty good" but requested fading between notes instead of pitch glides. build-midi-crossfade.st uses two alternating banks per logical note slot (six oscillators/filters/delays total, not unbounded allocation). On capture, countTriggersMod: 2 selects the new bank; its note latch changes while its amplitude fades up over 0.7 s, and the other bank retains its pitch while fading down. Pitch smoothing is removed; gentle 0.026-semitone drift remains.

Same five prototypes, direct-value initialization, no extra VCS controls. Keep outer MIDIVoice Polyphony 1 and MPE off for the conventional keyboard. Old delay tails still decay independently; set DroneWet 0 after startup to hear the crossfade alone. Rapid repeated replacement of the same slot faster than the 0.7-second fade may reuse a bank before it is fully silent; this is a two-bank crossfade, not unlimited overlapping note allocation. CPU/memory use increases. Source prepared; playback not yet verified.

## Whole-output fade button

Prepared build-midi-crossfade-toggle.st adds !DroneOn, initialized to 1. Configure its VCS widget as a toggle button, off 0/on 1, range 0-1. outputFade = (!DroneOn gt: 0.5) smooth: 2 s. Apply this factor to both channels of every final dry and delay branch, so off fades all audible output, including delay tails. Inner envelopes, note capture, and delay processing continue silently; on restores the currently latched notes/effects. Stop/replay resets DroneOn to on. No new template or Script input. New button behavior awaits user playback confirmation; crossfade version received no explicit playback confirmation before this request.

Current input-order update: user requests Initialize first. build-midi-crossfade-toggle.st now expects Initialize, VCF, Oscillator, Level, Delay at indices 1-5. This supersedes the earlier ordering for that file only; historical tests retain their original order. No audio behavior changes.

## Longer fade with note clearing

New candidate build-midi-crossfade-clear.st uses Initialize first, then VCF, Oscillator, Level, Delay. !DroneOn controls six-second smooth output fade. Once off and fadeLevel <=0.0001, clearNotes resets total and per-slot note counters to zero; no slot is active. New note capture is gated by on and uses !KeyDown switchedOn so turning on while a key is already held does not deliberately capture that held state. Note count determines cyclic slot allocation.

Final dry and delay outputs are also gated by noteCount>0, keeping retained delay memory inaudible after clear until a fresh note is played. This clears active note assignments, not physical delay buffers; residual effects memory could briefly be heard when new input reopens the output. Reversing the fade before reaching silence retains the existing chord. No new VCS settings; existing DroneOn initialized to 1.

Documented reset method: Capytalk Reference countTriggersReset: (printed 68) resets to zero on positive reset transition; switchedOn (279) detects fresh note-on edges. This reset/fade revision is not yet playback-tested.
