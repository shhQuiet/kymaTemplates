| initializerTemplate droneTemplate controllerTemplate
  low high walk brightness |

initializerTemplate := inputs at: 1.
droneTemplate := inputs at: 2.
controllerTemplate := inputs at: 3.

initializerTemplate start: 0 s event: !BrightnessLow value: 120.
initializerTemplate start: 0 s event: !BrightnessHigh value: 700.

"Accept the limits in either order; keep cutoff above 40 Hz."
low := (!BrightnessLow vmin: !BrightnessHigh) vmax: 40.
high := (!BrightnessLow vmax: !BrightnessHigh) vmax: 40.

"Fold the signed walk so wrapping does not jump between the limits."
walk := ((1 s tick)
    randomWalkStartingFrom: 0.5
    stepSize: 0.3
    reset: 0) abs.

brightness := low + ((high - low) * (walk smooth: 0.8 s)).
brightness := (brightness vmax: low) vmin: high.

"Run the original drone and its external brightness controller."
droneTemplate start: 0 s.
controllerTemplate start: 0 s
    event: !DroneBrightness
    value: brightness.
