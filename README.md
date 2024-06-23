# ya_inputdisplay

Yet another input display for Clone Hero / YARG **(WIP)**

It's made using Godot 4.2.1.

![demo:](https://github.com/raphaelgoulart/ya_inputdisplay/blob/main/demo.gif)

## FAQ/Common Issues

### Guitar not detected! What do I do?

If your guitar is an Ardwiino, upgrade it to the [Santroller](https://github.com/Santroller/Santroller) firmware.

Otherwise, please open an issue, mentioning which guitar model it is, and whether it's only some buttons that aren't detected, or the guitar as a whole.

### Program wrongly detecting tilt/whammy as input when mapping. What do I do?

Axis calibration is done both at program startup, or whenever `` ` `` or `` ^ `` is pressed. So, if you encounter this issue, either:

- Make sure you're holding your guitar horizontally (i.e. not tilting) and aren't holding the whammy bar while opening the program, or;
- Same as above, but press `` ` `` or `` ^ `` while the program is running.

## Controls

- Click on top of the button to re-bind it to another key or button;
- Press `` ` `` or `` ^ `` to calibrate axes.
- Press `backspace` to reset counters;

- Press `escape` or click the "Hamburger Button" in the top left corner to open the Config Menu
- Change a fret's color by left clicking it in the Config Menu.
- Change Scroll Speed and Input bar width in the Config Menu. Scroll speed supports one digit of decimal precision.

- Press `-` or `+`|`=` to decrease or increase the scroll speed of the input bars by 10. (This can be adjusted more precisely in the Config Menu.)
- Press `[`|`,` or `]`|`.` to decrease or increase the width of the input bars (This can be adjusted in the Config Menu, too.)

## Settings

Release 0.0.5+ have a Configuration Menu accessible via the `escape` key or the Hamburger Button (as mentioned above).
All available Settings can be adjusted there.

### Settings For release 0.0.4 and prior

(Note: It is recommended to *not* modify scroll_rate and width by directly editing the config file, and instead using the keybinds mentioned above.)

- `scroll_rate`: Scrolling speed of the input bars, in pixels per second; the higher, the faster. Default: 400;
- `width`: Sets the width in pixels of the input bars. Default: 50;
- `green`, `red`, `yellow`, `blue`, `orange`, `up` and `down`: Sets the color of each element. Must be set as a RGB Hex value (i.e. `"#FF0000"` for red).
(Note: On release 0.0.5+, these are called `fret_0`, `fret_1`, `fret_2`, `fret_3`, `fret_4`, `strum_up` and `strum_down.`)

If you cannot find the file, just open the input display and close it; the file is saved on application close.

## TODO

This is still WIP; here are some of the main TODO items (in no particular order):

- Test with other guitars (currently tested with Santroller, Xplorer, Fender RB1 Xbox 360, Les Paul Xbox 360);
- Make FPS independent (requires rewrite)

My time to work on this is relatively limited, but feel free to open issues and pull requests. Contributions are very welcome!
