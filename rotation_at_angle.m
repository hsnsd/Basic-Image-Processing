img = imread('grayscale.jpg');

img = rgb2gray(img);
a = input ('enter angle ');
a = a*pi/180;
%backward mapping rotation matrix
R = [cos(a) sin(a); -sin(a) cos(a)];
c = size (img);
%compute new size
newRow = ceil(c(1)*abs(cos(a)) + c(2)*abs(sin(a)))
newCol = ceil(c(1)*abs(sin(a)) + c(2)*abs(cos(a)))
%create new image
newImg = uint8(zeros(newRow,newCol));
%centre of original image
midAx = ceil(c(1)/2);
midAy = ceil(c(2)/2);
%centre of new image
midFx = ceil(newRow/2);
midFy = ceil(newCol/2);

%backward mapping
for i=1:newRow
    for j=1:newCol
        %translate and transform
        X = R*[i-midFx, j-midFy]';
        %translate back
        X(1,1) = round(X(1,1)) + midAx;
        X(2,1) = round(X(2,1)) + midAy;
        %if pixel within matrix range i.e greater than zero and within bounds of original image, move the pixels
        if (X(1,1)>=1 && X(2,1)>=1 && X(1,1)<=c(1) &&  X(2,1)<=c(2) ) 
              newImg(i,j)=img(X(1,1),X(2,1));  
         end
        
        
        
    end
end
%newImg
imshow(newImg)