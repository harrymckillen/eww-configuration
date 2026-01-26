# eww-configuration

## Pre-requisites

- Install [eww](https://elkowar.github.io/eww/) by following the build instructions
- Install `playerctl`, instructions [from here](https://github.com/altdesktop/playerctl).
- Install `cava` (relied upon by the audio visualiser), instructions [from here](https://github.com/karlstav/cava).

## Installation

- clone this repo
- copy to `.config/eww/` directory
- Make scripts executable `chmod a+x *.sh`
- Run `./eww.sh` to Launch

## Configuration

- You can change the colours and design of the widgets via the CSS etc.

## Example

<video src="eww.mp4" width="720" height="480" controls></video>

<!-- ![](eww.mp4) -->

## Known Issues

- Occasionally there is some _stuttering_ with the bars, and it seems to be around the read of the cava output
