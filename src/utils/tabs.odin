package utils

import "base:builtin"

import f "src:files"

close_tab :: proc(files_info: ^[dynamic]f.FileInfo, path: string) {
  for item, i in files_info {
    if (item.path == path) {
      delete(item.file_content)
      delete(item.path)
      delete(item.file_name)
      ordered_remove(files_info, i)
    }
  }
}
