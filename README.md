# CTF

Reverse engineering and mobile challenge material by Khalil Ammar (fadigaa, team MOJO-JOJO,
Securinets INSAT): solutions to challenges I solved in competitions, and challenges I wrote, with
their source and reference solvers.

Longer write-ups for some of these are on https://khalilammar.me/writeups/. The files in this
repository are the working material: solver scripts, challenge binaries where they were
distributed, and the solution notes.

## Challenges I authored

### re-track: a seven-challenge reverse engineering ladder

Written for Securinets INSAT's Friendly CTF 2026. Each rung teaches one technique (`ltrace`, reading
and inverting a loop, patching a check, unpacking a PyInstaller bundle, faking a DNS answer,
decompiling .NET, lying to an anti-debug check). Each directory has the source, a `build.sh` that
builds the player artifact and replays the intended solve, design notes and a reference solution.
See [re-track/README.md](re-track/README.md) for the full table and build instructions.

| # | Challenge | Technique | Write-up |
|---|---|---|---|
| 01 | [Doorman](re-track/01-doorman/) | `ltrace` on a `strcmp` | [site](https://khalilammar.me/writeups/friendly-ctf-doorman) |
| 02 | [Night Shift](re-track/02-night-shift/) | invert an XOR-and-rotate loop | [site](https://khalilammar.me/writeups/friendly-ctf-shift) |
| 03 | [Broken Lock](re-track/03-broken-lock/) | patch an unsatisfiable check | [site](https://khalilammar.me/writeups/friendly-ctf-patch-and-go) |
| 04 | [Paper Trail](re-track/04-paper-trail/) | unpack a PyInstaller bundle | [site](https://khalilammar.me/writeups/friendly-ctf-paper-trail) |
| 05 | [Dead Air](re-track/05-dead-air/) | answer a host that no longer exists | [site](https://khalilammar.me/writeups/friendly-ctf-relay) |
| 06 | [Decompile Me](re-track/06-decompile-me/) | decompile and debug .NET | none yet |
| 07 | [Debug Me Anyway](re-track/07-debug-me-anyway/) | change an anti-debug result in a register | [site](https://khalilammar.me/writeups/friendly-ctf-antidbg) |

### MOJO CTF

An internal CTF run by the MOJO-JOJO team. The binaries and files that were handed out are included
next to each solution and solver.

| Challenge | Category | Techniques | Solution | Write-up |
|---|---|---|---|---|
| warmup | Rev | ELF header repair, ptrace anti-debug bypass, LCG cipher | [Solution.md](Mojo_CTF_Release/warmup/Solution.md) | [site](https://khalilammar.me/writeups/mojo-warmup) |
| slow | Rev | gdb Python automation, function-pointer dispatcher, SHA-256 suffix brute force | [Solution.md](Mojo_CTF_Release/slow/Solution.md) | [site](https://khalilammar.me/writeups/mojo-slow) |
| pff | Forensics / Rev | PDF JavaScript, steghide passphrase cracking | [Solution.md](Mojo_CTF_Release/pff/Solution.md) | [site](https://khalilammar.me/writeups/mojo-pff) |
| mojo_vault | Rev / Bash | script self-integrity check, runtime extraction from `/tmp` | [Solution.md](Mojo_CTF_Release/mojo_vault/Solution.md) | [site](https://khalilammar.me/writeups/mojo-vault) |
| 13337 | Rev | self-modifying code, network handshake, per-chunk MD5 brute force | [Solution.md](Mojo_CTF_Release/13337/Solution.md) | [site](https://khalilammar.me/writeups/mojo-13337) |

13337 was the last challenge of the event and has a public write-up on the site.

## Challenges I solved in competitions

| Challenge | Category | Event | Solution | Write-up |
|---|---|---|---|---|
| Backdrop | Mobile / Rev | Securinets International Quals 2026 | [Solution.md](Securinets-Quals-2026/backdrop/Solution.md) | [site](https://khalilammar.me/writeups/backdrop-securinets-quals) |
| letmethink | Rev | Securinets International Quals 2026 | [Solution.md](Securinets-Quals-2026/letmethink/Solution.md) | none |
| GoCipher | Rev | Securinets Mini CTF | [Solution.md](GoCipher/Solution.md) | [site](https://khalilammar.me/writeups/gocipher-securinets) |

The Securinets Quals ended on 18 October 2026, so the solutions are published here with their flags.

## Layout

```
re-track/                        challenge source, build scripts, design notes, solvers
Mojo_CTF_Release/                MOJO CTF challenges: warmup, slow, pff, mojo_vault, 13337
Securinets-Quals-2026/           Backdrop and letmethink solutions
GoCipher/                        GoCipher solution, solver and binary
```

## Tools used across these

| Tool | Used for |
|---|---|
| Ghidra, IDA | static analysis |
| gdb (with pwndbg or Python scripting), `strace`, `ltrace` | dynamic analysis, automated brute force, tracing |
| Frida | hooking an Android app (Backdrop) |
| `xxd`, hex editors | inspecting and patching binaries |
| `qpdf`, `pdfimages`, `stegseek` | PDF and steganography work (pff) |
| ILSpy, dnSpy, `pyinstxtractor`, `uncompyle6` | managed and packed code (re-track) |
| Python 3 | solvers, brute force, decryption |
