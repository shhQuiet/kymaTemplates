| target |
target := inputs at: 1.

self debugWithLabel: 'Input class'
    value: target class.

self debugWithLabel: 'Input printable description'
    value: target printString.

self debugWithLabel: 'Recognizes printString'
    value: (target recognizes: #printString).

self debugWithLabel: 'Recognizes name'
    value: (target recognizes: #name).

"Deliberately test name directly, even if recognizes: returned false."
self debugWithLabel: 'Direct name result'
    value: target name.

self abortForKyma.
