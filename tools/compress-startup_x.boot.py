# -------------------------------------------------------------------------------------
# startup_x.boot images compressor
# Authors:      Jille, jtomtos
# Revision:     2
# -------------------------------------------------------------------------------------
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

if len(sys.argv) != 4:
    print("Usage: compress-startup_x.boot.py <original-file> <new-file> <imagesdir>")
    input("\nPress Enter to exit...")
    sys.exit(1)

out_dir = sys.argv[3]
if not os.path.exists(out_dir):
    print("Image folder does not exist.")
    input("\nPress Enter to exit...")
    sys.exit(1)

data = open(sys.argv[1], 'rb').read()
(cmd_block_len,) = struct.unpack_from('<I', data, 12)

datasize_offset = toc_offset = cmd_block_len + 24

offset = cmd_block_len + 24

(data_block_size, num_files,) = struct.unpack_from('<II', data, datasize_offset)
print("Number of images to compress: %d" % num_files)
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
print("Data start offset: %d" % offset_data_start)

offset_new = offset_data_start

#original_header = data[0:5208]
original_header = data[0:toc_offset]

images = bytes()
struct_toc = bytes()

struct_data = bytes()
data_block_size_new = 0

# loop through all the images and pack them into the cff
for j in range(0, int(num_files)):
    offset = offset_new
    fileimage_dir = os.path.join(out_dir, 'img_' + str(j).zfill(2) + '.mib')
    print("Compressing %s" % fileimage_dir)
    if not os.path.exists(fileimage_dir):
        print("ERROR! File %s does not exist." % filepath_original.decode("utf-8"))
        input("\nPress Enter to exit...")
        sys.exit(1)
    im = Image.open(fileimage_dir)
    if im.mode != "LA":
        print("WARNING! img_%d.mib isn't LA format. Make sure the image is saved as LA-format." % j)
        print("Converting img_%d.mib to LA format. This image will not have any transparency." % j)
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
print("Images are compressed into datablock of %d bytes" % data_block_size_new)

struct_numfiles = struct.pack('I', num_files)
print("Writing the datablock into %s " % sys.argv[2])
f = open(sys.argv[2], 'wb')
f.write(original_header + struct_datablocksize + struct_numfiles + struct_toc + struct_data)
f.close()

print("\nDone compressing images. Enjoy!")
input("\nPress Enter to exit...")
sys.exit(1)