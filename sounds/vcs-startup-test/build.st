| oscillatorTemplate initializerTemplate |

oscillatorTemplate := inputs at: 1.
initializerTemplate := inputs at: 2.

"Set TestLevel once at startup; allow subsequent VCS changes."
initializerTemplate start: 0 s
    value: 0.5.

oscillatorTemplate start: 0 s
    wave: 'Saw0064.aif'
    index: 0
    amp: (0.1 * (((!TestLevel vmax: 0) vmin: 1) smooth: 0.03 s))
    freq: 110 hz
    formant: 1
    maxMI: 0
    reset: 0.
