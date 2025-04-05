# AstroNvimV5 Config

<!--toc:start-->

- [AstroNvimV5 Config](#astronvimv5-config)
  - [Support neovim version](#support-neovim-version)
  - [Features](#features)
  - [workflow screenshot](#workflow-screenshot)
  - [other components config](#other-components-config)
  - [🛠️ Installation](#🛠️-installation)
    - [The system should supports commands](#the-system-should-supports-commands)
    - [Recommend install](#recommend-install)
    - [Note: for rust development](#note-for-rust-development)
    - [Make a backup of your current nvim and shared folder](#make-a-backup-of-your-current-nvim-and-shared-folder)
    - [Create a new user repository from this template](#create-a-new-user-repository-from-this-template)
    - [Clone the repository](#clone-the-repository)
    - [Start Neovim](#start-neovim)
  - [Tips](#tips)
    - [NVcheatsheet](#nvcheatsheet)
    - [Use Lazygit](#use-lazygit)
    - [Install unimatrix](#install-unimatrix)
    - [Install TTE](#install-tte)
    - [Install Bottom](#install-bottom)
    - [Neovim requirements](#neovim-requirements)
    - [Markdown Image Paste](#markdown-image-paste)
    - [Input Auto Switch](#input-auto-switch)
    - [Support for neovide](#support-for-neovide)
    - [Support Lazydocker](#support-lazydocker)
  - [General Mappings](#general-mappings)
    - [`KK`](#kk)
  - [Project workspace setup](#project-workspace-setup)
  <!--toc:end-->

**NOTE:** This is the latest v4 configuration.

In the course of my daily tasks, I have optimized my workflow by integrating several powerful tools. My terminal of choice is `WezTerm`, which offers a blend of performance and features that cater to my needs. Alongside this, I employ `tmux` to efficiently manage multiple terminal sessions within a single window.

Additionally, I utilize `yazi` as my terminal-based file manager, which seamlessly fits into my terminal-centric workflow. It is also worth noting that my configuration is compatible with `neovide`, eliminating the necessity for additional setups.

This streamlined combination of tools significantly enhances my productivity and provides a robust terminal experience.

## Support neovim version

neovim >= `0.11`, recommend `0.11.0`

## Features

now,this config supports development in `TypeScript`,`Python`,`Go`,`Rust` and `markdown`.

- **_`Typescript`_**: `vtsls` work with `volar2`
- **_`Python`_**: `basedpyright`
- **_`Go`_**: `gopher.nvim` _-- support go zero framework_
- **_`Markdown`_**: `iamcco/markdown-preview.nvim`,
- **_`Rust`_**: `mrcjkb/rustaceanvim`
- **_`C/C++`_**:`clangd+clang-format+clazy-standalone+neocmake+cmake-lint+cmake-format`

## workflow screenshot

`wezterm` + `tmux` + `astronvim`

![homepage](assets/imgs/homepage.png)

`wezterm`

![wezterm](assets/imgs/wezterm.png)

`tmux`

![tmux](assets/imgs/tmux.png)

`yazi`

![yazi](assets/imgs/yazi.png)

## other components config

`wezterm`: [https://github.com/chaozwn/wezterm]('https://github.com/chaozwn/wezterm')

`tmux`: [https://github.com/chaozwn/tmux]("https://github.com/chaozwn/tmux")

`yazi`: [https://github.com/chaozwn/yazi]("https://github.com/chaozwn/yazi")

## 🛠️ Installation

### The system should supports commands

`npm`,`rustc`,`go`

### Recommend install

rust toolchain:
`yay -S rustup`
`rustup default stable`

go toolchain:
`yay -S go`

fzf:
`yay -S fzf`

fd:
`yay -S fd`

luarocks:
`yay -S luarocks`

magick:
`sudo luarocks --lua-version 5.1 install magick`

clazy-standalone:
`yay -S clazy`

lazygit:
`yay -S lazygit`

ripgrep:
`yay -S ripgrep`

tree-sitter-cli:
`npm install -g tree-sitter-cli`

gdu:
`yay -S gdu`

bottom:
`yay -S bottom`

protobuf:
`yay -S protobuf`

mercurial:
`yay -S mercurial`

xxd:
`yay -S xxd`

trash-cli:
`sudo pacman -S trash-cli`

```
pip install notebook nbclassic jupyter-console
pip install git+https://github.com/will8211/unimatrix.git
npm install -g neovim
pip install pynvim
pip install terminaltexteffects
```

> brew tap daipeihust/tap
> im-select:for windows or Darwin
> Use fcitx framework on linux

neovide:
`yay -S neovide`

lazydocker:
`yay -S lazydocker-bin`

### Note: for rust development

> [!NOTE]
> rustup and mason's installation of rust-analzyer are different and may cause some [bugs](https://github.com/rust-lang/rust-analyzer/issues/17289), manual installation is recommended.

```
rustup component add rust-analyzer
```

### Make a backup of your current nvim and shared folder

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### Create a new user repository from this template

Press the "Use this template" button above to create a new repository to store your user configuration.

You can also just clone this repository directly if you do not want to track your user configuration in GitHub.

### Clone the repository

```bash
git clone https://github.com/CWndpkj/nvimConfigs.git ~/.config/nvim
```

### Start Neovim

```bash
nvim
```

## Tips

### NVcheatsheet

`<F2>`

![nvcheatsheet](assets/imgs/nvcheatsheet.png)

### Use Lazygit

`<leader>tl`

![lazygit](assets/imgs/lazygit.png)

### Install unimatrix

`<Leader>tm`

```shell
pip install git+https://github.com/will8211/unimatrix.git
```

![unimatrix](assets/imgs/unimatrix.png)

### Install TTE

`<Leader>te`

```shell
pip install terminaltexteffects
```

https://github.com/user-attachments/assets/ff8aa481-932d-431c-b1a1-ea7cc6e63920

### Install Bottom

`<Leader>tt`

```shell
brew install bottom
```

![bottom](assets/imgs/bottom.png)

### Neovim requirements

```
npm install -g neovim
pip install pynvim
```

### Markdown Image Paste

```sh
pip install pillow
```

### Input Auto Switch

```sh
brew tap daipeihust/tap
brew install im-select
im-select
```

run `im-select` & copy result to `im-select.lua`

```lua
return {
  "chaozwn/im-select.nvim",
  lazy = false,
  opts = {
    default_main_select = "com.sogou.inputmethod.sogou.pinyin", -- update your input method
    set_previous_events = { "InsertEnter", "FocusLost" },
  },
}
```

### Support for neovide

```sh
brew install neovide
neovide .
```

### Support Lazydocker

tigger command: `<leader>td`

```sh
brew install lazydocker
```

## General Mappings

| Action                      | Mappings              | Mode |
| --------------------------- | --------------------- | ---- |
| Leader key                  | <kbd>Space</kbd>      | n    |
| Resize up                   | <kbd>Ctrl+Up</kbd>    | n    |
| Resize Down                 | <kbd>Ctrl+Down</kbd>  | n    |
| Resize Left                 | <kbd>Ctrl+Left</kbd>  | n    |
| Resize Right                | <kbd>Ctrl+Right</kbd> | n    |
| Up Window                   | <kbd>Ctrl+k</kbd>     | n    |
| Down Window                 | <kbd>Ctrl+j</kbd>     | n    |
| Left Window                 | <kbd>Ctrl+h</kbd>     | n    |
| Right Window                | <kbd>Ctrl+l</kbd>     | n    |
| Force Write                 | <kbd>Ctrl+s</kbd>     | n    |
| Force Quit                  | <kbd>Ctrl+q</kbd>     | n    |
| New File                    | <kbd>Leader+n</kbd>   | n    |
| Close Buffer                | <kbd>Leader+b+d</kbd> | n    |
| Next Tab (real vim tab)     | <kbd>Tab</kbd>        | n    |
| Previous Tab (real vim tab) | <kbd>Shift+Tab</kbd>  | n    |
| Comment                     | <kbd>Control+/</kbd>  | n    |
| Horizontal Split            | <kbd>/</kbd>          | n    |
| Vertical Split              | <kbd>\|</kbd>         | n    |
| Open task menu              | <kbd>Leader+c</kbd>   | n    |

Copilot Mappings

| Action                   | Mappings              | Mode |
| ------------------------ | --------------------- | ---- |
| Open chat panel          | <kbd>Leader+n+c</kbd> | n    |
| Accept inline suggestion | <kbd>Ctrl+.</kbd>     | n    |

### `KK`

_vim.lsp.buf.hover()_ `KK` jump into signature help float window

> [!INFO]
> Displays hover information about the symbol under the cursor in a floating window. Calling the function twice will jump into the floating window.

## Project workspace setup

Use`<Leader>c` to open project task menu,and it'll determine the type of current workspace by typical files like node_modules/ for frontend,CMakeLists.txt for c/cpp Cargo.toml for Rust.
For cmake base c/cpp project,we use 'cmake-tools' to run cmake tasks.
For other type of project,we use 'overseer' to run tasks,including c/cpp project base on makefile,Rust project ,Python project,Frontend project,etc
