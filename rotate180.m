function[rotatedImage] = rotate180(imageA)
c = size(imageA);

for i=1:c(1)
    for j=1:c(2)
        rotatedImage(c(1) -i +1,c(2)-j+1) = imageA(i,j);
    end
end
end