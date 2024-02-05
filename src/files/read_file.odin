package files

import "core:os"
import "core:strings"

read_file_by_lines_in_whole :: proc(filepath: string) -> (content: string, ok: bool) {
  data: []byte
  data, ok = os.read_entire_file(filepath, context.allocator)
  if !ok {
    return "", ok
  }
  defer delete(data, context.allocator)

  content = string(data)
  return
}