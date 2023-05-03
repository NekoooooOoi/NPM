function center = getPcCenter(pcCoor)
CoorMax = max(pcCoor);
CoorMin = min(pcCoor);
center = (CoorMax+CoorMin)/2;
end