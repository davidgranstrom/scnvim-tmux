# scnvim tmux

Redirect post window ouput to a tmux pane.

## Installation

* Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use { 'davidgranstrom/scnvim-tmux' }
```

* Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'davidgranstrom/scnvim-tmux'
```

Load the extension **after** the call to `scnvim.setup`.

```lua
scnvim.setup{...}

scnvim.load_extension 'tmux'
```

## Usage

A new tmux split will be opended for the post window output after calling `:SCNvimStart`.

## Configuration

Add a `tmux` entry to the `extensions` table in the `scnvim.setup` function.

In the example below are the default values.

```lua
scnvim.setup {
  extensions = {
    tmux = {
      horizontal = true,
      size = '35%',
    },
  },
}
```
