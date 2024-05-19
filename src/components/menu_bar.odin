package components

import f "src:files"
import u "src:utils"
import m "."

import c "core:c"
import "core:mem"
import "core:fmt"
import "core:strings"

import imgui "dependencies:imgui"

show_sys_info: bool = false
current_display: cstring = ""
windows_size := imgui.Vec2{1280,720}

my_data: ^imgui.InputTextCallbackData
click: bool = false
menu_bar :: proc(p_open: ^bool, io: ^imgui.IO, files_info: ^[dynamic]f.FileInfo) {
  if imgui.BeginMenuBar() {
    if imgui.BeginMenu("File") {
      if imgui.MenuItem("Read a file") {
        p, file_content, ok := f.open_file(files_info)
        current_display = strings.unsafe_string_to_cstring(file_content)
      }
      imgui.Separator()
      if imgui.MenuItemEx("Exit", "Alt + F4", false, true) {
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
    //fmt.println(item.file_content)
    if imgui.BeginMenuBar() {
      if (imgui.BeginMenu(strings.unsafe_string_to_cstring(item.file_name))) {
        current_display = strings.unsafe_string_to_cstring(item.file_content)
        if (imgui.MenuItemEx("Close", "Ctrl + W",false, true)) {
          u.close_tab(files_info, item.path)
          current_display = ""
        }   
        
        imgui.EndMenu()
      }
      imgui.EndMenuBar()
    }
  }
  //fmt.println(current_display)
  
  if current_display != "" {

  
  input_callback: imgui.InputTextCallback

    input_callback = proc "c" (data: ^imgui.InputTextCallbackData) -> c.int {
      my_data = data
      click = true
      return 0
    } 
    
    imgui.InputTextMultilineEx("label1", current_display, len(current_display) + 100,windows_size, {.AllowTabInput, .CallbackAlways}, input_callback, nil)
    //imgui.Text("%s",current_display)
  }
  
  if click {
    ch := int(my_data.BufSize)
    if ch != 0 {
      fmt.println(ch)
    }
    click = false
  }
  
  if show_sys_info != false {
    sys_info(io)
  }
}


