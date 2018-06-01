#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 25 11:10:14 2018

@author: hsnsd
"""
import cv2

def vh(x,y, img):
    vh = 0
    for i in range(0,3):
        for j in range(0,4):
            if (x+i+1) < len(img) and (y+j) < len(img[0]):
                vh+= (img[x+i][y+j] - img[x+i+1][y+j])*(img[x+i][y+j] - img[x+i+1][y+j])
    return vh

def vv(x,y,img):
    vv = 0
    for i in range(0,4):
        for j in range(0,3):
            if (x+i) < len(img) and (y+j+1) < len(img[0]):
                vv+= (img[x+i][y+j] - img[x+i][y+j+1])*(img[x+i][y+j] - img[x+i][y+j+1])
    return vv

def vd(x,y,img):
    vd = 0
    for i in range(0,3):
        for j in range(0,3):
            if (x+i+1) < len(img) and (y+j+1) < len(img[0]):
                vd+= (img[x+i][y+j] - img[x+i+1][y+j+1])*(img[x+i][y+j] - img[x+i+1][y+j+1])
    return vd

def va(x,y,img):
    va = 0
    for i in range(1,4):
        for j in range(0,3):
            if (x+i+1) < len(img) and (y+j+1) < len(img[0]):
                va+= (img[x+i][y+j] - img[x+i-1][y+j+1])*(img[x+i][y+j] - img[x+i-1][y+j+1])
    return va


def check4(x,y,img):
    max = 0
    for i in range(0,4):
        for j in range(0,4):
            if (x+i) < len(img) and (y+j)<len(img[0]):
              if (img[x+i][y+j]) > max:
                  max = (img[x+i][y+j])
    return max

def generateV(vImg):
    tot=0
    for i in range(0,len(img)):
        for j in range(0,len(img[0])):
            vImg[i][j] = min (vh(i,j,img), vv(i,j,img), vd(i,j,img), va(i,j,img))
            if vImg[i][j] > 0:
                tot+=1
            
    return vImg,tot
    
def neighbourCheck(x,y,vImg):
    neighbours = [[x-2,y-4], [x+2,y-4],[x-4,y-2],[x,y-2],[x+4,y-2],[x-2,y],[x+2,y],[x,y+2],[x-4,y+2],[x+4,y+2],[x-2,y+4],[x+2,y+4]]
    for pixel in neighbours:
        if (vImg[x][y] < check4(pixel[0],pixel[1],vImg)) or vImg[x][y] > 100 :
            return False
    return True

def disp(img, name):
    cv2.imshow(name,img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
    cv2.waitKey(1)
    

tmp = cv2.imread("cat.jpg" , 1)

img = cv2.cvtColor(tmp, cv2.COLOR_BGR2GRAY)
vImg = cv2.cvtColor(tmp, cv2.COLOR_BGR2GRAY)
disp(img,"original")

vImg,tot = generateV(vImg)
#disp(vImg,"original")

for i in range(len(img)):
    for j in range(len(img[0])):

        if (vImg[i][j] >100):
            cv2.circle(tmp,(i,j), 1, (0,0,255), thickness = 2)
disp(tmp,"corner marked")

    
    
    
    