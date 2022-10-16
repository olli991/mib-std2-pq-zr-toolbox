# ------------------------------------------------------------------------------
# --- Quick 'n' dirty MCF file extractor
#
# File:        extract-mcf.py
# Author:      Jille, sVn, lprot
# Purpose:     Extraction of images from images.mcf of MIB STD2 PQ/ZR FWs
# Credits:     Partially based on code supplied by booto @ https://goo.gl/GqSfpt
# Changelog:   v1: Initial version
#              v2: Parsing of ImageIdMap.res added
#              v3: Python 3 support
#              v4: Moving and renaming skin0 files.
#              v5: The script works w/o any command line params now
# ------------------------------------------------------------------------------

import sys
if sys.version_info[0] < 3:
    raw_input("Install Python 3 or newer!\nPress Enter to exit...")
    sys.exit(1)

import os, struct, zlib
from shutil import copyfile

try:
    from PIL import Image, ImageFont, ImageDraw
except ImportError:
    print("  You are missing the PIL module!\n"
          "  install it by running:\n"
          "  pip install image")
    input("\nPress Enter to exit...")
    sys.exit(1)

out_dir = mcf_path = os.getcwd()
print('Parsing images.mcf...')
mcf_data = open(mcf_path + '\images.mcf', 'rb').read()

offset = 0
counterRGBA = 0
counterL = 0
counterLA = 0
num_mifIDs2 = 0

offset = 1  # skip the first bytes, makes comparing easier
(magic,) = struct.unpack_from('<3s', mcf_data, offset) #'<4s'='<' little-endian, 's' is type char, '6s' Array of 6 chars; get first entry of the returned tuple
if magic != str('MCF').encode("UTF-8"):  # corresponds to MCF file starting
    print('This is not a correct images.mcf file!')
    input("\nPress Enter to exit...")
    sys.exit(1)

filepath, filename = os.path.split(mcf_path)

offset = 32
(size_of_TOC,) = struct.unpack_from('<I', mcf_data, offset)

data_start = size_of_TOC + 56

offset = 48
(num_files,) = struct.unpack_from('<L', mcf_data, offset)
print("TOC size = %s. Data start = %d. Number of files = %d" % (str(size_of_TOC), data_start, num_files))

# TOC
offset = 52
for image_id in range(0, int(num_files)):
    (file_type, file_id, file_offset, file_size) = struct.unpack_from('<4sIII', mcf_data, offset)
    offset += 16

offset = data_start

print_number = input("Do you want to print the image number on each image(y/n)?: ")
for image_id in range(0, int(num_files)):
    (type, file_id, always_8, zsize, max_pixel_count, always_1, unknown_16, width, height, image_mode,
    always__1) = struct.unpack_from('<4sIIIIIIhhhh', mcf_data, offset)
    # max_pixel_count = width * height and mulitplied by 1 on L-Mode and mulitplied by 4 on RGBA-Mode
    zlib_data_offset = offset + 36
    # offsethex = "%0.8X" % zlib_data_offset
    zlib_image = mcf_data[zlib_data_offset:zlib_data_offset + zsize]
    zlib_decompress = zlib.decompress(zlib_image)
    if image_mode == 4096:
        im = Image.frombuffer('L', (width, height), zlib_decompress, 'raw', 'L', 0, 1)
        counterL += 1
    if image_mode == 4356:
        im = Image.frombuffer('RGBA', (width, height), zlib_decompress, 'raw', 'RGBA', 0, 1)
        counterRGBA += 1
    if (print_number == "y"):
        draw = ImageDraw.Draw(im)
        draw.text((width / 2, height / 2), "%d" % image_id, 255, ImageFont.truetype("cour.ttf", 14))
    out_dir_unsorted = out_dir + "\\Unsorted\\"
    print("extracting %d to %simg_%d.png" % (image_id, out_dir_unsorted, image_id))
    if not os.path.exists(out_dir_unsorted):
        os.makedirs(out_dir_unsorted)
    out_path = os.path.join(out_dir_unsorted, 'img_%d.png' % image_id)
    im.save(out_path)
    offset = offset + zsize + 40

counter = counterL + counterLA + counterRGBA
rest = int(num_files) - counter
print("Done. Extracted %d of %d images (RGBA: %d, L-mode: %d, LA-mode: %d)" % (counter, num_files, counterRGBA, counterL, counterLA))
if rest > 0:
    print("WARNING! %d were not extracted for some reason!" % (rest))

# Try to open mapping file and map unsorted images with IDs to human readable paths and filenames
idmap_path = mcf_path + "\imageidmap.res"
try:
    idMapFile = open(idmap_path, "rb")
    print("\nFound imageidmap.res. Parsing...")
    seek = idMapFile.seek
    read = idMapFile.read

    # read header
    seek(12)
    data = read(4)
    if (data != str("Skr0").encode("UTF-8")):
        print('WARNING! Unknown imageidmap.res header detected!')

    # read the UID
    seek(16)
    data = read(4)
    (UID,) = struct.unpack('<I', data)
    print('UID: ' + str(UID))

    # read the number of IDs
    seek(24)
    data = read(4)
    (num_mifIDs,) = struct.unpack('<I', data)
    print('Number of IDs: ' + str(num_mifIDs))

    # start of TOC
    seek(32)

    i = 0
    filename_array = []
    mifid_array = []

    # Create array of paths and filenames
    while (i < num_mifIDs):
        data = read(4)
        (path_len,) = struct.unpack('<I', data)
        # the length of the path is in number of characters, but since it's utf binary data, x2
        path_len = (path_len * 2)
        # read the path, for as long as the lenght of this string
        path = read(path_len).decode('utf-16')
        filename_array.append(path.replace("/", "\\"))
        seek(4, 1)
        i += 1

    data = read(4)
    (num_mifIDs2,) = struct.unpack('<I', data)

    if (num_mifIDs2 != num_mifIDs):
        print('ERROR! The table is corrupt! Expected %s mifIDs, read %s' % (str(num_mifIDs), str(num_mifIDs2)))

    j = 0
    print('Copying %s images from "Unsorted" into "Images" folder with proper path and name...' % str(num_mifIDs2))
    while (j < num_mifIDs2):
        data = read(4)
        #print(idMapFile.tell())
        (mifID,) = struct.unpack_from('<I', data, 0)
        file_id = mifID - 1
        originalfilepath = os.path.join(out_dir_unsorted, 'img_%d.png' % file_id)
        newfilepath = out_dir + "\\Images\\" + filename_array[j]
        pngfilepath, pngfilename = os.path.split(newfilepath)
        print("Copying \\Unsorted\\img_%d.png to %s" % (j, "\\Images\\" + filename_array[j]))
        if not os.path.exists(pngfilepath):
            os.makedirs(pngfilepath, 0o777)
        if not os.path.exists(originalfilepath):
            print("Error: %s  missing!" % (originalfilepath))
        else:
            copyfile(originalfilepath, newfilepath)
        j += 1
    print('Done.')
except IOError:
    print('Skipped mapping paths and filenames. Could not open imageidmap.res!')
input("\nPress Enter to exit...")