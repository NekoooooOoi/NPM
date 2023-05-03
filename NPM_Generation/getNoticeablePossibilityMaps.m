function [NPMapsA,NPMapsB] = getNoticeablePossibilityMaps(pcA,pcB)
% pcA= pcread('bag.ply');
% pcB=pcread('bag_gQP_2_tQP_3.ply');
rotation = (0:36:324); %rotate with axis-y
incline = (0:36:144); %rotate withe axis-z
%% Initialization
pcACoor = double(pcA.Location);
pcAColr = pcA.Color;
pcBCoor = double(pcB.Location);
pcBColr = pcB.Color;
NPMapsA = zeros(pcA.Count,2); % 1 -- noticed times ; 2 -- projection times
NPMapsB = zeros(pcB.Count,2); % 1 -- noticed times ; 2 -- projection times
%% pre-processing
[pcACoor,pcBCoor] = coorProc(pcACoor,pcBCoor,pcA.Count);
centerA = getPcCenter(pcACoor);
centerB = getPcCenter(pcBCoor);
%% Projection
for i = incline
    for j = rotation
        rotatAngle = [0,j,i];
        %rotation
        rotPcCoorA = rotateGeo(pcACoor,rotatAngle,centerA);
        rotPcCoorB = rotateGeo(pcBCoor,rotatAngle,centerB);
        MaxSizeA = getMaxImgSize(rotPcCoorA);
        MaxSizeB = getMaxImgSize(rotPcCoorB);
        MaxSize=max(MaxSizeA,MaxSizeB);
        %projection
        [imageA,indexA,~] = pcProjection(rotPcCoorA,pcAColr,MaxSize);
        [imageB,indexB,~] = pcProjection(rotPcCoorB,pcBColr,MaxSize);
        imageA = rgb2gray( im2uint8(imageA) );
        imageB = rgb2gray( im2uint8(imageB) );
        [ ~, jnd_mapA, ~, ~, ~ ] = func_JND_modeling_pattern_complexity( imageA );
        [ ~, jnd_mapB, ~, ~, ~ ] = func_JND_modeling_pattern_complexity( imageB );
        projPointsIndexA = find(indexA); %index in image
        projPointsIndexB = find(indexB); %index in image
        projPointsA = indexA(projPointsIndexA); % index in point cloud
        projPointsB = indexB(projPointsIndexB); % index in point cloud
        NPMapsA(projPointsA,2) = NPMapsA(projPointsA,2)+1;
        NPMapsB(projPointsB,2) = NPMapsB(projPointsB,2)+1;
        %notice points count
        logicA = abs(imageA(projPointsIndexA)-imageB(projPointsIndexA))>=jnd_mapA(projPointsIndexA);
        logicB = abs(imageA(projPointsIndexB)-imageB(projPointsIndexB))>=jnd_mapB(projPointsIndexB);
        NPMapsA(projPointsA,1) = NPMapsA(projPointsA,1)+logicA;
        NPMapsB(projPointsB,1) = NPMapsB(projPointsB,1)+logicB;
    end
end

end