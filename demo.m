% demo.m provides an example to use the functions.
%% import the point cloud files
pcA=pcread('longdress_vox10_1300.ply');% reference point cloud
pcA_norm = pcnormals(pcA);
pcA.Normal = pcA_norm;
pcB=pcread('longdress_gpccOT_r01.ply');% distorted point cloud
pc_fast = pcread('longdress_vox10_1300_resample.ply');% resampled points of the reference point cloud
NPMapsA=importdata('longdress_gpccOT_r01_ref.mat');% NPM of reference point cloud
NPMapsB=importdata('longdress_gpccOT_r01_dis.mat');% NPM of distorted point cloud
%% p2point and p2plane
resultORI = mpeg_pcc_metrics(pcA,pcB,min(calculate_ps(pcA),calculate_ps(pcB)));
resultNP = mpeg_pcc_metrics_jnd(pcA,pcB,NPMapsA,NPMapsB);
%% GraphSIM
graphSimOri = GraphSIM( pcA, pcB,pc_fast);
graphSimNP = GraphSIM_jnd( pcA, pcB,pc_fast,NPMapsA,NPMapsB);
%% PointSSIM
A.geom = pcA.Location;
A.color = pcA.Color;
B.geom = pcB.Location;
B.color = pcB.Color;
PARAMS.ATTRIBUTES.GEOM = true;
PARAMS.ATTRIBUTES.NORM = false;
PARAMS.ATTRIBUTES.CURV = false;
PARAMS.ATTRIBUTES.COLOR = true;
PARAMS.ESTIMATOR_TYPE = {'VAR'};
PARAMS.POOLING_TYPE = {'Mean'};
PARAMS.NEIGHBORHOOD_SIZE = 12;
PARAMS.CONST = eps(1);
PARAMS.REF = 0;
[pointssim_ori] = pc_ssim(A, B, PARAMS);
[pointssim_new] = pc_ssim_jnd(A, B, PARAMS,NPMapsA,NPMapsB);
ssim_ori_geo = pointssim_ori.geomSym;
ssim_new_geo = pointssim_new.geomSym;
ssim_ori_color = pointssim_ori.colorSym;
ssim_new_color = pointssim_new.colorSym;
%% plane2plane
plane2plane=plane2plane(pcA, pcB);
plane2plane_jnd = plane2plane_jnd(pcA, pcB,NPMapsA,NPMapsB);