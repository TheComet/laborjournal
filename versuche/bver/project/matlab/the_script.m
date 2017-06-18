clear all, close all;

img = imread('test.jpg');
[ohm, tol, ppm] = rescol2value(img);
