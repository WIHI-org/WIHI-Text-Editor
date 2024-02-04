package utils

import win32 "core:sys/windows"
import "core:strings"
Open_Save_Mode :: enum {
  Open = 0,
  Save = 1
}

open_file_dialog :: proc(title: string, dir: string, 
                          filters: [] string, default_filter: u32,
                          flags: u32, default_ext: string,
                          mode: Open_Save_Mode, allocator := context.temp_allocator) -> (path: string, ok: bool = true) {
  
  context.allocator = allocator
  file_buf := make([]u16, win32.MAX_PATH_WIDE)
  defer if !ok {
    delete(file_buf)
  }                 
  
  // filetrs need to be passed as a pair o fstring (title, filter)
  filter_len := u32(len(filters))

  // if they arent passed as pairs return false
  if filter_len % 2 != 0 {
    return "", false
  }

  filter: string
  filter = strings.join(filters, "\u0000", context.temp_allocator)
  filter = strings.concatenate({filter, "\u0000"}, context.temp_allocator)

  ofn := win32.OPENFILENAMEW {
    lStructSize     = size_of(win32.OPENFILENAMEW),
    lpstrFile       = win32.wstring(&file_buf[0]),
    nMaxFile        = win32.MAX_PATH_WIDE, 
    lpstrTitle      = win32.utf8_to_wstring(title, context.temp_allocator),
    lpstrFilter     = win32.utf8_to_wstring(filter, context.temp_allocator),
    lpstrInitialDir = win32.utf8_to_wstring(dir, context.temp_allocator),
    nFilterIndex    = u32(clamp(default_filter, 1, filter_len / 2)),
    lpstrDefExt     = win32.utf8_to_wstring(default_ext, context.temp_allocator),
    Flags           = u32(flags),
  }

  switch mode {
    case .Open:
      ok = bool(win32.GetOpenFileNameW(&ofn))
    case .Save:
      ok = bool(win32.GetSaveFileNameW(&ofn))
    case:
      ok = false
  }

  if (!ok) {
    return
  }

  file_name, _ := win32.utf16_to_utf8(file_buf[:], allocator)
  path = strings.trim_right_null(file_name)
  return
}

select_file_to_open :: proc(title := win32.OPEN_TITLE, dir := ".",
                            filters := []string{"All Files", "*.*"}, default_filter := u32(1),
                            flags := win32.OPEN_FLAGS, allocator := context.temp_allocator) -> (path: string, ok: bool) {
  
  path, ok = open_file_dialog(title, dir, filters, default_filter, flags, "", Open_Save_Mode.Open, allocator)
  return
}

select_file_to_save :: proc(title := win32.SAVE_TITLE, dir := ".", 
                            filters := []string{"All Files", "*.*"}, default_filter := u32(1),
                            flags := win32.SAVE_FLAGS, default_ext := win32.SAVE_EXT,
                            allocator := context.temp_allocator) -> (path: string, ok: bool) {
  
  path, ok = open_file_dialog(title, dir, filters, default_filter, flags, default_ext, Open_Save_Mode.Save, allocator)
  return
}