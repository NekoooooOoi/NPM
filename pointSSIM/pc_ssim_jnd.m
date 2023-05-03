function [pointssim] = pc_ssim_jnd(pcA, pcB, PARAMS,NPMapsA,NPMapsB)

if nargin < 2
    error('Too few input arguments.');
else
    if ~isfield(pcA,'geom') || ~isfield(pcB,'geom')
        error('No coordinates found in input point cloud(s).');
    end
    
    if nargin == 2
        if isfield(pcA,'color') && isfield(pcB,'color')
            % Default parameters
            PARAMS.ATTRIBUTES.GEOM = false;
            PARAMS.ATTRIBUTES.NORM = false;
            PARAMS.ATTRIBUTES.CURV = false;
            PARAMS.ATTRIBUTES.COLOR = true;

            PARAMS.ESTIMATOR_TYPE = {'VAR'};
            PARAMS.POOLING_TYPE = {'Mean'};
            PARAMS.NEIGHBORHOOD_SIZE = 12;
            PARAMS.CONST = eps(1);
            PARAMS.REF = 0;
        else
           error('Configure PARAMS.');
        end
    else
        if PARAMS.ATTRIBUTES.NORM && (~isfield(pcA,'norm') || ~isfield(pcB,'norm'))
            error('No normals found in input point cloud(s).');
        end
        if PARAMS.ATTRIBUTES.CURV && (~isfield(pcA,'curv') || ~isfield(pcB,'curv'))
            error('No curvatures found in input point cloud(s).');
        end
        if PARAMS.ATTRIBUTES.COLOR && (~isfield(pcA,'color') || ~isfield(pcB,'color'))
            error('No color found in input point cloud(s).');
        end
    end
end



%% Conversion to double
A = structfun(@double, pcA, 'UniformOutput', false);
B = structfun(@double, pcB, 'UniformOutput', false);
idxA=find(NPMapsA(:,2)==0);
idxB=find(NPMapsB(:,2)==0);
NPMapsA(idxA,2)=1;
NPMapsB(idxB,2)=1;
pcA_coor = A.geom;
pcA_col=A.color;
pcB_coor = B.geom;
pcB_col=B.color;
A.geom=pcA_coor;
A.color=pcA_col;
B.geom=pcB_coor;
B.color=pcB_col;
NPA=NPMapsA(:,1)./NPMapsA(:,2);
NPB=NPMapsB(:,1)./NPMapsB(:,2);

%% Formulation of neighborhoods in point clouds A and B
[idA, distA] = knnsearch(A.geom, A.geom, 'K', PARAMS.NEIGHBORHOOD_SIZE);
[idB, distB] = knnsearch(B.geom, B.geom, 'K', PARAMS.NEIGHBORHOOD_SIZE);
NPA_neig = NPA(idA);
NPB_neig = NPB(idB);
possA= mean(NPA_neig,2);
possB= mean(NPB_neig,2);

%% Association of neighborhoods between point clouds A and B
% Loop over B and find nearest neighbor in A (set A as the reference)
[idBA, ~] = knnsearch(A.geom, B.geom);
possiMaxB=max(possB,possA(idBA));
% Loop over A and find nearest neighbor in B (set B as the reference)
[idAB, ~] = knnsearch(B.geom, A.geom);
possiMaxA=max(possA,possB(idAB));


%% Structural similarity scores based on geometry-related features
if PARAMS.ATTRIBUTES.GEOM
    % Quantities as distances between a point and each neighbor
    geomQuantA = distA(:, 2:end);
    geomQuantB = distB(:, 2:end);

    % Structural similarity score(s)
    [pointssim.geomBA, pointssim.geomAB, pointssim.geomSym] = ssim_score_jnd(geomQuantA, geomQuantB, idBA, idAB, PARAMS,possiMaxA,possiMaxB);

    fprintf('Structural similarity scores based on geometry-related features\n');
end


%% Structural similarity scores based on normal-related features
if PARAMS.ATTRIBUTES.NORM 
    % Quantities as normal similarities between a point and each neighbor
    nsA = real( 1 - 2*acos(abs(sum(A.norm(idA,:).*repmat(A.norm,[PARAMS.NEIGHBORHOOD_SIZE,1]), 2)./(sqrt(sum(A.norm(idA,:).^2,2)).*sqrt(sum(repmat(A.norm,[PARAMS.NEIGHBORHOOD_SIZE,1]).^2,2)))))/pi );
    normQuantA = reshape(nsA, [size(nsA,1)/PARAMS.NEIGHBORHOOD_SIZE, PARAMS.NEIGHBORHOOD_SIZE]);
    nsB = real( 1 - 2*acos(abs(sum(B.norm(idB,:).*repmat(B.norm,[PARAMS.NEIGHBORHOOD_SIZE,1]), 2)./(sqrt(sum(B.norm(idB,:).^2,2)).*sqrt(sum(repmat(B.norm,[PARAMS.NEIGHBORHOOD_SIZE,1]).^2,2)))))/pi );
    normQuantB = reshape(nsB, [size(nsB,1)/PARAMS.NEIGHBORHOOD_SIZE, PARAMS.NEIGHBORHOOD_SIZE]);
    normQuantA(:,1) = [];
    normQuantB(:,1) = [];

    % Structural similarity score(s)
    [pointssim.normBA, pointssim.normAB, pointssim.normSym] = ssim_score(normQuantA, normQuantB, idBA, idAB, PARAMS);

    fprintf('Structural similarity scores based on normal-related features\n');
end


%% Structural similarity scores based on curvature-related features
if PARAMS.ATTRIBUTES.CURV 
    % Quantities as curvature of points that belong to the neighborhood
    curvQuantA = real(A.curv(idA));
    curvQuantB = real(B.curv(idB));

    % Structural similarity score(s)
    [pointssim.curvBA, pointssim.curvAB, pointssim.curvSym] = ssim_score(curvQuantA, curvQuantB, idBA, idAB, PARAMS);

    fprintf('Structural similarity scores based on curvature-related features\n');
end


%% Structural similarity scores based on color-related features
if PARAMS.ATTRIBUTES.COLOR
    % Quantities as luminance of points that belong to the neighborhood
    [yA, ~, ~] = rgb_to_yuv(A.color(:,1), A.color(:,2), A.color(:,3));
    [yB, ~, ~] = rgb_to_yuv(B.color(:,1), B.color(:,2), B.color(:,3));
    colorQuantA = double(yA(idA));
    colorQuantB = double(yB(idB));

    % Structural similarity score(s)
    [pointssim.colorBA, pointssim.colorAB, pointssim.colorSym] = ssim_score_jnd(colorQuantA, colorQuantB, idBA, idAB, PARAMS,possiMaxA,possiMaxB);

    fprintf('Structural similarity scores based on color-related features\n');
end
