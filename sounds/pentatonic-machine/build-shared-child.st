| findInput oscillatorTemplate filterTemplate levelTemplate delayTemplate
  initializerTemplate tempo density brightness motion spread delayMix volume
  pulses notes strides rates echoBeats attack decay adDuration |

"Child Script: PentatonicMachine. Play through the unchanged KymaSystem parent."
findInput := ?findInput.
oscillatorTemplate := findInput value: inputs value: 'Oscillator'.
filterTemplate := findInput value: inputs value: 'VCF'.
levelTemplate := findInput value: inputs value: 'Level'.
delayTemplate := findInput value: inputs value: 'DelayWithFeedback'.
initializerTemplate := findInput value: inputs value: 'Initializer'.

"Direct physical values for tempo and cutoff; relative controls are 0-1."
initializerTemplate start: 0 s event: !PentaTempo value: 96.
initializerTemplate start: 0 s event: !PentaDensity value: 0.65.
initializerTemplate start: 0 s event: !PentaBrightness value: 1800.
initializerTemplate start: 0 s event: !PentaMotion value: 0.4.
initializerTemplate start: 0 s event: !PentaSpread value: 0.8.
initializerTemplate start: 0 s event: !PentaDelay value: 0.3.
initializerTemplate start: 0 s event: !PentaVolume value: 0.65.
initializerTemplate start: 0 s event: !PentaAttack value: 0.01.
initializerTemplate start: 0 s event: !PentaDecay value: 0.18.

tempo := (!PentaTempo vmax: 30) vmin: 180.
density := (!PentaDensity vmax: 0) vmin: 1.
brightness := ((!PentaBrightness vmax: 150) vmin: 6000) smooth: 0.05 s.
motion := ((!PentaMotion vmax: 0) vmin: 1) smooth: 0.05 s.
spread := ((!PentaSpread vmax: 0) vmin: 1) smooth: 0.05 s.
delayMix := ((!PentaDelay vmax: 0) vmin: 1) smooth: 0.05 s.
volume := ((!PentaVolume vmax: 0) vmin: 1) smooth: 0.03 s.

attack := (!PentaAttack vmax: 0.005) vmin: 1.
decay := (!PentaDecay vmax: 0.02) vmin: 3.
adDuration := attack + decay.

"Eight-step Euclidean patterns: density selects 1-8 pulses; zero mutes attacks."
pulses := ((density * 8) truncated vmax: 1) vmin: 8.
"C major pentatonic, C3-A4; ten zero-based Capytalk array positions."
notes := #(48 50 52 55 57 60 62 64 67 69).
strides := #(1 3 7 9 3 7).
rates := #(2 1 0.5 2 1 0.5).
echoBeats := #(0.75 1 1.5 0.75 1 1.5).

1 to: 6 do: [:i |
    | clock gate index pitch envelope oscillator cutoff filtered pan
      positioned echo delaySeconds phase filterPhase progress rise fall |
    phase := (i - 1) / 6.
    clock := (1 bpm: (tempo * (rates at: i)) dutyCycle: 0.22) abs.
    gate := (clock euclideanForBeats: 8 pulses: pulses offset: (i - 1)) abs.
    gate := gate * (density gt: 0).
    "Each voice traverses all ten notes in a different permutation."
    index := (((clock nextIndexMod: 10) * (strides at: i)) + (i - 1)) mod: 10.
    "Hold each sounding note throughout its AD tail, including rests."
    pitch := (gate sampleAndHold: (index of: notes)) nn.
    "Linear attack to 1, then linear decay to 0; retrigger on each active step."
    progress := gate ramp: adDuration s.
    rise := ((progress * adDuration / attack) vmax: 0) vmin: 1.
    fall := (((1 - progress) * adDuration / decay) vmax: 0) vmin: 1.
    envelope := (rise * fall) smooth: 0.002 s.
    oscillator := oscillatorTemplate
        wave: 'Saw0064.aif'
        index: 0
        amp: (envelope * 0.06)
        freq: pitch
        formant: 1
        maxMI: 0
        reset: 0.
    filterPhase := ((1 repeatingRamp: 16 s) + phase) * 6.283185307.
    cutoff := ((brightness * (1 + (filterPhase sin * motion * 0.7)))
        vmax: 100) vmin: 10000.
    filtered := filterTemplate
        source: oscillator
        amp: 1
        cutoff: cutoff hz
        modRange: 0 hz
        modulator: oscillator
        resonance: 0.2.
    pan := (((((1 repeatingRamp: 24 s) + phase) * 6.283185307) sin)
        * spread * 0.5) + 0.5.
    positioned := levelTemplate
        source: filtered
        left: (1 - pan)
        right: pan.
    "Dry and wet branches are scheduled separately and mix at the Script output."
    levelTemplate start: 0 s
        source: positioned
        left: (volume * 0.75)
        right: (volume * 0.75).
    "Dotted eighth, quarter, or dotted quarter; 3 s accommodates 30 BPM."
    delaySeconds := (60 / tempo) * (echoBeats at: i).
    echo := delayTemplate
        source: positioned
        maxDelay: 3 s
        delayFraction: (delaySeconds / 3)
        feedback: 0.3
        scale: 1
        slewRate: 1.
    levelTemplate start: 0 s
        source: echo
        left: (volume * delayMix * 0.6)
        right: (volume * delayMix * 0.6).
].
