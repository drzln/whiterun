const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const zrpc = b.dependency("zrpc", .{});
    const mach = b.dependency("mach", .{});
    const clap = b.dependency("clap", .{});
    const exe = b.addExecutable(.{
        .name = "whiterun",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = mode,
    });
    exe.addModule("zrpc", zrpc.module("zrpc"));
    exe.addModule("mach", mach.module("mach"));
    exe.addModule("clap", clap.module("clap"));
    exe.install();
}
