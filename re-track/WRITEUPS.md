# RE track: solution summaries

Short spoiler-level summaries of the intended solve for each challenge in the ladder. Full
reference solvers are in each `NN-name/solution/`, and the reasoning behind each design is in
`NN-name/notes/design.md`. Per-challenge write-ups for players are on
https://khalilammar.me/writeups/.

Flags are never stored as strings in any of these. One primitive throughout (FNV-1a 32 for
key to seed, then an xorshift32 keystream, shared via `tools/seal.py`), unsealed into a stack
buffer at run time. Secrets live in each challenge's `src/*.txt`, which are not committed.

### 1. Doorman — 100
`strings` gives up the UI and nothing else. The badge code is sealed, but `main` compares it
with `strcmp`, so the process hands it over: `ltrace ./doorman`, type anything, and both
arguments of the call are printed side by side — yours and the real one. Feed the real one back.
Lesson: what a binary hides statically it often performs anyway. Watch it run.

### 2. Night Shift — 200
The same trick deliberately fails: `accepts()` never calls a library compare, it transforms
your input byte by byte and checks each result against a table in `.rodata`. Per byte it XORs
with `0x5a + 7i`, then rotates left by `i & 7`, then compares. Both steps are visible in
Ghidra or `objdump -d`; read them, then invert in the other order — rotate right, XOR back —
over the table bytes. `solution/solve.py` does exactly that, differing from a player only in
that it locates the table by parsing the ELF rather than by eye.
Lesson: when there is nothing to trace, the answer is in the arithmetic. Read it and run it backwards.

### 3. Broken Lock — 250
`licensed()` reads `/etc/meridian/service.lic`, insists on exactly 16 bytes, FNV-hashes them
and compares against a constant. Nothing you write satisfies it — a 32-bit target over 16 free
bytes is findable by brute force in principle, but the challenge is not asking for that. The
check is the obstacle, so remove the check: `licensed()` sits at `0x11ef`, where the vaddr
happens to equal the file offset, and the six bytes of its prologue become `b8 01 00 00 00 c3`
(`mov eax, 1 ; ret`). Patch with a hex editor, or set `$eax` and return in `gdb`.
Lesson: an unsatisfiable gate is a hint about method — stop trying to pass it and change it.

### 4. Paper Trail — 250
A ~10 MB "binary" that prints four lines. `_MEIPASS`, `pyimod` and `PYZ` in the strings, plus
`python3.8`, say what it is and which decompiler to reach for. `pyinstxtractor-ng` unpacks it,
`uncompyle6` (or `pycdc`) turns `paper_trail.pyc` and `payload.pyc` back into readable source,
and the source shows the passphrase sealed under a hardcoded seed and the flag sealed under the
digest of the passphrase. Unseal the first, then the second — or just type the passphrase into
the program.
Lesson: recognising the container is most of the work. A packed interpreter is not a stripped binary.

### 5. Dead Air — 350
The hostname, the token and the flag are all sealed, and the seeds are not constants either —
`code_key()` hashes 64 bytes of the binary's own `.text` at run time and XORs that in, so
lifting a seed out of a decompiler listing yields garbage. The binary prints one line per
failure stage (does not resolve, nothing listening, silence, wrong reply), and the stage is
also the exit code (2, 3, 4, 5).
The way in is that glibc puts the name in cleartext into the DNS query, so `strace -f -s 300`
(or `tcpdump`) yields the hostname the binary will not print. Point it at yourself in
`/etc/hosts`, listen on 8080 — deliberately unprivileged, no root needed — and it sends
`GET /relay/checkin` with the token in an `X-Relay-Expect` header. It only accepts a reply that
contains that token back, then unseals the flag under `digest(token)`.
Lesson: a client that has stopped being able to reach its server will still tell you who it was
looking for, and will still tell you what it expects to hear.
Honest limit: anything the binary computes offline an emulator can compute too. What the
self-hash buys is that reading the decompiler output and reimplementing it is not enough.

### 6. Decompile Me — 150
A Windows .NET Framework 4.8 console app (`CodeCheck.exe`) that asks for an access code. The code
is not stored: `Authority.Expected()` builds it at run time from a personnel roster (the eight
records at clearance 4, ordered by hire year, each indexing a 24-character wheel with
`(Badge * 31 + HireYear) % 24`). ILSpy turns the shipped assembly back into C#, and you can
either do the arithmetic or break in dnSpy while the code is being built and read it from the
locals window. Lesson: managed code keeps its names and structure, and a decompiler gives it back.

### 7. Debug Me Anyway — introductory debugger challenge
`leashed()` calls `ptrace(PTRACE_TRACEME)`, which fails under a debugger, and `main` refuses to
continue. The solve is five gdb commands: `break ptrace`, `run`, `finish`, `set $rax = 0`,
`continue`, then `call (char *) reveal()` on a function the program never calls itself
(`solution/gdb-walkthrough.md`). The real unsealer ships XOR-encrypted in its own section, keyed by
a hash of the program's `.text`, with four decoy unsealers that each yield a plausible wrong flag,
so a static shortcut returns wrong answers. Lesson: a check whose result you can read can be lied to.
