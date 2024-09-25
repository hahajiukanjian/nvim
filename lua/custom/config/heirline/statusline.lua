local components = require 'custom.config.heirline.components'

return { -- statusline
  components.RightPadding(components.ModeL, 2),
  components.RightPadding(components.FileNameBlock, 2),
  components.RightPadding(components.Git, 2),
  components.RightPadding(components.Diagnostics),
  components.Fill,
  components.MacroRecording,
  components.Fill,
  components.RightPadding(components.LSPActive),
  components.RightPadding(components.FileType, 0),
  components.RightPadding(components.Overseer, 0),
  components.RightPadding(components.CodeiumStatus, 0),
  components.RightPadding(components.Ruler),
  components.ScrollBar,
  components.LeftPadding(components.ModeR, 2),
}
