"""
From http://tensorflow.org/tutorials/mnist/beginners/index.md
"""

import argparse, os, sys, cv2
import numpy as np
import tensorflow as tf

FLAGS = None

def main(_):
  # Restore saved model which is built by train-mnist.py
  x = tf.placeholder(tf.float32, [None, 784])
  W = tf.Variable(tf.zeros([784, 10]))
  b = tf.Variable(tf.zeros([10]))
  y = tf.matmul(x, W) + b

  sess = tf.InteractiveSession()
  saver = tf.train.Saver()
  saver.restore(sess, os.path.join(FLAGS.log_dir, 'model.ckpt'))

  # Use images which are extracted by extract-mnist.py
  # img = cv2.imread('./letters/7/0000.png',0)
  # img = cv2.imread('./letters/2/0001.png',0)
  img = cv2.imread('./letters/1/0002.png',0) # 0 = grayscale
  img = cv2.resize(img, (28, 28))
  img = img.flatten().astype(np.float32)/255.0
  # tmp = np.zeros(10)
  # tmp[7] = 1

  # See http://stackoverflow.com/questions/33711556/making-predictions-with-a-tensorflow-model
  classification = sess.run(tf.argmax(y, 1), feed_dict={x: [img]})
  print(classification[0])

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--data_dir', type=str, default='/tmp/tensorflow/mnist/input_data',
                      help='Directory for storing input data')
  parser.add_argument('--log_dir', type=str, default='/tmp/tensorflow/mnist/logs',
                      help='Directory for storing input data')
  FLAGS, unparsed = parser.parse_known_args()
  tf.app.run(main=main, argv=[sys.argv[0]] + unparsed)
