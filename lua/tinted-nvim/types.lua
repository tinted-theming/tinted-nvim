---@alias tinted-nvim.HexColor string

---@class tinted-nvim.ColorTransform
---@field darken? string
---@field lighten? string
---@field amount number

---@alias tinted-nvim.ColorValue
---| tinted-nvim.HexColor
---| tinted-nvim.ColorTransform

---@class tinted-nvim.PaletteColor
---@field normal? tinted-nvim.HexColor
---@field bright? tinted-nvim.HexColor
---@field dim? tinted-nvim.HexColor

---@class tinted-nvim.PaletteNamed
---@field black tinted-nvim.PaletteColor
---@field gray tinted-nvim.PaletteColor
---@field white tinted-nvim.PaletteColor
---@field red tinted-nvim.PaletteColor
---@field orange tinted-nvim.PaletteColor
---@field yellow tinted-nvim.PaletteColor
---@field green tinted-nvim.PaletteColor
---@field cyan tinted-nvim.PaletteColor
---@field blue tinted-nvim.PaletteColor
---@field magenta tinted-nvim.PaletteColor
---@field brown tinted-nvim.PaletteColor

---@class tinted-nvim.UiGlobal
---@field background { normal: tinted-nvim.HexColor }
---@field foreground { normal: tinted-nvim.HexColor }

---@class tinted-nvim.UiCursor
---@field background { normal: tinted-nvim.HexColor }
---@field foreground { normal: tinted-nvim.HexColor }

---@class tinted-nvim.UiChrome
---@field background { normal: tinted-nvim.HexColor, dark: tinted-nvim.HexColor }
---@field foreground { normal: tinted-nvim.HexColor, dark: tinted-nvim.HexColor }

---@class tinted-nvim.UiHighlight
---@field line { background: tinted-nvim.HexColor }
---@field text { background: tinted-nvim.HexColor }
---@field search { background: tinted-nvim.HexColor, foreground: tinted-nvim.HexColor }

---@class tinted-nvim.UiStatus
---@field error tinted-nvim.HexColor
---@field warning tinted-nvim.HexColor
---@field info tinted-nvim.HexColor
---@field success tinted-nvim.HexColor

---@class tinted-nvim.Ui
---@field global tinted-nvim.UiGlobal
---@field cursor tinted-nvim.UiCursor
---@field gutter { foreground: tinted-nvim.HexColor }
---@field border { normal: tinted-nvim.HexColor }
---@field chrome tinted-nvim.UiChrome
---@field selection { background: tinted-nvim.HexColor }
---@field highlight tinted-nvim.UiHighlight
---@field status tinted-nvim.UiStatus

---@class tinted-nvim.SyntaxString
---@field default tinted-nvim.HexColor
---@field regexp tinted-nvim.HexColor
---@field other tinted-nvim.HexColor

---@class tinted-nvim.SyntaxConstantNumeric
---@field default tinted-nvim.HexColor
---@field float tinted-nvim.HexColor

---@class tinted-nvim.SyntaxConstantCharacter
---@field default tinted-nvim.HexColor
---@field escape tinted-nvim.HexColor

---@class tinted-nvim.SyntaxConstant
---@field default tinted-nvim.HexColor
---@field character tinted-nvim.SyntaxConstantCharacter
---@field language tinted-nvim.HexColor
---@field numeric tinted-nvim.SyntaxConstantNumeric

---@class tinted-nvim.SyntaxEntityNameFunction
---@field default tinted-nvim.HexColor
---@field constructor tinted-nvim.HexColor

---@class tinted-nvim.SyntaxEntityName
---@field class tinted-nvim.HexColor
---@field type tinted-nvim.HexColor
---@field ["function"] tinted-nvim.SyntaxEntityNameFunction
---@field label tinted-nvim.HexColor
---@field namespace tinted-nvim.HexColor
---@field tag tinted-nvim.HexColor

---@class tinted-nvim.SyntaxEntity
---@field name tinted-nvim.SyntaxEntityName
---@field other { ["attribute-name"]: tinted-nvim.HexColor }

---@class tinted-nvim.SyntaxKeywordControl
---@field default tinted-nvim.HexColor
---@field import tinted-nvim.HexColor
---@field flow tinted-nvim.HexColor

---@class tinted-nvim.SyntaxKeyword
---@field default tinted-nvim.HexColor
---@field control tinted-nvim.SyntaxKeywordControl
---@field operator tinted-nvim.HexColor
---@field declaration tinted-nvim.HexColor

---@class tinted-nvim.SyntaxVariable
---@field default tinted-nvim.HexColor
---@field parameter tinted-nvim.HexColor
---@field other { property: tinted-nvim.HexColor }

---@class tinted-nvim.SyntaxMarkup
---@field default tinted-nvim.HexColor
---@field heading tinted-nvim.HexColor
---@field raw tinted-nvim.HexColor
---@field link tinted-nvim.HexColor
---@field list tinted-nvim.HexColor
---@field inserted tinted-nvim.HexColor
---@field deleted tinted-nvim.HexColor

---@class tinted-nvim.Syntax
---@field comment tinted-nvim.HexColor
---@field string tinted-nvim.SyntaxString
---@field constant tinted-nvim.SyntaxConstant
---@field entity tinted-nvim.SyntaxEntity
---@field keyword tinted-nvim.SyntaxKeyword
---@field storage { type: tinted-nvim.HexColor, modifier: tinted-nvim.HexColor }
---@field variable tinted-nvim.SyntaxVariable
---@field punctuation { separator: tinted-nvim.HexColor, section: tinted-nvim.HexColor }
---@field markup tinted-nvim.SyntaxMarkup
---@field meta { preprocessor: tinted-nvim.HexColor }

---@class tinted-nvim.Palette
---@field variant "dark"|"light"
---@field palette tinted-nvim.PaletteNamed
---@field ui tinted-nvim.Ui
---@field syntax tinted-nvim.Syntax
-- Legacy base slot fields (synthesized for backwards compatibility).
---@field base00? tinted-nvim.HexColor
---@field base01? tinted-nvim.HexColor
---@field base02? tinted-nvim.HexColor
---@field base03? tinted-nvim.HexColor
---@field base04? tinted-nvim.HexColor
---@field base05? tinted-nvim.HexColor
---@field base06? tinted-nvim.HexColor
---@field base07? tinted-nvim.HexColor
---@field base08? tinted-nvim.HexColor
---@field base09? tinted-nvim.HexColor
---@field base0A? tinted-nvim.HexColor
---@field base0B? tinted-nvim.HexColor
---@field base0C? tinted-nvim.HexColor
---@field base0D? tinted-nvim.HexColor
---@field base0E? tinted-nvim.HexColor
---@field base0F? tinted-nvim.HexColor
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
