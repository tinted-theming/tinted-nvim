lint:
    luacheck lua/

fmt:
    stylua lua/

fmt-check:
    stylua --check lua/

check:
    lua-language-server --check lua/

docs:
    lemmy-help lua/tinted-nvim/init.lua lua/tinted-nvim/config.lua > doc/tinted-nvim.txt

list:
    @just --list
