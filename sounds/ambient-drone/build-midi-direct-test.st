| oscillatorTemplate |

oscillatorTemplate := inputs at: 2.

"Direct MIDI pitch test: no latch, modulation, filter, or delay."
oscillatorTemplate start: 0 s
    wave: 'Saw0064.aif'
    index: 0
    amp: 0.05
    freq: !KeyNumber nn
    formant: 1
    maxMI: 0
    reset: 0.
