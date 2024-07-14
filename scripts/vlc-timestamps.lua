-- "extension.lua"

function descriptor()
  return {
    title = "Timestamps to File",
    version = "1.0",
    author = "Ifor Waldo Williams",
    shortdesc = "Write current timestamp to file.",
    capabilities = {"input-listener", "meta-listener", "playing-listener"}
  }
end

function activate()
  create_dialog()
end

function deactivate()
end

function close()
  vlc.deactivate() -- deactivate extension on dialog box close:
end

function create_dialog()
  w = vlc.dialog("Create Timestamp")
  w2 = w:add_html('00:00:00', 1, 1, 1, 1, 1) -- text, col, row, col_span, row_span, width, height
  w3 = w:add_button("Punch In", click_Action, 2, 1, 1, 1, 1, 1)
end

function click_Action()
  current_timestamp = vlc.var.get(vlc.object.input(), "time") * 10^-6
  item = vlc.input.item()
  uri = item:uri()
  uri = string.gsub(uri, '^file:///', '')
  uri = string.gsub(uri, '%%20', ' ')
  filepath = uri .. ".cutfile"

  w2:set_text(current_timestamp)

  button_text = 'Punch In'
  if w3:get_text() == 'Punch In' then
    w3:set_text('Punch Out')
  else
    w3:set_text('Punch In')
  end

  strCmd = 'echo ' .. current_timestamp .. ' >> ' .. filepath
  os.execute(strCmd)
end
