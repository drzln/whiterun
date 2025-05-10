const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const zrpc = b.dependency("zrpc", .{});
    const exe = b.addExecutable(.{
        .name = "whiterun",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = mode,
    });
    exe.addModule("zrpc", zrpc.module("zrpc"));
    exe.install();
}
