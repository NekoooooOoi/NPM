function result = mpeg_pcc_metrics(pcA,pcB,pPSNR)
% pcA:reference pcB:distorted
% pcA has to contain normals
% author:Wang Zhengyu
% pPSNR:resolution

pcB_nor = scaleNormals(pcA,pcB);
pcA_nor = pcA.Normal;

result1 = findMetric(pcA,pcB,pcB_nor,pPSNR);
result2 = findMetric(pcB,pcA,pcA_nor,pPSNR);
result = compare_result(result1,result2);
end
