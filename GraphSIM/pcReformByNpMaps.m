function pc_r = pcReformByNpMaps(pc_r,idxA,pc_r_coor)
pcColor = pc_r.Color;
pcColor(idxA,:)=[];
pc_r_coor(idxA,:)=[];
pc_r=pointCloud(pc_r_coor,'Color',pcColor);
end