local windows = {}

-- Execute the action for every window that displays the given buffer.
function windows.for_windows_of_buf(buf, action)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      action(win)
    end
  end
end

return windows
