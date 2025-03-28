-- TODO: auto set up filename as debug name
local utils = require "astrocore"
local prefix_debug = "<Leader>d"
---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          [prefix_debug .. "q"] = {
            function() require("dap").terminate() end,
            desc = "Down Strace",
          },
          [prefix_debug .. "Q"] = {
            function() require("dap").close() end,
            desc = "Down Strace",
          },
          [prefix_debug .. "j"] = {
            function() require("dap").down() end,
            desc = "Down Strace",
          },
          [prefix_debug .. "k"] = {
            function() require("dap").up() end,
            desc = "Up Strace",
          },
          [prefix_debug .. "p"] = {
            function() require("dap.ui.widgets").preview() end,
            desc = "Debugger Preview",
          },
          [prefix_debug .. "P"] = {
            function() require("dap").pause() end,
            desc = "Pause (F6)",
          },
          [prefix_debug .. "t"] = {
            function() require("dap").terminate() end,
            desc = "Terminate",
          },
          [prefix_debug .. "u"] = {
            function() require("dapui").toggle { reset = false } end,
            desc = "Toggle Debugger UI",
          },
          [prefix_debug .. "r"] = {
            function() require("dap").run_last() end,
            desc = "Run Last",
          },
          [prefix_debug .. "R"] = {
            function() require("dap").restart_frame() end,
            desc = "Restart (C-F5)",
          },
          [prefix_debug .. "d"] = {
            ---@diagnostic disable-next-line: missing-parameter
            function() require("dapui").float_element() end,
            desc = "Open Dap UI Float Element",
          },
          ["<F9>"] = {
            function() require("persistent-breakpoints.api").toggle_breakpoint() end,
            desc = "Debugger: Toggle Breakpoint",
          },
          [prefix_debug .. "b"] = {
            function() require("persistent-breakpoints.api").toggle_breakpoint() end,
            desc = "Toggle Breakpoint (F9)",
          },
          [prefix_debug .. "B"] = {
            function() require("persistent-breakpoints.api").clear_all_breakpoints() end,
            desc = "Clear All Breakpoints",
          },
          [prefix_debug .. "C"] = {
            function() require("persistent-breakpoints.api").set_conditional_breakpoint() end,
            desc = "Conditional Breakpoint (S-F9)",
          },
          ["<F21>"] = {
            function() require("persistent-breakpoints.api").set_conditional_breakpoint() end,
            desc = "Conditional Breakpoint (S-F9)",
          },
          [prefix_debug .. "S"] = {
            function() require("dap").run_to_cursor() end,
            desc = "Run To Cursor",
          },
          [prefix_debug .. "s"] = {
            function()
              local w = require "dap.ui.widgets"
              w.centered_float(w.sessions, {})
            end,
            desc = "Switch Debug Session",
          },
        },
      },
    },
  },
  { "PongKJ/mason-nvim-dap.nvim", optional = true },
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "BufEnter",
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        load_breakpoints_event = { "BufEnter" },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "LiadOz/nvim-dap-repl-highlights",
      dependencies = { "mfussenegger/nvim-dap" },
      opts = {},
    },
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "dap_repl" })
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    event = "User AstroFile",
    opts = {
      commented = false,
      enabled = true,
      enabled_commands = true,
      only_first_definition = false,
      virt_text_pos = "eol",
      highlight_changed_variables = true,
      all_frames = true,
      all_references = true,
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function(_, opts)
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open { reset = false }
        vim.cmd "GitBlameDisable"
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open { reset = false }
        vim.cmd "GitBlameDisable"
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close {}
        vim.cmd "GitBlameEnable"
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close {}
        vim.cmd "GitBlameEnable"
      end
      opts = {
        controls = {
          element = "repl",
          enabled = false,
          icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = "",
          },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        force_buffers = true,
        icons = {
          collapsed = "",
          current_frame = "",
          expanded = "",
        },
        layouts = {
          {
            elements = {
              {
                id = "scopes",
                size = 0.25,
              },
              {
                id = "breakpoints",
                size = 0.25,
              },
              {
                id = "stacks",
                size = 0.25,
              },
              {
                id = "watches",
                size = 0.25,
              },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              {
                id = "repl",
                size = 0.5,
              },
              {
                id = "console",
                size = 0.5,
              },
            },
            position = "bottom",
            size = 8,
          },
        },
        mappings = {
          edit = "e",
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t",
        },
        render = {
          indent = 1,
          max_value_lines = 100,
        },
      }
      dapui.setup(opts)
    end,
  },
}
