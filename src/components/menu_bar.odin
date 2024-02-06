package components

import f "src:files"
import u "src:utils"

import "core:fmt"
import "core:strings"

import imgui "dependencies:imgui"
menu_bar :: proc(p_open: ^bool) {
  show_sys_info: bool = false
  content: string = ""
  if imgui.BeginMenuBar() {
    if imgui.BeginMenu("File") {
      if imgui.MenuItem("Read a file") {
        path, ok := u.select_file_to_open()
        if !ok {
          // display some err
          fmt.println("ERROR GETTING FILE FROM DIALOG")
        }
        content, ok = f.read_file_by_lines_in_whole(path)
        if (!ok) {
          // display some err
          fmt.printf("ERROR DURUING READING FILE")
        }
        fmt.println(content)
      }
      imgui.Separator()
      if imgui.MenuItemEx("Exit", "Alt+F4", false, true) {
        p_open^ = false
      }
      imgui.EndMenu()
    }
    if imgui.BeginMenu("Help") {
      if imgui.MenuItem("About system") {
        if !imgui.IsAnyMouseDown() {
          show_sys_info = true
        }
      }
      imgui.EndMenu()
    }
    imgui.EndMenuBar()
  }

  c: cstring = ""
  if content != "" {
    c = strings.unsafe_string_to_cstring(content)
  }
  imgui.Text("%s", c)

  if show_sys_info != false {
    u.sys_info()
  }
}