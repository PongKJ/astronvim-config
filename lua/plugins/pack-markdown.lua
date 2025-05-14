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
            utils.set_mappings({
              n = {
                ["<Leader>lp"] = { "<cmd>MarkdownPreview<cr>", desc = "Preview" },
                ["<Leader>ls"] = { "<cmd>MarkdownPreviewStop<cr>", desc = "Stop preview" },
                ["<Leader>mp"] = { "<cmd>PastifyAfter<CR>", desc = "Markdown Paste Image After" },
                ["<Leader>mP"] = { "<cmd>Pastify<CR>", desc = "Markdown Paste Image" },
              },
              x = {
                ["<Leader>mt"] = { [[:'<,'>MakeTable! \t<CR>]], desc = "Markdown csv to table(Default:\\t)" },
                ["<Leader>mT"] = { markdown_table_change, desc = "Markdown csv to table with separate char" },
              },
            }, { buffer = true })
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
        opts.ensure_installed = utils.list_insert_unique(
          opts.ensure_installed,
          { "latex", "html", "norg", "typst", "markdown", "markdown_inline" }
        )
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      -- lsp
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
        { "marksman", "prettierd", "markdownlint" },
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.handlers.markdownlint = function()
        local null_ls = require "null-ls"
        local markdownlint_diagnostics_buildins = null_ls.builtins.diagnostics.markdownlint
        -- local config_file = require("utils").detect_files_in_paths(
        --   { ".markdownlint.jsonc", ".markdownlint.json" },
        --   { vim.fn.getcwd(), vim.fn.stdpath "config" .. "/templates" }
        -- )
        -- if config_file then
        --   table.insert(markdownlint_diagnostics_buildins._opts.args, "--config")
        --   table.insert(markdownlint_diagnostics_buildins._opts.args, config_file)
        -- end
        null_ls.register(null_ls.builtins.diagnostics.markdownlint.with {
          generator_opts = markdownlint_diagnostics_buildins._opts,
        })
      end
    end,
  },
  -- BUG: Can't open browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "markdown.mdx" },
    build = function(plugin)
      local package_manager = vim.fn.executable "yarn" and "yarn" or vim.fn.executable "npx" and "npx -y yarn" or false

      --- HACK: Use `yarn` or `npx` when possible, otherwise throw an error
      ---@see https://github.com/iamcco/markdown-preview.nvim/issues/690
      ---@see https://github.com/iamcco/markdown-preview.nvim/issues/695
      if not package_manager then error "Missing `yarn` or `npx` in the PATH" end

      local cmd = string.format(
        "!cd %s && cd app && COREPACK_ENABLE_AUTO_PIN=0 %s install --frozen-lockfile",
        plugin.dir,
        package_manager
      )
      vim.cmd(cmd)
    end,
    init = function()
      local plugin = require("lazy.core.config").spec.plugins["markdown-preview.nvim"]
      vim.g.mkdp_filetypes = require("lazy.core.plugin").values(plugin, "ft", true)
    end,
  },
  {
    -- NOTE: Need to install python-neovim and python-pillow packages,
    -- Run `pip3 install neovim pillow`
    "TobinPalmer/pastify.nvim",
    cmd = { "Pastify", "PastifyAfter" },
    opts = {
      absolute_path = false,
      apikey = "",
      local_path = "/assets/imgs/",
      save = "local",
    },
  },
  -- TODO: make completions work
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { lsp = { enabled = true } },
      heading = { border = true },
    },
  },
}
