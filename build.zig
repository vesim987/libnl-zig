const std = @import("std");

const examples = .{
    "genl-ctrl-list",
    "idiag-socket-details",
    "nf-ct-add",
    "nf-ct-list",
    "nf-exp-add",
    "nf-exp-delete",
    "nf-exp-list",
    "nf-log",
    "nf-monitor",
    "nf-queue",
    "nl-addr-add",
    "nl-addr-delete",
    "nl-addr-list",
    "nl-class-add",
    "nl-class-delete",
    "nl-class-list",
    "nl-classid-lookup",
    // "nl-cls-add", // TODO: ematch
    // "nl-cls-delete",
    // "nl-cls-list",
    "nl-fib-lookup",
    "nl-link-enslave",
    "nl-link-ifindex2name",
    "nl-link-list",
    "nl-link-name2ifindex",
    "nl-link-release",
    "nl-link-set",
    "nl-link-stats",
    // "nl-list-caches", // TODO: incorrect include
    "nl-list-sockets",
    "nl-monitor",
    "nl-neigh-add",
    "nl-neigh-delete",
    "nl-neigh-list",
    "nl-neightbl-list",
    // "nl-pktloc-lookup", // TODO: pktloc
    "nl-qdisc-add",
    "nl-qdisc-delete",
    // "nl-qdisc-list", // TODO: ematch
    "nl-route-add",
    "nl-route-delete",
    "nl-route-get",
    "nl-route-list",
    "nl-rule-list",
    "nl-tctree-list",
    "nl-util-addr",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("libnl", .{});

    const lib = b.addStaticLibrary(.{
        .name = "libnl",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();

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
    lib.defineCMacro("SYSCONFDIR", "\"/usr/dummy\"");
    lib.defineCMacro("PKGLIBDIR", "\"/usr/lib\"");
    lib.defineCMacro("_GNU_SOURCE", "1");

    lib.addIncludePath(upstream.path("include"));
    lib.installHeadersDirectory(upstream.path("include"), "", .{});

    lib.addConfigHeader(config);
    lib.installConfigHeader(config);

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

            "lib/fib_lookup/lookup.c",
            "lib/fib_lookup/request.c",

            "lib/genl/ctrl.c",
            "lib/genl/family.c",
            "lib/genl/genl.c",
            "lib/genl/mngt.c",

            "lib/idiag/idiag.c",
            "lib/idiag/idiag_meminfo_obj.c",
            "lib/idiag/idiag_msg_obj.c",
            "lib/idiag/idiag_req_obj.c",
            "lib/idiag/idiag_vegasinfo_obj.c",

            "lib/netfilter/ct.c",
            "lib/netfilter/ct_obj.c",
            "lib/netfilter/exp.c",
            "lib/netfilter/exp_obj.c",
            "lib/netfilter/log.c",
            "lib/netfilter/log_msg.c",
            "lib/netfilter/log_msg_obj.c",
            "lib/netfilter/log_obj.c",
            "lib/netfilter/netfilter.c",
            "lib/netfilter/nfnl.c",
            "lib/netfilter/queue.c",
            "lib/netfilter/queue_msg.c",
            "lib/netfilter/queue_msg_obj.c",
            "lib/netfilter/queue_obj.c",

            "lib/route/classid.c",
            "lib/route/tc.c",
            "lib/route/addr.c",
            "lib/route/nexthop.c",
            "lib/route/qdisc/red.c",
            "lib/route/qdisc/sfq.c",
            "lib/route/qdisc/fifo.c",
            "lib/route/qdisc/plug.c",
            "lib/route/qdisc/netem.c",
            "lib/route/qdisc/tbf.c",
            "lib/route/qdisc/blackhole.c",
            "lib/route/qdisc/dsmark.c",
            "lib/route/qdisc/fq_codel.c",
            "lib/route/qdisc/prio.c",
            "lib/route/qdisc/ingress.c",
            "lib/route/qdisc/htb.c",
            "lib/route/qdisc/cbq.c",
            "lib/route/link.c",
            "lib/route/route.c",
            "lib/route/act/mirred.c",
            "lib/route/neightbl.c",
            "lib/route/rtnl.c",
            "lib/route/qdisc.c",
            "lib/route/class.c",
            "lib/route/cls/u32.c",
            "lib/route/cls/police.c",
            "lib/route/cls/basic.c",
            "lib/route/cls/fw.c",
            // "lib/route/cls/ematch.c",
            // "lib/route/cls/ematch_grammar.l",
            // "lib/route/cls/ematch_syntax.y",
            // "lib/route/cls/ematch/text.c",
            // "lib/route/cls/ematch/container.c",
            // "lib/route/cls/ematch/meta.c",
            // "lib/route/cls/ematch/nbyte.c",
            // "lib/route/cls/ematch/cmp.c",
            "lib/route/cls/cgroup.c",
            // "lib/route/pktloc.c",
            // "lib/route/pktloc_grammar.l",
            // "lib/route/pktloc_syntax.y",
            "lib/route/link/ipvti.c",
            "lib/route/link/sit.c",
            "lib/route/link/ipip.c",
            "lib/route/link/dummy.c",
            "lib/route/link/inet6.c",
            "lib/route/link/bonding.c",
            "lib/route/link/bridge.c",
            "lib/route/link/ip6tnl.c",
            "lib/route/link/api.c",
            "lib/route/link/can.c",
            "lib/route/link/veth.c",
            "lib/route/link/vxlan.c",
            "lib/route/link/macvlan.c",
            "lib/route/link/ipgre.c",
            "lib/route/link/inet.c",
            "lib/route/link/vlan.c",
            "lib/route/route_obj.c",
            "lib/route/rule.c",
            "lib/route/route_utils.c",
            "lib/route/act.c",
            "lib/route/cls.c",
            "lib/route/neigh.c",

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
    });

    b.installArtifact(lib);

    const examples_step = b.step("examples", "Build examples from libnl");
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
        examples_step.dependOn(&b.addInstallArtifact(exe, .{}).step);
    }
}
