local utils = require "astrocore"

local markdown_table_change = function()
  vim.ui.input({ prompt = "Separate Char: " }, function(input)
    if not input or #input == 0 then return end
    local execute_command = ([[:'<,'>MakeTable! ]] .. input)
    vim.cmd(execute_command)
  end)
end

local start_marker = "<!-- markdown toc:start -->"
local end_marker = "<!-- markdown toc:stop  -->"

local function gen_toc(start_linenr, end_linenr)
  local parser = vim.treesitter.get_parser(0, "markdown")
  local root = parser:parse()[1]:root()
  local query = vim.treesitter.query.parse(
    "markdown",
    [[
(atx_heading) @header
    ]]
  )
  local lines = { start_marker }
  for _, node in query:iter_captures(root, 0, end_linenr) do
    local level = tonumber(node:child(0):type():match "atx_h(%d)_marker") - 2
    if level >= 0 then
      local title = vim.treesitter.get_node_text(node:field("heading_content")[1], 0)
      local link = title:gsub("%s", "-")
      lines[#lines + 1] = ("  "):rep(level) .. ("* [%s](#%s)"):format(title, link)
    end
  end
  lines[#lines + 1] = end_marker
  vim.api.nvim_buf_set_lines(0, start_linenr, end_linenr, true, lines)
end
local function update_toc()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local start_linenr, end_linenr
  for i, line in ipairs(lines) do
    if line == start_marker then
      start_linenr = i - 1
    else
      if line == end_marker then
        end_linenr = i
        break
      end
    end
  end
  if not (start_linenr and end_linenr) then return end
  gen_toc(start_linenr, end_linenr)
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
            utils.set_mappings {
              n = {
                ["<Leader>lt"] = { desc = "Markdown TOC" },
                ["<Leader>ltg"] = {
                  function() gen_toc(vim.api.nvim_win_get_cursor(0)[1] - 1, vim.api.nvim_win_get_cursor(0)[1] - 1) end,
                  desc = "Markdown Generate TOC",
                },
                ["<Leader>ltu"] = { update_toc, desc = "Markdown Update TOC" },
              },
            }
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
    build = "cd app && npm install",
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
