function componentAndProperties
A = imread('a.bmp');
A= rgb2gray(A);
figure; imshow(A) %orgiinal image
A(A==255) = 1; %change 255 to 1
[A,label] = findConnected(A); %connected component method
figure; imagesc(findConnected(A)) %colored component wise image
area = getArea(A,label); %array of areas
sizeArea = size(area);
[centroidX centroidY] = getCentroid(A,label); %array of centroids
for i =2:sizeArea(2)-1
    disp(i) %LABEL
    num2str(area(i)) %Area
    
    ch = chainCodev1(A,i) %chaincode
    per = getPerimeter(ch) %perimeter
    comp = getCompactness(per,num2str(area(i))) %compactness
    
    
    %tmp = ['component label ', num2str(i) , ' has area ' , num2str(area(i)), ' has centroid X=', num2str(centroidX(i)), ' Y=',  num2str(centroidY(i))];
    %disp(tmp)
    %tmp1 = [' has chain code ', ch];
    %disp(tmp1)
    %tmp2 = [' has perimeter ', per, ' has compactness ', comp   ];
    %disp(tmp2)
end

function[area] = getArea(imageA,label)
area = zeros(1, label);
c = size(imageA);
for i=1:c(1)
    for j=1:c(2)
        if (imageA(i,j) ~= 0)
            area(imageA(i,j)) = area(imageA(i,j)) + 1;
        end
    end
end

function[centroidX centroidY] = getCentroid(imageA,label)
centroidX = zeros(1, label);
centroidY = zeros(1, label);
c = size(imageA)
for i=1:c(1)
    for j=1:c(2)
        if (imageA(i,j) ~= 0)
            centroidX(imageA(i,j)) = centroidX(imageA(i,j)) + i;
            centroidY(imageA(i,j)) = centroidY(imageA(i,j)) + j;
        end
    end
end
centroidX = centroidX ./ getArea(imageA,label); 
centroidY = centroidY ./ getArea(imageA,label);


function [modImage,label] = findConnected(imageA) %4-adjacency
c = size(imageA);
label = 2;
for i=1:c(1)
    for j=1:c(2)
        if (imageA(i,j) == 1)
            imageA(i,j) = label;
            
            imageA = labelNeighbour(imageA, i, j, label);
            label = label + 1;
            
        end
    end
end
modImage = imageA;
label = label;

function[imageA] = labelNeighbour(imageA, x, y, label)
[X Y] = size(imageA);
if (x-1 >= 1)
    if (imageA(x-1,y) == 1)
        imageA(x-1,y) = label;
        imageA = labelNeighbour(imageA, x-1, y, label);
    end
end
if (x+1 <= X)
    if (imageA(x+1,y) == 1)
        imageA(x+1,y) = label;
        imageA = labelNeighbour(imageA, x+1, y, label);
    end
end
if (y-1 >= 1)
    if (imageA(x,y-1) == 1)
        imageA(x,y-1) = label;
        imageA = labelNeighbour(imageA, x, y-1, label);
    end
end
if (y+1 <= Y)
    if (imageA(x,y+1) == 1)
        imageA(x,y+1) = label;
        imageA = labelNeighbour(imageA, x, y+1, label);
    end
end

function [chCode] = chainCodev1(imageA, label)
%chCode = "";
[X Y] = size(imageA);
chCode = "";      % The chain code
 % Coordinates of the current pixel
dir = 0;       % The starting direction

for i=1:X
    for j=1:Y
        if (imageA(i,j) == label)
            curI = i;
            curJ = j;
            while 1
                if dir == 0
                    if (checkUp(imageA, label, curI, curJ))
                        curI = curI - 1;
                        dir = 1;
                        chCode = strcat(chCode,"1");

                    elseif (checkRight(imageA, label, curI, curJ))
                        curJ = curJ + 1;
                        dir = 0;
                        chCode = strcat(chCode,"0");
                    elseif (checkDown(imageA, label, curI, curJ))
                        curI = curI + 1;
                        dir = 3;
                        chCode = strcat(chCode,"3");
                    elseif (checkLeft(imageA, label, curI, curJ))
                        curJ = curJ - 1;
                        dir = 2;
                        chCode = strcat(chCode,"2");
                    end
                elseif dir == 2
                    if (checkDown(imageA, label, curI, curJ))
                        curI = curI + 1;
                        dir = 3;
                        chCode = strcat(chCode,"3");
                    elseif (checkLeft(imageA, label, curI, curJ))
                        curJ = curJ - 1;
                        dir = 2;
                        chCode = strcat(chCode,"2");
                    elseif (checkUp(imageA, label, curI, curJ))
                        curI = curI - 1;
                        dir = 1;
                        chCode = strcat(chCode,"1");
                    elseif (checkRight(imageA, label, curI, curJ))
                        curJ = curJ + 1;
                        dir = 0;
                        chCode = strcat(chCode,"0");
                    end
                elseif dir == 1
                    if (checkLeft(imageA, label, curI, curJ))
                        curJ = curJ - 1;
                        dir = 2;
                        chCode = strcat(chCode,"2");
                    elseif (checkUp(imageA, label, curI, curJ))
                        curI = curI - 1;
                        dir = 1;
                        chCode = strcat(chCode,"1");
                    elseif (checkRight(imageA, label, curI, curJ))
                        curJ = curJ + 1;
                        dir = 0;
                        chCode = strcat(chCode,"0");
                    elseif (checkDown(imageA, label, curI, curJ))
                        curI = curI + 1;
                        dir = 3;
                        chCode = strcat(chCode,"3");
                    end
                elseif dir == 3
                    if (checkRight(imageA, label, curI, curJ))
                        curJ = curJ + 1;
                        dir = 0;
                        chCode = strcat(chCode,"0");
                    elseif (checkDown(imageA, label, curI, curJ))
                        curI = curI + 1;
                        dir = 3;
                        chCode = strcat(chCode,"3");
                    elseif (checkLeft(imageA, label, curI, curJ))
                        curJ = curJ - 1;
                        dir = 2;
                        chCode = strcat(chCode,"2");
                    elseif (checkUp(imageA, label, curI, curJ))
                        curI = curI - 1;
                        dir = 1;
                        chCode = strcat(chCode,"1");
                    end
                end
                if (curI == i && curJ == j)
                    if dir == 2
                        if (imageA(i+1,j) ~= label)
                            return;
                        end
                    
                    else
                        return;
                    end
                end
            end
        end
    end
end


function [found] = checkUp(imageA, label, i, j)
found = false;
c = size(imageA);
if (i-1 >= 1)
    if (imageA(i-1,j) == label)
        found = true;clc
        
        return
    end
end

function [found] = checkDown(imageA, label, i, j)
found = false;
c = size(imageA);
if (i+1 <= c(1))
    if (imageA(i+1,j) == label)
        found = true;
        return
    end
end

function [found] = checkLeft(imageA, label, i, j)
found = false;
c = size(imageA);
if (j-1 >= 1)
    if (imageA(i,j-1) == label)
        found = true;
        return
    end
end

function [found] = checkRight(imageA, label, i, j)
found = false;
c = size(imageA);
if (j+1 <= c(2))
    if (imageA(i,j+1) == label)
        found = true;
        return
    end
end

function [count] = getPerimeter(chCode) %trace back the chain code.
chCode = char(chCode);

strlength = size(chCode);
per = strlength(2);
i = 1;
count = 1;
curX = 0;
curY = 0;
A = [0 0];
while(i<=strlength(2))
    chCode(i);
    if (chCode(i) == '0')
        curY = curY + 1;
        if ismember([curX curY], A, 'rows')
        else
            A = [A; [curX curY]];
            count = count + 1;
        end
    elseif (chCode(i) == '1')
        curX = curX - 1;
        if ismember([curX curY], A, 'rows')
        else
            A = [A; [curX curY]];
            count = count + 1;
        end
    elseif (chCode(i) == '2')
        curY = curY - 1;
        if ismember([curX curY], A, 'rows');
        else
            A = [A; [curX curY]];
            count = count + 1;
        end
    elseif (chCode(i) == '3')
        curX = curX + 1;
        if ismember([curX curY], A, 'rows')
        else
            A = [A; [curX curY]];
            count = count + 1;
        end
    end
    i = i+1;
end
count;

function [compactness] = getCompactness(perimeter,area)
compactness = perimeter^2/str2double(area)*pi*4;