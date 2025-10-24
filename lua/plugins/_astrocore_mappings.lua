local utils = require "utils"

return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    if not opts.mappings then opts.mappings = require("astrocore").empty_map_table() end
    local workspace_type = require("utils").detect_workspace_type()
    local overseer = require "overseer"
    vim.notify("Workspace Type:" .. workspace_type .. "", vim.log.levels.INFO)
    local maps = opts.mappings
    if maps then
      if workspace_type ~= "unkown" then
        maps.n["<Leader>W"] = { "", desc = "Workspace" }
        maps.n["<Leader>Wd"] = {
          function() require("helper.workspace").ensure_workspace_dotfiles "c_cpp" end,
          desc = "Ensure dotfiles",
        }
      end
      -- <Leader>n
      maps.n["<Leader>n"] = { "", desc = "Tasks" }
      -- close search highlight
      -- maps.n["<Leader>nh"] = { ":nohlsearch<CR>", desc = "Close search highlight", silent = true }
      maps.n["<Leader>nn"] = { "<Cmd>CopilotChatToggle<CR>", desc = "Copilot Chat Toggle" }
      -- Overseer + .vscode/tasks.json to manage tasks
      maps.n["<Leader>o"] = { "", desc = "Overseer" }
      -- TODO: Add other workspace types
      if workspace_type == "c_cpp" then
        maps.n["<Leader>ns"] = { "", desc = "Select Target" }
        maps.n["<Leader>nh"] = { "<Cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch between source and header" }
        maps.n["<Leader>nsr"] = {
          function()
            vim.ui.input({ prompt = "target to run:" }, function(target)
              if target then
                -- vim.cmd("TermExec cmd='tsx project.mts run " .. target .. "'")
                require("toggleterm").exec("tsx project.mts run " .. target)
              else
                vim.notify("No target specified, run last target", vim.log.levels.INFO)
              end
            end)
          end,
          desc = "Run specific target",
        }
        maps.n["<Leader>nc"] = {
          "<Cmd>TermExec cmd='tsx project.mts config'<CR>",
          desc = "Cmake config",
        }
        maps.n["<Leader>nb"] = { "<Cmd>TermExec cmd='tsx project.mts build'<CR>", desc = "Build target" }
        maps.n["<Leader>nsb"] = {
          function()
            vim.ui.input({ prompt = "target to build:" }, function(target)
              if target then
                vim.cmd("TermExec cmd='tsx project.mts build " .. target .. "'")
              else
                vim.notify("No target specified, build last target", vim.log.levels.INFO)
              end
            end)
          end,
          desc = "Build specific target",
        }
        maps.n["<Leader>nt"] = { "<Cmd>TermExec cmd='tsx project.mts test'<CR>", desc = "Test" }
        maps.n["<Leader>nd"] = { "<Cmd>CMakeDebug<CR>", desc = "Debug" }
        maps.n["<F5>"] = { "<cmd>CMakeDebug<CR>", desc = "Start Debug" }
      end
      if workspace_type == "rust" then
        maps.n["<Leader>ns"] = { "", desc = "Select Target" }
        maps.n["<F5>"] = { "<Cmd>RustLsp! debuggables<CR>", desc = "Start Debug" }
        maps.n["<Leader>nd"] = { "<CMd>RustLsp! debuggables<CR>", desc = "Debug" }
        maps.n["<Leader>nsd"] = { "<Cmd>RustLsp debuggables<CR>", desc = "Select Debug Target" }
        maps.n["<Leader>nb"] = {
          function() overseer.run_template { tags = { overseer.TAG.BUILD } } end,
          desc = "Build",
        }
        maps.n["<Leader>nr"] = { "<Cmd>RustLsp! runnables<CR>", desc = "Run" }
        maps.n["<Leader>nsr"] = { "<Cmd>RustLsp runnables<CR>", desc = "Select Run Target" }
      end

      -- term mode mappings
      maps.t["<Esc>"] = { "<C-\\><C-n><CR>", desc = "Exit term mode" }
      maps.t["<C-h>"] = { "<Cmd>wincmd h<CR>", desc = "Move to left window" }
      maps.t["<C-j>"] = { "<Cmd>wincmd j<CR>", desc = "Move to down window" }
      maps.t["<NL>"] = false -- Disable conflicting <NL> mapping (equivalent to <C-j>)
      maps.t["<C-k>"] = { "<Cmd>wincmd k<CR>", desc = "Move to up window" }
      maps.t["<C-l>"] = { "<Cmd>wincmd l<CR>", desc = "Move to right window" }
      maps.t["<C-q>"] = { function() require("astrocore.buffer").close(0) end, desc = "Close terminal" }
      maps.n["<C-F7>"] = {
        function()
          if vim.fn.bufexists "term://*" == 1 then
            vim.cmd "TermNew"
          else
            vim.cmd "ToggleTerm"
          end
        end,
        desc = "Open or create terminal",
      }
      maps.t["<C-F7>"] = { "<Cmd>TermNew<CR>", desc = "Execute TermNew" }

      maps.n["<Leader>bd"] = {
        function() require("astrocore.buffer").close(0) end,
        desc = "Close Current Buffer",
      }

      maps.n.n = { utils.better_search "n", desc = "Next search" }
      maps.n.N = { utils.better_search "N", desc = "Previous search" }

      maps.v["<A-j>"] = { ":move '>+1<CR>gv-gv", desc = "Move line down", silent = true }
      maps.v["<A-k>"] = { ":move '<-2<CR>gv-gv", desc = "Move line up", silent = true }

      maps.i["<C-S>"] = { "<esc>:w<cr>a", desc = "Save file", silent = true }
      maps.x["<C-S>"] = { "<esc>:w<cr>a", desc = "Save file", silent = true }
      maps.n["<C-S>"] = { "<Cmd>w<cr>", desc = "Save file", silent = true }

      maps.n["n"] = { "nzz" }
      maps.n["N"] = { "Nzz" }
      maps.v["n"] = { "nzz" }
      maps.v["N"] = { "Nzz" }

      maps.n["H"] = { "^", desc = "Go to start without blank" }
      maps.n["L"] = { "$", desc = "Go to end without blank" }
      maps.v["H"] = { "^", desc = "Go to start without blank" }
      maps.v["L"] = { "$", desc = "Go to end without blank" }

      maps.v["<"] = { "<gv", desc = "Unindent line" }
      maps.v[">"] = { ">gv", desc = "Indent line" }

      -- 在visual mode 里粘贴不要复制
      maps.n["x"] = { '"_x', desc = "Cut without copy" }

      -- 分屏快捷键
      maps.n["<Leader>w"] = { "", desc = "󱂬 Window" }
      maps.n["<Leader>ww"] = { "<cmd><cr>", desc = "Save" }
      maps.n["<Leader>wc"] = { "<C-w>c", desc = "Close current screen" }
      maps.n["<Leader>wo"] = { "<C-w>o", desc = "Close other screen" }
      -- 多个窗口之间跳转
      maps.n["<Leader>we"] = { "<C-w>=", desc = "Make all window equal" }

      maps.n["<TAB>"] =
        { function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" }
      maps.n["<S-TAB>"] = {
        function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        desc = "Previous buffer",
      }
      -- maps.n["<Leader>bo"] = maps.n["<Leader>bc"]
      -- lsp restart
      maps.n["<Leader>lm"] = { "<Cmd>LspRestart<CR>", desc = "Lsp restart" }
      maps.n["<Leader>lg"] = { "<Cmd>LspLog<CR>", desc = "Show lsp log" }

      if vim.fn.executable "lazygit" == 1 then
        maps.n["<Leader>tl"] = {
          require("utils").toggle_lazy_git(),
          desc = "ToggleTerm lazygit",
        }
      end

      if vim.fn.executable "lazydocker" == 1 then
        maps.n["<Leader>td"] = {
          require("utils").toggle_lazy_docker(),
          desc = "ToggleTerm lazydocker",
        }
      end
    end
    opts.mappings = maps

    -- NeoScroll mappings
    local neoscroll = require "neoscroll"
    local keymap = {
      ["<C-u>"] = function() neoscroll.ctrl_u { duration = 100 } end,
      ["<C-d>"] = function() neoscroll.ctrl_d { duration = 100 } end,
      ["<C-b>"] = function() neoscroll.ctrl_b { duration = 200 } end,
      ["<C-f>"] = function() neoscroll.ctrl_f { duration = 200 } end,
      ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 }) end,
      ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 100 }) end,
      ["zt"] = function() neoscroll.zt { half_win_duration = 150 } end,
      ["zz"] = function() neoscroll.zz { half_win_duration = 150 } end,
      ["zb"] = function() neoscroll.zb { half_win_duration = 150 } end,
    }
    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end

    -- Some keymap set in VISUAL mode also affect SELECT mode
    -- So we need to delete them
    vim.schedule(function()
      vim.api.nvim_del_keymap("s", "n")
      vim.api.nvim_del_keymap("s", "N")
      vim.api.nvim_del_keymap("s", "H")
      vim.api.nvim_del_keymap("s", "L")
    end)
  end,
}
