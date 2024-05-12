# Log

## Pixel Mesurement 001
### Size in px
  - Map Hight: 248
  - Map Width: 224
  - Path: 16
  - Pac-Man: 13 * 13
  - Ghost: 14 * 14
  - Bonus fruit: 12 * 14
  - Pac: 2 * 2
  - Energizer: 8 * 8

## Pixel Masurement 002
### Block
Every block contains 8 * 8 sub pixel
  - Map Hight: 31
  - Map Width: 28
### Color
Code is in 12-bit Hex
  - Map border color: 11F
  - Gate Color: FBF

## Random Generator
In order to rebuild the original arcade vibes, we need to simulate the random bias of the random function which Pac-Man originally uses, creating the same "random" direction (which is not equally distributed). The ROM is made up with the first 8KB of original arcade version assembly code instructions, which is a 8192 16-bit Hexadecimal array. The index is reset at the start of each level and given the value of the current level (also 16-bit), for each call of the random function, it has a formula of `index = (index*5) + 1`, and modulo by 8192. The value in the ROM then be truncated into 2-bit signal 00, 01, 10, 11, which represent right, down, left and up respectively. The ROM isn't perfectily distributed due to it's nature, original code. The probability of each direction is 25.2%, 28.5%, 29.9%, 16.3% (2064, 2338, 2452, 1338).
> reference video: [How Frightened Ghosts Decide Where to Go](https://www.youtube.com/watch?v=eFP0_rkjwlY)


