#!/usr/bin/env bash
set -euo pipefail

# First boot recommendation:
# sudo apt update && sudo apt full-upgrade -y
# sudo fwupdmgr refresh && sudo fwupdmgr get-updates && sudo fwupdmgr update
# SSH setup before cloning:
# 1. ssh-keygen -t ed25519 -C "your_email@example.com"
# 2. eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519
# 3. Copy ~/.ssh/id_ed25519.pub to GitHub (Settings → SSH and GPG keys)
# 4. ssh -T git@github.com (verify access)

APT_PACKAGES=(
    build-essential
    clang-format
    curl
    fish
    fzf
    git
    neovim
    python3
    python3-pip
    rsync
    ripgrep
    tmux
    unzip
)

# apt-based package install
if command -v apt >/dev/null 2>&1; then
    echo "🔍 Checking essential apt packages..."
    sudo apt update
    for pkg in "${APT_PACKAGES[@]}"; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            echo "⬇️  Installing $pkg"
            sudo apt install -y "$pkg"
        else
            echo "✅ $pkg already installed"
        fi
    done
else
    echo "⚠️ apt not found; skipping package install step" >&2
fi

# latest neovim via PPA
if command -v apt >/dev/null 2>&1; then
    echo "⬇️  Ensuring latest Neovim from official PPA"
    if ! ls /etc/apt/sources.list.d 2>/dev/null | grep -q 'neovim-ppa-ubuntu-stable'; then
        sudo add-apt-repository -y ppa:neovim-ppa/stable
    else
        echo "✅ Neovim PPA already configured"
    fi
    sudo apt update
    sudo apt install -y neovim
else
    echo "⚠️ apt not found; skipping Neovim PPA install" >&2
fi

# npm-based installs
if command -v npm >/dev/null 2>&1; then
    echo "⬇️  Installing @google/gemini-cli via npm"
    sudo npm install -g @google/gemini-cli

    if ! command -v codex >/dev/null 2>&1; then
        echo "⬇️  Installing @openai/codex CLI"
        sudo npm install -g @openai/codex
    else
        echo "✅ Codex CLI already installed ($(codex --version))"
    fi
else
    echo "⚠️ npm not found; skipping @google/gemini-cli install" >&2
fi

# google chrome install
if command -v apt >/dev/null 2>&1; then
    if ! command -v google-chrome >/dev/null 2>&1; then
        echo "⬇️  Installing Google Chrome"
        TEMP_DEB="$(mktemp --suffix=.deb)"
        curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o "$TEMP_DEB"
        sudo apt install -y "$TEMP_DEB" || sudo dpkg -i "$TEMP_DEB"
        rm -f "$TEMP_DEB"
    else
        echo "✅ Google Chrome already installed"
    fi
else
    echo "⚠️ apt not found; skipping Google Chrome install" >&2
fi

# Fira Code Nerd Font install
if command -v fc-cache >/dev/null 2>&1 && command -v fc-list >/dev/null 2>&1; then
    if ! fc-list | grep -qi "FiraCode Nerd Font"; then
        echo "⬇️  Installing Fira Code Nerd Font"
        FONT_TMP_DIR="$(mktemp -d)"
        FONT_ZIP="$FONT_TMP_DIR/FiraCode.zip"
        curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -o "$FONT_ZIP"
        unzip -qq -o "$FONT_ZIP" -d "$FONT_TMP_DIR"
        mkdir -p "${HOME}/.local/share/fonts"
        cp "$FONT_TMP_DIR"/*.ttf "${HOME}/.local/share/fonts/"
        fc-cache -f
        rm -rf "$FONT_TMP_DIR"
    else
        echo "✅ Fira Code Nerd Font already present"
    fi
else
    echo "⚠️ fontconfig not available; skipping Fira Code Nerd Font install" >&2
fi

# fisher + theme setup
if command -v fish >/dev/null 2>&1; then
    if ! fish -c 'command -q fisher' >/dev/null 2>&1; then
        echo "🐟 Installing fisher package manager"
        fish -c 'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher'
    else
        echo "✅ fisher already installed"
    fi

    echo "🎨 Ensuring gruvbox fish theme"
    fish -c 'fisher install Jomik/fish-gruvbox >/dev/null; and theme_gruvbox dark soft'
else
    echo "⚠️ fish shell not found; skipping fisher/theme setup" >&2
fi

# nvim config sync
NVIM_WORKSPACE="${HOME}/workspace"
NVIM_REPO="git@github.com:Rafeeq-Muhammad/kickstart.nvim.git"
NVIM_BRANCH="rafeeq-main"
NVIM_SOURCE="${NVIM_WORKSPACE}/kickstart.nvim"
NVIM_TARGET="${HOME}/.config/nvim"

echo "📦 Syncing Neovim config repository..."
mkdir -p "$NVIM_WORKSPACE"
if [ -d "$NVIM_SOURCE/.git" ]; then
    git -C "$NVIM_SOURCE" fetch origin
    git -C "$NVIM_SOURCE" checkout "$NVIM_BRANCH"
    git -C "$NVIM_SOURCE" pull origin "$NVIM_BRANCH"
else
    git clone --branch "$NVIM_BRANCH" "$NVIM_REPO" "$NVIM_SOURCE"
fi

if [ -L "$NVIM_TARGET" ] || [ -d "$NVIM_TARGET" ] || [ -f "$NVIM_TARGET" ]; then
    if [ "$(readlink "$NVIM_TARGET" 2>/dev/null)" = "$NVIM_SOURCE" ]; then
        echo "✅ Neovim already symlinked to workspace"
    else
        echo "🔁 Updating existing Neovim config at $NVIM_TARGET"
        rm -rf "$NVIM_TARGET"
        ln -s "$NVIM_SOURCE" "$NVIM_TARGET"
    fi
else
    echo "🔗 Linking Neovim config to $NVIM_SOURCE"
    ln -s "$NVIM_SOURCE" "$NVIM_TARGET"
fi

# config repo sync
CONFIG_REPO="git@github.com:Rafeeq-Muhammad/config-files.git"
CONFIG_TARGET="${HOME}/.config"
CONFIG_TEMP="$(mktemp -d)"
trap 'rm -rf "$CONFIG_TEMP"' EXIT

echo "📦 Cloning config repository..."
git clone "$CONFIG_REPO" "$CONFIG_TEMP/repo"

echo "📁 Syncing config files into ${CONFIG_TARGET}"
mkdir -p "$CONFIG_TARGET"
rsync -a "$CONFIG_TEMP/repo/" "$CONFIG_TARGET/"

if [ -d "${CONFIG_TARGET}/.git" ]; then
    echo "🔧 Updating git remote for ${CONFIG_TARGET}"
    git -C "$CONFIG_TARGET" remote set-url origin "$CONFIG_REPO" 2>/dev/null || git -C "$CONFIG_TARGET" remote add origin "$CONFIG_REPO"
    git -C "$CONFIG_TARGET" remote -v
else
    echo "ℹ️ Git metadata not found in ${CONFIG_TARGET}; skipping remote configuration"
fi
