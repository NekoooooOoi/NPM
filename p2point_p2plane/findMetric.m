function result = findMetric(pcA,pcB,pcB_nor,pPSNR)
% pcA = pcread('bag.ply');
% pcB = pcread('bag_gQP_2_tQP_3.ply');
% pPSNR = 2048;
% pcB_nor = scaleNormals(pcA,pcB);

pcA_cor = pcA.Location;
pcB_cor = pcB.Location;
p2point_distance = zeros(pcA.Count,1); 
p2plane_distance = zeros(pcA.Count,1);
%p2point/p2plane/YUV
[idx,idt] = knnsearch(pcB_cor,pcA_cor,'K',10); 
err_vector = single(zeros(pcA.Count,3));
for i = 1:pcA.Count
    j = idx(i,1);
    err_vector(i,:) = pcA_cor(i,:) - pcB_cor(j,:);
    p2point_distance(i) = err_vector(i,:) * err_vector(i,:)'; 
    disproJ = err_vector(i,:) * pcB_nor(j,:)';
    p2plane_distance(i) = disproJ * disproJ;
    %average color
    lable = find(idt(i,:)==idt(i,1));
    lable = idx(i,lable);
    [~,colums] = size(lable);

    
    
end


result.p2point_MSE = mean(p2point_distance);
result.p2point_MSE_PSNR = getPSNR(pPSNR,result.p2point_MSE,3);
result.p2plane_MSE = mean(p2plane_distance);
result.p2plane_MSE_PSNR = getPSNR(pPSNR,result.p2plane_MSE,3);
end

