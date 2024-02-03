package file_read

import "core:fmt"
import "core:os"
import "core:strings"
import "core:bufio"

main :: proc() {
  semi_hand_written()
  iterator_aproach()
  buffer_aproach()
}

semi_hand_written :: proc(){
  f, err :=  os.open("text.txt", os.O_RDONLY)
  if err !=  os.ERROR_NONE {
    // Handle error
    fmt.println(err)
  }
  defer os.close(f)
  length: i64
  size_err: os.Errno
  if length, size_err = os.file_size(f); size_err != 0 || length <= 0{
    os.exit(1)
  }

  buf := make([]byte, int(length), context.allocator)
  if buf == nil {
    os.exit(1)
  }

  bytes_read, read_err := os.read_full(f, buf)
  if read_err != os.ERROR_NONE {
    delete(buf)
    os.exit(1)
  }
  defer delete(buf, context.allocator)

  buf = buf[: bytes_read]

  str := string(buf)
  fmt.println(str)
}

iterator_aproach :: proc() {
  data, ok := os.read_entire_file("text.txt", context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		// process line
	}
}

buffer_aproach :: proc() {
  f, ferr := os.open("text.txt")
	if ferr != 0 {
		// handle error appropriately
		return
	}
	defer os.close(f)

	r: bufio.Reader
	buffer: [1024]byte
	bufio.reader_init_with_buf(&r, os.stream_from_handle(f), buffer[:])
	// NOTE: bufio.reader_init can be used if you want to use a dynamic backing buffer
	defer bufio.reader_destroy(&r)

	for {
		// This will allocate a string because the line might go over the backing
		// buffer and thus need to join things together
		line, err := bufio.reader_read_string(&r, '\n', context.allocator)
		if err != nil {
			break
		}
		defer delete(line, context.allocator)
		line = strings.trim_right(line, "\r")

		// process line
	}
}
