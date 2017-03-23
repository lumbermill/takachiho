# For python3
# http://blog.livedoor.jp/kmiwa_project/archives/1058625358.html

import os, numpy
from PIL import Image
from tensorflow.examples.tutorials.mnist import input_data

mnist = input_data.read_data_sets("MNIST_data",one_hot=True)

def image_from_mnist(index,m):
    d = numpy.where(m.labels[index] == 1)[0][0] # one-hot vectors. ex: [0 0 1 0 0 0 0 0 0 0] = 2
    a = m.images[index]
    b = a.reshape((28,28))
    b = b*255
    img = Image.fromarray(b)
    img = img.convert("RGB")
    name = "letters/%d/%04d.png" % (d,index)
    img.save(name)
    print(m.labels[index]," ",name)

if __name__ == "__main__":
    for i in range(0,10):
        d = "letters/%d" % i
        if not os.path.isdir(d):
            os.mkdir(d)

    for i in range(0,len(mnist.test.labels)):
        image_from_mnist(i,mnist.test) # .train or .test
