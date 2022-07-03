local sclang = require 'scnvim.sclang'
local postwin = require 'scnvim.postwin'
local tmux = {}

local function tmux_send(tbl)
  local cmd = {'tmux', unpack(tbl)}
  return vim.fn.system(cmd)
end

local function get_pane_id()
  local id = tmux_send({
    'display-message',
    '-p',
    '#{pane_id}',
  })
  return id:gsub('\n', '')
end

sclang.on_init:replace(function()
  local path = vim.fn.tempname()
  tmux.post_buffer = io.open(path, 'wb')
  tmux_send({
    'split-window',
    tmux.horizontal and '-v' or '-h',
    '-l',
    tmux.size,
    'tail',
    '-F',
    path,
  })
  tmux.pane_id = get_pane_id()
  tmux_send({ 'last-pane' })
end)

sclang.on_exit:replace(function()
  if tmux.post_buffer then
    tmux.post_buffer:close()
  end
  if tmux.pane_id then
    tmux_send({
      'kill-pane',
      '-t',
      tmux.pane_id
    })
  end
end)

sclang.on_output:replace(function(line)
  if not tmux.post_buffer then
    return
  end
  tmux.post_buffer:write(line, '\n')
  tmux.post_buffer:flush()
end)

-- overrides
postwin.open = function()
  tmux_send({
    'select-pane',
    '-t',
    tmux.pane_id
  })
end

return require'scnvim'.register_extension {
  setup = function(ext_config, user_config)
    tmux.horizontal = ext_config.horizontal == nil and true or ext_config.horizontal
    tmux.size = ext_config.size or '35%'
  end,

  health = function()
    local health = require 'health'
    local has_tmux = vim.fn.executable('tmux')
    local has_tail = vim.fn.executable('tail')
    if has_tmux == 1 then
      health.report_ok 'tmux executable found'
    else
      health.report_error 'could not find tmux executable'
    end
    if has_tail == 1 then
      health.report_ok 'tail executable found'
    else
      health.report_error 'could not find tail executable'
    end
  end,
}
