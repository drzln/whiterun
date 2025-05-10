// src/main.zig
const std  = @import("std");
const zrpc = @import("zrpc"); // ← comes from build.zig.zon / build.zig

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print(
        "🏰  Whiterun CLI — Hello, Zig World!\n\
         (zrpc module imported, ready for future RPC magic)\n",
        .{},
    );

    // Touch the module so the compiler won’t complain that it's unused yet.
    // Delete this line once you actually call zrpc APIs.
    comptime _ = zrpc;
}
