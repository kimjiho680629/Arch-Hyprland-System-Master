-------------------------------------------------------
-- Monitor Setup: Upper 34" Ultrawide + Lower 27" 4K (Centered)
-- name: "Dual Vertical (34" Top + 27" Bottom)"
-------------------------------------------------------

hl.monitor({
    output = "desc:CMT GM34-CWQ2 CMI235200056",
    mode = "3440x1440@100.0",
    position = "0x0",
    scale = 1.0,
    vrr = 0
})

hl.monitor({
    output = "desc:Dell Inc. DELL U2723QE 4ZJP4P3",
    mode = "3840x2160@60.0",
    position = "440x1440",
    scale = 1.5,
    vrr = 0
})
