from sys import *


def g(one):
    if one=="0":
        ans = "0000"
    elif one=="1":
        ans = "0001"
    elif one=="2":
        ans = "0010"
    elif one=="3":
        ans = "0011"
    elif one=="4":
        ans = "0100"
    elif one=="5":
        ans = "0101"
    elif one=="6":
        ans = "0110"
    elif one=="7":
        ans = "0111"
    elif one=="8":
        ans = "1000"
    elif one=="9":
        ans = "1001"
    elif one=="a":
        ans = "1010"
    elif one=="b":
        ans = "1011"
    elif one=="c":
        ans = "1100"
    elif one=="d":
        ans = "1101"
    elif one=="e":
        ans = "1110"
    elif one=="f":
        ans = "1111"
    return ans


def make(a):
    return g(a[0]) + g(a[1])

path = argv[1]
path2 = argv[2]
bins = []
with open(path, "r") as f:
    lists = []
    for _, line in enumerate(f):
        datas = line.split(" ")
        for index, i in enumerate(datas):
            if index >= 1 and i != " " and i != "" and i != "\n":
              lists.append(make(i[0:2]))
with open(path2, "w") as g:
    for data in lists:
        g.write(data + "\n")
