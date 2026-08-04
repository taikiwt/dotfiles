return {
    "nvim-treesitter/nvim-treesitter",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    build = ":TSUpdate",
    -- main をあえて指定しない、もしくはプラグイン名そのものを指定することで
    -- Lazy.nvim が内部の新しいエンドポイントを正しく解釈します
    opts = {
        ensure_installed = {
            "json",
            "javascript",
            "typescript",
            "tsx",
            "yaml",
            "toml",
            "kdl",
            "html",
            "css",
            "scss",
            "prisma",
            "markdown",
            "markdown_inline",
            "svelte",
            "graphql",
            "bash",
            "lua",
            "vim",
            "dockerfile",
            "gitignore",
            "query",
            "vimdoc",
            "python",
            "php",
            "pug",
            "astro",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<leader>v",
                node_incremental = "<leader>v",
                scope_incremental = false,
                node_decremental = "<bs>",
            },
        },
    },
}
