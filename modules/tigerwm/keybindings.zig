// Shared keybinding table: single source of truth for input.zig and the fuzzer
const c = @import("c.zig").c;
const config = @import("config.zig");

pub const Action = union(enum) {
    spawn: []const [*:0]const u8,
    spawn_minor: []const [*:0]const u8,
    focusstack: i32,
    incnmaster: i32,
    setmfact: f32,
    zoom: void,
    view: u32,
    viewall: void,
    killclient: void,
    setlayout: ?usize,
    togglefloating: void,
    togglefullscreen: void,
    rotate_clients: i32,
    focusmaster: void,
    tag: u32,
    toggleview: u32,
    toggletag: u32,
    focusmon: i32,
    tagmon: i32,
    quit: void,
    chvt: u32,
    togglescratch: void,
    toggleprivacy: void,
};

pub const KeyBinding = struct {
    mod: u32,
    keysym: u32,
    action: Action,
};

pub const MODKEY = config.mod_key;
pub const SHIFT = c.WLR_MODIFIER_SHIFT;
pub const CTRL = c.WLR_MODIFIER_CTRL;
pub const ALT = c.WLR_MODIFIER_ALT;

pub const keys = keys: {
    const core = [_]KeyBinding{
        // Spawn commands
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_Return, .action = .{ .spawn = &config.term_cmd } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_Return, .action = .{ .spawn_minor = &config.term_cmd } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_p, .action = .{ .spawn = &config.menu_cmd } },
        // .{ .mod = MODKEY, .keysym = c.XKB_KEY_p, .action = .{ .spawn = &config.window_cmd } },
        // .{ .mod = MODKEY, .keysym = c.XKB_KEY_s, .action = .{ .spawn = &config.screenshot_cmd } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_e, .action = .{ .spawn = &config.emacs_cmd } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_u, .action = .{ .spawn = &config.lock_cmd } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_period, .action = .{ .spawn = &config.scratchpad_cmd } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_c, .action = .{ .spawn = &config.calc_cmd } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_b, .action = .{ .spawn = &config.bluetooth_cmd } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_e, .action = .{ .spawn = &config.excel_cmd } },

        // Kill client
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_Q, .action = .{ .killclient = {} } },

        // Focus / stack
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_j, .action = .{ .focusstack = 1 } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_k, .action = .{ .focusstack = -1 } },

        // Master-stack controls
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_Left, .action = .{ .setmfact = -0.05 } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_Right, .action = .{ .setmfact = 0.05 } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_i, .action = .{ .incnmaster = 1 } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_I, .action = .{ .incnmaster = -1 } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_space, .action = .{ .zoom = {} } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_K, .action = .{ .rotate_clients = 1 } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_J, .action = .{ .rotate_clients = -1 } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_o, .action = .{ .focusmaster = {} } },

        // Monitor focus/tag (l=LEFT, h=RIGHT per user preference)
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_h, .action = .{ .focusmon = c.WLR_DIRECTION_LEFT } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_H, .action = .{ .tagmon = c.WLR_DIRECTION_LEFT } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_l, .action = .{ .focusmon = c.WLR_DIRECTION_RIGHT } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_L, .action = .{ .tagmon = c.WLR_DIRECTION_RIGHT } },

        // Layout
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_f, .action = .{ .togglefullscreen = {} } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_y, .action = .{ .setlayout = 0 } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_g, .action = .{ .setlayout = 1 } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_m, .action = .{ .setlayout = 2 } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_t, .action = .{ .setlayout = 3 } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_g, .action = .{ .togglefloating = {} } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_period, .action = .{ .toggleview = config.scratchpad_tag } },
        .{ .mod = MODKEY, .keysym = c.XKB_KEY_comma, .action = .{ .togglescratch = {} } },
        // shift + comma = less
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_less, .action = .{ .tag = config.scratchpad_tag } },
        // shift + period = greater
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_greater, .action = .{ .toggletag = config.scratchpad_tag } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_Delete, .action = .{ .quit = {} } },
        .{ .mod = MODKEY | SHIFT, .keysym = c.XKB_KEY_p, .action = .{ .toggleprivacy = {} } },
    };

    const tag_bindings = blk: {
        const tag_syms = [_][2]u32{
            .{ c.XKB_KEY_1, c.XKB_KEY_exclam },
            .{ c.XKB_KEY_2, c.XKB_KEY_at },
            .{ c.XKB_KEY_3, c.XKB_KEY_numbersign },
            .{ c.XKB_KEY_4, c.XKB_KEY_dollar },
            .{ c.XKB_KEY_5, c.XKB_KEY_percent },
            .{ c.XKB_KEY_6, c.XKB_KEY_asciicircum },
            .{ c.XKB_KEY_7, c.XKB_KEY_ampersand },
            .{ c.XKB_KEY_8, c.XKB_KEY_asterisk },
            .{ c.XKB_KEY_9, c.XKB_KEY_parenleft },
            .{ c.XKB_KEY_0, c.XKB_KEY_parenright },
        };

        var bindings: [tag_syms.len * 4]KeyBinding = undefined;
        for (tag_syms, 0..) |tk, t| {
            const tag_bit: u32 = @as(u32, 1) << @as(u5, @intCast(t));
            bindings[t * 4 ..][0..4].* = .{
                .{ .mod = MODKEY, .keysym = tk[0], .action = .{ .view = tag_bit } },
                .{ .mod = MODKEY | CTRL, .keysym = tk[0], .action = .{ .toggleview = tag_bit } },
                .{ .mod = MODKEY | SHIFT, .keysym = tk[1], .action = .{ .tag = tag_bit } },
                .{ .mod = MODKEY | CTRL | SHIFT, .keysym = tk[1], .action = .{ .toggletag = tag_bit } },
            };
        }
        break :blk bindings;
    };

    break :keys core ++ tag_bindings;
};
