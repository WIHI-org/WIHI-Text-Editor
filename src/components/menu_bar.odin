package components

import f "src:files"
import u "src:utils"
import m "."
import "core:mem"

import "core:fmt"
import "core:strings"

import imgui "dependencies:imgui"
content: string = ""
show_sys_info: bool = false
current_display: cstring = ""
menu_bar :: proc(p_open: ^bool, io: ^imgui.IO, files_info: ^[dynamic]FileInfo) {
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
        fmt.printf(path)
        i := strings.last_index(path, "\\")

        f := FileInfo {
          file_name = path[i:],
          file_content = content,
          path = path,
        }
        
        append_elem(files_info, f)
       
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
  
  
  for item in files_info {
    fmt.println(item.file_content)
    if imgui.BeginMenuBar() {
      if (imgui.BeginMenu(strings.unsafe_string_to_cstring(item.file_name))) {
          
          current_display = strings.unsafe_string_to_cstring(item.file_content)
          
        imgui.EndMenu()
      }
      imgui.EndMenuBar()
    }
  }
  //fmt.println(current_display)
  if current_display != "" {
    imgui.Text("%s",current_display)
  }
  

  if show_sys_info != false {
    u.sys_info(io)
  }
}