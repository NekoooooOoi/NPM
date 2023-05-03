function rotPcCoor = rotateGeo(pcCoor,rotatAngle,center)
c1 = cos(rotatAngle(1)*2*pi/360);
s1 = sin(rotatAngle(1)*2*pi/360);
c2 = cos(rotatAngle(2)*2*pi/360);
s2 = sin(rotatAngle(2)*2*pi/360);
c3 = cos(rotatAngle(3)*2*pi/360);
s3 = sin(rotatAngle(3)*2*pi/360);
rotateMatrix = [1 0 0;0 c3 s3;0 -s3 c3] * [c2 0 s2;0 1 0;-s2 0 c2] * [c1 s1 0; -s1 c1 0; 0 0 1];

rotPcCoor = ((pcCoor-center) * rotateMatrix) + center;
rotPcCoor = round(rotPcCoor);
rotPcCoor = rotPcCoor - min(rotPcCoor) + 1;

end