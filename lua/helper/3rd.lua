local M = {}

function M.toggle_lazy_docker()
  return function()
    require("astrocore").toggle_term_cmd {
      cmd = "lazydocker",
      direction = "float",
      hidden = true,
      on_open = function() M.remove_keymap("t", "<Esc>") end,
      on_close = function() vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { silent = true, noremap = true }) end,
      on_exit = function()
        -- For Stop Term Mode
        vim.cmd [[stopinsert]]
      end,
    }
  end
end

function M.toggle_btm()
  return function()
    require("astrocore").toggle_term_cmd {
      cmd = "btm",
      direction = "float",
      hidden = true,
      on_open = function() M.remove_keymap("t", "<Esc>") end,
      on_close = function() vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { silent = true, noremap = true }) end,
      on_exit = function()
        -- For Stop Term Mode
        vim.cmd [[stopinsert]]
      end,
    }
  end
end

function M.toggle_lazy_git()
  return function()
    local worktree = require("astrocore").file_worktree()
    local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir) or ""
    require("astrocore").toggle_term_cmd {
      cmd = "lazygit " .. flags,
      direction = "float",
      hidden = true,
      on_open = function() M.remove_keymap("t", "<Esc>") end,
      on_close = function() vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { silent = true, noremap = true }) end,
      on_exit = function()
        -- For Stop Term Mode
        vim.cmd [[stopinsert]]
      end,
    }
  end
end

function M.toggle_unicmatrix()
  return function()
    require("astrocore").toggle_term_cmd {
      cmd = "unimatrix -s 96 -o -b",
      hidden = false,
      direction = "float",
      float_opts = {
        -- Enable full screen
        width = vim.o.columns,
        height = vim.o.lines,
        border = "none",
      },
    }
  end
end

function M.tte(selection, open_callback, close_callback, flag)
  local current_path = vim.fn.expand "%:p" -- get current file path
  local cmd = "tte --input-file " .. current_path .. " --xterm-colors " .. selection
  require("astrocore").toggle_term_cmd {
    cmd = cmd,
    hidden = false,
    direction = "float",
    close_on_exit = false,
    float_opts = {
      width = vim.o.columns,
      height = vim.o.lines,
      border = "none",
    },
    on_open = function()
      if open_callback and type(open_callback) == "function" then open_callback() end
    end,
    on_close = function(t)
      if flag then t:send "\x03" end
    end,
    on_exit = function(t, _, _, _)
      if close_callback and type(close_callback) == "function" then close_callback() end
      if vim.api.nvim_buf_is_loaded(t.bufnr) then vim.api.nvim_buf_delete(t.bufnr, { force = true }) end
    end,
  }
end

function M.toggle_tte()
  if require("astrocore").is_available "telescope.nvim" then
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values

    return function()
      pickers
        .new({}, {
          prompt_title = "Select TTE Effect",
          finder = finders.new_table {
            results = M.get_all_cmds(),
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry,
                ordinal = entry,
              }
            end,
          },
          sorter = conf.generic_sorter {},
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              M.tte(selection.value, nil, nil, true)
            end)
            return true
          end,
        })
        :find()
    end
  end
end

return M
