const std = @import("std");
const clay = @import("zclay");
const sokol = @import("sokol");
const slog = sokol.log;
const sg = sokol.gfx;
const sapp = sokol.app;
const sglue = sokol.glue;
const bae_arch = @import("bae_arch_ui");

const min_memory_size: u32 = clay.minMemorySize();
const memory = try allocator.alloc(u8, min_memory_size);
defer allocator.free(memory);
const arena: clay.Arena = clay.createArenaWithCapacityAndMemory(memory);
_ = clay.initialize(arena, .{ .h = 1024, .w = 768 }, .{});

const state = struct {
    var pass_action: sg.PassAction = .{};
    var pip: sg.Pipeline = .{};
    var bind: sg.Bindings = .{};
};

export fn init() void {
    sg.setup(.{
        .environment = sglue.environment(),
        .logger = .{ .func = slog.func },
    });

    state.pass_action.colors[0] = .{
        .load_action = .CLEAR,
        .clear_value = .{ .r = 0, .g = 0, .b = 0, .a = 1 },
    };

    //    state.pip = sg.makePipeline(.{
    //        .index_type = .UINT16,
    //        .cull_mode = .NONE,
    //        .depth = .{
    //            .compare = .LESS_EQUAL,
    //            .write_enabled = true,
    //        },
    //    });
}

export fn frame() void {
    sg.beginPass(.{ .action = state.pass_action, .swapchain = sglue.swapchain() });
    //    sg.applyPipeline(state.pip);
    //    sg.applyBindings(state.bind);
    sg.endPass();
    sg.commit();
}

export fn input(event: ?*const sapp.Event) void {
    const ev = event.?;
    if (ev.type == .KEY_DOWN) {}
}

export fn cleanup() void {
    sg.shutdown();
}

pub fn main() !void {
    sapp.run(.{
        .init_cb = init,
        .frame_cb = frame,
        .event_cb = input,
        .cleanup_cb = cleanup,
        .width = 1024,
        .height = 768,
        .sample_count = 4,
        .icon = .{ .sokol_default = true },
        .window_title = "Bae Arch",
        .logger = .{ .func = slog.func },
    });
}
