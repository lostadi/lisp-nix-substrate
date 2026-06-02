# lisp-nix-substrate

A pinned nix-darwin + home-manager configuration for macOS (aarch64-darwin), serving as the
reproducible host substrate for the [Ostadix](https://github.com/lostadi) toolchain.

---

## What this is

A declarative macOS system configuration using [nix-darwin](https://github.com/LnL7/nix-darwin)
and [home-manager](https://github.com/nix-community/home-manager), pinned via `flake.lock`.

The name reflects its intended role: this is the **execution substrate** for Ostadix — a project
that pipelines C source through Clang AST extraction, a Lisp intermediate representation, and
Nix-based derivation synthesis. The Nix layer is not incidental; it is the semantic target of the
compilation chain's lowest stage.

---

## Theoretical context (TCF / Ostadix)

The [Transcompiler Conjecture Framework (TCF)](https://github.com/lostadi/kernel-talk) argues
that:

- **T1**: Lisp evaluation semantics map onto Von Neumann execution with lower semantic loss than
  C or assembly representations, because Lisp's fully parenthesized, homoiconic structure
  preserves the call graph, binding structure, and control flow as first-class syntactic data.

- **T2**: The space of languages is path-connected under composition of transcompiler steps;
  compilation and decompilation form an adjunction.

- **T3**: Information-complete decompilation passes through `L*`, a lossless Lisp encoding
  modeled as a fiber bundle over the binary. The *definiteness tax* `H(S′ | B)` quantifies
  the irreducible ambiguity introduced when collapsing `L*` to a named-variable C representation.

The Nix layer sits at the bottom of the Ostadix pipeline:

```
C source
  → Clang AST
    → Lisp IR (O-lang)
      → Nix derivation
        → reproducible build / emerge
```

Nix derivations are the natural fixed-point of this chain: purely functional, content-addressed,
and referentially transparent — the same structural properties the Lisp IR is chosen for.
This repo pins the host environment so that derivation synthesis is reproducible across machines.

---

## Structure

```
lisp-nix-substrate/
├── flake.nix        # Pinned inputs: nixpkgs-unstable, nix-darwin, home-manager
├── flake.lock       # Exact input SHAs — the reproducibility guarantee
├── darwin.nix       # System-level config: nix daemon settings, user anchor
└── home.nix         # User-level packages and program config (home-manager)
```

---

## Usage

### Prerequisites

- macOS with [Nix installed](https://nixos.org/download) (multi-user daemon recommended)
- The username in `darwin.nix` and `flake.nix` is currently `ustad` — change to match your
  local user before applying.

```bash
# Verify nix is available
nix --version

# Clone
git clone https://github.com/lostadi/lisp-nix-substrate.git
cd lisp-nix-substrate

# First-time apply (installs nix-darwin + home-manager, rebuilds system)
nix run nix-darwin -- switch --flake .#macbook

# Subsequent rebuilds
darwin-rebuild switch --flake .#macbook
```

### Updating inputs

```bash
# Update all flake inputs to latest
nix flake update

# Update a single input
nix flake lock --update-input nixpkgs
```

---

## Known issues

- `darwin.nix` has a typo: `"nix-command flaks"` should be `"nix-command flakes"` — fix before
  applying on a fresh machine or the Nix daemon will not enable flake support.

---

## Status

Active substrate for local Ostadix development. The `home.nix` is intentionally minimal; it
grows as toolchain dependencies are locked into derivations rather than installed ad-hoc.

---

*Part of the [Ostadix](https://github.com/lostadi) project — Lee Ostadi, ECU Computer Vision Lab.*
