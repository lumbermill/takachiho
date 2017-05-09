"""
動作せず
"""

import argparse, os, sys, cv2
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import numpy as np
import tensorflow as tf

FLAGS = None


def main(_):
  # この辺りを参考にしてみたが、うまく組みきれず
  # http://suprsonicjetboy.hatenablog.com/entry/2017/04/30/204951
  sess = tf.InteractiveSession()
  saver = tf.train.Saver()
  saver.restore(sess, os.path.join(FLAGS.model))

  img = cv2.imread(FLAGS.image,1) # 0 = grayscale
  img = cv2.resize(img, (32, 32))
  cv2.imwrite(FLAGS.image.replace(".jpg","p.jpg"),img)
  img = img.flatten().astype(np.float32)/255.0

  classification = sess.run(tf.argmax(y, 1), feed_dict={x: [img]})
  print(classification[0])

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--checkpoint_dir', type=str, default='models',
                      help='Saved model')
  parser.add_argument('--model', type=str, default='models/cifar.ckpt',
                      help='Saved model')
  parser.add_argument('--image', type=str, default='historyes/yyyymmdd_hhmmss.jpg',
                      help='jpg image for input')
  FLAGS, unparsed = parser.parse_known_args()
  tf.app.run(main=main, argv=[sys.argv[0]] + unparsed)
