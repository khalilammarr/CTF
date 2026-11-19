# re-track: a reverse engineering ladder

Seven beginner-to-intermediate reverse engineering challenges, written for the Securinets INSAT
Friendly CTF 2026. Each one ships its source, a `build.sh` that produces the artifact players
download, design notes, and a reference solution.

The design goal is a ladder: every rung teaches one technique, and no two rungs are solved the same
way. The category had no on-ramp before this. The other challenges in it were Windows-only and hard,
so a beginner opening it had nothing to solve. Rung 01 can be done in ten minutes by someone who has
never opened a binary, and the later rungs each take away the shortcut the previous one allowed.

## The ladder

| # | Challenge | Event name | Platform | What it teaches | Intended tools | Pts | Write-up |
|---|---|---|---|---|---|---|---|
| 01 | [Doorman](01-doorman/) | Doorman | Linux x86-64 | `strings` finds nothing, but the process still compares your input with `strcmp` | `ltrace` | 100 | [site](https://khalilammar.me/writeups/friendly-ctf-doorman) |
| 02 | [Night Shift](02-night-shift/) | Shift | Linux x86-64 | No library call to trace: read an XOR-and-rotate loop and run it backwards | Ghidra or `objdump`, plus a script | 200 | [site](https://khalilammar.me/writeups/friendly-ctf-shift) |
| 03 | [Broken Lock](03-broken-lock/) | Patch&Go | Linux x86-64 | A check that cannot be satisfied is a hint to patch it instead | `objdump` and a hex editor, or `gdb` | 250 | [site](https://khalilammar.me/writeups/friendly-ctf-patch-and-go) |
| 04 | [Paper Trail](04-paper-trail/) | Paper Trail | Linux x86-64 | The "binary" is a packed Python program; recognising the container is most of the work | `pyinstxtractor`, `uncompyle6` | 250 | [site](https://khalilammar.me/writeups/friendly-ctf-paper-trail) |
| 05 | [Dead Air](05-dead-air/) | Relay | Linux x86-64 | The program calls a host that no longer exists: learn the name from the DNS lookup, answer it yourself | `strace`, `/etc/hosts`, `nc` | 350 | [site](https://khalilammar.me/writeups/friendly-ctf-relay) |
| 06 | [Decompile Me](06-decompile-me/) | Twofold | Windows (.NET Framework 4.8) | Managed code decompiles back to C#, and a debugger can stop it mid-computation | ILSpy, dnSpy | 150 | none yet |
| 07 | [Debug Me Anyway](07-debug-me-anyway/) | AntiDbg | Linux x86-64 | An anti-debug check can be lied to: let it run, then change its result in a register | `gdb` / pwndbg | n/a | [site](https://khalilammar.me/writeups/friendly-ctf-antidbg) |

Points are the suggested starting value used on the scoreboard. 06 is a Windows program but is
verified here under Wine.

## What each directory contains

```
NN-name/
  src/            challenge source (C, Python or C#); flag and secrets are not committed
  build.sh        builds the player artifact and verifies it (see below)
  solution/       reference solver(s) or a walkthrough
  notes/design.md why the challenge is built the way it is, and what was tried and rejected
tools/            shared build tooling (sealing, key derivation, notice generation)
solve_all.sh      runs every reference solution against a packaged copy of the artifacts
NOTICE.txt        rules notice shipped next to each challenge and embedded in the artifact
WRITEUPS.md       short solution summaries for all seven
```

## Design rules shared by the ladder

- The flag is never a stored string. It is sealed under a key the player has to earn and rebuilt in
  a stack buffer at run time. Every `build.sh` asserts that `strings` on the output returns nothing
  flag-shaped, and that assertion is itself tested: a planted flag has to make the build fail.
- One primitive throughout: FNV-1a 32 turns a key into a seed, and an xorshift32 keystream is XORed
  over the payload (`tools/seal.py`). It is short enough to follow by eye, so there is one thing to
  learn rather than five.
- Every `build.sh` plays the intended solve against the artifact it just built and fails the build
  if the solve stops working. These are not smoke tests. 02 finds the comparison table in `.rodata`
  and inverts it, 03 patches the licence function and runs the result, 04 unpacks and decompiles the
  bundle with the same tools players use, and 05 stands up a relay and talks to the shipped binary
  through a bind-mounted `/etc/hosts` inside an unprivileged namespace.
- Breadcrumbs stay readable. UI strings, prompts and the relay hostname are deliberately visible;
  only the answer is sealed. 05's build asserts the hostname is present in the DNS query, because
  sealing it would turn a fair task into a guessing game.
- Failure messages say what went wrong. A refusal that misleads costs players time without testing
  anything, so every refusal path describes the failure in plain words.

## Building and verifying

```sh
cd 01-doorman && ./build.sh        # likewise 02, 03, 05, 06, 07
```

The output lands in `build/`. A build that exits 0 has also run the intended solution against the
result. Rung-specific requirements:

| Rung | Needs |
|---|---|
| 01, 02, 03, 05 | gcc, binutils, ltrace (01); `strace` and `unshare` (05) |
| 04 | a Python 3.8 virtualenv with `pyinstaller`, `uncompyle6`, `pyinstxtractor-ng` |
| 06 | .NET SDK, `wine`, `ilspycmd` (`dotnet tool install -g ilspycmd`); first build needs network once for the reference assemblies |
| 07 | gcc, `gdb` (pwndbg optional; the build replays the solve under both) |

04 setup:

```sh
cd 04-paper-trail
uv venv --python 3.8 .venv
uv pip install --python .venv/bin/python pyinstaller uncompyle6 pyinstxtractor-ng
./build.sh
```

The Python 3.8 pin is required. uncompyle6 and pycdc decompile 3.8 bytecode cleanly; building on a
newer Python would produce a challenge whose intended solve has no working decompiler. The virtualenv
is also not relocatable, so recreate it after renaming the directory.

`./solve_all.sh [dir]` runs all seven reference solutions against a packaged copy of the artifacts
(by default `../Friendly-CTF-2026/reverse-engineering`), which checks the files players actually
received rather than a fresh build.

### Local files the builds read

The flag and the secret it is sealed under are read from `src/` at build time and are not in this
repository. To rebuild from a clone, create these yourself, one value per file with no trailing
whitespace:

| Challenge | Files in `src/` |
|---|---|
| 01 Doorman | `flag.txt`, `badge.txt` |
| 02 Night Shift | `flag.txt`, `roster.txt` (the rotation key) |
| 03 Broken Lock | `flag.txt` |
| 04 Paper Trail | `flag.txt`, `passphrase.txt` |
| 05 Dead Air | `flag.txt`, `token.txt`, `hostname.txt` |
| 06 Decompile Me | `flag.txt`, `code.txt` (`KEY-` followed by 8 wheel characters) |
| 07 Debug Me Anyway | `flag.txt` |

`build.sh` stops with a message if one is missing instead of building something wrong.

## Status

- 06 has been run under Wine only. The breakpoint-in-decompiled-code path the challenge page
  describes has not been observed on a real Windows machine with dnSpy.
- 05 listens on port 8080 on purpose, so nobody needs root to run their listener.
- 07 needs glibc 2.34 or newer; it was checked on Ubuntu 22.04 and 24.04, Debian 12 and Arch, and
  does not start on Ubuntu 20.04.
- Every offline binary contains what it needs to produce its flag. The hardening on 05 and 07 raises
  the price of reading the decompiler output and reimplementing it; it does not make that
  impossible. Each `notes/design.md` states what is and is not claimed.
