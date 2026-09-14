| signal |
signal := (inputs at: 1) freq: 220 hz.

(inputs at: 2) start: 0 s
    source: signal
    cutoff: 1000 hz.
