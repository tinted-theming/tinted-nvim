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

list:
    @just --list
