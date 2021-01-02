const wlr = @import("../wlroots.zig");

const std = @import("std");
const wl = @import("wayland").server.wl;

pub const ForeignToplevelManagerV1 = extern struct {
    pub const event = struct {
        pub const Maximize = extern struct {
            manager: *ForeignToplevelManagerV1,
            toplevel: *wlr.ForeignToplevelHandleV1,
            maximize: bool,
        };

        pub const Minimize = extern struct {
            manager: *ForeignToplevelManagerV1,
            toplevel: *wlr.ForeignToplevelHandleV1,
            minimize: bool,
        };

        pub const Activate = extern struct {
            manager: *ForeignToplevelManagerV1,
            toplevel: *wlr.ForeignToplevelHandleV1,
            seat: *wlr.Seat,
        };

        pub const Fullscreen = extern struct {
            manager: *ForeignToplevelManagerV1,
            toplevel: *wlr.ForeignToplevelHandleV1,
            fullscreen: bool,
            output: *wlr.Output,
        };

        pub const Close = extern struct {
            manager: *ForeignToplevelManagerV1,
            toplevel: *wlr.ForeignToplevelHandleV1,
        };

        pub const SetRectangle = extern struct {
            manager: *ForeignToplevelManagerV1,
            toplevel: *wlr.ForeignToplevelHandleV1,
            surface: *wlr.Surface,
            x: i32,
            y: i32,
            width: i32,
            height: i32,
        };
    };

    global: *wl.Global,

    server_destroy: wl.Listener(*wl.Server),

    events: extern struct {
        request_maximize: wl.Signal(*event.Maximize),
        request_minimize: wl.Signal(*event.Minimize),
        request_activate: wl.Signal(*event.Activate),
        request_fullscreen: wl.Signal(*event.Fullscreen),
        request_close: wl.Signal(*event.Close),
        set_rectangle: wl.Signal(*event.SetRectangle),
        destroy: wl.Signal(*ForeignToplevelManagerV1),
    },

    data: usize,

    extern fn wlr_ext_foreign_toplevel_manager_v1_create(wl_server: *wl.Server) ?*ForeignToplevelManagerV1;
    pub fn create(wl_server: *wl.Server) !*ForeignToplevelManagerV1 {
        return wlr_ext_foreign_toplevel_manager_v1_create(wl_server) orelse error.OutOfMemory;
    }
};
