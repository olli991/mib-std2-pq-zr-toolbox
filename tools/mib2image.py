#!/usr/bin/env python2

#   Gimp-Python - allows the writing of Gimp plugins in Python.
#   Copyright (C) 2003, 2005  Manish Singh <yosh@gimp.org>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

import string
import struct
import inspect
import math
import os.path

import gimp
from gimpfu import *
from array import *
import gtk


gettext.install("gimp20-python", gimp.locale_directory, unicode=True)


def load_mib2(filename, raw_filename):
    scrImg =  pdb.file_png_load(filename, raw_filename)
    
    wh = scrImg.width
    ht = scrImg.height
    
    srcLayer = scrImg.layers[0]
    srcRgn = srcLayer.get_pixel_rgn(0, 0, wh, ht, False, False)
    sp_size = len(srcRgn[0, 0])
    src_pixels = array("B", srcRgn[0:wh, 0:ht])
    
    sp_size = 2   # GRAYA
    dp_size = 3   # RGB
    dest_pixels = array("B", "\x00" * (wh * ht * dp_size))    
    
    gimp.progress_init("Updating image")
    for i in xrange(0, wh):
        for j in xrange(0, ht):
            src_pos = (i + wh * j) * sp_size
            dest_pos = (i + wh * j) * dp_size
            i2 = (i / 2) * 2
            src_pos2 = (i2 + wh * j) * sp_size
            srcPixel1 = src_pixels[src_pos: src_pos + sp_size]
            g = srcPixel1[1]    
           
            gb = src_pixels[src_pos2: src_pos2 + sp_size][0]
            gr = src_pixels[src_pos2 + sp_size: src_pos2 + sp_size + sp_size][0]
            
            b = max(min(g - 512 + (gr*4 + gb*8)/3, 255), 0)
            r = max(min(g - 512 + (gb*4 + gr*8)/3, 255), 0)
            
                                           
            pixel = array("B", [r, g, b])
               
            dest_pixels[dest_pos : dest_pos + dp_size] = pixel            
        gimp.progress_update(float(i)/float(wh))
       
    dstImg = gimp.pdb.gimp_image_new(wh, ht, RGB)
    dstLayer = pdb.gimp_layer_new(dstImg, wh, ht, RGB_IMAGE, "background", 100.0, NORMAL_MODE)
    dstImg.add_layer(dstLayer, 0)
    dstRgn = dstLayer.get_pixel_rgn(0, 0, wh, ht, True, False)
    dstRgn[0:wh, 0:ht] = dest_pixels.tostring() 
    return dstImg     
    

def fileMIB2save(image, drawable, filename, raw_filename, dummy, limcolors, extlbl):
    # height = 480
    # width = 800
    lbl_height = 100
    lbl_width = 480
    lbl_rect = [160,320,lbl_width+160,lbl_height+320]
    
    #if not ((image.width == width and image.height==height) or (image.width == lbl_width and image.height==lbl_height)):
    #    raise ValueError('Invalid resolution. Allowed only 800x480 or 480x100')
    if (image.width % 2 != 0):
        raise ValueError('Invalid resolution. Width must be even.')
    
    height = image.height
    width = image.width
    extlbl = extlbl and (image.width == 800 and image.height==480)
    
    #prepare source image
    img = pdb.gimp_image_duplicate(image)    
    try:
        #reduce colors to limcolors to fit 1mb limit       
        if (img.base_type != RGB):
            pdb.gimp_image_convert_rgb(img)
        srcLayer = img.flatten() 
        if (limcolors>0):    
            pdb.gimp_drawable_posterize(srcLayer, limcolors)            
            #
            # pdb.gimp_image_convert_indexed(img, NO_DITHER, MAKE_PALETTE, limcolors, False, True, "")
            # pdb.gimp_image_convert_rgb(img)
        #extract pixel array
        rgn = srcLayer.get_pixel_rgn(0, 0, width, height, False, False)
        sp_size = len(rgn[0, 0])       
        src_pixels = array("B", rgn[0:width, 0:height])
    finally:    
        pdb.gimp_image_delete(img)
        
        
    #prepare desination pixel array
    dp_size = 2   # GRAYA
    dest_pixels = array("B", "\x00" * (width * height * dp_size))
    dest_pixels_label = array("B", "\x00" * (lbl_width * lbl_height * dp_size))
    #start image converting
    gimp.progress_init("Updating image")
    for i in xrange(0, width):
        for j in xrange(0, height):
            src_pos = (i + width * j) * sp_size
            dest_pos = (i + width * j) * dp_size
                
            srcPixel = src_pixels[src_pos: src_pos + sp_size]
            r = srcPixel[0]
            g = srcPixel[1]
            b = srcPixel[2]

            if ((i % 2) == 0):
                r2 = src_pixels[src_pos + sp_size: src_pos + sp_size + sp_size][0]
                r = int(math.sqrt((r*r + r2*r2)/2))
                px = (((b - r)/2 + 128) + ((b - g)/2 + 128))/2   
            else:
                b2 = src_pixels[src_pos - sp_size: src_pos][2]
                b = int(math.sqrt((b*b + b2*b2)/2))
                px = (((r - b)/2 + 128) + ((r - g)/2 + 128))/2                    
                    
            pixel = array("B", [px, g])
                
            if (extlbl and (i >=lbl_rect[0]) and (i<lbl_rect[2]) and (j>=lbl_rect[1]) and (j<lbl_rect[3])):
                lbl_dest_pos = (i - lbl_rect[0] + lbl_width * (j - lbl_rect[1])) * dp_size
                dest_pixels_label[lbl_dest_pos : lbl_dest_pos + dp_size] = pixel
                pixel = array("B", [128, 0])
                                
            dest_pixels[dest_pos : dest_pos + dp_size] = pixel                
        gimp.progress_update(float(i)/float(width))
        
    #save results to the file
    newImg = gimp.pdb.gimp_image_new(width, height, GRAY)
    newLayer = pdb.gimp_layer_new(newImg, width, height, 3, "background", 100.0, NORMAL_MODE)
    newImg.add_layer(newLayer, 0)
    dstRgn = newLayer.get_pixel_rgn(0, 0, width, height, True, False)
    dstRgn[0:width, 0:height] = dest_pixels.tostring() 
    newLayer.flush()


    pdb.file_png_save(newImg, newLayer, filename, raw_filename, 0, 9, 0, 0, 0, 0, 0)
    #save label to the file
    if (extlbl):
        lblImg = gimp.pdb.gimp_image_new(lbl_width, lbl_height, GRAY)
        lblLayer = pdb.gimp_layer_new(lblImg, lbl_width, lbl_height, 3, "label", 100.0, NORMAL_MODE)
        lblImg.add_layer(lblLayer, 0)
        lblRgn = lblLayer.get_pixel_rgn(0, 0, lbl_width, lbl_height, True, False)
        lblRgn[0:lbl_width, 0:lbl_height] = dest_pixels_label.tostring() 
        lblLayer.flush()
        fpath = os.path.split(filename)
        fname = os.path.splitext(fpath[1])
        lbl_filename = os.path.join(fpath[0], fname[0]+"_lbl"+fname[1])

        pdb.file_png_save(lblImg, lblLayer, lbl_filename, lbl_filename, 0, 9, 0, 0, 0, 0, 0)
        #pdb.gimp_message(os.path.split(filename)[1])
    
def register_save():
    gimp.register_save_handler("file-mib2-save", "mib", "")
    
    
def register_load_handlers():
    gimp.register_load_handler('file-mib2-load', 'mib', '')
    pdb['gimp-register-file-handler-mime']('file-mib2-load', 'image/mib2')

register(
    "file-mib2-save",
    N_("Save MIB2STD boot image"),
    "Saves RGB picture as GraySacle with Alpha for MIB2STD Boot animation",
    "John Tomatos",
    "John Tomatos",
    "2021",
    N_("MIB2STD BOOT Image"),
    "RGB",
    [
        (PF_IMAGE, "image", "Input image", None),
        (PF_DRAWABLE, "drawable", "Input drawable", None),
        (PF_STRING, "filename", "The name of the file", None),
        (PF_STRING, "raw-filename", "The name of the file", None),
        (PF_BOOL, "dummy", _("dummy"), True),
        (PF_INT, "lim-colors", _("Limit colors to fit size limit (0 - No limit)"), 0),
        (PF_BOOL, "extlbl", _("_Extract label to separate file"), True)
    ],
    [],
    fileMIB2save, on_query=register_save,
    menu="<Save>", domain=("gimp20-python", gimp.locale_directory)
    )


register(
    'file-mib2-load', #name
    'load an mib boot animation (.mib) file', #description
    'load an mib boot animation (.mib) file',
    'John Tomatos', #author
    'John Tomatos', #copyright
    '2021', #year
    N_("MIB2STD BOOT Image"),
    None, #image type
    [   #input args. Format (type, name, description, default [, extra])
        (PF_STRING, 'filename', 'The name of the file to load', None),
        (PF_STRING, 'raw-filename', 'The name entered', None),
    ],
    [(PF_IMAGE, 'image', 'Output image')], #results. Format (type, name, description)
    load_mib2, #callback
    on_query = register_load_handlers,
    menu = "<Load>",
)


main()
