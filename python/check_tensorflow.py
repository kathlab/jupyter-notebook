import tensorflow as tf

if tf.test.is_gpu_available():
    print("TENSORFLOW CUDA devices: " + str(tf.config.list_physical_devices('GPU')))
else:
    print(":(")