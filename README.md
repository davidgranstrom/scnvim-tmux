# scnvim tmux

Redirect post window ouput to a tmux pane.

The `sclang` process still runs in nvim, so closing the split will not close
`sclang`. This extension emulates the default post window API, so no need to
define any special keymaps.

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

Works like the normal `scnvim` post window, only a tmux split is used instead.

## Configuration

Add a `tmux` entry to the `extensions` table in the `scnvim.setup` function.

The example below shows the default values.

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

## License

```
scnvim-tmux - Redirect post window ouput to a tmux pane.
Copyright © 2022 David Granström

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
