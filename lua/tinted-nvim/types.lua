---@class tinted-nvim.Config
---@field default_scheme string
---@field apply_scheme_on_startup boolean
---@field compile boolean
---@field capabilities tinted-nvim.Config.Capabilities
---@field ui tinted-nvim.Config.Ui
---@field styles tinted-nvim.Config.Styles
---@field highlights tinted-nvim.Config.Highlights
---@field schemes table<string, tinted-nvim.SchemeSpec>
---@field selector tinted-nvim.Config.Selector

---@class tinted-nvim.Config.Capabilities
---@field undercurl boolean
---@field terminal_colors boolean

---@class tinted-nvim.Config.Ui
---@field transparent boolean
---@field dim_inactive boolean

---@class tinted-nvim.Config.StyleAttrs
---@field italic? boolean
---@field bold? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field strikethrough? boolean

---@class tinted-nvim.Config.Styles
---@field comments tinted-nvim.Config.StyleAttrs
---@field keywords tinted-nvim.Config.StyleAttrs
---@field functions tinted-nvim.Config.StyleAttrs
---@field variables tinted-nvim.Config.StyleAttrs
---@field types tinted-nvim.Config.StyleAttrs

---@class tinted-nvim.Config.Integrations
---@field telescope boolean
---@field notify boolean
---@field cmp boolean
---@field blink boolean
---@field dapui boolean

---@alias tinted-nvim.Config.HighlightOverridesFn fun(palette:tinted-nvim.Palette):tinted-nvim.Highlights

---@class tinted-nvim.Config.Highlights
---@field integrations tinted-nvim.Config.Integrations
---@field use_lazy_specs boolean
---@field overrides tinted-nvim.Config.HighlightOverridesFn

---@alias tinted-nvim.Config.SelectorMode "file"|"env"|"cmd"

---@class tinted-nvim.Config.Selector
---@field enabled boolean
---@field mode tinted-nvim.Config.SelectorMode
---@field path string
---@field env string
---@field cmd string
---@field watch boolean

---@alias tinted-nvim.HexColor string

---@class tinted-nvim.ColorTransform
---@field darken? string
---@field lighten? string
---@field amount number

---@alias tinted-nvim.ColorValue
---| tinted-nvim.HexColor
---| tinted-nvim.ColorTransform

---@class tinted-nvim.Palette
---@field variant "dark"|"light"
---@field base00 tinted-nvim.HexColor
---@field base01 tinted-nvim.HexColor
---@field base02 tinted-nvim.HexColor
---@field base03 tinted-nvim.HexColor
---@field base04 tinted-nvim.HexColor
---@field base05 tinted-nvim.HexColor
---@field base06 tinted-nvim.HexColor
---@field base07 tinted-nvim.HexColor
---@field base08 tinted-nvim.HexColor
---@field base09 tinted-nvim.HexColor
---@field base0A tinted-nvim.HexColor
---@field base0B tinted-nvim.HexColor
---@field base0C tinted-nvim.HexColor
---@field base0D tinted-nvim.HexColor
---@field base0E tinted-nvim.HexColor
---@field base0F tinted-nvim.HexColor
---@field base10? tinted-nvim.HexColor
---@field base11? tinted-nvim.HexColor
---@field base12? tinted-nvim.HexColor
---@field base13? tinted-nvim.HexColor
---@field base14? tinted-nvim.HexColor
---@field base15? tinted-nvim.HexColor
---@field base16? tinted-nvim.HexColor
---@field base17? tinted-nvim.HexColor

---@alias tinted-nvim.PaletteValue
---| tinted-nvim.HexColor
---| fun(palette:tinted-nvim.Palette):tinted-nvim.HexColor

---@class tinted-nvim.SchemeSpec
---@field variant? "dark"|"light"
---@field base00? tinted-nvim.PaletteValue
---@field base01? tinted-nvim.PaletteValue
---@field base02? tinted-nvim.PaletteValue
---@field base03? tinted-nvim.PaletteValue
---@field base04? tinted-nvim.PaletteValue
---@field base05? tinted-nvim.PaletteValue
---@field base06? tinted-nvim.PaletteValue
---@field base07? tinted-nvim.PaletteValue
---@field base08? tinted-nvim.PaletteValue
---@field base09? tinted-nvim.PaletteValue
---@field base0A? tinted-nvim.PaletteValue
---@field base0B? tinted-nvim.PaletteValue
---@field base0C? tinted-nvim.PaletteValue
---@field base0D? tinted-nvim.PaletteValue
---@field base0E? tinted-nvim.PaletteValue
---@field base0F? tinted-nvim.PaletteValue
---@field base10? tinted-nvim.PaletteValue
---@field base11? tinted-nvim.PaletteValue
---@field base12? tinted-nvim.PaletteValue
---@field base13? tinted-nvim.PaletteValue
---@field base14? tinted-nvim.PaletteValue
---@field base15? tinted-nvim.PaletteValue
---@field base16? tinted-nvim.PaletteValue
---@field base17? tinted-nvim.PaletteValue

---@class tinted-nvim.Highlight: vim.api.keyset.highlight
---@field fg? tinted-nvim.ColorValue
---@field bg? tinted-nvim.ColorValue
---@field sp? tinted-nvim.ColorValue

---@alias tinted-nvim.Highlights table<string, tinted-nvim.Highlight>
