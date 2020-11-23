import os
import sys

stderr = sys.stderr
sys.stderr = open(os.devnull, 'w')
import keras
import cv2
import numpy as np
import tensorflow as tf
import time
from keras.models import load_model, model_from_json
from keras.preprocessing.image import img_to_array
from keras import backend as K
from numpy import loadtxt
from os import listdir
from os.path import isfile, join
sys.stderr = stderr

# turn off GPU inference
os.environ['CUDA_VISIBLE_DEVICES'] = '-1'
# and other noisy messages
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

if (len(sys.argv) != 4):
    print("usage <model.h5> <label.csv> <resolution>")
    print("example inference model.h5 label.csv 96")
    print("resolution is square 96x96 pixels input to the model")
    sys.exit()

model_file = sys.argv[1]
label_file = sys.argv[2]
image_size = int(sys.argv[3])
INFERENCE_FOLDER = './inference/'

label = sorted(loadtxt(label_file, dtype='str'))

# show the 'winning' label and score
def show_label(i, score):
    m = 0.0
    p = 0
    for x in range(len(label)):
        if (score[0][x] > m):
            m = score[0][x]
            p = x            
    #print('file',i,label[p], "{0:.3f}".format(m * 100.0),'%')
    return p, m

######################################################################
# load the model and set input image size
loaded_model = load_model(model_file)
print ("Model Loaded")
#loaded_model.summary()

# define my test images to run through keras inference
set_path = INFERENCE_FOLDER
test_set = [f for f in listdir(set_path) if isfile(join(set_path, f))]

print("inferencing ", len(test_set), " images")

# run the inference
wrong = 0
right = 0
start = time.time()
for i in test_set:
    image = cv2.imread(set_path + i)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image = cv2.resize(image, (image_size, image_size))
    image = image.astype("float") / 255.0
    image = img_to_array(image)
    image = np.expand_dims(image, axis=0)
    p, m = show_label(i, loaded_model.predict(image))
    if (label[p] in i):
        right = right + 1
    else:
        wrong = wrong + 1
end = time.time()
print ("correct = ", right)
print ("wrong = ", wrong)
print ("Percent = ", right / (right+wrong))
print ("Time = ", end - start)

