local utils = require "astrocore"

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "bash" })
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "shfmt", "bash-language-server" })
    end,
  },
  {
    "PongKJ/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      -- dap
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "bash" })
    end,
  },
}
