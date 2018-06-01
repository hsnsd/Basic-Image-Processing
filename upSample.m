function [upSampledImage] = upSample(imageA)
prompt = 'Input upsampling scale';
n = input(prompt);
c = size(imageA);
count = 1;
countWidth = 1;
for i=1:c(1)
    for j=1:c(2)
        for k=1:n
            for l=1:n
            upSampledImage(count+k-1,countWidth+l-1) = imageA(i,j);
            end
        end
        countWidth = countWidth + n;
        
    end
    countWidth = 1;
    count = count + n;
end
end