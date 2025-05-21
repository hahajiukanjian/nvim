local conditions = require("heirline.conditions")
local colors = require("tokyonight.colors").setup()

-- 模式模块：显示当前 Vim 模式（如 NORMAL, INSERT）
local ViMode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    static = {
        mode_names = {
            n = "NORMAL", i = "INSERT", v = "VISUAL",
            V = "V-LINE", ["\22"] = "V-BLOCK",
            c = "COMMAND", s = "SELECT", S = "S-LINE",
            R = "REPLACE", r = "HIT-ENTER",
            t = "TERMINAL",
        },
    },
    provider = function(self)
        return " " .. (self.mode_names[self.mode] or "UNKNOWN") .. " "
    end,
    hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = colors.bg, bg = colors.blue, bold = true }
    end,
}

-- Git 模块：显示当前 Git 分支
local Git = {
    condition = conditions.is_git_repo,
    provider = function()
        return " " .. (vim.b.gitsigns_head or "no-branch") .. " "
    end,
    hl = { fg = colors.orange },
}

-- 文件类型模块
local FileType = {
    provider = function()
        return "󰈙 " .. (vim.bo.filetype ~= "" and vim.bo.filetype or "noft")
    end,
    hl = { fg = colors.yellow },
}

-- 编码模块
local Encoding = {
    provider = function()
        return vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc
    end,
    hl = { fg = colors.magenta },
}

-- 游标位置模块
local Ruler = {
    provider = function()
        return string.format(" %3d:%-2d ", unpack(vim.api.nvim_win_get_cursor(0)))
    end,
    hl = { fg = colors.cyan },
}

-- 命令提示信息模块（临时显示）
local msg_state = {
    content = "",
    visible = false,
    timer = nil,
}

local CommandMessage = {
    init = function()
        local msg = vim.v.statusmsg or ""
        if msg ~= "" and msg ~= msg_state.content then
            msg_state.content = msg
            msg_state.visible = true

            if msg_state.timer then
                msg_state.timer:stop()
                msg_state.timer:close()
            end

            msg_state.timer = vim.loop.new_timer()
            msg_state.timer:start(4000, 0, function()
                msg_state.visible = false
                vim.schedule(function()
                    vim.cmd("redrawstatus")
                end)
            end)
        end
    end,

    provider = function()
        if msg_state.visible and msg_state.content ~= "" then
            return " " .. msg_state.content .. " "
        end
        return ""
    end,

    hl = { fg = colors.magenta },
}

-- 滚动条模块
local ScrollBar = {
    static = {
        sbar = { ' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
    },
    provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
    end,

    hl = { fg = colors.yellow, bg = colors.bg },
}

-- 返回最终的组件列表
return {
    ViMode,
    Git,
    CommandMessage,
    -- FileNameBlock, -- 如有需要可以启用
    { provider = "%=" }, -- 居中对齐
    FileType,
    { provider = " " },
    Encoding,
    { provider = " " },
    Ruler,
    ScrollBar,
}

