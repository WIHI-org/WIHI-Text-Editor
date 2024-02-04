package proto_main

import "core:fmt"
import "core:os"
import imgui "dependencies:imgui"
import "dependencies:imgui/imgui_impl_glfw"
import "dependencies:imgui/imgui_impl_opengl3"


import "vendor:glfw"
import gl "vendor:OpenGL"

main :: proc() {
  assert(cast(bool)glfw.Init(), "Can't init flfw!")
  defer glfw.Terminate()

  glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
  glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 2)
  glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
  glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, 1)

  window : = glfw.CreateWindow(1280, 720, "WIHI", nil, nil)
  assert(window != nil, "Window handle is not created!")
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
  io.ConfigFlags  += {.NavEnableKeyboard, .NavEnableGamepad}

  when imgui.IMGUI_BRANCH == "docking" {
    io.ConfigFlags += {.DockingEnable}
    //io.ConfigFlags += {.ViewportsEnable}

    style := imgui.GetStyle()
    style.WindowRounding = 0.25
    style.Colors[imgui.Col.WindowBg].w = 1
  }

  imgui.StyleColorsDark(nil)

  imgui_impl_glfw.InitForOpenGL(window, true)
  defer imgui_impl_glfw.Shutdown()
  imgui_impl_opengl3.Init("#version 150")
  defer imgui_impl_opengl3.Shutdown()
  fmt.println("line")

  count: i32 = 0
  fps: f32 = 0.0


  for !glfw.WindowShouldClose(window) {
    glfw.PollEvents()
    imgui_impl_opengl3.NewFrame()
    imgui_impl_glfw.NewFrame()
    imgui.NewFrame()
    
    // Star of UI Code
    viewport := imgui.GetMainViewport()
    // can shorten to .Appearing
    imgui.SetNextWindowPos({0, 0}, imgui.Cond.Appearing)
    imgui.SetNextWindowSize(viewport.Size, .Appearing)
    if imgui.Begin("WIHI", nil, {.NoResize, .NoCollapse, .NoMove, .MenuBar}) {
      if imgui.BeginMenuBar() {
        if (imgui.BeginMenu("Popusi Kurac")) {
          if imgui.MenuItem("Nikola") {
            fmt.println("TEST")
          }
          imgui.EndMenu()
        }
        imgui.EndMenuBar()  
      }


      fps = io.Framerate
      //fmt.println(fps)
      imgui.Text("FPS: %d", cast(i32)fps)
    }

    imgui.End()
    // End of UI Code
    imgui.Render()
    display_w, display_h := glfw.GetFramebufferSize(window)
    gl.Viewport(0,0, display_w, display_h)
    gl.ClearColor(0,0,0,1)
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
