import tensorflow as tf
from tensorflow.keras import datasets, layers, models
import os
import struct
import numpy as np
import math


#function to take 32 bit float accuracy and return bfloat16 equivalent float
def float_to_bfloat(f):

    sign = np.sign(f)
    # converts to hex  form 0x12345678
    h = hex(struct.unpack('<I', struct.pack('<f', f))[0])

    # removes last 4 values to put precision to float 16
    bfloat = h[:-4]

    ft = bfloat + '0000'

    dec = int(ft, 16)
    bn = bin(dec)
    b = str(bn[2:]).zfill(32)

    if (b[0] == 1):
        sign = -1
    else:
        sign = 1

    exponent = int(b[1:9], 2) - 127

    mant = int(b[10:], 2)

    mant = 1 + mant / (2 ** (23))

    flt = sign * mant * 2 ** exponent

    # return base 16 float
    return flt



def parse_conv2d(layer, layer_num):
    '''
    Takes in a tf conv2d layer object and which number in the model it is and outputs .h
    files of the weights for each filter.

    :param layer: tf layer object, where the weights are extracted from
    :param layer_num: number of this type of layer so far in the model, used for file naming
    :return: None
    '''

    print("\tParsing Conv2D Layer")
    # print(weights)

    # get weights and each useful metric of the layer
    weights = layer.get_weights()
    filters = layer.filters
    kernels = layer.kernel_size

    # figure out how many values to save to each filters weights
    kernel_size = kernels[0] * kernels[1]

    # set the order of the colors, think it should be RGB
    image_colors = ['R', 'G', 'B']

    print(f'\tNo. of Filters: {filters}, Kernel Size: {kernels[0]} x {kernels[1]}')

    # Create output file with .h file type and put commented first line with details
    file_name = "conv2D_" + str(layer_num)
    file = open('models\\extractedWeights\\' + file_name + ".h", 'w')
    file.write("/* " + str(filters) + " filters, kernel size: " + str(kernels[0]) + "x" + str(kernels[1]) + "*/\n")

    # Iterates over the 3 color channels
    for color in range(len(image_colors)):

        # seperates out each kernels weights
        for i in range(filters):

            # print(f"filter: {i}") #Use to validate weights above manually
            file.write(
                'const static float kernel_' + str(i) + "_" + image_colors[color] + "[" + str(kernel_size) + "] = {")

            # Checks dimensions of each kernel, handles non 3x3 kernels
            for row in range(kernels[0]):
                for col in range(kernels[1]):

                    print("Starting float conversionconda update te")
                    weight = float(weights[0][color][row][col][i])
                    bfloat_weight = float_to_bfloat(weight)
                    file.write(str(bfloat_weight))

                    # checks if it is the last value and stops placing a single comma
                    if ((row + 1) * (col + 1) < kernel_size):
                        file.write(",")

            file.write("};\n")

    file.close()


def parse_dense(layer, layer_num):
    '''
    Takes in a dense tf layer object and which number in the model it is and outputs .h
    files of the weights by output node. i.e. if it's 32 nodes feeding into a 10 node dense layer,
    there will be 10 arrays created in the header file with those weights labelled by node

    :param layer: tf layer object, where the weights are extracted from
    :param layer_num: number of this type of layer so far in the model, used for file naming
    :return: None
    '''

    print("\tParsing Dense Layer")
    # print(weights)

    weights = layer.get_weights()

    num_inputs = len(weights[0])
    num_outputs = len(weights[0][0])
    print(f'\tNum. of Output Classes: {num_outputs}, Num. of Input Nodes: {num_inputs}')

    # set up output .h file and put in first line comment with details
    file_name = "dense_" + str(layer_num)
    file = open('models\\extractedWeights\\'+ file_name + ".h", 'w')
    file.write("/* " + str(num_inputs) + " inputs to each node, " + str(num_outputs) + " output nodes" + "*/\n")

    for output in range(num_outputs):

        file.write('const static float node_' + str(output) + "[" + str(num_inputs) + "] = {")

        for inputs in range(num_inputs):

            weight = float(weights[0][inputs][output])
            # print(weight)
            bfloat_weight = float_to_bfloat(weight)
            file.write(str(bfloat_weight))

            # checks if it is the last value and stops placing a single comma
            if (inputs < num_inputs - 1):
                file.write(",")

        file.write("};\n")

    file.close()



if __name__ == "__main__":

    # path to model
    model_name = 'cifar10_model' #use later if transferring numerous models into the HW to keep track of versions
    model_file = 'models\\' + model_name + '.h5'
    model = models.load_model(model_file)
    print("Model Loaded")
    model.summary()

    # Tracking number of layers of each type for naming of files
    conv_layers = 0
    dense_layers = 0

    #Iterate over all layers in the model and parse each type into .h files
    for layer in model.layers:

        layer_type = layer.__class__.__name__
        print(layer_type)

        if layer_type == "Conv2D":
            parse_conv2d(layer, conv_layers)
            conv_layers += 1

        if layer_type == "Dense":
            parse_dense(layer, dense_layers)
            dense_layers += 1