function pcB_nor = scaleNormals(pcA,pcB)
% pcA(ply) = reference (contain Normals) pcB(ply) = distorted pc
% return the normals of B caculated by normals of A
% pcA = pcread('bag.ply');
% pcB = pcread('bag_gQP_2_tQP_3.ply');
pcA_cor = pcA.Location;
pcB_cor = pcB.Location;
pcA_nor = pcA.Normal;
nCount = zeros(pcB.Count,1);
pcB_nor = single(zeros(pcB.Count,3));
[idx1,~] = knnsearch(pcA_cor,pcB_cor); 
[idx2,~] = knnsearch(pcB_cor,pcA_cor); 

for i = 1:pcA.Count 
    j = idx2(i);
    pcB_nor(j,:) = pcB_nor(j,:) + pcA_nor(i,:);
    nCount(j) = nCount(j) + 1;
end

for i = 1:pcB.Count 
    j = idx1(i); 
    if (nCount(i)==0)
        pcB_nor(i,:) = pcA_nor(j,:);
    else
        pcB_nor(i,:) = pcB_nor(i,:)/nCount(i);
    end
end
end