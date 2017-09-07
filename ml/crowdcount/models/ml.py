from __future__ import print_function
import tensorflow as tf


def train():
    hello = tf.constant('Hello, TensorFlow!')

    # Start tf session
    sess = tf.Session()

    # Run the op
    print(sess.run(hello))


def test():
    print('todo: test')
