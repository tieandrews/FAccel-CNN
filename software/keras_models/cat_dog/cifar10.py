import keras
from keras.datasets import cifar10
from keras.utils import to_categorical
from keras.models import Sequential
from keras.layers import Conv2D, Dense, Flatten
from keras.preprocessing.image import ImageDataGenerator

EPOCHS = 3

def define_model(train_x, train_y):
    model = Sequential()
    model.add(Conv2D(1, kernel_size=(5,5), strides=(1,1), padding='same', input_shape=(32,32,3)))
    model.add(Flatten())
    model.add(Dense(10, activation='softmax'))
    model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
    #model.fit(train_x, train_y, epochs=EPOCHS, verbose=1)
    return model
    
def add_layer(model, train_x, train_y):
    output_layer = model.layers[-1]
    model.pop()
    model.pop()
    for layer in model.layers:
        layer.trainable = False
    model.add(Conv2D(1, kernel_size=(5,5), strides=(1,1), padding='same'))
    model.add(output_layer)
    #model.fit(train_x, train_y,epochs=EPOCHS, verbose=1)
    
def load_dataset():
    (train_x, train_y), (test_x, test_y) = cifar10.load_data()
    train_y = to_categorical(train_y)
    test_y = to_categorical(test_y)
    return train_x, train_y, test_x, test_y

def format_pixels(train, test):
    train_norm = train.astype('float32') / 255.0
    test_norm = test.astype('float32') / 255.0
    return train_norm, test_norm

def test_harness():  
    train_x, train_y, test_x, test_y = load_dataset()
    train_x, test_x = format_pixels(train_x, test_x)

    model = define_model(train_x, train_y)
    model.summary()
    add_layer(model, train_x, train_y)
    model.summary()

    datagen = ImageDataGenerator(
        zoom_range=0.15,
        brightness_range=[0.5,1.5],
        rotation_range=20,
        shear_range=0.15, 
        horizontal_flip=True, 
        height_shift_range=0.1, 
        width_shift_range=0.1,
        fill_mode="nearest"
    )

    it_train = datagen.flow(train_x, train_y, batch_size=64)

    steps = int(train_x.shape[0] / 64)
    history = model.fit_generator(
        it_train, 
        steps_per_epoch=steps, 
        epochs=10, 
        validation_data=(test_x, test_y),
        verbose=1
    )

    _, acc = model.evaluate(test_x, test_y, verbose=1)
    print('accuracy => %.3f' % (acc * 100.0))

test_harness()

