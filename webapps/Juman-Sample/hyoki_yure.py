#-*- encoding: utf-8 -*-
from __future__ import print_function
from pyknp import Jumanpp

import sys
import codecs
import pprint
pp = pprint.PrettyPrinter(indent=4)

def read_and_anlyze_text():
    sys.stdin = codecs.getreader('utf_8')(sys.stdin)
    sys.stdout = codecs.getwriter('utf_8')(sys.stdout)
    jumanpp = Jumanpp()
    midasis = []
    repnames = []
    repname_counts = {}

    while True:
        input_ = sys.stdin.readline()
        if input_ == '' :
            break
        else :
            result = jumanpp.analysis(input_)
            for mrph in result.mrph_list():
                if not repname_counts.has_key(mrph.repname):
                    repname_counts[mrph.repname] = 0
                if not mrph.midasi in midasis:
                    repname_counts[mrph.repname] += 1
                midasis.append(mrph.midasi)
                repnames.append(mrph.repname)
            midasis.append("\n")
            repnames.append("\n")
            repname_counts["\n"] = 0
    result = []
    for i, midasi in enumerate(midasis):
        yure = False
        if repname_counts[repnames[i]] > 1:
            yure = True
        result.append({"midasi":midasi, "repname": repnames[i], "repname_count":repname_counts[repnames[i]], "yure": yure})
    return result

def format_to_html(analzed_obj):
    for obj in analzed_obj:
        if obj["midasi"] == "\n":
            print("<br>")
        elif obj["yure"]:
            print('<span class="yure">', end="")
            print(obj["midasi"], end="")
            print("</span>", end="")
        else:
            print(obj["midasi"], end="")

format_to_html(read_and_anlyze_text())
