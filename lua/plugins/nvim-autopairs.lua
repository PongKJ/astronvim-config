---@type LazySpec
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function(plugin, opts)
    -- run default AstroNvim config
    require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts)
    -- require Rule function
    local Rule = require "nvim-autopairs.rule"
    local npairs = require "nvim-autopairs"
    -- npairs.add_rules {
    --   {
        -- specify a list of rules to add
        -- Rule(" ", " "):with_pair(function(options)
        --   local pair = options.line:sub(options.col - 1, options.col)
        --   return vim.tbl_contains({ "()", "[]", "{}" }, pair)
        -- end),
        -- Rule("( ", " )")
        --   :with_pair(function() return false end)
        --   :with_move(function(options) return options.prev_char:match ".%)" ~= nil end)
        --   :use_key ")",
        -- Rule("{ ", " }")
        --   :with_pair(function() return false end)
        --   :with_move(function(options) return options.prev_char:match ".%}" ~= nil end)
        --   :use_key "}",
        -- Rule("[ ", " ]")
        --   :with_pair(function() return false end)
        --   :with_move(function(options) return options.prev_char:match ".%]" ~= nil end)
        --   :use_key "]",
    --   },
    -- }
  end,
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      enable_check_bracket_line = false,
      map_c_h = true,
      map_c_w = true,
      map_bs = true,
      check_ts = true,
      enable_abbr = true,
      map_cr = true,
    })
  end,
}
