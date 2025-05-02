local modules = require('lualine_require').lazy_require { notices = 'lualine.utils.notices' }

local function add_notice(notice)
  modules.notices.add_notice('theme(tinted): ' .. notice)
end

local function setup(colors)
  local theme = {
    normal = {
      a = { fg = colors.bg, bg = colors.normal },
      b = { fg = colors.light_fg, bg = colors.alt_bg },
      c = { fg = colors.fg, bg = colors.bg },
    },
    replace = {
      a = { fg = colors.bg, bg = colors.replace },
      b = { fg = colors.light_fg, bg = colors.alt_bg },
    },
    insert = {
      a = { fg = colors.bg, bg = colors.insert },
      b = { fg = colors.light_fg, bg = colors.alt_bg },
    },
    visual = {
      a = { fg = colors.bg, bg = colors.visual },
      b = { fg = colors.light_fg, bg = colors.alt_bg },
    },
    inactive = {
      a = { fg = colors.dark_fg, bg = colors.bg },
      b = { fg = colors.dark_fg, bg = colors.bg },
      c = { fg = colors.dark_fg, bg = colors.bg },
    },
  }

  theme.command = theme.normal
  theme.terminal = theme.insert

  return theme
end

local function setup_default()
  add_notice(
    'tinted-nvim and tinted-vim is not currently present in your runtimepath, make sure it is properly installed,'
    .. ' fallback to default colors.'
  )

  -- ayu-dark default
  return setup {
    bg = '#0f1419',
    alt_bg = '#272d38',
    dark_fg = '#3e4b59',
    fg = '#3e4b59',
    light_fg = '#e6e1cf',
    normal = '#59c2ff',
    insert = '#b8cc52',
    visual = '#d2a6ff',
    replace = '#ff8f40',
  }
end

local function setup_tinted_nvim()
  -- Continue to load tinted-nvim
  local loaded, tinted = pcall(require, 'tinted-colorscheme')

  if not loaded then
    return nil
  end

  local colors = tinted.colors or tinted.colorschemes['tinted-nvim-default']

  return setup {
    bg = colors.base01,
    alt_bg = colors.base02,
    dark_fg = colors.base03,
    fg = colors.base04,
    light_fg = colors.base05,
    normal = colors.base0D,
    insert = colors.base0B,
    visual = colors.base0E,
    replace = colors.base09,
  }
end

local function setup_tinted_vim()
  -- context: https://github.com/nvim-lualine/lualine.nvim/pull/1352
  if vim.g.tinted_gui00 and vim.g.tinted_gui0F then
    return setup {
      bg = vim.g.tinted_gui01,
      alt_bg = vim.g.tinted_gui02,
      dark_fg = vim.g.tinted_gui03,
      fg = vim.g.tinted_gui04,
      light_fg = vim.g.tinted_gui05,
      normal = vim.g.tinted_gui0D,
      insert = vim.g.tinted_gui0B,
      visual = vim.g.tinted_gui0E,
      replace = vim.g.tinted_gui09,
    }
  end

  return nil
end

return setup_tinted_nvim() or setup_tinted_vim() or setup_default()
