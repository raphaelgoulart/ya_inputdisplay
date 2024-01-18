# ya_inputdisplay
Yet another input display for Clone Hero / YARG **(WIP)**

It's made using Godot 4.2.1.

## Controls
- Click on top of the button to re-bind it to another key or button (**warning:** not saved yet);
- Press `backspace` to reset counters;
- Press `-` or `=` to decrease/increase the scrolling speed of the input bars;
- Press `[` or `]` to decrease/increase the width of the input bars (does not affect existing input bars, only new ones).

## Settings
Some of these can be edited in-app, but not all; the settings file can be found in `%APPDATA%\Godot\app_userdata\ya_inputdisplay\yaid_settings.cfg`. It allows you to tweak the following values:
- `scroll_rate`: Scrolling speed of the input bars, in pixels per second; the higher, the faster. Default: 400;
- `width`: Sets the width in pixels of the input bars. Default: 50;
- `green`, `red`, `yellow`, `blue`, `orange`, `up` and `down`: Sets the color of each element. Must be set as a RGB Hex value (i.e. `"#FF0000"` for red).

If you cannot find the file, just open the input display and close it; the file is saved on application close.

## TODO
This is still very early and WIP - only tested with an Ardwiino in XInput mode. Here are some of the main TODO items (in no particular order):
- Make Ardwiino PS3 be detected;
- Test with other guitars / Ardwiino settings;
- Make joypad support read axes instead of only buttons;
- Implement calibration for axes;
- Save/load current bindings / calibration info;

My time to work on this is relatively limited, but feel free to open issues and pull requests. Contributions are very welcome!
