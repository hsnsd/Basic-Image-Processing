#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 22 22:55:26 2018

@author: hsnsd
"""

import cv2
import numpy as np

def disp(img, name):
    cv2.imshow(name,img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
    cv2.waitKey(1)

def canny(img, low, high):
    tmp = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    tmp = cv2.GaussianBlur(img, (3, 3), 0)
    return cv2.Canny(tmp, low, high)

def convert_white_yellow(img):
    
    imgHLS = cv2.cvtColor(img, cv2.COLOR_RGB2HLS)
    # white color mask
    lower = np.uint8([  0, 200,   0])
    upper = np.uint8([255, 255, 255])
    white_mask = cv2.inRange(imgHLS, lower, upper)
    # yellow color mask
    lower = np.uint8([ 10,   0, 100])
    upper = np.uint8([ 40, 255, 255])
    yellow_mask = cv2.inRange(imgHLS, lower, upper)
    # combine the mask
    mask = cv2.bitwise_or(white_mask, yellow_mask)
    return cv2.bitwise_and(imgHLS, imgHLS, mask = mask)


def hough_lines(img):
    return cv2.HoughLinesP(img, rho=3, theta=np.pi/150, threshold=60, minLineLength=30, maxLineGap=200)

def crop(img):
    height, width = img.shape
    
    #cropping to regions of interest, usually a triangle
    vertex=[(0, height),(width/2, height/2),(width, height)]
    
    mask=np.zeros_like(img)
    colorofmask= (255,)*3
    cv2.fillPoly(mask, np.array([vertex], np.int32), colorofmask)

    croppedimg=cv2.bitwise_and(img, mask)
    return croppedimg


img = 'im5.jpg' #Query Image
img = cv2.imread(img,1)

tmp = convert_white_yellow(img)
tmp = canny(tmp, 100, 200)
disp(tmp,'Canny Edges')
tmp = crop(tmp)
disp(tmp,'Region Of Interest')
lines=hough_lines(tmp)
for x in range(0, len(lines)):
    for x1,y1,x2,y2 in lines[x]:
        cv2.line(img,(x1,y1),(x2,y2),(0,255,0),2)
#disp(canny((convert_white_yellow(img)), 50, 100), 'ed')

disp( img, 'Line Detected')