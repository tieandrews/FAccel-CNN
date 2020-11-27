import tensorflow as tf
import numpy as np
from keras import backend as K
from tensorflow import keras
from tensorflow.keras import datasets, layers, utils, models
from tensorflow.keras import callbacks, preprocessing, optimizers

BATCH_SIZE = 128
EPOCHS = 100

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

model = inputs
model = layers.Conv2D(4, 3, strides=1, padding='same', use_bias=False)(model)
model = layers.MaxPooling2D(2, strides=2, padding='same')(model)
model = layers.Conv2D(8, 3, strides=1, padding='same', use_bias=False)(model)
model = layers.Activation('relu')(model)

model = layers.Conv2D(num_classes, 1, strides=1, padding='same', use_bias=False)(model)
model = layers.GlobalAveragePooling2D()(model)
model = layers.Activation('softmax', name='visualized_layer')(model)
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

