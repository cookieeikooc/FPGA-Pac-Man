# Log

## Pixel Mesurement
### Size in px
  - Map Height: 248
  - Map Width: 224
  - Path: 8 x 8
  - Pac-Man: 16 x 16
  - Ghost: 16 x 16
  - Bonus fruit: 16 x 16
  - Pac: 8 x 8
  - Energizer: 8 x 8

### Block
Each tile contains 8 x 8 sub pixels
  - Map Height: 31
  - Map Width: 28
### Color
The original color is 8bit RGB, 3 bit for red, 3 bit for green and 1 bit for blue. I only have the original color palette in PNG, which is 8 bit for each color, so I have to compress the 0 to 255 color range to 8-bit RGB, and then expand it to 12-bit color for VGA output. As you can see we have to approximate the color when expanding from 8-bit to 12-bit, the code block below shows the approximation result.
  ```
  0   2   4   6     9   B   D   F
  000 033 071 128 151 183 222 255   R
  000 033 071 128 151 183 222 255   G
  000      082       173      255   B
  0         5         A         F
  ```

## Random Generator
In order to rebuild the original arcade vibes, we need to simulate the random bias of the random function which Pac-Man originally uses, creating the same "random" direction (which is not equally distributed). The ROM is made up with the first 8KB of original arcade version assembly code instructions, which is a 8192 16-bit Hexadecimal array. The index is reset at the start of each level and given the value of the current level (also 16-bit), for each call of the random function, it has a formula of `index = (index*5) + 1`, and modulo by 8192. The value in the ROM then be truncated into 2-bit signal 00, 01, 10, 11, which represent right, down, left and up respectively. The ROM isn't perfectily distributed due to it's nature, original code. The probability of each direction is 25.2%, 28.5%, 29.9%, 16.3% (2064, 2338, 2452, 1338).
> reference video: [How Frightened Ghosts Decide Where to Go](https://www.youtube.com/watch?v=eFP0_rkjwlY)

## ROM
With data store in ROM, pre-made pixels can be easily get with address decoder.
### Tiles
The ROM is stored in a form of tiles, then get a tile from the ROM then cast it into display cache
### Address decoder
To make the task of the cache more simple, given the adddress decoder a clock signal, and it will generate ROM address with the specific form that the ROM can use, and a counter in cache that keep track of the clock cycles passed.

## Display cache
Cut the whole display into three parts, score, board and level, so that we can combine all cache to create the display memory array for the VGA output module.
### Map
The Map have 34 different types of tile, which is given with number 0 to 33, stored in a 28 x 31 array, and each tile is an 8 x 8 tile, with only colored or black stored in it.
```
00: empty       08: ┘           16: ╝           24: ]           32: ║ right 
01: ┌ outer     09: ╔ outer     17: ╒           25: ─ top       33: gate
02: ┐           10: ╗           18: ╕           26: ─ bottom    
03: └           11: ╚           19: ╓           27: │ left      
04: ┘           12: ╝           20: ╖           28: │ right     
05: ┌ inner     13: ╔ sharp     21: ╙           29: ═ top       
06: ┐           14: ╗           22: ╜           30: ═ bottom
07: └           15: ╚           23: [           31: ║ left
```
This step is done automatically, regardless of any input from other modules, exept the refresh signal which trigger the whole system when new fram need to be generated, which is at 60Hz.
### Pacs
There's 244 Pacs in the map, including 4 energizers, which flashes in the frequency of 8Hz (4 cycles a sec). The cache will get the existence of the pac from a 244 elements long array.
### Fruit //editing
### PacMan
PacMan has one round shape, two opened mouth with each direction, and 13 frames for dying animation.
```
0: Closed 1: R wide open 2: R open 3: D wide open
4: D open 5: L wide open 6: L open 7: U wide open
8: U open 9: Die 1       20: Die 12
```
### Ghost
When the frightened mode is going to end, the ghosts will flash at a frequency of 4Hz (2 cycles a sec). The flash frame starting is independent from the position of ghosts and the animation frame, and the animation frame is independent from the position of ghosts, with the frequency of 4Hz.
### Score //editing

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


## C++
There's lots of syntax conversion task that deals with large amount of data which is barely possible to be done by hands, mostly because of the [.mem file](https://docs.amd.com/r/en-US/ug901-vivado-synthesis/Specifying-RAM-Initial-Contents-in-an-External-Data-File) that can only be either binary or hexadecimal. The CPP file contains mostly file I/O, switches and simple calculations.
