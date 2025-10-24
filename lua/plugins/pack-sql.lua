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
}
