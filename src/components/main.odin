package components

import "dependencies:imgui"
main_entry :: proc(p_open: ^bool, io: ^imgui.IO, files_info: ^[dynamic]FileInfo) {
  if imgui.Begin(
    "Fullscreen single windows",
    nil,
    {.NoCollapse, .NoMove, .MenuBar, .NoResize},
  ) {
    menu_bar(p_open, io, files_info)
  }
  imgui.End()
}

FileInfo :: struct {
	file_name: string,
	path: string,
	file_content: string,
}
