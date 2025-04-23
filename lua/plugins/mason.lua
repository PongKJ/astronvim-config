-- HACK: Bug in main brach, see https://github.com/williamboman/mason.nvim/pull/1882,
-- Currently usring the v2.x branch which fixes the issue
-- TODO: Remove this after merge to the main branch
return {
  {
    "williamboman/mason.nvim",
    branch = "v2.x",
  },
}
