# For python3

import numpy as np
import _pickle,random
from PIL import Image

def unpickle(file):
    fo = open(file, 'rb')
    dict = _pickle.load(fo, encoding='latin-1')
    fo.close()
    return dict

def image_from_cifar(index,dic):
    name = dic['filenames'][index]
    data = dic['data'][index].reshape(3, 32, 32).transpose(1, 2, 0) # shape=(32, 32, 3)
    img = Image.fromarray(data, 'RGB')
    print(name)
    img.save(name)

if __name__ == "__main__":
    dic = unpickle('cifar-10-batches-py/data_batch_1')
    image_from_cifar(random.randint(0,len(dic['filenames'])),dic)
