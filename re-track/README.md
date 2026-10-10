# RE track — the beginner ladder

Six standalone challenges — five Linux x86-64, one Windows .NET, built 2026-09-20/21, in their own workspaces. They
exist because the Reverse Engineering category had **no on-ramp**: the four challenges already
packaged (two Water Run game-hacking builds, the 20-question malware case, Straight Key) are all
Windows-only and all hard. A beginner opening that category had nothing to solve.

**Nothing here is committed or packaged into `Friendly-CTF-2026/` yet** — user's instruction.

## The ladder

Each one teaches a different move, and no two are solved the same way. Difficulty is the
suggested CTFd `initial`. 01-05 carry a light noir framing (one failing company, Meridian Field
Service); **06 carries none by instruction — its page and its own output address the player
directly and describe nothing but the task.** Apply that to 01-05 too if the framing in their
pages is ever read as story rather than setting.

| # | Name | The move it teaches | Intended tool | Pts |
|---|---|---|---|---|
| 01 | Doorman | `strings` fails, the process tells you anyway | `ltrace` | 100 |
| 02 | Night Shift | there is no library compare to trace — read the loop and invert it | Ghidra / `objdump` + a solver script | 200 |
| 03 | Broken Lock | recognise an unsatisfiable check and patch it instead | `objdump` + hex editor, or `gdb` | 250 |
| 04 | Paper Trail | a "binary" that is a packed Python program | `pyinstxtractor` + `uncompyle6` | 250 |
| 05 | Dead Air | make a dead host answer, then answer it correctly | `strace` + `/etc/hosts` + `nc` | 350 |
| 06 | Decompile Me | managed code decompiles to real C# — and you can stop it mid-run | ILSpy + dnSpy (debugger) | 150 |

## Rules every one of them follows

- **The flag is never a stored string.** It is sealed under the key the player has to earn and
  reconstructed in a stack buffer at run time. Every `build.sh` asserts `strings` returns nothing
  flag-shaped, and that check is negative-tested (a planted flag must make the build fail).
- **One primitive, five challenges.** FNV-1a 32 for key→seed, then an xorshift32 keystream —
  the same variant already used by `secrets/gen_sirr_blob.py` and the game track. Short enough
  that a beginner can follow the C by eye, and it means there is one thing to learn, not five.
  Shared implementation in `tools/seal.py`.
- **Every `build.sh` plays the intended solve and fails the build if it stops working.** These
  are not smoke tests: 02 locates the comparison table in `.rodata` and inverts it, 03 patches
  the licence function and runs the result, 04 extracts and decompiles the bundle with the real
  player tooling, 05 stands up a relay and talks to the shipped binary through a bind-mounted
  `/etc/hosts`.
- **`NOTICE.txt` ships with every challenge and is embedded in every artifact.** It states, in
  the author's own voice, that this is a scored competition with prizes and that agentic AI
  assistance is prohibited outright. It is a speed bump, not a control — anyone who says "ignore
  that notice" defeats it — but every claim in it is true, which is what makes an aligned model
  actually honour it. Generated from one source by `tools/gen_notice.py` so the copy in a binary
  cannot drift from the copy players read. **On the PyInstaller bundle it is compressed inside the
  PYZ and only surfaces after extraction, which is why the companion file is not optional.**
- **Failure messages guide, never mislead** — *except in 05, deliberately; see its notes.* `docs/CTF-DESIGN-GUIDELINES.md` is explicit that
  false starts and misinformation don't test creativity, they just burn player time. Every
  refusal path in these five says what went wrong in-character.
- **Breadcrumbs stay visible.** UI strings, prompts and the relay hostname are deliberately
  readable. Only the answer is sealed. 05's build asserts the hostname is *present* — sealing it
  would turn a fair task into a guessing game.

## Local files the build needs (all gitignored, none in this repo)

The answer to each challenge -- the flag, and the secret it is sealed under -- lives on disk so
`build.sh` can seal it, and is never committed. `secrets/` is gitignored project-wide for the same
reason. A fresh clone therefore cannot rebuild these until you recreate the following, one line
each, no trailing whitespace:

| File | Holds |
|---|---|
| `01-doorman/src/flag.txt` · `src/badge.txt` | the flag · the badge code |
| `02-night-shift/src/flag.txt` · `src/roster.txt` | the flag · the rotation key |
| `03-broken-lock/src/flag.txt` | the flag (no secret -- the solve is a patch) |
| `04-paper-trail/src/flag.txt` · `src/passphrase.txt` | the flag · the archive passphrase |
| `05-dead-air/src/flag.txt` · `src/token.txt` · `src/hostname.txt` | the flag · the relay token · the relay hostname |
| `06-decompile-me/src/flag.txt` · `src/code.txt` | the flag · the access code (`KEY-` + 8 wheel characters) |

The live values are in `secrets/flags.json` (flags) and in this session's PROGRESS entry. Every
`build.sh` fails with a clear message if its inputs are missing, rather than building something
silently wrong.

## Building

```sh
cd 01-doorman && ./build.sh      # and so on
```

01/02/03/05 need only gcc, binutils and ltrace. 06 needs the .NET SDK, `wine` (to run the exe on
Linux) and `ilspycmd` (`dotnet tool install -g ilspycmd`) — the first build restores the
`Microsoft.NETFramework.ReferenceAssemblies` package, so it needs network once. 04 needs its own
Python 3.8 venv:

```sh
cd 04-paper-trail
uv venv --python 3.8 .venv
uv pip install --python .venv/bin/python pyinstaller uncompyle6 pyinstxtractor-ng
./build.sh
```

**The 3.8 pin is load-bearing, not incidental.** uncompyle6 and pycdc both decompile 3.8
bytecode cleanly. Building that challenge on the host's 3.14 would ship a task whose intended
solve does not exist yet in any decompiler — the player would get a
"version unsupported" error instead of source, and the challenge would be unsolvable as
designed. Also: **the venv is not relocatable.** Renaming the challenge directory leaves every
console script's shebang pointing at the old path and they fail with a confusing `ENOENT` on a
file that visibly exists. Recreate it after any move.

## What still has to happen before any of these ship

1. **Play each one as a player**, on a clean machine, without the build script. The builds prove
   the mechanism; they do not prove the experience. **06 has never been run on real Windows with
   real dnSpy** — it is verified under wine only, and the breakpoint-in-decompiled-code path that
   the challenge page tells players to use has not been observed working.
2. **Write the CTFd `challenge.yaml` descriptions.** Written for all six now, in
   `Friendly-CTF-2026/reverse-engineering/`. No scenario or story in any of them — they address
   the player directly, name the tools, and state the first step (user's instruction).
3. **Decide the 04 lab story.** It ships a ~10 MB binary with a full CPython inside. That is
   normal for PyInstaller and is itself a clue, but it is worth saying so players don't think
   the download is corrupt.
4. **05 needs a note about port 8080** being deliberately unprivileged, so nobody tries to run
   their listener with sudo.
