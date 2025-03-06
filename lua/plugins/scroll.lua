---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      if not opts.mappings then opts.mappings = require("astrocore").empty_map_table() end
      local maps = opts.mappings
      if maps then
        maps.n["zz"] = { function() require("neoscroll").zz { half_win_duration = 250 } end, desc = "Center screen" }
        maps.x["zz"] = maps.n["zz"]
        maps.n["zt"] = { function() require("neoscroll").zt { half_win_duration = 250 } end, desc = "Top screen" }
        maps.x["zt"] = maps.n["zt"]
        maps.n["zb"] = { function() require("neoscroll").zb { half_win_duration = 250 } end, desc = "Bottom screen" }
        maps.x["zb"] = maps.n["zb"]
      end
      opts.mappings = maps
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = {
        "<C-b>",
        "<C-f>",
        "<C-y>",
        "<C-e>",
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup {
        handle = {
          color = "#555555",
        },
        marks = {
          Search = { color = "#00FF00" },
          Error = { color = "#FF0000" },
          Warn = { color = "#FFA500" },
          Info = { color = "#00FFFF" },
          Hint = { color = "#FF00FF" },
          Misc = { color = "#FFFF00" },
        },
      }
    end,
  },
}
