const std = @import("std");

const examples = .{
    // "genl-ctrl-list",
    // "idiag-socket-details",
    // "nf-ct-add",
    // "nf-ct-list",
    // "nf-exp-add",
    // "nf-exp-delete",
    // "nf-exp-list",
    // "nf-log",
    // "nf-monitor",
    // "nf-queue",
    // "nl-addr-add",
    // "nl-addr-delete",
    "nl-addr-list",
    // "nl-class-add",
    // "nl-class-delete",
    // "nl-class-list",
    // "nl-classid-lookup",
    // "nl-cls-add",
    // "nl-cls-delete",
    // "nl-cls-list",
    // "nl-fib-lookup",
    // "nl-link-enslave",
    // "nl-link-ifindex2name",
    // "nl-link-list",
    // "nl-link-name2ifindex",
    // "nl-link-release",
    // "nl-link-set",
    // "nl-link-stats",
    // "nl-list-caches",
    // "nl-list-sockets",
    // "nl-monitor",
    // "nl-neigh-add",
    // "nl-neigh-delete",
    // "nl-neigh-list",
    // "nl-neightbl-list",
    // "nl-pktloc-lookup",
    // "nl-qdisc-add",
    // "nl-qdisc-delete",
    // "nl-qdisc-list",
    // "nl-route-add",
    // "nl-route-delete",
    // "nl-route-get",
    // "nl-route-list",
    // "nl-rule-list",
    // "nl-tctree-list",
    // "nl-util-addr",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("libnl", .{});

    const lib = b.addStaticLibrary(.{
        .name = "libnl-zig",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();

    lib.addIncludePath(upstream.path("include"));
    lib.installHeadersDirectory(upstream.path("include"), "", .{});

    const config = b.addConfigHeader(.{
        .style = .{ .autoconf = upstream.path("lib/defs.h.in") },
    }, .{
        .DISABLE_PTHREADS = false,
        .HAVE_DLFCN_H = true,
        .HAVE_INTTYPES_H = true,
        .HAVE_LIBM = true,
        .HAVE_LIBPTHREAD = true,
        .HAVE_MEMORY_H = true,
        .HAVE_STDINT_H = true,
        .HAVE_STDLIB_H = true,
        .HAVE_STRINGS_H = true,
        .HAVE_STRING_H = true,
        .HAVE_SYS_STAT_H = true,
        .HAVE_SYS_TYPES_H = false,
        .HAVE_UNISTD_H = true,
        .LT_OBJDIR = "",
        .NL_DEBUG = false,
        .NO_MINUS_C_MINUS_O = false,
        .PACKAGE = "libnl",
        .PACKAGE_BUGREPORT = "TODO",
        .PACKAGE_NAME = "libnl",
        .PACKAGE_STRING = "libnl",
        .PACKAGE_TARNAME = "libnl",
        .PACKAGE_URL = "TODO",
        .PACKAGE_VERSION = "TODO",
        .STDC_HEADERS = true,
        .VERSION = true,
        .@"const" = .@"const",
        .@"inline" = .__inline,
    });

    lib.addConfigHeader(config);

    lib.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = &.{
            "lib/addr.c",
            "lib/attr.c",
            "lib/cache.c",
            "lib/cache_mngr.c",
            "lib/cache_mngt.c",
            "lib/data.c",
            "lib/error.c",
            "lib/handlers.c",
            "lib/hash.c",
            "lib/hashtable.c",
            "lib/msg.c",
            "lib/nl.c",
            "lib/object.c",
            "lib/socket.c",
            "lib/utils.c",
            "lib/version.c",

            "src/lib/addr.c",
            "src/lib/class.c",
            "src/lib/cls.c",
            "src/lib/ct.c",
            "src/lib/exp.c",
            "src/lib/link.c",
            "src/lib/neigh.c",
            "src/lib/qdisc.c",
            "src/lib/route.c",
            "src/lib/rule.c",
            "src/lib/tc.c",
            "src/lib/utils.c",
        },
        .flags = &.{
            "-DPKGLIBDIR=\"/usr/lib\"",
            "-DSYSCONFDIR=\"/etc/dummy\"",
        },
    });

    b.installArtifact(lib);

    inline for (examples) |example| {
        const exe = b.addExecutable(.{
            .name = example,
            .target = target,
            .optimize = optimize,
        });
        exe.addCSourceFile(.{
            .file = upstream.path("src/" ++ example ++ ".c"),
        });
        exe.linkLibrary(lib);
        exe.linkLibC();

        b.installArtifact(exe);
    }
}
