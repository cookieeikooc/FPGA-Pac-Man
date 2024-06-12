> Having best reading experience using Github dark theme - Bing Yu Li
# Introduction
You may not heard of this name, but you must have seen this game before. A Yellow PacMan eating dots, and four ghosts chasing after, with the signature "Wakka wakka" sound. Pac-Man is one of the most famous and best-selling video game in history. Pac-Man first appeared in 1980, Japan, as an arcade game. As the game started it's journey in America, it quickly went viral across the states, and became the most popular game in the 80s. We are now trying to simulate the original 80s arcade version of Pac-Man on the Nexys 4 DDR, which is a development board using the Artix-7™ FPGA from Xilinx®. The whole development process is very tough. With irresponsible and unproductive group members, it's barely possible to make every thing done all by myself, even though I've put all my effort, sacrificing my sleep time and my mental health.

# Design Process
## Materials
Hardware:
- [Nexys 4 DDR](https://digilent.com/reference/programmable-logic/nexys-4-ddr/start)
- Screen
- VGA cable

Software:
- [AMD Vivado](https://www.xilinx.com/products/design-tools/vivado.html) (RTL design in Verilog)
- [Xcode](https://developer.apple.com/xcode/) (C++ for data management)

## Work Assignment and Design Structure
Just two days before the demonstration day, one group member told me that he hasn't finish the code (only half finished), and the other said that he has done nothing on the last day. I have to reassign the whole process and pick up some of the undone tasks, contacting the TA for overdue request. Eventually a group member just disappear and the task was left undone though I've tried to cover up all their tasks. The design structures and the work assignment of the project is shown below:

![original design structures](https://github.com/cookieeikooc/FPGA-Pac-Man/assets/160454617/9e7d9567-fc3e-43dc-aa58-98fca87ce2da)
> Original

![reassigned design structures](https://github.com/cookieeikooc/FPGA-Pac-Man/assets/160454617/53d25ec1-ac90-442e-b6d0-9735f26b206a)
> Reassigned

Even with the new assignment and some tasks discarded, we still cannot present a playable game on screen. The one last piece of the project, PacMan was given four days before due day, I don't have enough time to fix all synthesis errors which had never shown before as I connect all modules together. The synthesis errors and debug details is provided at Synthesis Errors.

## Modules
### VGA
> See the Verilog [code](https://github.com/cookieeikooc/FPGA-Pac-Man/blob/main/pacman/pacman.srcs/sources_1/new/VGA/VGA.v) here

**Why We Choose 720p**

Unlike those 4:3 CRT monitors that had been widely used from 70s to early 2000, most of the monitors nowadays are 16:9, and mostly FHD or 4K. Due to the clock speed limit (1080p needs the clock speed at 148.5 MHz, which exceeds the 100 MHz clock speed of the FPGA) and limited RAM size, we discover that the 720p (HD) is the most suitable choice for us, since it uses the clock speed at 74.25 MHz.

**How Does VGA Work**

VGA is a analog [RGBHV](https://en.wikipedia.org/wiki/Component_video#RGB_analog_component_video) video port. The FPGA board provide a 12-bit digital RGB to analog circuit. we only have to deal with the Vertical Sync and Horizontal Sync signals, and different resolution and frame rate has different Sync pulse. As the information [provided](https://projectf.io/posts/video-timings-vga-720p-1080p/), the code block shows the sync timing of 720p 60Hz:
```
Name         1280x720p60          Pixel Clock       74.250 MHz            Active Pixels    921,600
Standard       CTA-770.3          TMDS Clock       742.500 MHz            Data Rate           1.78 Gbps
VIC                    4          Pixel Time          13.5 ns ±0.5%       Frame Memory (Kbits)
Short Name          720p          Horizontal Freq.  45.000 kHz            8-bit Memory      7,200
Aspect Ratio        16:9          Line Time           22.2 μs             12-bit Memory     10,800
                                  Vertical Freq.    60.000 Hz             24-bit Memory     21,600 
                                  Frame Time          16.7 ms             32-bit Memory     28,800

Horizontal Timings                Vertical Timings
Active Pixels       1280          Active Lines         720
Front Porch          110          Front Porch            5
Sync Width            40          Sync Width             5
Back Porch           220          Back Porch            20
Blanking Total       370          Blanking Total        30
Total Pixels        1650          Total Lines          750
Sync Polarity        pos          Sync Polarity        pos
```
The Sync pulse signal only stays low during "Sync Width", and High at other pixels. The RGB signal can only be non-zero during "Active Pixels". The monitor will be scanned row by row, from left to right, top to bottom, as the picture has shown.
![VGA Sync](https://github.com/cookieeikooc/FPGA-Pac-Man/assets/160454617/0499c875-86e9-4b87-952d-38765e4fe712)

> Visualize VGA timing and HV sync pulse

**Clocking**
The clock speed of 720p is 74.25 MHz, in order to generate it from 100 MHz clock, the ordinary clock divider cannot do the job. There's some way that can realize the circuits, and Phase-Locked Loop (PLL) is one of them. PLL uses a clock multiplier and a clock divider to generate certain clock frequency. 劉秀勇 eventually find an IP from AMD called [Clocking Wizard v6.0](https://www.xilinx.com/products/intellectual-property/clocking_wizard.html), which can perfectly get the job done.

### Display RAM
> See the Verilog [code](https://github.com/cookieeikooc/FPGA-Pac-Man/blob/main/pacman/pacman.srcs/sources_1/new/Display/output_display_array.v) here

**Display Workflow**
When constructing the structure of display, I immediately realized that the non-active pixels of the display array is not sufficient for the RAM to setup multiple frame, so I decided to design a cache system that precalculate the display output and store it in the cache even during active time, and the display RAM will load data in the cache during non-active period. 

There's two way to achieve this, one is a cache that only stores one row of data and loaded at the h-sync active low, the other is  a cache that stores the bigger parts of the display and loaded at v-sync active low. Some pros and cons are listed here.

Row refreshing:
- Pros:
  - Uses less memory
  - easy to construct
- Cons:
  - May have some time wasted
  - Setup time may being insufficient
  - Insufficient loading time (need to run under fast clock speed)

Block refreshing:
- Pros:
  - More setup time (as the picture below has shown)
- Cons:
  - Uses more memory (I mean a lot)
  - More complex addressing and loading

![cache](https://github.com/cookieeikooc/FPGA-Pac-Man/assets/160454617/8bfdde7d-807d-406e-84d2-a5b8ab69822d)


### Cache
> See the Verilog [code](https://github.com/cookieeikooc/FPGA-Pac-Man/blob/main/pacman/pacman.srcs/sources_1/new/Display/board/board_display_cache.v) here

The module has to combine and decode all the inputs from Pacs, Fruits, PacMan, Ghosts and Eaten Score, and read values inside ROMs, putting them into the correct position of the RAM, and can be loaded by Display RAM after finishing rendering. The structure is clear but due to those undone modules, some switches are empty and some inputs are unconnected.

**Layers**

As different objects being "paste" onto the cache, there would be some layering issue, which means that we have to decide which is above which and should be done by specific sequences. In order to minimize the rendering time, only a small block of cache is updated but the whole RAM if possible. The table below shows the layers arrangement and pixels numbers to the corresponding layers.

|           | Map   | Pac   | Fruit   | PACMAN  | BLINKY  | PINKY   | INKY    | CLYDE   | SCORE   |
| --------- | ----- | ----- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| Form (px) | 8 x 8 | 8 x 8 | 16 x 16 | 16 x 16 | 16 x 16 | 16 x 16 | 16 x 16 | 16 x 16 | 16 x 16 |
| Num of px | 55552 | 15616 | 256     | 256     | 256     | 256     | 256     | 256     | 256     |

Layers are controlled by a finite state machine, which run tough all the pixels, the rendering time is decided by the clock speed. The clock speed should be carefully calculate to ensure that all the circuit would be able to finish their tasks in a clock cycle, and practical tests is also needed. 

**ROM Reading**
Some specific signal is given, for example, the signal that indicates if the Pac exist: if exist, paste it, and if not, do nothing. Only the clock is given to the RAM to minimize wires, and ROMs have to decode the clock themselves. 

### ROM
> See the Verilog [code](https://github.com/cookieeikooc/FPGA-Pac-Man/tree/main/pacman/pacman.srcs/sources_1/new/Display/ROM) here

**Memory Initialize**

Vivado has provide [a synthesis method](https://docs.amd.com/r/en-US/ug901-vivado-synthesis/Specifying-RAM-Initial-Contents-in-an-External-Data-File) that can use initial block and `$readmem` to include the memory value in the bitstream, and write into its block RAM. To deal with the large number of data in different forms, here comes the C++ files. I use these code to help me convert number between forms, because the `$readmem` method can only uses either Binary or Hexadecimal, and you can't mix both. But in the most circumstances I prefer using Decimal since it's easy for people to understand, so the C++ code basically just read the file and convert the data into Binary. By doing so I can avoid human errors and uses less time to achieve the same goal. Here is an quick view of a part of the Ghost's ROM
```
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0
0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0
0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
0 0 1 1 1 3 3 1 1 1 1 3 3 1 0 0
0 0 1 1 3 3 3 3 1 1 3 3 3 3 0 0
0 0 1 1 3 3 2 2 1 1 3 3 2 2 0 0
0 1 1 1 3 3 2 2 1 1 3 3 2 2 1 0
0 1 1 1 1 3 3 1 1 1 1 3 3 1 1 0
0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0
0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0
0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0
0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0
0 1 1 0 1 1 1 0 0 1 1 1 0 1 1 0
0 1 0 0 0 1 1 0 0 1 1 0 0 0 1 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
```

**Tilemapping**

In order to minimize ROM usage, instead of storing data in 12-bit RGB for each element, I decided to store simple value inside ROMs and each value has a corresponding color. As I dig into the graphics of some old arcade games, they also uses the similar method called "Tilesets", which is a cleaver systematic way of storing and decoding graphics. "Tiles" is a block of pixels (mostly 8 x 8 or 16 x 16). It basically just stores the pixels in each graph as 2-bit number, and some 8-bit RGB templates correspond to the 2-bit number. Selecting different templates and different graph can generate graphics needed. The [website](https://www.retrogamedeconstructionzone.com/2020/01/graphics-in-early-arcade-games-tilemaps.html) has provided more fun history and working details.

![Assets/Palettes](https://www.spriters-resource.com/resources/sheets/156/159361.png?updated=1628406045)
> Picture from [The Spriters Resource](https://www.spriters-resource.com/arcade/pacman/sheet/159361/)

**Color Bit Depth**
The original color in most of the old arcade games are 8-bit RGB, 3 bit for red, 3 bit for green and 1 bit for blue. I only have the original color palette in PNG, which is 8-bit for each color, so I have to compress the 0 to 255 color range to 8-bit RGB, and then expand it to 12-bit color for the VGA output. As the code block below has shown, we have to approximate the color when expanding from 8-bit to 12-bit.

```
0   2   4   6     9   B   D   F
000 033 071 128 151 183 222 255   R
000 033 071 128 151 183 222 255   G
000      082       173      255   B
0         5         A         F
```

**Timing**

To avoid unstable signal, I use negedge to reset, alter between states and change RAM's address, and posedge for data to load. The timing diagram shows the design of state machine and ROM accessing.
![time dia 1](https://github.com/cookieeikooc/FPGA-Pac-Man/assets/160454617/ea2b5de0-7394-4779-8c3b-f15ada74949f)

**Modules Details**

Here's some details of some ROMs:

***Map***
> See the Verilog [code](https://github.com/cookieeikooc/FPGA-Pac-Man/blob/main/pacman/pacman.srcs/sources_1/new/Display/board/map_ROM.v) here

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
This step is done automatically, regardless of any input from other modules, except the refresh signal which trigger the whole system when new frame is needed, which is at 60Hz.

***Pacs***
> See the Verilog [code](https://github.com/cookieeikooc/FPGA-Pac-Man/blob/main/pacman/pacman.srcs/sources_1/new/pac/pac.v) here

There's 244 Pacs in the map, including 4 energizers, which flashes in the frequency of 8Hz (4 cycles a sec). The cache will get the existence of the pac from a 244 elements long array.

***Ghost***
> See the Verilog [code](https://github.com/cookieeikooc/FPGA-Pac-Man/blob/main/pacman/pacman.srcs/sources_1/new/Display/board/ghost_ROM.v) here

When the frightened mode is going to end, the ghosts will flash at a frequency of 4Hz (2 cycles a sec). The flash frame starting is independent from the position of ghosts and the animation frame, and the animation frame is independent from the position of ghosts, with the frequency of 4Hz.

### Random Generator
> See the Verilog [code](https://github.com/cookieeikooc/FPGA-Pac-Man/blob/main/pacman/pacman.srcs/sources_1/new/random_generator/random_generator.v) here

In order to rebuild the original arcade vibes, we need to simulate the random bias of the random function which Pac-Man originally uses, creating the same "random" direction (which is not equally distributed). The ROM is made up with the first 8KB of original arcade version assembly code instructions, which is a 8192 16-bit Hexadecimal array. The index is reset at the start of each level and given the value of the current level (also 16-bit), for each call of the random function, it has a formula of `index = (index*5) + 1`, and modulo by 8192. The value in the ROM then be truncated into 2-bit signal 00, 01, 10, 11, which represent right, down, left and up respectively. The ROM isn't perfectily distributed due to it's nature, original code. The probability of each direction is 25.2%, 28.5%, 29.9%, 16.3% (2064, 2338, 2452, 1338).
> reference video: [How Frightened Ghosts Decide Where to Go](https://www.youtube.com/watch?v=eFP0_rkjwlY)

> Also see the [assembly code](https://pastebin.com/80zu44Eu)

## Trial and error

### $readmem to set up a 2D unpacked array
I was trying to set up a ROM that is a 2D unpacked array, but the synthesis did not work. After checking Documentations, I still cannot find the reason why. So I turned to the Xilinx [community](https://support.xilinx.com/s/?language=en_US) for help. I got the [answers](https://support.xilinx.com/s/question/0D54U00008OJ1cySAD/is-it-possible-to-use-readmemh-to-set-up-a-2d-unpacked-array?language=en_US) after a few days of waiting, 

1. **Is it possible to use `$readmemh` to read a .mem file to a unpacked 2D array?**

     No, the memory can only be linear unpacked, so I have to combine rows and cols to be able to achieve the same functionality, and uses address as `{row, col}` to locate the specific element.

2. **Is whitespaces allowed for index spacing?**

     The comment give me some code and ask me to test them myself, and the answer is yes. Though the documentation says "There must be as many lines in the external data file as there are rows in the RAM array. An insufficient number of lines is flagged", but the truth is, no matter how many whitespaces is used to separate elements, the ROM works just fine. 

### RAM Method
Each module had done the synthesis successfully individually, but after I connect my modules and module provided by my group member, the synthesis errors occurred, and as I checked the Log, trying to figure things out, I discovered more critical errors, some modules didn't act as RAMs but being dissolved into registers. This was not what I would like to see because it took up 666644 registers. I've tried to ask [question](https://support.xilinx.com/s/question/0D54U00008SjrFYSAZ/solved-ignoring-malformed-readmem-task?language=en_US) on the community but nobody had answered.

So I asked a retired engineer for help. He suggest that I can use a memory [IP](https://www.xilinx.com/products/intellectual-property/block_memory_generator.html) to manage my RAMs and ROMs, but this method would take a bunch of time but I only had 2 days left. So we discovered another way, he found the specific [way](https://fpga.eetrend.com/blog/2023/100574582.html) for Vivado to know that I want to use the block RAM on board instead of the registers. But the same error Log "`WARNING: [Synth 8-2898] ignoring malformed $readmem task: invalid memory name`" still remained. 

After few hours of trails and discussions, he suggested that "how about setting the bit width to [0:0] instead of nothing", and it works! We found a synthesis bug of Vivado. But now some of the RAMs and ROMs still need modification to prompt Vivado to synthesize RAM but registers, and it's a big change. Unfortunately I don't have enough time to get every file changed, and another synthesis error still remains. It even located a line in my [code]((https://github.com/cookieeikooc/FPGA-Pac-Man/blob/main/pacman/pacman.srcs/sources_1/new/Display/output_display_array.v)) that doesn't even exist. 

# Conclusion
We use the knowledge we've learn in logic design and digital LAB, and information online to develop this project. Although the result isn't what I've expected, the value of the design process is priceless. I've learned how to prompt chatGPT to generate Verilog code with as few errors as possible (the structures it provided were mostly right), and using Github copilot to help me with the RTL project. I also enhanced my skill of coding in Verilog. With the courses and the discussion with former engineer, I've learned more about FPGA, RAM style coding, how synthesis works and trouble shooting methods. Unlike most of the software languages, the way that I have to have clear circuit layout in my mind when using Verilog just feels right to me. I also learned that I have to setup clear deadline and uses time tracking tool to help me keeping track of group members progress. For now the project is stranded because the remaining synthesis error that Vivado located a line that doesn't exist. 
