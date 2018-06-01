function [result] = convolve(imageA, SE) % SE = kernel
paddedImage = padding(imageA,SE)
result = paddedImage;
sizeOg = size(imageA);
sizePd = size(paddedImage);

SE = fliplr(SE); %horizontal flip
SE = flipud(SE); %vertical flip
pad = size(paddedImage) - size(imageA);
for i=pad(1)/2 + 1: sizePd(1) - pad(1)/2
    for j=pad(2)/2 + 1: sizePd(2) - pad(2)/2
        result(i,j) = getConvolved(paddedImage, SE, i, j);
    end
end
result = result(pad(1)/2 + 1:sizePd(1) - pad(1)/2, pad(2)/2 + 1:sizePd(2) - pad(2)/2);


end

function [value] = getConvolved(imageA, SE, x, y)
value = 0;
c = size(SE);
iSE = 1; jSE = 1;
for i = x-floor(c(1)/2) : x + floor(c(1)/2)
    for j = y-floor(c(2)/2) : y + floor(c(2)/2)
        %multiplication is not working if value at SE is negative, for some reason. Check the console
        %output. Cant debug or check but logic is fine I think.
        fprintf('SE %d Image %d, Result after multiplication %d \n', SE(iSE,jSE), imageA(i,j),SE(iSE,jSE)*imageA(i,j)) 
        value =value + SE(iSE,jSE)*imageA(i,j);
        jSE = jSE + 1;
    end
    jSE = 1;
    iSE = iSE+1;
end
value;
        
end

function [paddedImage] = padding(imageA, SE)
c = size(imageA);
c1 = size(SE);
midX = ceil(c1(1)/2);
midY = ceil(c1(2)/2);
c(1);
paddedImage = imageA;
size(paddedImage)
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
end
