#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  1 22:42:28 2018

@author: hsnsd

- Histogram comparision on grey scale image was giving a little better similarity than on bgr image, so I have adopted that.
- Please edit file paths accordingly.
"""
import os
from os import listdir
from os.path import isfile, join
import cv2

def getNormHist(I, path):
    I = cv2.cvtColor(I, cv2.COLOR_BGR2GRAY)
    hist = cv2.calcHist([I], [0], None, [256], [0,256])
    cv2.normalize(hist,hist)
    return (path,hist)

    
def getEmd(histA, histB):
    prevEmd = 0
    emd = 0
    for i in range(255):
        tmp = abs((histA[i][0] + prevEmd - histB[i][0]))
        emd += tmp
        prevEmd = tmp
    return emd


def generateEMD(imageDb, qDet):
    metricDb = []
    for images in imageDb:
        #EMD
        res = getEmd(images[1],qDet[1])
        metricDb.append((images[0],res))
    return metricDb
    
def generateCor(imageDb, qDet):
    metricDb = []
    for images in imageDb:
        #CORRELATION
        res = cv2.compareHist(images[1],qDet[1], method=cv2.HISTCMP_CORREL)
        metricDb.append((images[0],res))
    return metricDb

def generateBht(imageDb, qDet):
    metricDb = []
    for images in imageDb:
        #BHATTACHARYYA
        res = cv2.compareHist(images[1],qDet[1], method=cv2.HISTCMP_BHATTACHARYYA)
        metricDb.append((images[0],res))
    return metricDb

def generateChi(imageDb, qDet):
    metricDb = []
    for images in imageDb:
        #CORRELATION
        res = cv2.compareHist(images[1],qDet[1], method=cv2.HISTCMP_CHISQR)
        metricDb.append((images[0],res))
    return metricDb

def generateInt(imageDb, qDet):
    metricDb = []
    for images in imageDb:
        #CORRELATION
        res = cv2.compareHist(images[1],qDet[1], method=cv2.HISTCMP_INTERSECT)
        metricDb.append((images[0],res))
    return metricDb
        
        
def disp(imgP, name):
    img = cv2.imread(imgP,1)
    cv2.imshow(name,img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
    cv2.waitKey(1)

mypath = "/Users/hsnsd/Documents/Corel/"

#Uncomment the below part if testing on hw3images
"""
onlydir = [f for f in listdir(mypath) if os.path.isdir(join(mypath, f))]

onlyfiles = []
for dir in onlydir:
    tmp = [(join(mypath+dir, f)) for f in listdir(mypath + dir) ]
    onlyfiles += tmp

"""

onlyfiles = [join(mypath, f) for f in listdir(mypath) if f != ".DS_Store"] #comment this line if testing on hw3images
#query image
#pathI = onlyfiles[100]
pathI = 'cat.jpeg'
disp(pathI, 'original')
qImg = cv2.imread(pathI)
qDet = getNormHist(qImg, pathI)

imageDb = [] # image = (path,histB,histG,histR)
for f in onlyfiles:
    I = cv2.imread(f)
    imageDb.append(getNormHist(I,f))


cor = generateCor(imageDb,qDet)
cor.sort(key=lambda x: x[1], reverse = True)

bht = generateBht(imageDb,qDet)
bht.sort(key=lambda x: x[1])

chi = generateChi(imageDb,qDet)
chi.sort(key=lambda x: x[1])

inter = generateInt(imageDb,qDet)
inter.sort(key=lambda x: x[1], reverse = True)

emd = generateEMD(imageDb,qDet)
emd.sort(key=lambda x: x[1])


#limit = No of best matches to be displayed
limit = 5
for i in range(limit):
    disp(cor[i][0], "Cor#" + str(i) + " V= " + str(cor[i][1]))
    disp(bht[i][0], "Bht#" + str(i) + " V= " + str(bht[i][1]))
    disp(chi[i][0], "Chi#" + str(i) + " V= " + str(chi[i][1]))
    disp(inter[i][0], "Inter#" + str(i) + " V= " + str(inter[i][1]))
    disp(emd[i][0], "EMD#" + str(i) + " V= " + str(emd[i][1]))



print('end')