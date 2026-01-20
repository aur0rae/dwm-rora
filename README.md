## About
This project is a customized fork of Suckless's `dwm` for running a simple but pretty desktop on lower power 
computers.

## Installation
To install and configure everything, just run `install.sh`. It will request user input for passwords as needed for 
`sudo` permissions, as you cannot (and should not attempt to) run the program as root.

This is intended to be easily run on just about anything UNIX-like that supports Xorg, though on distributions of 
UNIX, Linux, GNU/Hurd, etc. other than Debian GNU/Linux, all dependencies for DWM must be installed manually before 
running this script. If you find any issues in the shell script that prevent it from working with shell util 
implementations other than the GNU Coreutils, please let me know.

```sh
chmod +x install.sh
. ./install.sh
```

## Patches
When trying to rebase to a different version of DWM, be mindful that you may need to patch some things by hand. 
Most of the patches below cannot be automatically applied one after the other, so it gets to be annoying the more 
patches you have. For convenience a (probably license-violating) patch is included to apply all of these at once
on DWM 6.7 (current stable)

- **amixer-integration** - allows for control over the system audio using media keys (modified to use `pactl`)
- **autostart** - runs the `autostart.sh` script located under dwm's folder. This sets the wallpaper and launches the statusbar.
- **cursorwarp** - "warps" the cursor to the center of the window upon spawning or switching focus.
- **fullgaps** - adds gaps around windows to make them float.
- **reload** - allows hotreloading of DWM while running to streamline patching and configuring.
- **viewontag** - shifts the current desktop when moving windows to different workspaces.

## Credits
This project is forked off of **dwm**, **dmenu**, and **slstatus** by [Suckless Software](https://suckless.org/).

Thanks to Suckless Software, Chris Titus Tech, Glockenspiel, and everyone behind DWM's patches!

## Important binds
The default modifier key for all binds is `alt`. You can edit DWM's `config.h` and recompile it to use `Mod4Mask` 
instead - that being the "Windows" or "super" key. Media and backlight keys should "just work."

General:
- **mod+Shift+Return** - spawns XTerm, the default X windowing system terminal.
- **mod+P** - launches Dmenu.
- **mod+R** - hotreloads current running config after a recompile.
- **mod+shift+Q** - kills current session.

Window management:
- **mod+Shift+C** - kills current window.
- **mod+[1-9]** - switches current workspace.
- **mod+Shift+[1-9]** - moves current window to a different workspace.
- **mod+Enter** - shifts current focused window to the "master" column.
- **mod+Enter+[I,D]** - shifts windows into/out of the "master" column.
- **mod+[L,H]** - grows or shrinks "master" and "stack" columns.
- **mod+[J,K]** - shifts focus.

## Screenshots
*DWM running on my Netbook with Void Linux*
<img alt="DWM on Void" src="https://github.com/aur0rae/RoWM/blob/main/res/screenshot.png">
