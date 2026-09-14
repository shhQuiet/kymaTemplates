| signal |
signal := (inputs at: 2) freq: 220 hz.

(inputs at: 1) start: 0 s
    source: signal
    cutoff: 1000 hz.
