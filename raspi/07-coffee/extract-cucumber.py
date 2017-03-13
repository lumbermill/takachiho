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

def image_from_cucumber(basedir,index,dic):
    name = dic['filenames'][index]
    r = dic['data'][index*3]
    g = dic['data'][index*3+1]
    b = dic['data'][index*3+2]
    data = np.array([r,g,b]).T.reshape(32,32,3)
    img = Image.fromarray(data, 'RGB')
    print(name)
    img.save(basedir+name)

if __name__ == "__main__":
    IMG_DIR = "./cucumbers/"

    for i in range(1,6): # 1 to 5
        dic = unpickle("CUCUMBER-9-master/prototype_1/cucumber-9-python/data_batch_%d" % (i))
        for j in range(0,len(dic['filenames'])):
            image_from_cucumber(IMG_DIR,j,dic)
