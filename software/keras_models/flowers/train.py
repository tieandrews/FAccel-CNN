import matplotlib.pyplot as plt
import numpy as np
import os
import cv2
import shutil, random
import define_model

from keras.models import Model
from keras.layers import Input, Conv2D, Activation, MaxPooling2D, BatchNormalization
from keras.layers import Dropout, Dense
from keras.layers import GlobalAveragePooling2D
from keras.layers.merge import add, concatenate
from keras.preprocessing.image import ImageDataGenerator
from keras.activations import relu, softmax
from keras.callbacks import EarlyStopping, ModelCheckpoint
from keras.optimizers import SGD, Adam
from keras import regularizers
from sklearn.model_selection import train_test_split
from numpy import savetxt, asarray
from os import listdir, remove
from keras.applications import MobileNet

# turn off GPU inference
os.environ['CUDA_VISIBLE_DEVICES'] = '-1'
# and other noisy messages
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

# Define hyperparameters
INPUT_SIZE = 64
BATCH_SIZE = 64
STEPS_PER_EPOCH = 512 #8192//BATCH_SIZE
EPOCHS = 500
TRAIN_FOLDER = './train/'
TEST_FOLDER = './test/'

M1 = (1,1)
M2 = (2,2)
M3 = (3,3)

# count training labels
CATEGORIES = len(os.listdir(TRAIN_FOLDER))

model = define_model.model_a((INPUT_SIZE, INPUT_SIZE, 3), CATEGORIES)

define_model.train_model(model,
    TRAIN_FOLDER,
    TEST_FOLDER,
    INPUT_SIZE,
    BATCH_SIZE,
    STEPS_PER_EPOCH, EPOCHS)

