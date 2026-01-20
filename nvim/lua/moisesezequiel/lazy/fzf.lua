return {
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    config = function()
      -- Buscar archivos
      vim.keymap.set("n", "<C-p>", ":GFiles<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ff", ":Files<CR>", { noremap = true, silent = true })

      -- Grep interactivo
      vim.keymap.set("n", "<leader>ps", function()
        vim.cmd("grep! " .. vim.fn.input("grep > "))
        vim.cmd("copen")
      end, { noremap = true, silent = true })

      -- Buscar buffers
      vim.keymap.set("n", "<leader>fb", ":Buffers<CR>", { silent = true })

      -- Buscar comandos
      vim.keymap.set("n", "<leader>fc", ":Commands<CR>", { silent = true })
    end,
  },
}
