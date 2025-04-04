local utils = require "astrocore"

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      ---@diagnostic disable: missing-fields
      config = {
        emmet_language_server = {
          filetypes = {
            "css",
            "eruby",
            "html",
            "htmldjango",
            "javascriptreact",
            "less",
            "pug",
            "sass",
            "scss",
            "typescriptreact",
            "vue",
          },
        },
        html = { init_options = { provideFormatter = false } },
        cssls = {
          init_options = { provideFormatter = false },
          settings = {
            css = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
            less = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = false,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "html", "css", "scss" })
      end
      vim.treesitter.language.register("scss", "less")
      vim.treesitter.language.register("scss", "postcss")
    end,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = { filetypes = { extension = {
      pcss = "postcss",
      postcss = "postcss",
    } } },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      -- lsp
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
        { "html-lsp", "css-lsp", "cssmodules-language-server", "emmet-ls", "lemminx" ,"prettierd"}
      })
    end,
  },
  {
    "echasnovski/mini.icons",
    optional = true,
    opts = {
      filetype = {
        postcss = { glyph = "󰌜", hl = "MiniIconsOrange" },
      },
    },
  },
}
