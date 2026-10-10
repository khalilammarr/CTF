#!/usr/bin/env bash
# Solve all seven RE-ladder challenges against the artifacts players receive.
#
# The per-challenge build.sh proves a FRESH build is solvable. This proves the
# PACKAGED one is -- which is not the same claim, and is the one that matters
# after an artifact has been copied, rebuilt or replaced. Point it at the
# packaged tree (the default) or at anything with the same layout.
#
#   solve_all.sh [packaged-re-directory]
set -uo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
PKG=${1:-$HERE/../Friendly-CTF-2026/reverse-engineering}

run() {
    local name=$1 solver=$2 artifact=$3
    if [ ! -e "$artifact" ]; then
        printf '%-15s MISSING   %s\n' "$name" "$artifact"
        return 1
    fi
    local out rc=0
    out=$("$solver" "$artifact" 2>&1) || rc=$?
    local flag
    flag=$(grep -ao 'Securinets{[^}]*}' <<<"$out" | head -1)
    if [ $rc -ne 0 ] || [ -z "$flag" ]; then
        printf '%-15s FAIL\n' "$name"
        sed 's/^/                 /' <<<"$out" | tail -8
        return 1
    fi
    printf '%-15s ok        %s\n' "$name" "$flag"
}

# Rung 07 has no solver script on purpose -- the commands players are handed are
# the only recorded solve (see 07-debug-me-anyway/solution/gdb-walkthrough.md).
# They are replayed inline here so the PACKAGED artifact is still covered.
# The single breakpoint fires twice: once on the check, once on the re-check after
# the builder is unpacked. reveal() is dead code the player calls; the cast is
# required because the artifact carries no debug info.
run_07() {
    local artifact=$1
    if [ ! -e "$artifact" ]; then
        printf '%-15s MISSING   %s\n' "07 debug-me" "$artifact"
        return 1
    fi
    local ix=() out flag
    [ -f "${PWNDBG:-$HOME/pwndbg/gdbinit.py}" ] && ix=(-ix "${PWNDBG:-$HOME/pwndbg/gdbinit.py}")
    out=$(timeout 300 gdb -batch -nx "${ix[@]}" \
            -ex 'break ptrace' -ex run -ex finish -ex 'set $rax = 0' \
            -ex continue -ex 'call (char *) reveal()' -ex quit \
            "$artifact" </dev/null 2>&1 || true)
    flag=$(grep -aoE 'Securinets\{[^}]*\}' <<<"$out" | head -1)
    if [ -z "$flag" ]; then
        printf '%-15s FAIL\n' "07 debug-me"
        sed 's/^/                 /' <<<"$out" | tail -8
        return 1
    fi
    printf '%-15s ok        %s\n' "07 debug-me" "$flag"
}

FAILED=0
run "01 doorman"     "$HERE/01-doorman/solution/solve.sh"     "$PKG/doorman/attachments/doorman"          || FAILED=1
run "02 night-shift" "$HERE/02-night-shift/solution/solve.sh" "$PKG/night_shift/attachments/nightshift"   || FAILED=1
run "03 broken-lock" "$HERE/03-broken-lock/solution/solve.sh" "$PKG/broken_lock/attachments/lock"         || FAILED=1
run "04 paper-trail" "$HERE/04-paper-trail/solution/solve.sh" "$PKG/paper_trail/attachments/paper_trail"  || FAILED=1
run "05 dead-air"    "$HERE/05-dead-air/solution/solve.sh"    "$PKG/dead_air/attachments/relay"           || FAILED=1
run "06 decompile-me" "$HERE/06-decompile-me/solution/solve.sh" "$PKG/decompile_me/attachments/CodeCheck.exe" || FAILED=1
run_07 "$PKG/debug_me_anyway/attachments/gate" || FAILED=1

echo
if [ $FAILED -eq 0 ]; then
    echo "all seven packaged artifacts are solvable"
else
    echo "at least one packaged artifact did NOT solve -- see above" >&2
fi
exit $FAILED
