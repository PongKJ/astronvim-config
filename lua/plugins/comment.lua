local utils = require "utils"
---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      local maps = require("astrocore").empty_map_table()
      -- We need to hanle ctrl-prefix keymap differently on Windows
      if utils.get_os_name() == "windows" then
        -- Actually, on Windows, <C-_> is is what neovim received
        -- when you press <C-/> on the keyboard.
        -- see: https://www.reddit.com/r/neovim/comments/ro2hm4/ctrl_keybinding_not_working/?tl=zh-hans
        maps.n["<C-_>"] = opts.mappings.n["<Leader>/"]
        maps.x["<C-_>"] = opts.mappings.x["<Leader>/"]
      else
        maps.n["<C-/>"] = opts.mappings.n["<Leader>/"]
        maps.x["<C-/>"] = opts.mappings.x["<Leader>/"]
      end
      maps.n["<Leader>/"] = false
      maps.x["<Leader>/"] = false

      opts.mappings = require("astrocore").extend_tbl(opts.mappings, maps)
    end,
  },
}
