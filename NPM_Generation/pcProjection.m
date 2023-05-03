function [image, index, depthMatrix] =pcProjection(rotPcCoor,pcCorl,MaxSize)
pcCount = size(rotPcCoor,1);
DefaultRGB = [128,128,128];
depthMatrix = ones(MaxSize,MaxSize) * (MaxSize + 1000); 
R = ones(MaxSize,MaxSize) * DefaultRGB(1);
G = ones(MaxSize,MaxSize) * DefaultRGB(2);
B = ones(MaxSize,MaxSize) * DefaultRGB(3);
index = zeros(MaxSize,MaxSize);
for i = 1:pcCount
    nx = rotPcCoor(i,2);
    ny = rotPcCoor(i,1);
    dep = rotPcCoor(i,3);
    if (dep < depthMatrix(nx,ny))
        R(nx,ny) = pcCorl(i,1);
        G(nx,ny) = pcCorl(i,2);
        B(nx,ny) = pcCorl(i,3);
        depthMatrix(nx,ny) = dep;
        index(nx, ny) = i;
    end
end
image = cat(3, R, G, B) ./ 256;
end