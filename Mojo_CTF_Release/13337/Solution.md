# 13337

* ***Category : Reverse Engineering***

The final stage of the MOJO CTF. One binary (`chall`) and the solver I wrote for it (`solver.py`).

## Solution

Running the binary prints nothing useful. A quick `strace` shows it silently trying to connect to
`127.0.0.1` on port **13337**, so it expects a server to talk to.

In Ghidra the stripped binary is a wall of obfuscation. Calls to `mprotect` and a set of XOR routines
mean self-modifying code: the binary decrypts its own logic at run time with a static key (`0xDE`)
combined with a randomised stabilisation key.

With gdb (pwndbg) I put a breakpoint right after the `mprotect` call and dumped the freshly decrypted
memory. The exposed logic is a network handshake that starts with a magic DWORD (`0x0DF7B6FA`). The
payload is then mangled: the incoming buffer is XORed with a session ID and passed through MD5
validations.

The validator processes the payload in 4-byte chunks, so each MD5 can be brute-forced on an ordinary
CPU. After cracking the hashes and mapping the multi-round cipher with gdb watchpoints, the remaining
work is a server that performs the handshake and sends the right data frame. `solver.py` is that
server: it listens on 13337, checks the magic value, sends the handshake, reads the session ID, and
replies with the eight target values XORed with it. Run it, then run `chall`.

## Takeaways

- Hardware breakpoints and watchpoints in gdb are the way into self-modifying code once the memory
  has been decrypted.
- A check over a tiny input such as a 32-bit integer can be brute-forced regardless of the hash used.
