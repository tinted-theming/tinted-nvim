test filter="":
    vusted tests/ {{ if filter != "" { "--filter=" + filter } else { "" } }}

test-file file:
    vusted {{ file }}

lint:
    luacheck lua/ tests/

fmt:
    stylua lua/ tests/

fmt-check:
    stylua --check lua/ tests/

check:
    lua-language-server --check lua/ --configpath $(pwd)/.luarc.json

docs:
    lemmy-help lua/tinted-nvim/init.lua lua/tinted-nvim/config.lua > doc/tinted-nvim.txt
    # Runs Neovim in non-interactive batch mode, with no config/state, to
    # generate help tags for doc/
    nvim -N -u NONE -i NONE -n -E -s -V1 -c "helptags $(pwd)/doc" +quit!

list:
    @just --list

# Verify current highlight tables match the pre-migration baseline byte-for-byte.
#
# The baseline SHA must live on `main` (or another permanent branch) so that
# rebases of feature branches do not orphan it. f7d101d is the last "real"
# (non-CI-palette-regen) commit on main before the tinted8 work began. The
# CI auto-regen commits on main since then only touch palette files, not
# highlights, so f7d101d's highlight output is still the canonical baseline.
verify-parity:
    #!/usr/bin/env bash
    set -euo pipefail
    BASELINE=f7d101d
    WORKTREE=/tmp/tinted-nvim-pre-migration-$$
    REPO=$(pwd)
    # Best-effort fetch in case the baseline isn't in the local clone yet.
    # Don't fail the recipe if we're offline or lack credentials — fall back
    # to whatever is already local.
    git fetch origin --quiet 2>/dev/null || true
    if ! git rev-parse --verify --quiet "${BASELINE}^{commit}" >/dev/null; then
        echo "error: baseline commit ${BASELINE} is not reachable (shallow clone? missing from main?)" >&2
        exit 1
    fi
    cleanup() { git worktree remove --force "${WORKTREE}" >/dev/null 2>&1 || true; }
    trap cleanup EXIT
    git worktree add --detach "${WORKTREE}" "${BASELINE}" >/dev/null
    mkdir -p "${WORKTREE}/tests/fixtures/snapshots"
    cp "${REPO}/tests/fixtures/snapshot_highlights.lua" "${WORKTREE}/tests/fixtures/snapshot_highlights.lua"
    (cd "${WORKTREE}" && nvim --headless -u NONE --cmd "set rtp+=${WORKTREE}" -c "luafile tests/fixtures/snapshot_highlights.lua" -c "quit")
    if diff -r "${WORKTREE}/tests/fixtures/snapshots" "${REPO}/tests/fixtures/snapshots"; then
        echo "verify-parity: PASS (snapshots match pre-migration baseline ${BASELINE})"
    else
        echo "verify-parity: FAIL (snapshots differ from pre-migration baseline ${BASELINE})" >&2
        exit 1
    fi
