function result = mpeg_pcc_metrics_jnd(pcA,pcB,NPMapsA,NPMapsB)
% pcA:reference pcB:distorted
% pcA has to contain normals
% author:Wang Zhengyu
% pPSNR:resolution
pcACoor = pcA.Location;
pcBCoor = pcB.Location;
pcA=pointCloud(pcACoor,'Color',pcA.Color,'Normal',pcA.Normal);
pcB=pointCloud(pcBCoor,'Color',pcB.Color);
pPSNR=min(calculate_ps(pcA),calculate_ps(pcB));

pcB_nor = scaleNormals(pcA,pcB);
pcA_nor = pcA.Normal;

result1 = findMetric_jnd(pcA,pcB,pcB_nor,pPSNR,NPMapsA,NPMapsB);
result2 = findMetric_jnd(pcB,pcA,pcA_nor,pPSNR,NPMapsB,NPMapsA);
result = compare_result(result1,result2);
end
