# ----------------------------------------------------------
# --- Quick 'n' dirty startup_x.boot file extractor
#
# File:        	extract-startup_x.boot.py
# Author:      	Jille
# Revision:    	1
# Purpose:     	startup_x.boot file extractor
# Comments:    	Usage: extract-startup_x.boot.py <filename> <outdir>
# Changelog:	First edition
# ----------------------------------------------------------

import os
import struct
import sys
import zlib

if sys.version_info[0] < 3:
    sys.exit("You need to run this with Python 3")

try:
    from PIL import Image
except ImportError:
    sys.exit("  You are missing the PIL module!\n"
             "  install it by running: \n"
             "  pip install image")

if len(sys.argv) != 3:
    print("usage: extract-startup_x.boot.py <filename> <outdir>")
    sys.exit(1)

out_dir = sys.argv[2]
if not os.path.exists(out_dir):
    os.mkdir(out_dir)


def mkdir_path(path):
    if not os.access(path, os.F_OK):
        os.mkdir(path)


data = open(sys.argv[1], 'rb').read()  # Open File with path in sys.argv[1] in mode 'r' reading and 'b' binary mode

offset = 12

(cmd_block_len,) = struct.unpack_from('<I', data, offset)

offset = cmd_block_len + 24
(data_block_size, num_files,) = struct.unpack_from('<II', data, offset)
print("Num of files: \t %d" % num_files)
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
print("Extracting files...")
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
    out_path = os.path.join(out_dir, 'img_%d.png' % j)

    print("Extracting", out_path, width, height)
    im = Image.frombuffer('LA', (width, height), image_decompressed, 'raw', 'LA', 0, 1)
    im.save(out_path)

    j = j + 1

print("Done extracting images. Enjoy!")
