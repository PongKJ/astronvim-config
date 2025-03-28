local utils = require "astrocore"
return {
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "slint_lsp" }) end,
  },
  {
    "AstroNvim/astrolsp",
    ft = { "slint" },
    optional = true,
    opts = function(_, opts)
      opts.config = vim.tbl_deep_extend("keep", opts.config, {
        slint_lsp = {
          capabilities = {
            -- offsetEncoding = "utf-8",
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "slint" })
      end
    end,
  },
}
