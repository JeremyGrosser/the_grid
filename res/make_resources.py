from PIL import Image
import subprocess
import os.path
import os


def make_elf(binary_file, elf_file):
    subprocess.call(['arm-eabi-objcopy',
        '--rename-section', '.data=.rodata,alloc,load,readonly,data,contents',
        '-I', 'binary',
        '-O', 'elf32-littlearm',
        '-B', 'arm',
        binary_file, elf_file])


def make_library(elf_files):
    subprocess.call(['arm-eabi-ar', 'rs', 'libresources.a'] + elf_files)


def to_binary(source, dest):
    '''
    Convert an 8-bit grayscale image to 2-bit binary
    '''
    print(source, '->', dest)
    n = 0
    p = 0
    with open(dest, 'wb') as fd:
        with Image.open(source) as im:
            for y in range(0, im.height):
                for x in range(0, im.width):
                    pixel = im.getpixel((x, y))
                    pixel = pixel >> 6
                    p |= pixel << ((x * 2) % 8)
                    n += 1
                    if n == 4:
                        b = p.to_bytes(1, 'little')
                        fd.write(b)
                        p = 0
                        n = 0



def main():
    objs = []
    for filename in os.listdir('art'):
        if not filename.endswith('.png'):
            continue
        png = os.path.join('art', filename)
        basename = filename.rsplit('.', 1)[0]
        binary = basename + '.bin'
        obj = basename + '.o'
        to_binary(png, binary)
        make_elf(binary, obj)
        objs.append(obj)

    make_library(objs)

if __name__ == '__main__':
    main()
