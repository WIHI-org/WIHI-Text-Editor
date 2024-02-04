package fs_single_win

// This is an example of using the bindings with GLFW and OpenGL 3.
// For a more complete example with comments, see:
// https://github.com/ocornut/imgui/blob/docking/examples/example_glfw_opengl3/main.cpp
// (for updating: based on https://github.com/ocornut/imgui/blob/96839b445e32e46d87a44fd43a9cdd60c806f7e1/examples/example_glfw_opengl3/main.cpp)

import "core:fmt"
import u "src:utils"
import imgui "dependencies:imgui"
import "dependencies:imgui/imgui_impl_glfw"
import "dependencies:imgui/imgui_impl_opengl3"

import gl "vendor:OpenGL"
import "vendor:glfw"

main :: proc() {
	assert(cast(bool)glfw.Init())
	defer glfw.Terminate()
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 2)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, 1) // i32(true)

	window := glfw.CreateWindow(1280, 720, "Fullscreen single window", nil, nil)
	assert(window != nil)
	defer glfw.DestroyWindow(window)

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1) // vsync

	gl.load_up_to(3, 2, proc(p: rawptr, name: cstring) {
		(cast(^rawptr)p)^ = glfw.GetProcAddress(name)
	})

	imgui.CHECKVERSION()
	imgui.CreateContext(nil)
	defer imgui.DestroyContext(nil)
	io := imgui.GetIO()
	io.ConfigFlags += {.NavEnableKeyboard, .NavEnableGamepad}
	when imgui.IMGUI_BRANCH == "docking" {
		io.ConfigFlags += {.DockingEnable}
		// Seperates windows into two instead of one whole
		// io.ConfigFlags += {.ViewportsEnable}

		style := imgui.GetStyle()
		style.WindowRounding = 0
		style.Colors[imgui.Col.WindowBg].w = 1
	}

	imgui.StyleColorsDark(nil)

	imgui_impl_glfw.InitForOpenGL(window, true)
	defer imgui_impl_glfw.Shutdown()
	imgui_impl_opengl3.Init("#version 150")
	defer imgui_impl_opengl3.Shutdown()

	for !glfw.WindowShouldClose(window) {
		glfw.PollEvents()

		imgui_impl_opengl3.NewFrame()
		imgui_impl_glfw.NewFrame()
		imgui.NewFrame()

		//imgui.ShowDemoWindow(nil)

		// ui code

		viewport := imgui.GetMainViewport()
		imgui.SetNextWindowPos({0, 0}, .Appearing)
		imgui.SetNextWindowSize(viewport.Size, .Appearing)

		if imgui.Begin("Fullscreen single windows", nil, {.NoCollapse, .NoMove, .MenuBar, .NoResize }) {
			if imgui.BeginMenuBar() {
				if imgui.BeginMenu("File") {
					if imgui.MenuItem("Read a file") {
						path, ok := u.select_file_to_open()
            fmt.println("Success: %t. Filepath: %s", ok, path)
					}
					imgui.Separator()
					if imgui.MenuItemEx("Exit", "Alt+F4", false, true) {
						glfw.SetWindowShouldClose(window, true)
					}
					imgui.EndMenu()
				}
				imgui.EndMenuBar()
			}

			if imgui.Button("The quit button in question") {
				glfw.SetWindowShouldClose(window, true)
			}
		}
		imgui.End()

		// end of ui code

		imgui.Render()
		display_w, display_h := glfw.GetFramebufferSize(window)
		gl.Viewport(0, 0, display_w, display_h)
		gl.ClearColor(0, 0, 0, 1)
		gl.Clear(gl.COLOR_BUFFER_BIT)
		imgui_impl_opengl3.RenderDrawData(imgui.GetDrawData())

		when imgui.IMGUI_BRANCH == "docking" {
			backup_current_window := glfw.GetCurrentContext()
			imgui.UpdatePlatformWindows()
			imgui.RenderPlatformWindowsDefault()
			glfw.MakeContextCurrent(backup_current_window)
		}

		glfw.SwapBuffers(window)
	}
}