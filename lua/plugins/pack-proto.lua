local set_mappings = require("astrocore").set_mappings
local file_exists = require("utils").file_exists
local utils = require "utils"

local function create_buf_config_file()
  local source_file = vim.fn.stdpath "config" .. "/templates/buf.yaml"
  local target_file = vim.fn.getcwd() .. "/buf.yaml"
  utils.copy_file(source_file, target_file)
end

local function create_buf_gen_config_file()
  local source_file = vim.fn.stdpath "config" .. "/templates/buf.gen.yaml"
  local target_file = vim.fn.getcwd() .. "/buf.gen.yaml"
  utils.copy_file(source_file, target_file)
end

local function diagnostic_auto_import_config()
  local null_ls = require "null-ls"
  local buf_buildins = null_ls.builtins.formatting.buf
  -- local config_file = require("utils").detect_files_in_paths(
  --   { ".buf.yaml", "buf.yaml" },
  --   { vim.fn.getcwd(), vim.fn.stdpath "config" .. "/templates" }
  -- )
  -- if config_file then
  --   table.insert(buf_buildins._opts.args, "--config")
  --   table.insert(buf_buildins._opts.args, config_file)
  -- end

  null_ls.register(null_ls.builtins.formatting.buf.with(buf_buildins))
end

local function formatting_auto_import_config()
  local null_ls = require "null-ls"
  local buf_buildins = null_ls.builtins.diagnostics.buf

  -- local config_file = require("utils").detect_files_in_paths(
  --   { ".buf.yaml", "buf.yaml" },
  --   { vim.fn.getcwd(), vim.fn.stdpath "config" .. "/templates" }
  -- )
  -- if config_file then
  --   table.insert(buf_buildins._opts.args, "--config")
  --   table.insert(buf_buildins._opts.args, config_file)
  -- end
  null_ls.register(null_ls.builtins.diagnostics.buf.with(buf_buildins))
end

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      ---@diagnostic disable: missing-fields
      config = {
        bufls = {
          filetypes = { "proto" },
          single_file_support = true,
        },
      },
      on_attach = function()
        set_mappings({
          n = {
            ["<Leader>lc"] = {
              function()
                local buf_path = vim.fn.getcwd() .. "/buf.yaml"
                local buf_gen_path = vim.fn.getcwd() .. "/buf.gen.yaml"
                if not file_exists(buf_path) then
                  local confirm = vim.fn.confirm("File `buf.yaml` Not Exist, Create it?", "&Yes\n&No", 1, "Question")
                  if confirm == 1 then create_buf_config_file() end
                end

                if not file_exists(buf_gen_path) then
                  local confirm =
                    vim.fn.confirm("File `buf.gen.yaml` Not Exist, Create it?", "&Yes\n&No", 1, "Question")
                  if confirm == 1 then create_buf_gen_config_file() end
                end
              end,
              desc = "Create Buf Config File",
            },
          },
        }, { buffer = true })
      end,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      -- Ensure that opts.ensure_installed exists and is a table or string "all".
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "proto" })
      end
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.handlers then opts.handlers = {} end

      opts.handlers.buf = function()
        diagnostic_auto_import_config()
        formatting_auto_import_config()
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      -- lsp
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        { "buf" },
      })
    end,
  },
}
