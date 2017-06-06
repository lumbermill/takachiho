#! /usr/bin/python -u 

import os, shutil, subprocess, sys, time

def main():
    params = sys.argv 
    print params
    started_at = time.time()
    ddir = params[params.index("-data")+1]
    if os.path.isdir(ddir):
        print "Clean up %s.." % (ddir)
        shutil.rmtree(ddir)

    subprocess.call(["opencv_haartraining"]+params)
    # subprocess.call(["opencv_traincascade"]+params)
    elapsed = time.time() - started_at
    print "Elapsed: %d" % elapsed

if __name__ == "__main__":
    main()

