# -*- coding: utf-8 -*-
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
    wikipedia_redirections = []
    w_rs = []
    w_r_counts = {}
    row_result = []
    while True:
        input_ = sys.stdin.readline()
        if input_ == '' :
            break
        else :
            input_ = input_.strip()
            if input_ == '' :
                continue
            result = jumanpp.analysis(input_)
            for mrph in result.mrph_list():
                if not repname_counts.has_key(mrph.repname):
                    repname_counts[mrph.repname] = 0
                if (not mrph.midasi in midasis) and (mrph.repname != u"") :
                    repname_counts[mrph.repname] += 1
                w_r = get_wikipedia_redirection(mrph.imis)
                if not w_r :
                    w_r = mrph.midasi
                if not w_r_counts.has_key(w_r):
                    w_r_counts[w_r] = 0
                if (not mrph.midasi in midasis):
                    w_r_counts[w_r] += 1
                midasis.append(mrph.midasi)
                repnames.append(mrph.repname)
                wikipedia_redirections.append(w_r)
                w_rs.append(w_r)
            midasis.append("\n")
            repnames.append("\n")
            wikipedia_redirections.append(None)
            w_rs.append("\n")
            repname_counts["\n"] = 0
            w_r_counts["\n"] = 0
            row_result.append(result.spec())

    yure_result = []
    for i, midasi in enumerate(midasis):
        yure = False
        if repname_counts[repnames[i]] > 1 or w_r_counts[w_rs[i]] > 1:
            yure = True
        yure_result.append({"midasi":midasi,
            "repname": repnames[i],
            "wikipedia_redirection": wikipedia_redirections[i],
            "repname_count": repname_counts[repnames[i]],
            "w_r_count": w_r_counts[w_rs[i]],
            "yure": yure})
    return row_result, yure_result

def get_wikipedia_redirection(imis):
    imis_parts = imis.split(u" ")
    for part in imis_parts:
        if part.find(u':') >= 0:
            k_v = part.split(u":")
            if k_v[0] == u'Wikipediaリダイレクト':
                return k_v[1]

def disp_marked_sentence(yure_result):
    print(u"<h2>表記ゆれ検出結果</h2>")
    print("<div class='sentence'>")
    for obj in yure_result:
        if obj["midasi"] == "\n":
            print("<br>")
        elif obj["yure"]:
            print('<span class="yure">', end="")
            print(obj["midasi"], end="")
            print("</span>", end="")
        else:
            print(obj["midasi"], end="")
    print("</div>")

def disp_yure(yure_result):
    print(u"<h2>表記ゆれ解析結果</h2>")
    print("<div class='yure_list'><table>")
    print(u"<tr><th>見出し</th><th>代表表記</th><th>Wikipedia<br>リダイレクト</th><th>重複数</th><th>Wikipedia<br>リダイレクト数</th></tr>")
    for obj in yure_result:
        if obj["midasi"] != u"" and obj["midasi"] != u"\n":
            print("<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td><td>%d</td></tr>" % \
                    (obj["midasi"], obj["repname"], obj["wikipedia_redirection"], obj["repname_count"], obj["w_r_count"]))
    print("</table></div>")

def disp_structure(row_result):
    print(u"<h2>JUMAN++解析結果</h2>")
    print("<div class='structure'><pre>")
    for obj in row_result:
        print(obj)
    print("</pre></div>")

row_result, yure_result = read_and_anlyze_text()
disp_marked_sentence(yure_result)
disp_yure(yure_result)
disp_structure(row_result) #for debug
