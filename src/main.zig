// src/main.zig
const std  = @import("std");
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print(
        "🏰  Whiterun CLI — Hello, Zig World!\n
         (zrpc module imported, ready for future RPC magic)\n",
        .{},
    );
}
