lint:
    luacheck lua/

fmt:
    stylua lua/

fmt-check:
    stylua --check lua/

check:
    lua-language-server --check lua/

list:
    @just --list
