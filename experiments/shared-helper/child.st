| helper result |

helper := ?helper.
result := helper value: 21.

self debugWithLabel: 'Shared helper result (expected 42)'
    value: result.

self abortForKyma.
