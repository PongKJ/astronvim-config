return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      indent = {
        animate = {
          enabled = vim.fn.has "nvim-0.10" == 1,
          style = "out",
          easing = "linear",
          duration = {
            step = 10, -- ms per step
            total = 100, -- maximum duration
          },
        },
        scope = {
          enabled = true, -- enable highlighting the current scope
          priority = 200,
          char = "│",
          underline = true, -- underline the start of the scope
          only_current = false, -- only show scope in the current window
          hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
        },
        win = {
          enabled = true,
          priority = 200,
          char = "│",
          underline = true, -- underline the start of the scope
          only_current = false, -- only show scope in the current window
          hl = "SnacksIndentWin", ---@type string|string[] hl group for scopes
        },
        enabled = true,
        filter = function(buf)
          local forbidden_filetypes = { "markdown", "markdown.mdx" } -- Add your forbidden filetypes here
          local filetype = vim.bo[buf].filetype
          for _, ft in ipairs(forbidden_filetypes) do
            if filetype == ft then return false end
          end
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
      },
      notifier = { enabled = true },
      -- Some bugs, so disable it for now
      -- scroll = {
      --   enabled = false,
      --   animate = {
      --     duration = 20,
      --     easing = "linear",
      --   },
      --   -- faster animation when repeating scroll after delay
      --   animate_repeat = {
      --     delay = 100, -- delay in ms before using the repeat animation
      --     duration = 10,
      --     easing = "linear",
      --   },
      -- },
      scope = { enabled = true },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = true, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      profiler = { enabled = true },
      lazygit = { enabled = false },
      terminal = { enabled = false },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts) opts.statuscolumn = false end,
  },
}
