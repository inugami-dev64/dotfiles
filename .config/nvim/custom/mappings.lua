local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd>DapToggleBreakpoint <CR>",
      "Toggle breakpoint on current line"
    },
    ["<leader>dc"] = {
      function ()
        require('dap').clear_breakpoints()
      end,
      "Clear all breakpoints"
    }
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function ()
        require('dap-python').test_method()
      end,
      "Start Python debugging session"
    }
  }
}

M.custom = {
  n = {
    ["<C-l>"] = {"5zl", "Move buffer right by 5 characters"},
    ["<C-h>"] = {"5zh", "Move buffer left by 5 characters"},
    ["<C-j>"] = {"2<C-e>", "Move buffer down by 2 lines"},
    ["<C-k>"] = {"2<C-y>", "Move buffer up by 2 lines"},
    ["<leader>o"] = {
      function ()
        vim.diagnostic.open_float()
      end,
      "Open diagnostic message as floating window"
    }
  }
}
return M
