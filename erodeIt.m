function erodeIt
imageA = imread('a.bmp');
imageA = rgb2gray(imageA);
SE1 = [ 0 1 0; 1 1 1; 0 1 0];
SE2 = [ 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1];
SE3 = [ 0 0 1 0 0; 0 1 1 1 0; 1 1 1 1 1; 0 1 1 1 0; 0 0 1 0 0];
figure; imshow(imageA);
figure; imshow(erosionv1(imageA,SE1));
figure; imshow(erosionv1(imageA,SE2));
figure; imshow(erosionv1(imageA,SE3));


function [result] = erosionv1(imageA, SE)
paddedImage = padding(imageA,SE);
result = paddedImage;
sizeOg = size(imageA);
sizePd = size(paddedImage);
pad = size(paddedImage) - size(imageA);
for i=pad(1)/2 + 1: sizePd(1) - pad(1)/2
    for j=pad(2)/2 + 1: sizePd(2) - pad(2)/2
        result(i,j) = checkNeighbour(paddedImage, SE, i, j); 
    end
end
result;
result = result(pad(1)/2 + 1:sizePd(1) - pad(1)/2, pad(2)/2 + 1:sizePd(2) - pad(2)/2);

function [value] = checkNeighbour(imageA, SE, x, y)
value = imageA(x,y);
c = size(SE);
midX = ceil(c(1)/2);
midY = ceil(c(2)/2);
Y = y - (c(2)-midY);
%X = x - (c(1)-midX);
X = x;
for i=midX:-1:1
    for j=1:c(2)
        if (SE(i,j) == 1 && imageA(X,Y) ~= 255)
            value = 0;
            return
        end
        Y = Y+1;
    end
    Y = y - (c(2)-midY);
    X = X - 1;
end
X = x + 1;
for i=midX+1:c(1)
    for j=1:c(2)
        if (SE(i,j) == 1 && imageA(X,Y) ~= 255)
            value = 0;
            return
        end
        Y = Y+1;
    end
    Y = y - (c(2)-midY);
    X = X + 1;
end

function [paddedImage] = padding(imageA, SE)
c = size(imageA);
c1 = size(SE);
midX = ceil(c1(1)/2);
midY = ceil(c1(2)/2);
c(1);
paddedImage = imageA;
size(paddedImage);
%pad rows in the beginning
for i=1:c1(1)-midX
    paddedImage = [uint8(zeros(1,c(2)));paddedImage];
end

%pad rows in the end
for i=1:c1(1)-midX
    paddedImage = [paddedImage;uint8(zeros(1,c(2)))];
end

for i=1:c1(2) - midY
    paddedImage = [uint8(zeros(c(1) + 2*(c1(1)-midX),1)) paddedImage];
end

for i=1:c1(2) - midY
    paddedImage = [paddedImage uint8(zeros(c(1) + 2*(c1(1)-midX),1)) ];
end

paddedImage;
