# ya_inputdisplay
Yet another input display for Clone Hero / YARG **(WIP)**

It's made using Godot 4.2.1.

![](https://github.com/raphaelgoulart/ya_inputdisplay/blob/main/demo.gif)

## Controls
- Click on top of the button to re-bind it to another key or button;
- Press `backspace` to reset counters;
- Press `-` or `=` to decrease/increase the scrolling speed of the input bars;
- Press `[` or `]` to decrease/increase the width of the input bars (does not affect existing input bars, only new ones).
- Press `` ` `` to calibrate axes.

## Settings
Some of these can be edited in-app, but not all; the settings file can be found in `%APPDATA%\Godot\app_userdata\ya_inputdisplay\yaid_settings.cfg`. It allows you to tweak the following values:
- `scroll_rate`: Scrolling speed of the input bars, in pixels per second; the higher, the faster. Default: 400;
- `width`: Sets the width in pixels of the input bars. Default: 50;
- `green`, `red`, `yellow`, `blue`, `orange`, `up` and `down`: Sets the color of each element. Must be set as a RGB Hex value (i.e. `"#FF0000"` for red).

If you cannot find the file, just open the input display and close it; the file is saved on application close.

## Guitar not detected! What do I do?
If your guitar is an Ardwiino, upgrade it to the [Santroller](https://github.com/Santroller/Santroller) firmware.

Otherwise, please open an issue, mentioning which guitar model it is, and whether it's only some buttons that aren't detected, or the guitar as a whole.

## Program wrongly detecting tilt/whammy as input when mapping. What do I do?
Axis calibration is done both at program startup, or whenever `` ` `` is pressed. So, if you encounter this issue, either:
- Make sure you're holding your guitar horizontally (i.e. not tilting) and aren't holding the whammy bar while opening the program, or;
- Same as above, but press `` ` `` while the program is running.

## TODO
This is still WIP; here are some of the main TODO items (in no particular order):
- Test with other guitars (currently tested with Santroller, Xplorer, Fender RB1 Xbox 360);
- Make FPS independent (requires rewrite)

My time to work on this is relatively limited, but feel free to open issues and pull requests. Contributions are very welcome!
