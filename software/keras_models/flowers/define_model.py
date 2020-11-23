from numpy.random import seed
seed(1234)
from tensorflow import set_random_seed
set_random_seed(1234)

from keras.models import Model
from keras.layers import Input, Conv2D, Activation, MaxPooling2D
from keras.layers import Dropout, Dense, Flatten, Concatenate, Add, GlobalMaxPooling2D
from keras.layers import GlobalAveragePooling2D, SpatialDropout2D, Concatenate
from keras.activations import relu, softmax
from keras.optimizers import SGD, RMSprop, Adadelta
from keras.applications import MobileNet
from keras.preprocessing.image import ImageDataGenerator
from keras.callbacks import EarlyStopping, ModelCheckpoint

M1 = (1,1)
M2 = (2,2)
M3 = (3,3)
M7 = (7,7)

###############################################################################
def model_a(input_shape, categories):
    input_tensor = Input(input_shape)
    
    x = Conv2D(filters=8, kernel_size=M1, strides=M1, padding='same', use_bias=False)(input_tensor)
    x = Activation('relu')(x)
    x = MaxPooling2D(pool_size=M3, strides=M1, padding='same')(x)

    x = Conv2D(filters=16, kernel_size=M1, strides=M1, padding='same', use_bias=False)(x)
    x = SpatialDropout2D(0.05)(x)
    x = Activation('relu')(x)
    x = MaxPooling2D(pool_size=M3, strides=M2, padding='same')(x)
    
    x = Conv2D(filters=32, kernel_size=M3, strides=M1, padding='same', use_bias=False)(x)
    x = SpatialDropout2D(0.05)(x)
    x = Activation('relu')(x)
    x = MaxPooling2D(pool_size=M3, strides=M2, padding='same')(x)

    x = Conv2D(filters=categories, kernel_size=M1, strides=M1, padding='same', use_bias=False)(x)
    x = SpatialDropout2D(0.1)(x)
    #x = Activation('relu')(x)
    x = MaxPooling2D(pool_size=M3, strides=M1, padding='same')(x)

    x = GlobalAveragePooling2D()(x)    
    x = Activation('softmax')(x)
    
    model = Model(inputs = input_tensor, outputs = x)
    sgd = SGD(lr=0.001, decay=0.0001, momentum=0.9, nesterov=True)
    rms = RMSprop(lr=0.001, decay=0.0001)
    add = Adadelta(lr=0.001, decay=0.0001)
    model.compile(optimizer = 'rmsprop', loss = 'categorical_crossentropy', metrics = ['accuracy'])
    model.summary()    
    return model


###############################################################################
    
def train_model(model, train_folder, test_folder, input_size, batch_size,
        steps_per_epoch, epochs):
    training_data_generator = ImageDataGenerator(
        rotation_range=45,
        width_shift_range=0.2,
        height_shift_range=0.2,
        rescale=1./255,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True,
        fill_mode='nearest'
        #zca_whitening=True
    )
    testing_data_generator = ImageDataGenerator(
       rescale = 1. / 255
    )
    training_set = training_data_generator.flow_from_directory(train_folder,
        target_size = (input_size, input_size),
        batch_size = batch_size,
        class_mode = 'categorical',
        shuffle = True)
    test_set = testing_data_generator.flow_from_directory(test_folder,
        target_size = (input_size, input_size),
        batch_size = batch_size,
        class_mode = 'categorical',
        shuffle = True)
    early_stop = EarlyStopping(monitor='loss',
        min_delta=0.001,
        patience=3,
        mode='min', 
        verbose=1)
    checkpoint = ModelCheckpoint('best_model.h5',
        monitor='loss', 
        verbose=1, 
        save_best_only=True, 
        mode='min',
        period=1)
    history = model.fit_generator(training_set,
        steps_per_epoch = steps_per_epoch,
        epochs = epochs,
        verbose = 1,
        validation_data=test_set,
        validation_steps=100,
        callbacks = [early_stop,checkpoint])

