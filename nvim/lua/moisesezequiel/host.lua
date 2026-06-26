local M = {}

local uname = vim.uv.os_uname()
local sys = (uname.sysname or ""):lower()

M.is_windows = sys:find("windows", 1, true) ~= nil
M.is_linux = sys:find("linux", 1, true) ~= nil
M.is_wsl = vim.fn.has("wsl") == 1

function M.has(bin)
    return vim.fn.executable(bin) == 1
end

return M
