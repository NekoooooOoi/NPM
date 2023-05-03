function result = findMetric_jnd(pcA,pcB,pcB_nor,pPSNR,NPMapsA,NPMapsB)
% pcA = pcread('bag.ply');
% pcB = pcread('bag_gQP_2_tQP_3.ply');
% pPSNR = 2048;
% pcB_nor = scaleNormals(pcA,pcB);
%initialization
idxA=find(NPMapsA(:,2)==0);
idxB=find(NPMapsB(:,2)==0);
NPMapsA(idxA,2)=1;
NPMapsB(idxB,2)=1;
pcA_cor = pcA.Location;
pcB_cor = pcB.Location;
% delete not projected points
NPA=NPMapsA(:,1)./NPMapsA(:,2);
NPB=NPMapsB(:,1)./NPMapsB(:,2);
pcA_size = size(pcA_cor,1);
p2point_distance = zeros(pcA_size,1); 
p2plane_distance = zeros(pcA_size,1);
%p2point/p2plane/YUV
[idx,idt] = knnsearch(pcB_cor,pcA_cor,'K',10); 
err_vector = single(zeros(pcA_size,3));
for i = 1:pcA_size
    j = idx(i,1);
    NPA(i)=max(NPA(i),NPB(j));
    err_vector(i,:) = pcA_cor(i,:) - pcB_cor(j,:);
    p2point_distance(i) = err_vector(i,:) * err_vector(i,:)'; 
    disproJ = err_vector(i,:) * pcB_nor(j,:)';
    p2plane_distance(i) = disproJ * disproJ;
    %average color
    lable = find(idt(i,:)==idt(i,1));
    lable = idx(i,lable);
    [~,colums] = size(lable);
 
end
%NP
p2point_distance=p2point_distance.*NPA;
p2plane_distance=p2plane_distance.*NPA;
%scores
result.p2point_MSE = mean(p2point_distance);
result.p2point_MSE_PSNR = getPSNR(pPSNR,result.p2point_MSE,3);
result.p2plane_MSE = mean(p2plane_distance);
result.p2plane_MSE_PSNR = getPSNR(pPSNR,result.p2plane_MSE,3);
end

