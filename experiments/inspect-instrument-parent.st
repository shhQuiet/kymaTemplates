| instrumentClass parent |
instrumentClass := (inputs at: 1) class.

(instrumentClass recognizes: #superclass)
    ifTrue: [
        parent := instrumentClass superclass.
        self debugWithLabel: 'Instrument parent class'
            value: parent.
        (parent recognizes: #selectors)
            ifTrue: [
                self debugWithLabel: 'Parent methods'
                    value: parent selectors]]
    ifFalse: [
        self debug: 'Superclass access is not exposed'].

self abortForKyma.
