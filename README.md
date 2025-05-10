# 🏰 Whiterun

**Whiterun** is a minimalist, fast, and fully declarative KVM-based virtual machine launcher — built with Zig, powered by Nix.

---

## ✨ Overview

Whiterun bridges the power of [Nix](https://nixos.org/) and [KVM](https://www.linux-kvm.org/) to offer a **purely declarative VM runtime** with **zero image building**. No more shell wrappers. No QEMU. No `virt-install`. Just raw power, controlled by a typed CLI and a functional build graph.

---

## 🔧 What It Does

- 🚀 Boots virtual machines directly from Nix derivations
- 🔥 Uses `/dev/kvm` and low-level Linux syscalls to launch VMs
- 🧱 Accepts Nix-built kernel, initrd, and root filesystem as inputs
- 🌀 No shells, no images, no disk carving — everything is derivation-native
- 💡 Written in [Zig](https://ziglang.org/) for modern, safe systems programming

---

## 📁 Project Goals

- **Deterministic VMs**: Machines are launched from reproducible Nix builds
- **Dev-friendly VMM**: A CLI-first, JSON-configurable micro-hypervisor
- **Micro footprint**: No legacy BIOS, UEFI, QEMU bloat — just what you need
- **Composable**: Meant to be integrated into GitOps and automated infra pipelines

---

## 🚀 Getting Started

```bash
# Build a NixOS VM configuration
nix build .#nixosConfigurations.vm.config.system.build.{kernel,initrd,toplevel}

# Run the VM with Whiterun
./whiterun \
  --kernel ./result-kernel/bzImage \
  --initrd ./result-initrd/initrd \
  --rootfs ./result-toplevel \
  --mem 1024 \
  --cpus 2
```

---

## 🔩 Features in Progress

- [ ] vCPU management and topology
- [ ] Minimal device emulation (e.g. serial console)
- [ ] Initrd-only boot support
- [ ] Kernel command-line customization
- [ ] Virtio-9p shared folder support with host
- [ ] Zig JSON config loader for structured VM manifests

---

## 📦 Requirements

- Linux host with `/dev/kvm` enabled
- Nix & flakes enabled
- Zig >= 0.11.0

---

## 💬 Philosophy

> Declarative infrastructure deserves a declarative runtime.  
> Whiterun boots Nix-built machines like they were systemd units.

---

## 🧑‍💻 Author

Built by [drzzln](https://github.com/drzln)

---

## 🪪 License

MIT. Free to use, hack, and fork.
