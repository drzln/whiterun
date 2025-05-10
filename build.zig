// build.zig
const std = @import("std");
pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "whiterun",
        .root_source_file = b.path("src/main.zig"),
    });
    b.installArtifact(exe);
}
