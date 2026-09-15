# Dorian bass with Euverb Stereo

Status: new test awaiting user compilation/playback. Save a copy of the drone in a separate native Sound file, suggested name Dorian Bass Euverb.kym. Replace input 4 (delay) with the prepared Euverb Stereo composite. Order: VCF, Oscillator, Level, Euverb Stereo. Script Left and Right stay 1. Paste the complete build.st.

One sustained voice follows D2 A1 C2 E2 F2 B1 G2 A1 (all D Dorian). Default note interval eight seconds, eight-note cycle 64 seconds, 0.8-second pitch glide. Note triggers advance pitch only; they do not gate the amplitude. Filter breathing and gentle stereo balance movement continue independently. Reverb tails can overlap prior notes; no simultaneous oscillator chord. This test replaces the delay rather than adding a fifth template.

## VCS

| Control | Range | Start | Meaning |
| --- | --- | --- | --- |
| DroneLevel | 0-1 | 0.5 | Relative level |
| DroneMotion | 0-1 | 0.2 | Relative slowness |
| DroneBrightness | 80-1500 | 180 | Hz |
| DroneDepth | 0-3000 | 700 | Hz |
| DroneResonance | 0-1 | 0.3 | Relative resonance |
| DroneNoteSeconds | 2-30 | 8 | Seconds per note |
| DroneReverb | 0-1 | 0.5 | Reverb amount (scaled to 0-0.6) |
| DroneReverbDecay | 0-1 | 0.8 | Relative decay (scaled to 0-0.95) |
| DroneReverbTone | 0-1 | 0.45 | Native relative reverb cutoff |
| DroneDiffusion | 0-1 | 0.7 | Right reverb diffusion |

Set values manually and save a preset. Old drone delay controls are unused. Euverb Stereo exposes source, decay, cutoff, diffusion, reverb, direct; direct is 1 and no extra dry output is scheduled. The template cutoff is normalized, not Hz.

Parameter evidence: readable embedded help in /Volumes/Kyma/Kyma 7 Folder/Kyma X Sound Library/Effects Processing/Reverbs.kym identifies EuverbLeft and EuverbRight cutoff as 0-1 and decay as 0-1 corresponding to 0.1-10 seconds. No linear conversion is assumed. Right diffusion is applied to internal DelayScale expressions. This is evidence for the matching older components rather than the different generic EUVerb class.

Validation: delimiters balanced, all seven oscillator, six VCF, three Level, and six Euverb Stereo bindings supplied; template substitution and sequencing follow working examples. New reverb construction and pitch gliding still require playback verification. Test DroneReverb 0 for direct sound, then 0.5 for tails; set DroneLevel 0 and listen for reverb decay. Stop with Kyma's normal Stop.
