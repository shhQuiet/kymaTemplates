| instrumentClass |
instrumentClass := (inputs at: 1) class.

(instrumentClass recognizes: #selectors)
    ifTrue: [
        self debugWithLabel: 'Instrument methods'
            value: instrumentClass selectors]
    ifFalse: [
        self debug: 'This class does not expose selectors'].

self abortForKyma.
