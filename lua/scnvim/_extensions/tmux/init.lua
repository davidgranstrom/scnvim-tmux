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

local function is_open()
  if not tmux.pane_id then
    return false
  end
  local pane_ids = tmux_send({
    'list-panes',
    '-F',
    '#{pane_id}'
  })
  pane_ids = vim.split(pane_ids, '\n', {trimempty = true})
  local result = vim.tbl_filter(function(id)
    return id == tmux.pane_id
  end, pane_ids)
  return #result == 1
end

function tmux.create()
  tmux.path = vim.fn.tempname()
  tmux.post_buffer = io.open(tmux.path, 'wb')
end

function tmux.open()
  if is_open() then
    return tmux.pane_id
  end
  if not tmux.post_buffer then
    tmux.create()
  end
  tmux_send({
    'split-window',
    tmux.horizontal and '-v' or '-h',
    '-l',
    tmux.size,
    'tail',
    '-F',
    tmux.path,
  })
  tmux.pane_id = get_pane_id()
  tmux_send({ 'last-pane' })
  return tmux.pane_id
end

function tmux.close()
  if tmux.pane_id then
    tmux_send({
      'kill-pane',
      '-t',
      tmux.pane_id
    })
    tmux.pane_id = nil
  end
end

function tmux.toggle()
  if is_open() then
    tmux.close()
  else
    tmux.open()
  end
end

function tmux.destroy()
  tmux.close()
  if tmux.post_buffer then
    tmux.post_buffer:close()
  end
end

function tmux.post(line)
  if not tmux.post_buffer then
    return
  end
  tmux.post_buffer:write(line, '\n')
  tmux.post_buffer:flush()
end

-- Actions
sclang.on_init:replace(tmux.open)
sclang.on_exit:replace(tmux.destroy)
sclang.on_output:replace(tmux.post)

-- Overrides
postwin.open = tmux.open
postwin.close = tmux.close
postwin.toggle = tmux.toggle

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
