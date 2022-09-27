# ------------------------------------------------------------------
# startup_x.boot images extractor
# Authors:      Jille, jtomtos
# Revision:    	2
# ------------------------------------------------------------------
import os, struct, sys, zlib

if sys.version_info[0] < 3:
    raw_input("You need to run this with Python 3!\nPress Enter to exit...")
    sys.exit(1)

try:
    from PIL import Image
except ImportError:
    print("  You are missing the PIL module!\n"
          "  install it by running:\n"
          "  pip install image")
    input("\nPress Enter to exit...")
    sys.exit(1)

if len(sys.argv) != 3:
    print("Usage: extract-startup_x.boot.py <filename> <outdir>")
    input("\nPress Enter to exit...")
    sys.exit(1)

out_dir = sys.argv[2]
if not os.path.exists(out_dir):
    os.mkdir(out_dir)

def mkdir_path(path):
    if not os.access(path, os.F_OK):
        os.mkdir(path)

data = open(sys.argv[1], 'rb').read()  # Open File with path in sys.argv[1] in mode 'r' reading and 'b' binary mode
(cmd_block_len,) = struct.unpack_from('<I', data, 12)

# extracting command list 
print("Extracting command list...")
f_commands = open(os.path.join(out_dir, 'animation.csv'), 'wt')
cmd_offset = 20
i=0 
num_blocks = cmd_block_len / 32
print("Number of commands: %d" % num_blocks)
while i < num_blocks:
    comment = ''
    (nn,cmd,arg1,arg2,arg3,arg4,arg5,arg6) = struct.unpack_from('<IIIIIIII', data, cmd_offset)
    match cmd:
        case 0:
            comment = 'BEGIN'        
        case 1:
            comment = 'END'
        case 4:
            comment = 'DRAW BASE img_'+str(arg1).zfill(2)+' at position (x:'+str(arg3)+', y:'+str(arg4)+')'
        case 5:
            comment = 'DRAW STICKER img_'+str(arg1).zfill(2)+' at position (x:'+str(arg3)+', y:'+str(arg4)+')'
        case 6:
            comment = 'WAIT '+str(arg1*0.01)+' sec.'
        case 10:
            comment = 'IF NO_HIFI'
        case 11:
            comment = 'ELSE'
        case 12:
            comment = 'ENDIF'
    
    f_commands.write("\"{}\";\"{}\";\"{}\";\"{}\";\"{}\";\"{}\";\"{}\";\"{}\";\"{}\"\n".format(nn,cmd,arg1,arg2,arg3,arg4,arg5,arg6,comment))

    cmd_offset = cmd_offset + 32
    i = i + 1
f_commands.close()
print("Command list extracted to animation.csv")

offset = cmd_block_len + 24
(data_block_size, num_files,) = struct.unpack_from('<II', data, offset)
print("Number of images: %d" % num_files)
offset = offset + 8
i = 0
offset_array = []

# go through the entire table of contents to get all paths and offsets
while i < num_files:
    (file_offset,) = struct.unpack_from('<I', data, offset)
    offset = offset + 4
    offset_array.append(file_offset)
    i = i + 1
zsize = 0
j = 0
print("Extracting images...")
while j < num_files:
    offset = offset_array[j]
    # read data at offset
    (width, height) = struct.unpack_from('<II', data, offset)
    offset = offset + 8
    k = j + 1

    if j == num_files - 1:
        zsize = data_block_size  # remaining piece of data block after all is done
    else:
        zsize = (offset_array[k] - offset_array[j]) - 8
        data_block_size = data_block_size - (zsize + 8)

    zlib_image = data[offset:offset + zsize]

    image_decompressed = zlib.decompress(zlib_image)
    # create path
    if not os.path.exists(out_dir):
        os.makedirs(out_dir)
    out_path = os.path.join(out_dir, 'img_' + str(j).zfill(2) + '.mib')

    print("Extracting %s %dx%d" %(out_path, width, height))
    im = Image.frombuffer('LA', (width, height), image_decompressed, 'raw', 'LA', 0, 1)
    im.save(out_path, 'png')

    j = j + 1

print("Done extracting images. Enjoy!")
input("\nPress Enter to exit...")
sys.exit(1)
