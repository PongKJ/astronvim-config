local utils = require "astrocore"
local set_mappings = utils.set_mappings

local function create_sqlfluff_config_file()
  local source_file = vim.fn.stdpath "config" .. "/templates/.sqlfluff"
  local target_file = vim.fn.getcwd() .. "/.sqlfluff"
  require("utils").copy_file(source_file, target_file)
end

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        auto_spell = {
          {
            event = "FileType",
            desc = "create completion",
            pattern = { "sql", "mysql", "plsql" },
            callback = function()
              set_mappings({
                n = {
                  ["<Leader>lc"] = {
                    create_sqlfluff_config_file,
                    desc = "Create sqlfluff config file",
                  },
                },
              }, { buffer = true })
            end,
            once = true,
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
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "sql" })
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "sqlfluff", "sqlfmt" })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.handlers then opts.handlers = {} end

      opts.handlers.sqlfluff = function()
        local null_ls = require "null-ls"
        local buf_diagnostics_buildins = null_ls.builtins.diagnostics.sqlfluff
        -- local config_file = require("utils").detect_files_in_paths(
        --   { ".sqlfluff", "sqlfluff" },
        --   { vim.fn.getcwd(), vim.fn.stdpath "config" .. "/templates" }
        -- )
        -- if config_file then
        --   table.insert(buf_diagnostics_buildins._opts.args, "--config")
        --   table.insert(buf_diagnostics_buildins._opts.args, config_file)
        -- end
        null_ls.register(null_ls.builtins.diagnostics.sqlfluff.with {
          generator_opts = buf_diagnostics_buildins._opts,
          filetypes = { "sql", "dbt" },
        })

        -- format
        local sqlfmt_formatting_buildins = null_ls.builtins.formatting.sqlfmt
        table.insert(sqlfmt_formatting_buildins._opts.args, "--dialect")
        table.insert(sqlfmt_formatting_buildins._opts.args, "polyglot")
        null_ls.register(null_ls.builtins.formatting.sqlfmt.with {
          generator_opts = sqlfmt_formatting_buildins._opts,
          filetypes = { "sql", "dbt" },
        })
      end
    end,
  },
}
