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

# Verify current highlight tables match pre-migration baseline (commit e128f82) byte-for-byte.
verify-parity:
    #!/usr/bin/env bash
    set -euo pipefail
    BASELINE=e128f82
    WORKTREE=/tmp/tinted-nvim-pre-migration-$$
    REPO=$(pwd)
    git fetch origin
    if ! git rev-parse --verify --quiet "${BASELINE}^{commit}" >/dev/null; then
        echo "error: baseline commit ${BASELINE} is not reachable (shallow clone?)" >&2
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
