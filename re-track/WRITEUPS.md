## Reverse Engineering

### The beginner ladder — five Linux ELF challenges
One noir arc (Meridian Field Service), five different moves, no two solved the same way. The
flag is never a stored string in any of them: one primitive throughout (FNV-1a 32 for
key → seed, then an xorshift32 keystream, shared via `re-track/tools/seal.py`), unsealed into
a stack buffer at run time. Secrets live in each challenge's `src/*.txt`, gitignored.

#### 1. Doorman — 100
`strings` gives up the UI and nothing else. The badge code is sealed, but `main` compares it
with `strcmp`, so the process hands it over: `ltrace ./doorman`, type anything, and both
arguments of the call are printed side by side — yours and the real one. Feed the real one back.
Lesson: what a binary hides statically it often performs anyway. Watch it run.

#### 2. Night Shift — 200
The same trick deliberately fails: `accepts()` never calls a library compare, it transforms
your input byte by byte and checks each result against a table in `.rodata`. Per byte it XORs
with `0x5a + 7i`, then rotates left by `i & 7`, then compares. Both steps are visible in
Ghidra or `objdump -d`; read them, then invert in the other order — rotate right, XOR back —
over the table bytes. `solution/solve.py` does exactly that, differing from a player only in
that it locates the table by parsing the ELF rather than by eye.
Lesson: when there is nothing to trace, the answer is in the arithmetic. Read it and run it backwards.

#### 3. Broken Lock — 250
`licensed()` reads `/etc/meridian/service.lic`, insists on exactly 16 bytes, FNV-hashes them
and compares against a constant. Nothing you write satisfies it — a 32-bit target over 16 free
bytes is findable by brute force in principle, but the challenge is not asking for that. The
check is the obstacle, so remove the check: `licensed()` sits at `0x11ef`, where the vaddr
happens to equal the file offset, and the six bytes of its prologue become `b8 01 00 00 00 c3`
(`mov eax, 1 ; ret`). Patch with a hex editor, or set `$eax` and return in `gdb`.
Lesson: an unsatisfiable gate is a hint about method — stop trying to pass it and change it.

#### 4. Paper Trail — 250
A ~10 MB "binary" that prints four lines. `_MEIPASS`, `pyimod` and `PYZ` in the strings, plus
`python3.8`, say what it is and which decompiler to reach for. `pyinstxtractor-ng` unpacks it,
`uncompyle6` (or `pycdc`) turns `paper_trail.pyc` and `payload.pyc` back into readable source,
and the source shows the passphrase sealed under a hardcoded seed and the flag sealed under the
digest of the passphrase. Unseal the first, then the second — or just type the passphrase into
the program.
Lesson: recognising the container is most of the work. A packed interpreter is not a stripped binary.

#### 5. Dead Air — 350
The hostname, the token and the flag are all sealed, and the seeds are not constants either —
`code_key()` hashes 64 bytes of the binary's own `.text` at run time and XORs that in, so
lifting a seed out of a decompiler listing yields garbage. The binary also says nothing useful:
one generic failure line, with progress reported only in the exit code (2 did not resolve,
3 resolved but nothing answered, 4 silence, 5 wrong token).
The way in is that glibc puts the name in cleartext into the DNS query, so `strace -f -s 300`
(or `tcpdump`) yields the hostname the binary will not print. Point it at yourself in
`/etc/hosts`, listen on 8080 — deliberately unprivileged, no root needed — and it sends
`GET /relay/checkin` with the token in an `X-Relay-Expect` header. It only accepts a reply that
contains that token back, then unseals the flag under `digest(token)`.
Lesson: a client that has stopped being able to reach its server will still tell you who it was
looking for, and will still tell you what it expects to hear.
Honest limit: anything the binary computes offline an emulator can compute too. What the
hardening buys is that reading the decompiler output and reimplementing it is not enough.


### Straight Key
A Windows "keyboard self-test" that types one character over and over. The message isn't in
the characters — it's in how long each key is **held**. Read the durations and you read the
text.
Lesson: the channel is timing, not content. Run it only in a disposable VM.

### Water Run (Beginner)
A Godot game with a wall that ends the run. The jump-power value lives in a plain C struct on
the heap, so a 4-byte Cheat Engine scan finds it and it is writable.
Clear the wall and collect the artifact; the flag is reconstructed from that state, never
stored as a string.
Lesson: game state in native memory is editable by whoever owns the process.

### Water Run: Revenge (Advanced)
Same wall, but the writable jump field is gone. Only live vertical velocity is in memory, so
it takes unknown-initial-value plus increased/decreased scans to pin down.
Lesson: the technique is the same; removing the convenient value only raises the effort.

### Sample (SpoolHelper) — malware analysis
A clean-room dropper. Its URLs are RC4-encrypted constants, so `strings` finds nothing; it
shells out to fetch a decoy, then a stager, then a payload, and the stager deletes itself,
so the contents survive only in a packet capture.
Answer the 19 questions over `nc` to get the flag. Static analysis alone will not finish it.
Lesson: dynamic analysis is not optional when the sample erases its own evidence.
