return {
  "jakewvincent/mkdnflow.nvim",
  ft = { "markdown" }, -- Markdownファイルを開いたときだけ遅延読み込み
  config = function()
    require("mkdnflow").setup({
      -- 必要なモジュールだけを有効化
      modules = {
        lists = true,
        tables = true,
        links = false, -- Obsidianと併用するためリンク機能はオフ
      },
      mappings = {
        -- インサートモードのリスト自動継続（これはリーダーキー不要でEnterのみ）
        MkdnEnter = { { "i", "n", "v" }, "<CR>" },

        -- リーダーキーを使用したマッピング
        -- <leader>m を基点にすると which-key のメニューも綺麗にまとまります
        MkdnToggleToDo = { { "n", "v" }, "<leader>mc" }, -- [M]arkdown [C]heckbox のトグル
        MkdnUpdateNumbering = { "n", "<leader>mn" }, -- [M]arkdown [N]umber の再採番

        -- キーバインドの競合を防ぐため、使わないデフォルト設定は無効化
        MkdnNextLink = false,
        MkdnPrevLink = false,
        MkdnFollowLink = false,
        MkdnDestroyLink = false,
        MkdnCreateLink = false,
      },
    })
  end,
}
