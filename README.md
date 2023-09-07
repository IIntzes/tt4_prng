![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)
# PSEUDO RANDOM NUMBER GENERATOR for Tiny Tapeout

### International Hellenic University [(IHU)](https://www.iee.ihu.gr/) Thessaloniki, Sindos
#### Mentor: Ioannis Intzes
##### Students: Spyridon Tsioupros, Eumorfia Sidiroglou, Georgios Vellios


# What is a Pseudo Random Number Generator 

This circuit is a Pseudo Random Number Generator [(PRNG)](https://en.wikipedia.org/wiki/Pseudorandom_number_generator) 

A pseudorandom number generator (PRNG), also known as a deterministic random bit generator (DRBG), is an algorithm for generating a sequence of numbers whose properties approximate the properties of sequences of random numbers. The PRNG-generated sequence is not truly random, because it is completely determined by an initial value, called the PRNG's seed (which may include truly random values).

###### There are also Real Random Number Generator [(TRNG)](https://en.wikipedia.org/wiki/Hardware_random_number_generator)
###### is a device that generates random numbers from a physical process capable of producing entropy (in other words, the device always has access to a physical entropy source)


# Implementation details

-In this project as source of pseudo-randomness we used 2 LFSR's. One that works with 8-bit and one with 16-bit. The circuit don't have input data,  just 1 clock and 1 enable pin. The output will be on two 7 segment displays, so 14 output pins. <br />
-The 16-bit LFSR produces the input of a 16-to-8 multiplexer and the 8-bit LFSR produces the selection bits of 16-to-8 multiplexer.  <br />
-The 16-to-8 multiplexer is implemented by 8 2-to-1 multiplexers.  <br />
-In the final stage the data are converted to BCD format and are shown in two 7-segment displays. The format is hexadecimal.

| # | Input  | Output |
| ----- | ----- | ------ |
| 0     | CLK | Segment0 A |
| 1     | EN | Segment0 B |
| 2     | RST_N | Segment0 C |
| 3     | NONE | Segment0 D |
| 4     | NONE | Segment0 E |
| 5     | NONE | Segment0 F |
| 6     | NONE | Segment0 G |
| 7     | NONE | Segment1 A |
| 8     | NONE | Segment1 B |
| 9     | NONE | Segment1 C |
| 10    | NONE | Segment1 D |
| 11    | NONE | Segment1 E |
| 12    | NONE | Segment1 F |
| 13    | NONE | Segment1 G |

This is the 2d photo of gds file of chip
![2d-photo](https://github.com/Spiros7bit/tt04-submission-test/blob/main/2d.png)


## Test

Test done in FPGA Cyclone V [De1-Soc Board](https://www.intel.com/content/www/us/en/partner/showcase/offering/a5b3b0000004cbaAAA/de1soc-board.html)

## Idea

The idea for the implementation of this cell came from the paper: [Dopingless Transistor Based Hybrid Oscillator Arbiter Physical Unclonable Function](https://ieeexplore.ieee.org/abstract/document/7987589)

----
# What is Tiny Tapeout?

TinyTapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real chip!

Go to https://tinytapeout.com for instructions!

## How to change the Wokwi project

Edit the [info.yaml](info.yaml) and change the wokwi_id to match your project.

## How to enable the GitHub actions to build the ASIC files

Please see the instructions for:

- [Enabling GitHub Actions](https://tinytapeout.com/faq/#when-i-commit-my-change-the-gds-action-isnt-running)
- [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## How does it work?

When you edit the info.yaml to choose a different ID, the [GitHub Action](.github/workflows/gds.yaml) will fetch the digital netlist of your design from Wokwi.

After that, the action uses the open source ASIC tool called [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/) to build the files needed to fabricate an ASIC.

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://discord.gg/rPK2nSjxy8)

## What next?

- Share your GDS on Twitter, tag it [#tinytapeout](https://twitter.com/hashtag/tinytapeout?src=hashtag_click) and [link me](https://twitter.com/matthewvenn)!
