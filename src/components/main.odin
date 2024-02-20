package components

import f "src:files"
import "dependencies:imgui"
main_entry :: proc(p_open: ^bool, io: ^imgui.IO, files_info: ^[dynamic]f.FileInfo) {
  if imgui.Begin(
    "Fullscreen single windows",
    nil,
    {.NoCollapse, .NoMove, .MenuBar, .NoResize},
  ) {
    menu_bar(p_open, io, files_info)
  }
  imgui.End()
}

