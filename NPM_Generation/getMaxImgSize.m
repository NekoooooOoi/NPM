function ans = getMaxImgSize(pcCoor)
coorMax = max(pcCoor(:,1:2));
CoorMin = min(pcCoor(:,1:2));
ans = max(coorMax-CoorMin)+1;
ans = 2^ceil(log2(ans));
end