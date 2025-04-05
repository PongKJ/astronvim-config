return {
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    opts = {
      default_mappings = true,
      -- WARN: Not support
      -- opacity = 0.9,
    },
  },
  -- FIXME: Didn't show on which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").add { {
        "gp",
        desc = "Goto preview",
      } }
    end,
  },
}
