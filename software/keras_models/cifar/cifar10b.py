import tensorflow as tf
import numpy as np
from keras import backend as K
from tensorflow import keras
from tensorflow.keras import datasets, layers, utils, models
from tensorflow.keras import callbacks, preprocessing, optimizers
import os
import random
import ssl

ssl._create_default_https_context = ssl._create_unverified_context

seed_value = 9876
os.environ['PYTHONHASHSEED']=str(seed_value)
random.seed(seed_value)
np.random.seed(seed_value)
tf.compat.v1.set_random_seed(seed_value)
#session_conf = tf.ConfigProto(intra_op_parallelism_threads=1, inter_op_parallelism_threads=1)
#sess = tf.Session(graph=tf.get_default_graph(), config=session_conf)
#K.set_session(sess)

BATCH_SIZE = 32
EPOCHS = 500

(trainX, trainY), (testX, testY) = datasets.cifar10.load_data()
if K.image_data_format == 'channels_first':
    trainX = trainX.reshape(trainX.shape[0], 3, 32, 32)
    testX = testX.reshape(testX.shape[0], 3, 32, 32)
    input_shape = (3, 32, 32)
else:
    trainX = trainX.reshape(trainX.shape[0], 32, 32, 3)
    testX = testX.reshape(testX.shape[0], 32, 32, 3)
    input_shape = (32, 32, 3)
trainX = trainX.astype('float32') / 255.0
testX = testX.astype('float32') / 255.0
num_classes = len(np.unique(trainY))
trainY = utils.to_categorical(trainY, num_classes)
testY = utils.to_categorical(testY, num_classes)

def conv(model, width, depth, dropout):
    m = [None]*(width)
    for j in range(width):
        m[j] = model
        for i in range(depth):
            m[j] = layers.Conv2D(1, 3, strides=1, padding='same', use_bias=False)(m[j])
            m[j] = layers.SpatialDropout2D(dropout)(m[j])
            m[j] = layers.Activation('elu')(m[j])
    return layers.Concatenate()(m)

###############################################################################
inputs = layers.Input(shape=input_shape)

model = inputs
"""
model = conv(model, 6, 3, 0.01)
model = conv(model, 12, 3, 0.01)
#model = conv(model, 12, 3, 0.01)
#model = conv(model, 12, 3, 0.01)
model = conv(model, 19, 3, 0.01)
model = layers.MaxPooling2D(2, strides=2, padding='same')(model)
#model = conv(model, 19, 3, 0.01)
#model = conv(model, 19, 3, 0.01)
#model = conv(model, 19, 3, 0.01)
model = conv(model, 19, 3, 0.01)
model = conv(model, 28, 3, 0.01)
model = layers.MaxPooling2D(2, strides=2, padding='same')(model)
model = conv(model, 35, 3, 0.05)
model = conv(model, 43, 4, 0.1)
"""
model = layers.Conv2D(6, 3, strides=1, padding='same', use_bias=False)(model)
model = layers.SpatialDropout2D(0.1)(model)
model = layers.Activation('elu')(model)
model = layers.Conv2D(12, 3, strides=1, padding='same', use_bias=False)(model)
model = layers.SpatialDropout2D(0.1)(model)
model = layers.Activation('elu')(model)
model = layers.Conv2D(19, 3, strides=1, padding='same', use_bias=False)(model)
model = layers.SpatialDropout2D(0.1)(model)
model = layers.Activation('elu')(model)
model = layers.MaxPooling2D(2, strides=2, padding='same')(model)
model = layers.Conv2D(19, 3, strides=1, padding='same', use_bias=False)(model)
model = layers.SpatialDropout2D(0.1)(model)
model = layers.Activation('elu')(model)
model = layers.Conv2D(28, 3, strides=1, padding='same', use_bias=False)(model)
model = layers.SpatialDropout2D(0.1)(model)
model = layers.Activation('elu')(model)
model = layers.MaxPooling2D(2, strides=2, padding='same')(model)
model = layers.Conv2D(35, 3, strides=1, padding='same', use_bias=False)(model)
model = layers.SpatialDropout2D(0.1)(model)
model = layers.Activation('elu')(model)
model = layers.Conv2D(43, 3, strides=1, padding='same', use_bias=False)(model)
model = layers.SpatialDropout2D(0.2)(model)
model = layers.Activation('elu')(model)
#model = layers.MaxPooling2D(2, strides=2, padding='same')(model)


model = layers.Conv2D(num_classes, 1, strides=1, padding='same', use_bias=False)(model)
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

