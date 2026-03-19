return {
  -- Configure LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- HTML support
        html = {},
        -- CSS support
        cssls = {},
        -- Tailwind support (Crucial for modern web dev)
        tailwindcss = {},
        -- Emmet (This gives you the VSCode "div.container" expansions)
        emmet_ls = {
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
        },
      },
    },
  },
  -- Add treesitter parsers for better highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "html", "css", "javascript", "typescript", "tsx" })
      end
    end,
  },
  -- Auto-tagging (closing <div> automatically)
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
}
