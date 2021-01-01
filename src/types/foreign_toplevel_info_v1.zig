const wlr = @import("../wlroots.zig");

const std = @import("std");
const wl = @import("wayland").server.wl;

pub const ForeignToplevelInfoV1 = extern struct {
    event_loop: *wl.EventLoop,
    global: *wl.Global,
    resources: wl.list.Head(wl.Resource, null),
    toplevels: wl.list.Head(ForeignToplevelHandleV1, "link"),

    server_destroy: wl.Listener(*wl.Server),

    events: extern struct {
        destroy: wl.Signal(*ForeignToplevelInfoV1),
    },

    data: usize,

    extern fn wlr_ext_foreign_toplevel_info_v1_create(wl_server: *wl.Server) ?*ForeignToplevelInfoV1;
    pub fn create(wl_server: *wl.Server) !*ForeignToplevelInfoV1 {
        return wlr_ext_foreign_toplevel_info_v1_create(wl_server) orelse error.OutOfMemory;
    }
};

pub const ForeignToplevelHandleV1 = extern struct {
    pub const State = packed struct {
        maximized: bool align(@alignOf(u32)) = false,
        minimized: bool = false,
        activated: bool = false,
        fullscreen: bool = false,
        _: u28,
        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u32));
            std.debug.assert(@alignOf(@This()) == @alignOf(u32));
        }
    };

    pub const Output = extern struct {
        link: wl.list.Link,
        output_destroy: wl.Listener(*wlr.Output),
        output: *wlr.Output,
        toplevel: *ForeignToplevelHandleV1,
    };

    info: *ForeignToplevelInfoV1,
    resources: wl.list.Head(wl.Resource, null),
    link: wl.list.Link,
    idle_source: ?*wl.EventSource,

    title: ?[*:0]u8,
    app_id: ?[*:0]u8,
    parent: ?*ForeignToplevelHandleV1,
    outputs: wl.list.Head(ForeignToplevelHandleV1.Output, "link"),
    state: State,

    events: extern struct {
        destroy: wl.Signal(*ForeignToplevelHandleV1),
    },

    data: usize,

    extern fn wlr_ext_foreign_toplevel_handle_v1_create(manager: *ForeignToplevelInfoV1) ?*ForeignToplevelHandleV1;
    pub fn create(manager: *ForeignToplevelInfoV1) !*ForeignToplevelHandleV1 {
        return wlr_ext_foreign_toplevel_handle_v1_create(manager) orelse error.OutOfMemory;
    }

    extern fn wlr_ext_foreign_toplevel_handle_v1_destroy(toplevel: *ForeignToplevelHandleV1) void;
    pub const destroy = wlr_ext_foreign_toplevel_handle_v1_destroy;

    extern fn wlr_ext_foreign_toplevel_handle_v1_set_title(toplevel: *ForeignToplevelHandleV1, title: [*:0]const u8) void;
    pub const setTitle = wlr_ext_foreign_toplevel_handle_v1_set_title;

    extern fn wlr_ext_foreign_toplevel_handle_v1_set_app_id(toplevel: *ForeignToplevelHandleV1, app_id: [*:0]const u8) void;
    pub const setAppId = wlr_ext_foreign_toplevel_handle_v1_set_app_id;

    extern fn wlr_ext_foreign_toplevel_handle_v1_output_enter(toplevel: *ForeignToplevelHandleV1, output: *wlr.Output) void;
    pub const outputEnter = wlr_ext_foreign_toplevel_handle_v1_output_enter;

    extern fn wlr_ext_foreign_toplevel_handle_v1_output_leave(toplevel: *ForeignToplevelHandleV1, output: *wlr.Output) void;
    pub const outputLeave = wlr_ext_foreign_toplevel_handle_v1_output_leave;

    extern fn wlr_ext_foreign_toplevel_handle_v1_set_maximized(toplevel: *ForeignToplevelHandleV1, maximized: bool) void;
    pub const setMaximized = wlr_ext_foreign_toplevel_handle_v1_set_maximized;

    extern fn wlr_ext_foreign_toplevel_handle_v1_set_minimized(toplevel: *ForeignToplevelHandleV1, minimized: bool) void;
    pub const setMinimized = wlr_ext_foreign_toplevel_handle_v1_set_minimized;

    extern fn wlr_ext_foreign_toplevel_handle_v1_set_activated(toplevel: *ForeignToplevelHandleV1, activated: bool) void;
    pub const setActivated = wlr_ext_foreign_toplevel_handle_v1_set_activated;

    extern fn wlr_ext_foreign_toplevel_handle_v1_set_fullscreen(toplevel: *ForeignToplevelHandleV1, fullscreen: bool) void;
    pub const setFullscreen = wlr_ext_foreign_toplevel_handle_v1_set_fullscreen;

    extern fn wlr_ext_foreign_toplevel_handle_v1_set_parent(toplevel: *ForeignToplevelHandleV1, parent: ?*ForeignToplevelHandleV1) void;
    pub const setParent = wlr_ext_foreign_toplevel_handle_v1_set_parent;
};
