#! /usr/bin/python -u 

import json, os, subprocess, sys, time

cmd_ex = os.path.dirname(__file__) + "/extract_vec"

def main():
    params = sys.argv
    print params
    started_at = time.time()
    subprocess.call(["opencv_createsamples"]+params)
    vec = params[params.index("-vec")+1]
    dir = vec.replace(".vec","_vec")
    vec_params = {}
    if "-w" in params:
        vec_params["w"] = params[params.index("-w")+1]
    if "-h" in params:
        vec_params["h"] = params[params.index("-h")+1] 
    subprocess.call(["mkdir","-p",dir])
    vp = ""
    for k in vec_params:
        vp += " -"+k+" "+vec_params[k]
    subprocess.call("cd %s && %s %s %s" \
        % (dir,cmd_ex,vec,vp),shell=True)

    elapsed = time.time() - started_at
    print "Elapsed: %d" % elapsed
    info = vec.replace(".vec","_info.json")
    print "Saving result in %s" % (info)
    d = json.load(open(info))
    d.update(vec_params)
    print json.dumps(d)
    json.dump(d,open(info,"w"))

if __name__ == "__main__":
    main()

