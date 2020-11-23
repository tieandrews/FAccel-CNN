python3 keras_to_tf.py --input_model=$1 --output_model=model.pb
python3 /opt/intel/openvino/deployment_tools/model_optimizer/mo.py --input_model model.pb --input_shape [3,$2,$2,3] --scale 255 --reverse_input_channel

