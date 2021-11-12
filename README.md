Work in progress game demo for the [Pimoroni Picosystem](https://shop.pimoroni.com/products/picosystem). Don't expect this to do much right now.

## Resources
I use GIMP to create 8-bit 8x8 grayscale bitmaps, which are transformed by `res/make_resources.py` into 2-bit ELF objects and statically linked into libresources.a. Those symbols are imported by `src/bitmaps.ads`.

You need a GNAT ARM ELF toolchain in your PATH and the Python Pillow Library (python3-pil) installed to run make_resources.

    cd res
    python3 make_resources.py
    cd ..

## Compile

    alr build

## Install
If you don't have a SWD debugger connected to your Picosystem, you can generate a .uf2 binary that can be loaded over USB by holding the X button while plugging it in. elf2uf2 comes from [pico-sdk](https://github.com/raspberrypi/pico-sdk) and needs to be in your PATH.

    elf2uf2 bin/main bin/main.uf2
