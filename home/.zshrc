# =============================================================================
# 1. OS判定・PATH・環境変数の設定
# =============================================================================

# --- Homebrew の環境セットアップ（Mac: Apple Silicon / Intel、Linux: Linuxbrew 両対応） ---
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- 基本環境変数 ---
export EDITOR='nvim'
export GHQ_ROOT="$HOME/dev"
export ESLINT_USE_FLAT_CONFIG=true

# --- OS別 PATH・ツール個別設定 ---
if [[ "$OSTYPE" == darwin* ]]; then
  # Mac固有: PostgreSQL 15 (Brew経由)
  [ -d "/opt/homebrew/opt/postgresql@15/bin" ] && export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
  # Mac固有: Antigravity CLI
  [ -d "$HOME/.antigravity/antigravity/bin" ] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
elif [[ "$OSTYPE" == linux* ]]; then
  # Linux固有: ユーザーローカルバイナリ（Zedなど）
  [ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
fi

# --- 自作スクリプトの PATH 追加 ---
export PATH="$HOME/.local/bin:$PATH" # `~/dotfiles/scripts` からリンク
export PATH="$HOME/dev/github.com/taikiwt/myscripts:$PATH"


# =============================================================================
# 2. Mise（バージョン・CLIツール管理）の初期化
# =============================================================================
# Node.js や CLI ツールなどを Mise で制御するため、他ツールより前に有効化
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi


# =============================================================================
# 3. Zinit（Zshプラグインマネージャー）のセットアップ
# =============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"


# =============================================================================
# 4. Zsh 補完機能 (compinit) の初期化
# =============================================================================

# zsh-completions は compinit の実行前に読み込む（blockfで補完の自動登録を調整）
zinit ice blockf
zinit light zsh-users/zsh-completions

# 補完キャッシュの再生成を24時間に1回に制限
# ※ 設定を大きく書き換えた場合は `rm -f ~/.zcompdump*` を手動で実行しておく
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Zinitで補完プラグインを適用するために実行
zinit cdreplay -q


# =============================================================================
# 5. Zsh プラグインの読み込み
# =============================================================================

# --- 補完強化プラグイン（compinit の直後に同期読み込み） ---
# タブ補完を fzf インターフェースで快適にする
zinit light Aloxaf/fzf-tab

# --- Oh My Zsh スニペット ---
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found
# zinit snippet OMZP::sudo


# --- オートサジェスチョン（入力予測・遅延読み込み） ---
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

# --- シンタックスハイライト（【重要】必ず一番最後に読み込む） ---
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting


# =============================================================================
# 6. コンプリーション（補完）のスタイル設定
# =============================================================================
# 大文字・小文字を区別しない補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# 補完候補のカラー表示
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# デフォルトの補完メニューを無効化（fzf-tab に統合するため）
zstyle ':completion:*' menu no

# fzf-tab で cd や zoxide 補完時にディレクトリ内容をプレビュー
zstyle 'fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle 'fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# =============================================================================
# 7. Shell Integrations & CLI ツール連携
# =============================================================================
# command -v で存在確認を入れることで未インストール環境でのエラーを防ぎます

# Fzf (コマンドライン曖昧検索)
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# Zoxide (スマート cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# Yazi (ターミナルファイルマネージャー: cd 連動ラッパー関数)
if command -v yazi >/dev/null 2>&1; then
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi


# =============================================================================
# 8. キーバインド & 履歴 (History) 設定
# =============================================================================

# --- キーバインド ---
# Ctrl+f でオートサジェスチョン（入力予測）を確定
bindkey '^f' autosuggest-accept
# Ctrl+p で履歴の逆検索
bindkey '^p' history-search-backward

# --- 履歴設定 ---
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE

setopt appendhistory         # 履歴をファイルに追加
setopt sharehistory          # 複数端末間で履歴をリアルタイム共有
setopt hist_ignore_space     # 先頭にスペースを入れたコマンドは履歴に残さない
setopt hist_save_no_dups     # 古い重複コマンドを履歴ファイルから削除
setopt hist_find_no_dups     # 検索時に重複をスキップ
setopt hist_ignore_dups      # 直前と同じコマンドは履歴に追加しない


# =============================================================================
# 9. エイリアス & 関数定義
# =============================================================================

# --- 基本エイリアス ---
alias c='clear'

# eza (ls のモダン代替ツール: mise等で導入時にコメントアウト解除)
# alias ls='eza --icons --group-directories-first'
# alias la='eza -a --icons --group-directories-first'
# alias ll='eza -al --icons --group-directories-first'
# alias l='eza -al --icons --group-directories-first'

# --- Neovim / Fzf エイリアス ---
alias v='nvim'
alias vz='nvim ~/.zshrc'
alias vf='nvim $(fzf)'
alias vfp='fzf --preview "bat --style=numbers --color=always {}" | xargs -n 1 nvim'

# --- Diff 関数 (標準コマンド df の衝突・上書きを避けるため fdiff に変更) ---
fdiff() {
  nvim -d "$(fzf --prompt="File-1: ")" "$(fzf --prompt="File-2: ")"
}

# --- ghq リポジトリ移動 ---
cdr() {
  local repodir=$(ghq list | fzf -1 +m) && cd $(ghq root)/$repodir
}

# --- sitecue Custom Git Aliases ---
# 堅牢なAdd（必ず状況を確認する）
alias gaa='git add --all && git status'
# 直感的なCommit（wipをデフォルトに組み込む）
alias gc='git commit -m'
alias gcw='git commit -m "wip: "'
alias gcae='git commit --allow-empty -m "chore: empty commit for trigger"'
# 既存コミットの修正（!を付けて「上書き」を意識）
alias gca!='git commit --amend'
alias gcan!='git commit --amend --no-edit'
# 歴史の整理（引数に数字を入れるだけ：例 grbi 3）
alias grbi='git rebase -i HEAD~'
# 確認コマンド
alias gl='git log --oneline -n 10' # 直近10件だけサクッと見る
alias gd='git diff --stat' # どのファイルが変わったかだけ把握する
alias gdf='git diff > change.diff' # 変更部分をファイル出力


# =============================================================================
# 10. ローカル固有設定 & 外部ファイルの読み込み
# =============================================================================

# AI関連 API Key の読み込み
if [ -f "$HOME/.api_keys.sh" ]; then
  source "$HOME/.api_keys.sh"
fi

# マシン固有の設定があれば読み込み (gitignore対象にしておくと便利)
if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi


# =============================================================================
# 11. Starship Prompt (プロンプト表示)
# =============================================================================
# ※ すべての設定・補完が完了した最末尾で評価するのが推奨されている
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

