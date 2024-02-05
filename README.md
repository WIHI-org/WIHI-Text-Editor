# WIHI-IDE
Our take on creating an  IDE

# SETUP
To run execute build.py in dependencies/imgui and follow [setup steps](https://gitlab.com/L-4/odin-imgui) from that repo []
Add this to your ols.json in collections section
```
{
  "name":  "dependencies",
  "path": "./dependencies"
},
{
  "name": "src",
  "path": "./src"
}
```
Refer to imgui_test for usage

To run use you can use taskfile yaml tool ``` task imgui_test ```

# Dependencies
Odin-imgui from L-4
https://gitlab.com/L-4/odin-imgui