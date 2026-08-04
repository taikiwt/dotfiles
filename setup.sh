#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

mkdir -p ~/.config ~/.local/bin

echo "Stowパッケージを展開中..."

for dir in */; do
  pkg="${dir%/}"

  # バックアップ用や非公開用のフォルダがあれば除外（無ければ不要）
  if [[ "$pkg" == "unused_configs" || "$pkg" == "backup_settings" ]]; then
    continue
  fi

  echo " -> Stow: $pkg"
  stow -t ~ "$pkg"
done

echo "すべてのシンボリックリンクの展開が完了しました！"
