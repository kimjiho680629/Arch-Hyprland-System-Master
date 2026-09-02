-- Upper monitor: Cooler Master 34" Ultrawide @ 100Hz
hl.monitor({
    output = "desc:CMT GM34-CWQ2 CMI235200056",
    mode = "3440x1440@100.0",
    position = "0x0",
    scale = 1.0,
    vrr = 0
})

-- Lower monitor: Dell 27" 4K @ 60Hz (1.5x scale -> 2560x1440 logical, centered at x=440, y=1440)
hl.monitor({
    output = "desc:Dell Inc. DELL U2723QE 4ZJP4P3",
    mode = "3840x2160@60.0",
    position = "440x1440",
    scale = 1.5,
    vrr = 0
})
