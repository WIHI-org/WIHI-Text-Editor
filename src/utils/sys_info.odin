package utils

import si "core:sys/info"

import imgui "dependencies:imgui"

sys_info :: proc() {
	io := imgui.GetIO()
	fps := cast(u32)io.Framerate

	imgui.Text("Odin:  %s\n\n", ODIN_VERSION)
	imgui.Text("OS:    %s\n", si.os_version.as_string)
	imgui.Text("CPU:   %s\n", si.cpu_name)
	imgui.Text("RAM:   %d MiB\n\n", si.ram.total_ram / 1024 / 1024)

	for gpu, i in si.gpus {
		imgui.Text("GPU %d:\n", i)
		imgui.Text("\tVendor: %s\n", gpu.vendor_name)
		imgui.Text("\tModel:  %s\n", gpu.model_name)
		imgui.Text("\tVRAM:   %d MiB\n\n", gpu.total_ram / 1024 / 1024)
	}

	imgui.Text("FPS: %d", fps)
}
