| findInput |

"Look up one exact role name in the caller's input collection."
findInput := [:availableInputs :requiredName |
    | matches |
    matches := availableInputs select: [:candidate |
        candidate name printString = requiredName].
    (matches size = 1) ifFalse: [
        self debugWithLabel: ('Expected exactly one input named ', requiredName)
            value: matches size.
        self abortForKyma].
    matches at: 1
].

"Every input is a patch Script that receives the common functions."
inputs do: [:patch |
    patch start: 0 s findInput: findInput
].
