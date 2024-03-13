local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup({
  settings = {
       save_on_toggle = true
  }
})

-- REQUIRED

vim.keymap.set("n", "<C-a>", function() harpoon:list():append() end)
vim.keymap.set("n", "<C-e>",
  function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-;>", function() harpoon:list():select(5) end)

vim.api.nvim_set_keymap('n', '<leader>m', ':Neotree toggle<CR>',
  {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>cp', ':Copilot panel<CR>',
  {noremap = true, silent = true})
-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- Explorer
-- vim.api.nvim_set_keymap('n', '<C-o>', ':Explore<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })


vim.opt.relativenumber = true
vim.opt.colorcolumn = "80,120"
