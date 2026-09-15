| matches child doubleValue |

matches := inputs select: [:candidate |
    candidate name printString = 'TestChild'].
(matches size = 1) ifFalse: [
    self debugWithLabel: 'Expected exactly one input named TestChild'
        value: matches size.
    self abortForKyma].
child := matches at: 1.

doubleValue := [:number | number * 2].

child start: 0 s helper: doubleValue.
