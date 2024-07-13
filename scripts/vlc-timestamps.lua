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
  -- deactivate extension on dialog box close:
  vlc.deactivate()
end

function create_dialog()
  w = vlc.dialog("Create Timestamp")
  w2 = w:add_html('00:00:00', 1, 1, 1, 1, 1) -- text, col, row, col_span, row_span, width, height
  w3 = w:add_button("Save", click_Action, 2, 1, 1, 1, 1, 1)
end

function GetFilename(path)
	return path:match("^.+/(.+)$")
end

function click_Action()
	current_timestamp = vlc.var.get(vlc.object.input(), "time") * 10^-6
	item = vlc.input.item()
	uri = item:uri()
	filename = GetFilename(uri)
  filepath = "/Users/ifor/Downloads/" .. filename .. ".cut"

  w2:set_text(current_timestamp)
	strCmd = 'echo ' .. current_timestamp .. ' >> ' .. filepath
	os.execute(strCmd)
end
