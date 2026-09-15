# Euverb Stereo prototype

Status: setup based on user screenshots; playback not yet tested. The selected factory composite is Euverb Stereo, not the separate EUVerb class in Sound Class Reference 64-66. Do not apply that different class's field list or parameter units to this composite without verification.

## Structure

One outer Variable feeds rightChan -> EuverbRight -> Level right, leftChan -> EuverbLeft -> Level left, and a dry Level input. The final Mixer is Euverb Stereo. Preserve channel selectors, left/right routing Levels, and final Mixer settings. Rename the outer Variable source. Save the complete final Mixer graph in the AI custom prototype collection.

| Component | Field | Setting |
| --- | --- | --- |
| EuverbLeft | Decay | ?decay |
| EuverbLeft | Cutoff | ?cutoff |
| EuverbLeft | Reverb | ?reverb |
| EuverbRight | Decay | ?decay |
| EuverbRight | Cutoff | ?cutoff |
| EuverbRight | Diffusion | ?diffusion |
| EuverbRight | Reverb | ?reverb |
| Dry Level named input | Left | ?direct |
| Dry Level named input | Right | ?direct |

EuverbLeft has no Diffusion field; only bind the field on EuverbRight. User screenshot shows EuverbLeft Reverb still set to !ReverbL: replace it with ?reverb so script bindings control both branches. Preserve leftChan and rightChan inputs. Repeated ?decay/?cutoff/?reverb names deliberately share each binding across this composite.

Script interface: source, decay, cutoff, diffusion, reverb, direct. Matching EuverbLeft/EuverbRight embedded help in the older factory Reverbs.kym confirms cutoff 0-1 and decay 0-1 (0.1-10 seconds, without an established linear mapping). Internal right-branch delay expressions use Diffusion for DelayScale. Playback behavior remains unverified. No script has been tested with this template yet.

Full first test: [Dorian bass with Euverb](dorian-bass-euverb/README.md).

Script Inputs naming: use unique identifier-style Sound names without spaces/punctuation (OscillatorFM, EuverbStereo, etc.). User confirmed renaming Delay fixed a rejected drop. This supersedes spaced display-name suggestions above; prototype internals and variable bindings are unchanged.
