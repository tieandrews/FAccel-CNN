import tensorflow as tf
import numpy as np
from keras import backend as K
from tensorflow import keras
from tensorflow.keras import datasets, layers, utils, models
from tensorflow.keras import callbacks, preprocessing, optimizers
import os
import random

seed_value = 9876
os.environ['PYTHONHASHSEED']=str(seed_value)
random.seed(seed_value)
np.random.seed(seed_value)
tf.compat.v1.set_random_seed(seed_value)
session_conf = tf.ConfigProto(intra_op_parallelism_threads=1, inter_op_parallelism_threads=1)
sess = tf.Session(graph=tf.get_default_graph(), config=session_conf)
K.set_session(sess)

BATCH_SIZE = 32
EPOCHS = 500

(trainX, trainY), (testX, testY) = datasets.mnist.load_data()
if K.image_data_format == 'channels_first':
    trainX = trainX.reshape(trainX.shape[0], 1, 28, 28)
    testX = testX.reshape(testX.shape[0], 1, 28, 28)
    input_shape = (1, 28, 28)
else:
    trainX = trainX.reshape(trainX.shape[0], 28, 28, 1)
    testX = testX.reshape(testX.shape[0], 28, 28, 1)
    input_shape = (28, 28, 1)
trainX = trainX.astype('float32') / 255.0
testX = testX.astype('float32') / 255.0
num_classes = len(np.unique(trainY))
trainY = utils.to_categorical(trainY, num_classes)
testY = utils.to_categorical(testY, num_classes)

###############################################################################
inputs = layers.Input(shape=input_shape)

m = [None]*10
for j in range(10):
    m[j] = inputs
    #for i in range(3):
        #m[j] = layers.Conv2D(1, 3, strides=1, padding='same', use_bias=False)(m[j])
        #m[j] = layers.MaxPooling2D(2, strides=1, padding='same')(m[j])
        #m[j] = layers.Activation('relu')(m[j])
    m[j] = layers.Conv2D(1, 3, strides=1, padding='same', use_bias=False)(m[j])
    m[j] = layers.Activation('elu')(m[j])
    m[j] = layers.Conv2D(1, 3, strides=1, padding='same', use_bias=False)(m[j])
    #m[j] = layers.MaxPooling2D(2, strides=2, padding='same')(m[j])
    m[j] = layers.Activation('elu')(m[j])
    m[j] = layers.Conv2D(1, 3, strides=1, padding='same', use_bias=False)(m[j])
    m[j] = layers.Activation('elu')(m[j])
    m[j] = layers.Conv2D(1, 3, strides=1, padding='same', use_bias=False)(m[j])
    #m[j] = layers.MaxPooling2D(2, strides=2, padding='same')(m[j])
    m[j] = layers.Activation('elu')(m[j])
    m[j] = layers.Conv2D(1, 1, strides=1, padding='same', use_bias=False)(m[j])
    #m[j] = layers.Activation('relu')(m[j])

model = layers.Concatenate()(m)
model = layers.MaxPooling2D(2, strides=1, padding='same')(model)

#model = layers.Conv2D(num_classes, 1, strides=1, padding='same', use_bias=False)(model)
model = layers.GlobalAveragePooling2D()(model)
model = layers.Activation('softmax')(model)
###############################################################################

model = models.Model(inputs=inputs, outputs=model)
model.compile(optimizer='rmsprop', loss='categorical_crossentropy', metrics=['accuracy'])
model.summary()
model.save('original.h5')

cp = callbacks.ModelCheckpoint('best_mnist.h5',
    monitor='loss',
    verbose=1,
    save_best_only=True,
    mode='min')
es = callbacks.EarlyStopping(
    monitor='loss',
    min_delta=0.001,
    patience=3,
    mode='min',
    verbose=1)

fit = model.fit(
    trainX, trainY, 
    epochs=EPOCHS, 
    batch_size=BATCH_SIZE, 
    validation_data=(testX, testY), 
    callbacks=[es, cp],
    verbose=1)

