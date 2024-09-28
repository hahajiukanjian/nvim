-- 定义一个局部函数，用于预览堆栈跟踪信息
local preview_stack_trace = function()
    -- 获取当前行的内容
    local line = vim.api.nvim_get_current_line()

    -- 定义用于匹配堆栈跟踪信息的正则表达式模式
    local pattern = "package:[^/]+/([^:]+):(%d+):(%d+)"

    -- 使用模式从行中提取文件路径、行号和列号
    local filepath, line_nr, column_nr = string.match(line, pattern)

    -- 如果匹配到了文件路径、行号和列号
    if filepath and line_nr and column_nr then
        -- 切换到上一个窗口
        vim.cmd(":wincmd k")

        -- 打开提取到的文件路径
        vim.cmd("e " .. filepath)

        -- 将光标移动到提取到的行号和列号
        vim.api.nvim_win_set_cursor(0, { tonumber(line_nr), tonumber(column_nr) })

        -- 切换回到原窗口
        vim.cmd(":wincmd j")
    end
end

-- 返回一个表，包含设置函数
return {
    -- setup 函数，接受 LSP (Language Server Protocol) 参数
    setup = function(lsp)
        -- 创建一个自动命令，当进入名为 "__FLUTTER_DEV_LOG__" 的 buffer 时，绑定键映射
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "__FLUTTER_DEV_LOG__",
            callback = function()
                -- 在普通模式下按下 "p" 键时调用 preview_stack_trace 函数
                vim.keymap.set("n", "p", preview_stack_trace, { silent = true, noremap = true, buffer = true })
            end
        })

        -- 使用 Dart 语言服务器的选项配置 LSP
        local dart_lsp = lsp.build_options('dartls', {})

        -- 引入 Flutter 插件并配置
        local flutter = require('flutter-tools')
        flutter.setup({
            -- 使用 FVM（Flutter 版本管理工具）
            fvm = true,

            -- 配置 Flutter widget 的引导线显示
            widget_guides = {
                enabled = true,
            },

            -- 配置 UI 选项
            ui = {
                -- 设置 UI 边框为圆角
                border = "rounded",

                -- 通知样式使用 "nvim-notify" 插件
                notification_style = 'nvim-notify'
            },

            -- 配置 LSP
            lsp = {
                -- 当 LSP 附加时执行的回调
                on_attach = function()
                    -- 将 Flutter widget 引导线的高亮链接到 Comment 组
                    vim.cmd('highlight! link FlutterWidgetGuides Comment')
                end,

                -- 将 Dart 语言服务器的能力传递给 LSP
                capabilities = dart_lsp.capabilities,

                -- 配置 Dart 语言服务器的设置
                settings = {
                    -- 禁用代码片段
                    enableSnippets = false,

                    -- 显示待办事项
                    showTodos = true,

                    -- 启用函数调用补全
                    completeFunctionCalls = true,

                    -- 排除分析的文件夹
                    analysisExcludedFolders = {
                        vim.fn.expand '$HOME/.pub-cache',
                        vim.fn.expand '$HOME/fvm',
                    },

                    -- 设置行长度
                    lineLength = vim.g.flutter_format_line_length,
                },
            },

            -- 配置开发日志功能
            dev_log = {
                enabled = true,
                notify_errors = true,         -- 如果运行时出现错误，则通知用户
                open_cmd = "botright 40vnew", -- 在右下角打开一个 40 列宽的新窗口显示日志
            },

            -- 配置调试器
            debugger = {
                -- 启用与 nvim-dap（调试适配器协议）集成
                enabled = true,

                -- 使用 nvim-dap 运行 Flutter 应用程序
                run_via_dap = true,

                -- 设置异常断点过滤条件
                exception_breakpoints = {
                    {
                        filter = 'raised',
                        label = 'Exceptions',
                        condition =
                        "!(url:startsWith('package:flutter/') || url:startsWith('package:flutter_test/') || url:startsWith('package:dartpad_sample/') || url:startsWith('package:flutter_localizations/'))"
                    }
                },

                -- 注册调试配置
                register_configurations = function(_)
                    local dap = require("dap")

                    -- 如果 Dart 的调试配置尚未注册，则进行配置
                    if not dap.configurations.dart then
                        -- 设置 Dart 调试适配器
                        dap.adapters.dart = {
                            type = "executable",
                            command = "flutter",
                            args = { "debug_adapter" }
                        }

                        -- 配置 Dart 调试的启动设置
                        dap.configurations.dart = {
                            {
                                -- 设置 Flutter 项目的调试配置
                                type = "dart",
                                request = "launch",
                                name = "Launch Flutter Program",
                                program = "lib/main.dart",   -- 调试的入口程序
                                cwd = "${workspaceFolder}",  -- 工作目录
                                toolArgs = { "-d", "macos" } -- 使用 macOS 设备进行调试
                            }
                        }
                    end
                    -- 从 launch.json 中加载调试配置
                    require("dap.ext.vscode").load_launchjs()
                end,
            },
        })
    end
}
