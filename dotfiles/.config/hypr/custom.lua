-- -----------------------------------------------------
-- Custom Hyprland Configuration (ML4W Persistence Layer)
-- -----------------------------------------------------

-- Upper Monitor: Cooler Master 34" Ultrawide (100Hz Main Display)
hl.monitor({
    output = "desc:CMT GM34-CWQ2 CMI235200056",
    mode = "3440x1440@100.0",
    position = "0x0",
    scale = 1.0,
    vrr = 0
})

-- Lower Monitor: Dell 27" 4K (60Hz, 1.5x Scaling -> 2560x1440 logical, Horizontally Centered at x=440, y=1440)
hl.monitor({
    output = "desc:Dell Inc. DELL U2723QE 4ZJP4P3",
    mode = "3840x2160@60.0",
    position = "440x1440",
    scale = 1.5,
    vrr = 0
})

-- Workspace Bindings: Upper (1~5), Lower (6~10)
hl.workspace_rule({
    workspace = "1",
    monitor = "HDMI-A-1",
    default = true
})
hl.workspace_rule({
    workspace = "2",
    monitor = "HDMI-A-1"
})
hl.workspace_rule({
    workspace = "3",
    monitor = "HDMI-A-1"
})
hl.workspace_rule({
    workspace = "4",
    monitor = "HDMI-A-1"
})
hl.workspace_rule({
    workspace = "5",
    monitor = "HDMI-A-1"
})
hl.workspace_rule({
    workspace = "6",
    monitor = "DP-2",
    default = true
})
hl.workspace_rule({
    workspace = "7",
    monitor = "DP-2"
})
hl.workspace_rule({
    workspace = "8",
    monitor = "DP-2"
})
hl.workspace_rule({
    workspace = "9",
    monitor = "DP-2"
})
hl.workspace_rule({
    workspace = "10",
    monitor = "DP-2"
})
