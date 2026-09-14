| target |
target := inputs at: 1.

self debugWithLabel: 'Input object class'
    value: target class.

self debugWithLabel: 'Supported messages'
    value: (#(name input inputs soundNamed: allInputs allSounds)
        select: [:selector | target recognizes: selector]).

self abortForKyma.
