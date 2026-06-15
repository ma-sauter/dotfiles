-- ~/.config/hypr/hyprland.lua
-- Hyprland injects the global 'hl' automatically. Do not use require("hyprland").

-------------------------------------------------------------------------------
-- 1. UTILITY FUNCTIONS (Your Embedded Scripts)
-------------------------------------------------------------------------------
local function exec(cmd)
    hl.exec_cmd(cmd)
end

-- Native Lua implementation of switch_wallpaper.sh and initialize_wallpaper.sh
local function handle_wallpaper(force_random)
    local home = os.getenv("HOME")
    local cache_exists = os.execute("[ -e " .. home .. "/.cache/wal/colors ]")

    if cache_exists == 0 and not force_random then
        exec("wal -R")
    else
        local wp_dir = home .. "/wallpaper"
        local p = io.popen("ls " .. wp_dir)
        local pics = {}
        if p then
            for file in p:lines() do
                table.insert(pics, file)
            end
            p:close()
        end

        if #pics > 0 then
            math.randomseed(os.time())
            local random_pic = pics[math.random(1, #pics)]
            local full_path = wp_dir .. "/" .. random_pic

            exec("awww img " .. full_path .. " --transition-type grow --transition-fps 60 --transition-duration 0.2 --transition-pos 0.810,0.972 --transition-bezier 0.65,0,0.35,1 --transition-step 255")
            exec("awww img" .. full_path)
            exec("wal -q -i " .. full_path)
        end
    end
end


-------------------------------------------------------------------------------
-- 2. ENVIRONMENT
-------------------------------------------------------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-------------------------------------------------------------------------------
-- 3. MONITORS 
-------------------------------------------------------------------------------
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "0x0",
    scale = 1
})

-- Standard Monitor setup
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto-right",
    scale = 1,
    mirror = "eDP-1"
})

-- Monitors at PosskeLab
hl.monitor({
    output = "DP-3",
    mode = "preferred",
    position = "auto-right",
    scale = 1
})
hl.monitor({
    output = "DP-5",
    mode = "preferred",
    position = "auto-right",
    scale = 1
})

-- Color Fallbacks
local active_border = "0xff7aa2f7"
local inactive_border = "0xff3b4261"

-------------------------------------------------------------------------------
-- 4. LOOK, FEEL & CORE CONFIGURATION MATRIX
-------------------------------------------------------------------------------
hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 5,
        border_size = 1,
        ["col.active_border"] = active_border,
        ["col.inactive_border"] = inactive_border,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle"
    },
    decoration = {
        rounding = 3,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)"
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            vibrancy = 0.1696
        }
    },
    animations = {
        enabled = true
    },
    dwindle = {
        preserve_split = true
    },
    input = {
        kb_layout = "us,us",
        kb_variant = ",intl",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true
        }
    },
    xwayland = {
            enabled = true
    }
})

-- Workspace rules
hl.workspace_rule({
        workspace = "10",
        on_created_empty = "keepassxc",
        default_name = ""
})

-- Animations
hl.curve( "Bezier", { type = "bezier", points = { { 0.65,0}, {0.35,1} } })
hl.curve( "Spring", { type = "spring", mass = 1, stiffness = 170, dampening = 15 })

hl.animation({
        leaf = "global",
        enabled = true,
        speed = 2,
        bezier = "Bezier",
})

-- Gestures map
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Per-device exceptions
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5
})

-------------------------------------------------------------------------------
-- 5. WINDOW RULES
-------------------------------------------------------------------------------
hl.window_rule({
    match = { class = ".*" },
    suppress_event = "maximize"
})

-------------------------------------------------------------------------------
-- 6. KEYBINDINGS (Optimized via robust lambda dispatch wrappers)
-------------------------------------------------------------------------------
-- Shortcut helper for command execution keybinds
local function bind_cmd(keys, cmd, flags)
    hl.bind(keys, function() exec(cmd) end, flags)
end

-- Function / Media keys
bind_cmd("XF86AudioMute", "amixer set Speaker unmute; amixer set Master toggle")
bind_cmd("XF86AudioLowerVolume", "amixer set Master 10%-", { repeating = true })
bind_cmd("XF86AudioRaiseVolume", "amixer set Master 10%+", { repeating = true })
bind_cmd("XF86AudioMicMute", "pactl set-source-mute 1 toggle")
bind_cmd("XF86MonBrightnessDown", "brightnessctl set 5%-", { repeating = true })
bind_cmd("XF86MonBrightnessUp", "brightnessctl set 5%+", { repeating = true })

-- Core applications & layouts
bind_cmd("SUPER + Q", "alacritty")
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exit())
bind_cmd("SUPER + E", "nemo")
hl.bind("SUPER + V", hl.dsp.window.float())
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + S", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.swap({prev = true}))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({action = toggle}))
bind_cmd("SUPER + PRINT", "hyprshot -m window")

-- Web-Apps & Custom Script Triggers
hl.bind("SUPER + W", function() handle_wallpaper(true) end) -- BROKEN!!!
bind_cmd("SUPER + B", "brave")
bind_cmd("SUPER + G", "brave --app=https://chat.openai.com")
bind_cmd("SUPER + N", "brave --app=https://notion.so")
bind_cmd("SUPER + O", "obsidian")

-- Custom layout chain
hl.bind("SUPER + SHIFT + F", function()
    hl.dispatch(hl.dsp.window.float())
    hl.dispatch(hl.dsp.window.resize({x=1980, y=1080, relative = false}))
    hl.dispatch(hl.dsp.window.move({x=0,y=0})) --still need to implement inverse
end)

-- Directional window navigation
hl.bind("SUPER + H", hl.dsp.focus({direction = "l"}))
hl.bind("SUPER + J", hl.dsp.focus({direction = "d"}))
hl.bind("SUPER + K", hl.dsp.focus({direction = "u"}))
hl.bind("SUPER + L", hl.dsp.focus({direction = "r"}))

-- Moving Windows to Workspaces Loop
for i = 0, 9 do
    local ws = tostring(i == 0 and 10 or i)
    hl.bind("SUPER + " .. tostring(i), hl.dsp.focus({workspace=ws}))
    hl.bind("SUPER + SHIFT + " .. tostring(i), hl.dsp.window.move({workspace=ws}))
    hl.bind("SUPER + CONTROL + SHIFT + " .. tostring(i), hl.dsp.window.move({monitor=tostring(i-1), follow = true}))
end

-- Moving Workspace to Next Monitor by pressing arrow keys
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.workspace.move({monitor = "+1", follow = "true"}))
hl.bind("SUPER + SHIFT + LEFT", hl.dsp.workspace.move({monitor = "-1", follow = "true"}))
-- Moving Focus to Next Monitor by pressing arrow keys
hl.bind("SUPER + RIGHT", hl.dsp.focus({monitor = "+1"}))
hl.bind("SUPER + LEFT", hl.dsp.focus({monitor = "-1"}))

-- Mouse Dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", function() hl.dispatch("resizewindow") end, { mouse = true })
hl.bind("SUPER + mouse_down", function() hl.dispatch("workspace", "e+1") end)
hl.bind("SUPER + mouse_up", function() hl.dispatch("workspace", "e-1") end)

-------------------------------------------------------------------------------
-- 7. SUBMAPS (Resize and Audio)
-------------------------------------------------------------------------------
hl.bind("SUPER + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
        hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = true}), { repeating = true })
        hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = true}), { repeating = true })
        hl.bind("K", hl.dsp.window.resize({ x = 0, y = 10, relative = true}), { repeating = true })
        hl.bind("J", hl.dsp.window.resize({ x = 0, y = -10, relative = true}), { repeating = true })
        hl.bind("catchall", hl.dsp.submap("reset"))
end)


hl.bind("SUPER + A", hl.dsp.submap("audio"))

hl.define_submap("audio", function()
        hl.bind("L", function() exec("pactl set-card-profile 0 output:analog-stereo") end)
        hl.bind("H", function() exec("pactl set-card-profile 0 output:hdmi-stereo") end)
        
        hl.bind("catchall", hl.dsp.submap("reset"))
end)


-------------------------------------------------------------------------------
-- 8. AUTOSTART EXECS
-------------------------------------------------------------------------------
hl.on("hyprland.start", function()
        hl.exec_cmd("systemctl --user start hyprpolkitagent")
        hl.exec_cmd("awww-daemon")
        handle_wallpaper(false)
        hl.exec_cmd("/usr/bin/dunst")
        hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
        hl.exec_cmd("waybar -c .config/waybar/config.jsonc")
end)
