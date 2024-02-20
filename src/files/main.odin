package files

import "core:strings"
import "core:fmt"

open_file :: proc(files_info: ^[dynamic]FileInfo) -> (p: string = "", file_content: string = "", ok: bool) {
  path: string
  path, ok = select_file_to_open()
  if !ok {
    // display some err
    fmt.println("ERROR GETTING FILE FROM DIALOG")
    return
  }

  file_content, ok = read_file_by_lines_in_whole(path)
  if (!ok) {
    // display some err
    fmt.printf("ERROR DURUING READING FILE")
    return
  }
  i := strings.last_index(path, "\\")
  p = path[i+1:]
  f := FileInfo {
    file_name = strings.clone(p),
    file_content = strings.clone(file_content),
    path = strings.clone(path),
  }
  
  append_elem(files_info, f)
  return p, file_content, ok
}

FileInfo :: struct {
	file_name: string,
	path: string,
	file_content: string,
}
