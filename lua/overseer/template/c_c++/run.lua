local overseer = require "overseer"

return {
  -- Required fields
  name = "run",
  builder = function()
    local args = { "project.mts", "run" }
    --- @type overseer.TaskDefinition
    return {
      -- cmd is the only required field
      cmd = { "tsx" },
      -- additional arguments for the cmd
      args = args,
      -- the name of the task (defaults to the cmd of the task)
      name = "run",
      -- the list of components or component aliases to add to the task
      components = {
        "default",
      },
    }
  end,
  -- Optional fields
  desc = "Run selected target",
  -- Tags can be used in overseer.run_template()
  tags = { overseer.TAG.RUN },
  params = {
    -- See :help overseer-params
  },
  -- Determines sort order when choosing tasks. Lower comes first.
  priority = 50,
  -- Add requirements for this template. If they are not met, the template will not be visible.
  -- All fields are optional.
  condition = {
    -- Arbitrary logic for determining if task is available
    -- callback = function() return .is_cmake_project() end,
  },
}
