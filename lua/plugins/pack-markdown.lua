local utils = require "astrocore"

local markdown_table_change = function()
  vim.ui.input({ prompt = "Separate Char: " }, function(input)
    if not input or #input == 0 then return end
    local execute_command = ([[:'<,'>MakeTable! ]] .. input)
    vim.cmd(execute_command)
  end)
end

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        options = {
          g = {
            mkdp_auto_close = 0,
            mkdp_combine_preview = 1,
          },
        },
      })
    end,
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      ---@diagnostic disable: missing-fields
      config = {
        marksman = {
          on_attach = function()
            if utils.is_available "markdown-preview.nvim" then
              utils.set_mappings({
                n = {
                  ["<Leader>lz"] = { "<cmd>MarkdownPreview<CR>", desc = "Markdown Start Preview" },
                  ["<Leader>lZ"] = { "<cmd>MarkdownPreviewStop<CR>", desc = "Markdown Stop Preview" },
                  ["<Leader>lp"] = { "<cmd>PastifyAfter<CR>", desc = "Markdown Paste Image After" },
                  ["<Leader>lP"] = { "<cmd>Pastify<CR>", desc = "Markdown Paste Image" },
                },
                x = {
                  ["<Leader>lt"] = { [[:'<,'>MakeTable! \t<CR>]], desc = "Markdown csv to table(Default:\\t)" },
                  ["<Leader>lT"] = { markdown_table_change, desc = "Markdown csv to table with separate char" },
                },
              }, { buffer = true })
            end
          end,
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "markdown", "markdown_inline" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "marksman" }) end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "prettierd", "markdownlint" })

      opts.handlers.markdownlint = function()
        local null_ls = require "null-ls"
        local markdownlint_diagnostics_buildins = null_ls.builtins.diagnostics.markdownlint
        local config_file = require("utils").detect_files_in_paths(
          { ".markdownlint.jsonc", ".markdownlint.json" },
          { vim.fn.getcwd(), vim.fn.stdpath "config" .. "/dotfiles" }
        )
        if config_file then
          table.insert(markdownlint_diagnostics_buildins._opts.args, "--config")
          table.insert(markdownlint_diagnostics_buildins._opts.args, config_file)
        end
        null_ls.register(null_ls.builtins.diagnostics.markdownlint.with {
          generator_opts = markdownlint_diagnostics_buildins._opts,
        })
      end
    end,
  },
  -- install with yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
  {
    "TobinPalmer/pastify.nvim",
    cmd = { "Pastify", "PastifyAfter" },
    opts = {
      absolute_path = false,
      apikey = "",
      local_path = "/assets/imgs/",
      save = "local",
    },
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown", -- If you decide to lazy-load anyway
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      hybrid_modes = { "n" },
    },
  },
}
