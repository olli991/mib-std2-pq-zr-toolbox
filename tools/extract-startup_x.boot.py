#----------------------------------------------------------------------------
#--- startup_x.boot command list and images extractor
#
# Authors:     Jille, jtomtos, lprot
# Revision:    3
# Changelog:   1: Initial version
#              2: mib2image.py added
#              3: By default, extracts all *.boot files in the current folder
#----------------------------------------------------------------------------
import sys

if sys.version_info[0] < 3:
    raw_input("You need to run this with Python 3!\nPress Enter to exit...")
    sys.exit(1)

import os, struct, zlib
try:
    from PIL import Image
except ImportError:
    print("  You are missing the PIL module!\n"
          "  install it by running:\n"
          "  pip install image")
    input("\nPress Enter to exit...")
    sys.exit(1)

def extract(filename, out_dir):
    print("\nOpening %s" % filename)
    data = open(filename, 'rb').read()  # Opens filename in mode 'r' reading and 'b' binary mode
    (cmd_block_len,) = struct.unpack_from('<I', data, 12)

    if not os.path.exists(out_dir):
        print("Creating folder %s" % out_dir)
        os.mkdir(out_dir)

    # extracting command list 
    cmd_offset = 20
    i = 0 
    num_blocks = cmd_block_len / 32
    print("Number of commands in command list: %d. Extracting to animation.csv..." % num_blocks)
    f_commands = open(os.path.join(out_dir, 'animation.csv'), 'wt')
    while i < num_blocks:
        comment = ''
        (nn,cmd,arg1,arg2,arg3,arg4,arg5,arg6) = struct.unpack_from('<IIIIIIII', data, cmd_offset)
        match cmd:
            case 0:
                comment = 'BEGIN'
            case 1:
                comment = 'END'
            case 2:
                comment = 'CLEAR SCREEN'
            case 3:
                comment = 'SET RESOLUTION '+str(arg3).zfill(2)+'x'+str(arg4)
            case 4:
                comment = 'DRAW BASE img_'+str(arg1).zfill(2)+' at position (x:'+str(arg3)+', y:'+str(arg4)+')'
            case 5:
                comment = 'DRAW STICKER img_'+str(arg1).zfill(2)+' at position (x:'+str(arg3)+', y:'+str(arg4)+')'
            case 6:
                comment = 'WAIT '+str(arg1*0.01)+' sec.'
            case 7:
                comment = 'START/END ANIMATION'
            case 10:
                comment = 'IF NO_HIFI'
            case 11:
                comment = 'ELSE'
            case 12:
                comment = 'ENDIF'
            case _:
                comment = 'UNKNOWN'
        f_commands.write("\"{}\";\"{}\";\"{}\";\"{}\";\"{}\";\"{}\";\"{}\";\"{}\";\"{}\"\n".format(nn,cmd,arg1,arg2,arg3,arg4,arg5,arg6,comment))

        cmd_offset += 32
        i += 1
    f_commands.close()

    #extracting images
    offset = cmd_block_len + 24
    (data_block_size, num_files,) = struct.unpack_from('<II', data, offset)
    print("Number of images: %d. Exracting..." % num_files)
    offset += 8
    i = 0
    offset_array = []

    # go through the entire table of contents to get all paths and offsets
    while i < num_files:
        (file_offset,) = struct.unpack_from('<I', data, offset)
        offset += 4
        offset_array.append(file_offset)
        i += 1

    zsize = j = 0
    while j < num_files:
        offset = offset_array[j]
        # read data at offset
        (width, height) = struct.unpack_from('<II', data, offset)
        offset += 8
        k = j + 1

        if j == num_files - 1:
            zsize = data_block_size  # remaining piece of data block after all is done
        else:
            zsize = (offset_array[k] - offset_array[j]) - 8
            data_block_size = data_block_size - (zsize + 8)

        zlib_image = data[offset:offset + zsize]

        image_decompressed = zlib.decompress(zlib_image)
        im = Image.frombuffer('LA', (width, height), image_decompressed, 'raw', 'LA', 0, 1)
        out_path = os.path.join(out_dir, 'img_' + str(j).zfill(2) + '.mib')
        print("Saving %s Width/Height=%dx%d" %(out_path, width, height))
        im.save(out_path, 'png')
        j += 1

match len(sys.argv):
    case 3:
        extract(sys.argv[1], sys.argv[2])
    case 2:
        extract(sys.argv[1], '.\\' + os.path.splitext(sys.argv[1])[0])
    case 1:
        for filename in os.scandir('.\\'):
            if filename.is_file() and filename.name.endswith('.boot'):
                extract(filename.name, os.path.splitext(filename)[0])
    case _:
        print("Usage: extract-startup_x.boot.py <filename> <outdir>")
        print("   or: extract-startup_x.boot.py <filename>")
        print("   or: extract-startup_x.boot.py")
        input("\nPress Enter to exit...")
        sys.exit(1)

print("Extracting done. Enjoy!")
input("\nPress Enter to exit...")
sys.exit(1)