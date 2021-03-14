# ----------------------------------------------------------
# --- Quick 'n' dirty startup_x.boot file compressor
#
# File:        compress-startup_x.boot.py
# Author:      Jille
# Revision:    1
# Purpose:     Compress MIB2 images in mcf file
# Comments:    Usage: compress-startup_x.boot.py <original-file> <new-file> <imagesdir>
# Changelog:   v1:      initial version
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

if len(sys.argv) != 4:
    print("Usage: compress-startup_x.boot.py <original-file> <new-file> <imagesdir>")
    sys.exit(1)

out_dir = sys.argv[3]
if not os.path.exists(out_dir):
    print("Image folder does not exist.")
    sys.exit(1)

data = open(sys.argv[1], 'rb').read()
offset = 12
(cmd_block_len,) = struct.unpack_from('<I', data, offset)

datasize_offset = toc_offset = cmd_block_len + 24

offset = cmd_block_len + 24

(data_block_size, num_files,) = struct.unpack_from('<II', data, datasize_offset)
print("Num of files: \t %d" % num_files)
offset = offset + 8
i = 0
offset_array = []

while i < num_files:
    (file_offset,) = struct.unpack_from('<I', data, offset)
    offset = offset + 4
    offset_array.append(file_offset)
    i = i + 1
zsize = 0

j = 0

offset_data_start = offset_array[0]
print(("data start offset: %d" % offset_data_start))

offset_new = offset_data_start

original_header = data[0:5208]

images = bytes()
struct_toc = bytes()

struct_data = bytes()
data_block_size_new = 0

# loop through all the images and pack them into the cff
for j in range(0, int(num_files)):
    offset = offset_new
    fileimage_dir = os.path.join(out_dir, 'img_%d.png' % j)

    print("importing img_%d.png to %s" % (j, sys.argv[2]))
    if not os.path.exists(fileimage_dir):
        print("file %s does not exist." % filepath_original.decode("utf-8"))
        sys.exit(1)
    im = Image.open(fileimage_dir)
    if im.mode != "LA":
        print("! WARNING: img_%d.png isn't LA format. Make sure the image is saved as LA-format." % j)
        print("Converting img_%d.png to LA format. This image will not have any transparency." % j)
        im = im.convert('LA')
    width, height = im.size
    image_bytes = im.tobytes('raw')

    zlib_level = 9
    image_zlib = zlib.compress(image_bytes, zlib_level)
    zlib_size = sys.getsizeof(image_zlib)
    struct_data = struct_data + struct.pack('<II', width, height) + image_zlib
    struct_toc = struct_toc + struct.pack('<I', offset)

    offset_new = offset + zlib_size - 25
    data_block_size_new = data_block_size_new + (zlib_size - 25) + 8
    j = j + 1

struct_datablocksize = struct.pack('I', data_block_size_new + (num_files * 4))
print("Datablock size:", data_block_size_new)

struct_numfiles = struct.pack('I', 38)
print("Writing %d images to %s " % (num_files, sys.argv[2]))
f = open(sys.argv[2], 'wb')
f.write(original_header + struct_datablocksize + struct_numfiles + struct_toc + struct_data)
print("\nAll files are imported to %s" % sys.argv[2])
f.close()
