// Comptime configuration for dwz.
// Edit this file and recompile to customize (matching dwl's config.def.h philosophy).

const std = @import("std");

// ── Pool Limits ────────────────────────────────────────────────────────

pub const max_clients: usize = 256;
pub const max_monitors: usize = 8;
pub const max_layer_surfaces: usize = 64;
pub const max_keyboard_groups: usize = 4;
pub const max_pointer_constraints: usize = 8;
pub const max_session_locks: usize = 2;
pub const max_ipc_outputs: usize = 32;
pub const max_cursor_devices: usize = 16;
pub const max_popup_trackers: usize = 64;

// ── Tags ───────────────────────────────────────────────────────────────

/// Number of tags (workspaces). Maximum 31 (must fit in u32 bitmask minus sign bit).
pub const tag_count: u5 = 10;

// ── Appearance ─────────────────────────────────────────────────────────

pub const border_px: u32 = 2;
pub const monitor_border_flash_ms: u32 = 300;
pub const sloppy_focus: bool = true;
pub const bypass_surface_visibility: bool = false;

/// Color represented as 4 floats (RGBA, 0.0–1.0).
pub const Color = [4]f32;

pub fn hexColor(comptime hex: u32) Color {
    return .{
        @as(f32, @floatFromInt((hex >> 24) & 0xFF)) / 255.0,
        @as(f32, @floatFromInt((hex >> 16) & 0xFF)) / 255.0,
        @as(f32, @floatFromInt((hex >> 8) & 0xFF)) / 255.0,
        @as(f32, @floatFromInt(hex & 0xFF)) / 255.0,
    };
}

pub const root_color: Color = hexColor(0x222222ff);
pub const border_color: Color = hexColor(0x444444ff);
pub const focus_color: Color = hexColor(0x005577ff);
pub const urgent_color: Color = hexColor(0xff0000ff);
pub const fullscreen_bg: Color = .{ 0.0, 0.0, 0.0, 1.0 };

// ── Keyboard ───────────────────────────────────────────────────────────

pub const repeat_rate: i32 = 25;
pub const repeat_delay: i32 = 600;

// XKB rule names (null means use system default)
pub const xkb_rules: ?[*:0]const u8 = null;
pub const xkb_model: ?[*:0]const u8 = null;
pub const xkb_layout: ?[*:0]const u8 = null;
pub const xkb_variant: ?[*:0]const u8 = null;
pub const xkb_options: ?[*:0]const u8 = "ctrl:nocaps";

// ── Trackpad ───────────────────────────────────────────────────────────

pub const tap_to_click: bool = true;
pub const tap_and_drag: bool = true;
pub const drag_lock: bool = true;
pub const natural_scrolling: bool = false;
pub const disable_while_typing: bool = true;
pub const left_handed: bool = false;
pub const middle_button_emulation: bool = false;
pub const accel_speed: f64 = 0.0;

// ── Layouts ────────────────────────────────────────────────────────────

pub const Layout = struct {
    symbol: []const u8,
    arrange: ?*const fn (monitor: anytype) void,
};

// Layout function pointers are set up in layout.zig; here we just define symbols.
// The actual layout table with function pointers lives in layout.zig.
pub const layout_symbols = [_][]const u8{
    "[]=", // tile (default)
    "><>", // floating
    "[M]", // monocle
    "[][]", // deck
};

// ── Monitor Rules ──────────────────────────────────────────────────────

pub const MonitorRule = struct {
    // Match keys. If any key is set, all set keys must match.
    // Rules matching by make/model/serial/description are preferred over name-only rules.
    name: ?[]const u8, // connector name (e.g. "DP-5"), unstable across reconnects
    make: ?[]const u8, // manufacturer
    model: ?[]const u8, // model name
    serial: ?[]const u8, // serial number (can be empty/missing on some outputs)
    description: ?[]const u8, // compositor-provided human-readable output description
    mfact: f32,
    nmaster: i32,
    scale: f32,
    layout_idx: usize,
    transform: u32, // wl_output_transform
    x: i32,
    y: i32,
};
pub const monitor_rules = [_]MonitorRule{
    .{
        .name = "eDP-1",
        .make = null,
        .model = null,
        .serial = null,
        .description = null,
        .mfact = 0.55,
        .nmaster = 1,
        .scale = 2.0,
        .layout_idx = 0,
        .transform = 0,
        .x = 3840,
        .y = 240,
    },
    .{
        .name = null,
        .make = null,
        .model = "P32p-30",
        .serial = "V30D66R3",
        .description = null,
        .mfact = 0.55,
        .nmaster = 1,
        .scale = 2.0,
        .layout_idx = 0,
        .transform = 0,
        .x = 1920,
        .y = 120,
    },
    .{
        .name = null,
        .make = null,
        .model = null,
        .serial = null,
        .description = null,
        .mfact = 0.55,
        .nmaster = 1,
        .scale = 2.0,
        .layout_idx = 0,
        .transform = 0,
        .x = -1,
        .y = -1,
    },
};

// ── Window Rules ───────────────────────────────────────────────────────

pub const Rule = struct {
    app_id: ?[]const u8,
    title: ?[]const u8,
    tags: u32,
    is_floating: bool,
    monitor: i32, // -1 = any
};

pub const rules = [_]Rule{
    // Example: .{ .app_id = "Gimp", .title = null, .tags = 0, .is_floating = true, .monitor = -1 },
};

// ── Key Bindings ───────────────────────────────────────────────────────

/// Modifier key used as the main modifier (Alt by default).
/// WLR_MODIFIER_ALT
pub const mod_key: u32 = 8;
/// WLR_MODIFIER_LOG
// pub const mod_key: u32 = 64;

// enum wlr_keyboard_modifier {
//  WLR_MODIFIER_SHIFT = 1 << 0,
//  WLR_MODIFIER_CAPS = 1 << 1,
//  WLR_MODIFIER_CTRL = 1 << 2,
//  WLR_MODIFIER_ALT = 1 << 3,
//  WLR_MODIFIER_MOD2 = 1 << 4,
//  WLR_MODIFIER_MOD3 = 1 << 5,
//  WLR_MODIFIER_LOGO = 1 << 6,
//  WLR_MODIFIER_MOD5 = 1 << 7,
// };

/// Action function type for key/button bindings.
pub const ActionFn = *const fn (*anyopaque, Arg) void;

pub const Arg = union {
    i: i32,
    ui: u32,
    f: f32,
    v: ?*const anyopaque,
};

pub const Key = struct {
    mod: u32,
    keysym: u32,
    action: ActionFn,
    arg: Arg,
};

pub const Button = struct {
    mod: u32,
    button: u32,
    action: ActionFn,
    arg: Arg,
};

// Key and button binding tables are populated in input.zig after action functions exist.
// We declare the types here so all modules share them.

// ── Commands ───────────────────────────────────────────────────────────

pub const term_bin = [_]const u8{"/run/current-system/sw/bin/alacritty"};
pub const launcher_bin = [_]const u8{"/run/current-system/sw/bin/rofi"};

pub const scratchpad_tag: u32 = 1 << 20;
pub const term_cmd = [_][*:0]const u8{term_bin};
pub const emacs_cmd = [_][*:0]const u8{ "/bin/sh", "-c", "emacs" };
pub const scratchpad_cmd = [_][*:0]const u8{ "/bin/sh", "-c", "emacs-scratchpad" };
pub const menu_cmd = [_][*:0]const u8{ launcher_bin, "-mode" "combi" "-combi-modi", "window,run.ssh", "-show", "drun", "-theme", "material" };
pub const window_cmd = [_][*:0]const u8{ launcher_bin, "-show", "window", "-theme", "material" };
pub const screenshot_cmd = [_][*:0]const u8{ "/bin/sh", "-c", "/run/current-system/sw/bin/grim -g \"$(/run/current-system/sw/bin/slurp)\" - | /run/current-system/sw/bin/wl-copy" };
pub const calc_cmd = [_][*:0]const u8{ term_bin, "-e", "numbat" };
pub const excel_cmd = [_][*:0]const u8{ "bin/sh", "-c", "libreoffice --calc" };
pub const lock_cmd = [_][*:0]const u8{ "/bin/sh", "-c", "swaylock -c 000000" };
pub const bar_cmd = [_][*:0]const u8{"/run/current-system/sw/bin/waybar"};
pub const portal_cmd = [_][*:0]const u8{ "/bin/sh", "-c", "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots && systemctl --user start xdg-desktop-portal xdg-desktop-portal-wlr" };
pub const autostart_cmds = [_][]const [*:0]const u8{
    // &bar_cmd,
    &term_cmd
    // Example idle/lock/DPMS workflow (disabled by default):
    // &[_][*:0]const u8{
    //     "/bin/sh",
    //     "-c",
    //     "swayidle -w timeout 300 'gtklock -d' timeout 600 \"wlr-randr | awk '/^[^[:space:]].* connected/{print \\\\$1}' | xargs -r -I{} wlr-randr --output {} --off\" resume \"wlr-randr | awk '/^[^[:space:]].* connected/{print \\\\$1}' | xargs -r -I{} wlr-randr --output {} --on\" before-sleep 'gtklock -d'",
    // },
};

pub const TaggedAutostartCmd = struct {
    cmd: []const [*:0]const u8,
    tag_mask: u32,
};

pub const autostart_tagged_cmds = [_]TaggedAutostartCmd{
    // Example: start one specific Emacs instance on scratchpad (one-shot).
    // .{
    //     .cmd = &[_][*:0]const u8{ "emacs", "--name", "scratch-emacs" },
    //     .tag_mask = scratchpad_tag,
    // },
};

// ── XWayland ───────────────────────────────────────────────────────────

pub const enable_xwayland: bool = @import("build_options").enable_xwayland;

// ── Logging ────────────────────────────────────────────────────────────

/// wlroots log level: 0=silent, 1=error, 2=info, 3=debug
pub const wlr_log_level: c_int = 1; // WLR_ERROR

// ── Tests ──────────────────────────────────────────────────────────────

test "hexColor: white" {
    const white = hexColor(0xFFFFFFFF);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), white[0], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), white[1], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), white[2], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), white[3], 0.01);
}

test "hexColor: black" {
    const black = hexColor(0x000000FF);
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), black[0], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), black[1], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), black[2], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), black[3], 0.01);
}

test "hexColor: red" {
    const red = hexColor(0xFF0000FF);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), red[0], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), red[1], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), red[2], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), red[3], 0.01);
}

test "hexColor: semi-transparent green" {
    const green = hexColor(0x00FF0080);
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), green[0], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), green[1], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 0.0), green[2], 0.01);
    try std.testing.expectApproxEqAbs(@as(f32, 0.502), green[3], 0.01);
}

test "pool limits are sane" {
    try std.testing.expect(max_clients >= 1);
    try std.testing.expect(max_monitors >= 1);
    try std.testing.expect(max_layer_surfaces >= 1);
    try std.testing.expect(max_keyboard_groups >= 1);
    try std.testing.expect(max_session_locks >= 1);
    try std.testing.expect(tag_count >= 1 and tag_count <= 31);
}

test "scratchpad_tag is a valid power of two" {
    try std.testing.expect(scratchpad_tag != 0);
    // Must be a single bit (power of two)
    try std.testing.expectEqual(@as(u32, 0), scratchpad_tag & (scratchpad_tag - 1));
}

test "monitor rules have valid defaults" {
    for (monitor_rules) |rule| {
        try std.testing.expect(rule.mfact >= 0.1 and rule.mfact <= 0.9);
        try std.testing.expect(rule.nmaster >= 0);
        try std.testing.expect(rule.scale >= 0.5);
        try std.testing.expect(rule.layout_idx < layout_symbols.len);
    }
}
