# SimpleDoku
Simple Sudoku game for Android (and probably iOS).

## Features
* Very minimalist UI
* Procedural generation of new fields (with a nifty algorithm)
* Automatic checking of the board when every field was filled
* Saves the board on exit
* Start a new game whenever you want and how often you want
* Nothing else :D

## Getting Started
* Install flutter (https://github.com/flutter/flutter)
* Run:
```
    flutter packages get
    flutter build apk
```
* Install the generated .apk on your device.

Alternatively you can connect your device to your computer with usb-debugging enabled and run:
```
    flutter run --release
```

The app might also compile for iOS, but it was never tested.

## Known issues
* Board dimmensions will not fit every device
* Landscape mode Will break the internal keyboard (but it's still usable)

## TODO
* Tipps (to solve the board)
  * which field
  * which value
  * on specific field
* German translation
* Add a timer (maybe hidden to remove distractions)
* Global score (including time)
* Button to restart the game
* Show the used seed
* Select a specific board by seed
