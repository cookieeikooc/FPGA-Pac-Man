# Log

## Pixel Mesurement
### Size in px
  - Map Hight: 248
  - Map Width: 224
  - Path: 8 * 8
  - Pac-Man: 16 * 16
  - Ghost: 16 * 16
  - Bonus fruit: 16 * 16
  - Pac: 8 * 8
  - Energizer: 8 * 8

## Pixel Masurement
### Block
Each tile contains 8 * 8 sub pixels
  - Map Hight: 31
  - Map Width: 28
### Color
The original color is 8bit RGB, which red has 3 bit, green has 3 bit and blue has 1 bit. I only have the original color palette in PNG, which is 8 bit for each color, so I have to compress the 0 to 255 color to 8bit RGB, and then expand it to 16 bit color for VGA output. As you can see we have to approximate color when expanding color form 8bit to 48bit, the code block below shows the approximation result.

Code is in 12-bit Hex
  ```
  0   2   4   6     9   B   D   F
  000 033 071 128 151 183 222 255
  000 033 071 128 151 183 222 255
  000      082       173      255
  0         5         A         F
  ```

## Random Generator
In order to rebuild the original arcade vibes, we need to simulate the random bias of the random function which Pac-Man originally uses, creating the same "random" direction (which is not equally distributed). The ROM is made up with the first 8KB of original arcade version assembly code instructions, which is a 8192 16-bit Hexadecimal array. The index is reset at the start of each level and given the value of the current level (also 16-bit), for each call of the random function, it has a formula of `index = (index*5) + 1`, and modulo by 8192. The value in the ROM then be truncated into 2-bit signal 00, 01, 10, 11, which represent right, down, left and up respectively. The ROM isn't perfectily distributed due to it's nature, original code. The probability of each direction is 25.2%, 28.5%, 29.9%, 16.3% (2064, 2338, 2452, 1338).
> reference video: [How Frightened Ghosts Decide Where to Go](https://www.youtube.com/watch?v=eFP0_rkjwlY)

## ROM
With data store in ROM, pre-made pixels can be easily get with address decoder.
### Tiles
The ROM is store in a form of tiles, getting a tile from the ROM then cast it into display cache

## Display cache
Cut the whole display in to three pieces, score, board, level, so that we can combine all cache to create the display memory array for VGA output module.

## PacMan

## PacMan
From PACMAN: 
```
[1:0] pm_state
00 : Die
01 : IDLE
02 : Energized
03 : Killing
```

## Ghost
When the frighten mode is going to end, the ghosts will flash, with the frequency of 4Hz (2 cycles a sec). The flash frame starting is independent to the position of the ghosts and the animation frame, and the animation frame is independent to the position of the ghost, with the frequency of 4Hz.


queued:





