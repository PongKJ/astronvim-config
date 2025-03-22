local utils = require "utils"

return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    if not opts.mappings then opts.mappings = require("astrocore").empty_map_table() end
    -- TODO: Move workspace_type to other place
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
      -- Overseer + .vscode/tasks.json to manage tasks
      maps.n["<Leader>o"] = { "", desc = "Overseer" }
      -- TODO: Add other workspace types
      if workspace_type == "c_cpp" then
        maps.n["<Leader>ns"] = { "<Cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch between source and header" }
        maps.n["<Leader>c"] = { "", desc = "C_Cpp tasks" }
        maps.n["<Leader>cr"] = {
          "<Cmd>OverseerRun RUN<CR>",
          desc = "Run target",
        }
        maps.n["<Leader>cb"] = {
          "<Cmd>OverseerRun Build<CR>",
          desc = "Build target",
        }
        maps.n["<Leader>ct"] = {
          "<Cmd>OverseerRun Test<CR>",
          desc = "Running target",
        }
        maps.n["<Leader>cc"] = {
          "<Cmd>OverseerRun CLEAN<CR>",
          desc = "clean",
        }
        maps.n["<Leader>csr"] = {
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
        maps.n["<Leader>cc"] = {
          "<Cmd>TermExec cmd='tsx project.mts config'<CR>",
          desc = "Cmake config",
        }
        maps.n["<Leader>cb"] = { "<Cmd>TermExec cmd='tsx project.mts build'<CR>", desc = "Build target" }
        maps.n["<Leader>csb"] = {
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
        maps.n["<Leader>ct"] = { "<Cmd>TermExec cmd='tsx project.mts test'<CR>", desc = "Test" }
        maps.n["<Leader>cd"] = { "<Cmd>akeDebug<CR>", desc = "Debug" }
        maps.n["<F5>"] = { "<cmd>CMakeDebug<CR>", desc = "Start Debug" }
      end
      if workspace_type == "rust" then
        maps.n["<Leader>c"] = { "", desc = "Cargo tasks" }
        maps.n["<Leader>cs"] = { "", desc = "Select Target" }
        maps.n["<F5>"] = { "<Cmd>RustLsp! debuggables<CR>", desc = "Start Debug" }
        maps.n["<Leader>cd"] = { "<CMd>RustLsp! debuggables<CR>", desc = "Debug" }
        maps.n["<Leader>csd"] = { "<Cmd>RustLsp debuggables<CR>", desc = "Select Debug Target" }
        maps.n["<Leader>cb"] = {
          function() overseer.run_template { tags = { overseer.TAG.BUILD } } end,
          desc = "Build",
        }
        maps.n["<Leader>cr"] = { "<Cmd>RustLsp! runnables<CR>", desc = "Run" }
        maps.n["<Leader>csr"] = { "<Cmd>RustLsp runnables<CR>", desc = "Select Run Target" }
      end

      -- term mode mappings
      maps.t["<esc>"] = { "<C-\\><C-n><CR>", desc = "Exit term mode" }

      -- <Leader>n
      maps.n["<Leader>n"] = { "", desc = "Highlights and copilot" }
      -- close search highlight
      maps.n["<Leader>nh"] = { ":nohlsearch<CR>", desc = "Close search highlight", silent = true }
      maps.n["<Leader>nc"] = { "<Cmd>CopilotChatToggle<CR>", desc = "Copilot Chat Toggle" }

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

      if vim.fn.executable "btm" == 1 then
        maps.n["<Leader>tt"] = {
          require("utils").toggle_btm(),
          desc = "ToggleTerm btm",
        }
      end

      if vim.fn.executable "unimatrix" == 1 then
        maps.n["<Leader>tm"] = {
          require("utils").toggle_unicmatrix(),
          desc = "ToggleTerm unimatrix",
        }
      end

      if vim.fn.executable "tte" == 1 then
        maps.n["<Leader>te"] = {
          require("utils").toggle_tte(),
          desc = "ToggleTerm tte",
        }
      end
    end
    opts.mappings = maps
  end,
}
