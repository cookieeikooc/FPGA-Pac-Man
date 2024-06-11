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

How Does VGA Work

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

![VGA Sync](https://github.com/cookieeikooc/FPGA-Pac-Man/assets/160454617/c2840560-f624-4a72-9ac0-7cacb09c11a9)
> Visualize VGA timing and HV sync pulse

### Display RAM
> See the Verilog [code](https://github.com/cookieeikooc/FPGA-Pac-Man/blob/main/pacman/pacman.srcs/sources_1/new/Display/output_display_array.v) here
**Display Workflow**
When constructing the structure of display, I immediately realized that the non-active pixels of the display array is not sufficient for the RAM to setup multiple frame, so I decided to design a cache system that precalculating the display output and store it in cache even during the active time, and the display RAM will load data in the cache during non-active peroid. 



