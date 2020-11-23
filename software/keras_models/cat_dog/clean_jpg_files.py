import os
import cv2
from os import walk

mypath = "e:\\High_Vis_Dataset\\"
f = []
for (dirpath, dirnames, filenames) in walk(mypath):
    f.extend(filenames)
    break

for i in f:
    image = cv2.imread(mypath + i)
    cx = image.shape[1]
    cy = image.shape[0]
    new_y = int((cy * 800)/ cx)
    # scale to 800 width
    new_image = cv2.resize(image, (800, new_y))
    cv2.imwrite("e:\\High_Vis_Dataset\\new\\" + i, new_image)
