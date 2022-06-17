Example project to demonstrate usage of the [godot-nim](https://github.com/pragmagic/godot-nim) library.
This follows the 2D Tutorial from [godot's documentation](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html)

Prerequisites:

1. Install [nake](https://github.com/fowlmouth/nake): `nimble install nake -n`.
2. Ensure `~/.nimble/bin` is in your PATH (On Windows: `C:\Users\<your_username>\.nimble\bin`).
3. Set `GODOT_BIN` environment varible to point to Godot executable (requires Godot 3.2 or newer).
4. Install godot-nim: `nimble install godot`

Run `nake build` in any directory within the project to compile for the current platform.

Run `nake run` to run the compiled project.
