function asimSym = plane2plane_jnd(pcA, pcB,NPMapsA,NPMapsB)
% Copyright (C) 2018 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE, Switzerland
%
%     Multimedia Signal Processing Group (MMSPG)
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%
% Author:
%   Evangelos Alexiou (evangelos.alexiou@epfl.ch)
%
% Reference:
%   E. Alexiou and T. Ebrahimi, "Point Cloud Quality Assessment Metric
%   Based on Angular Similarity," 2018 IEEE International Conference on
%   Multimedia and Expo (ICME), San Diego, CA, 2018, pp. 1-6.
%
%
% Angular similarity between point clouds A and B quantifies the difference
%   in orientation of tangent planes corresponding to associated points
%   that belong to the two models. The points are associated as nearest
%   neighbors and an individual angular similarity value is computed for
%   every pair. After pooling across the individual values, an angular
%   similarity score is obtained.
%
%   [asimBA, asimAB, asimSym] = pc_asim(A, B, POOLING_TYPE)
%
%   INPUTS
%       A, B: Point clouds in pointCloud format as defined in MATLAB. The
%           coordinates (e.g., A.Location, B.Location) and the normal
%           vectors (e.g., A.Normal, B.Normal) of both models are required.
%       POOLING_TYPE: Defines the pooling method that is applied on
%           individual angular similarity values obtained from pairs of
%           associated points. The following options are available:
%           {'Mean', 'Min', 'Max', 'MS', 'RMS'}.
%
%   OUTPUTS
%       asimBA: Angular similarity score of point cloud B, using A as
%           reference. The computed score depends on POOLING_TYPE.
%       asimAB: Angular similarity score of point cloud A, using B as
%           reference. The computed score depends on POOLING_TYPE.
%       asimSym: Symmetric angular similarity score, using both A and B as
%           reference. The computed score depends on POOLING_TYPE.


idxA=find(NPMapsA(:,2)==0);
idxB=find(NPMapsB(:,2)==0);
NPMapsA(idxA,2)=1;
NPMapsB(idxB,2)=1;
pcA_coor = pcA.Location;
pcA_col=pcA.Color;
pcB_coor = pcB.Location;
pcB_col=pcB.Color;
NPA=NPMapsA(:,1)./NPMapsA(:,2);
NPB=NPMapsB(:,1)./NPMapsB(:,2);
pcA= pointCloud(pcA_coor,'Color',pcA_col);
pcB= pointCloud(pcB_coor,'Color',pcB_col);
pcA.Normal=pcnormals(pcA);
pcB.Normal=pcnormals(pcB);

POOLING_TYPE='Mean';
if nargin < 2
    error('Too few input arguments.');
elseif nargin==2
    POOLING_TYPE = 'Mean';
elseif nargin>2
    switch POOLING_TYPE
        case {'Mean', 'Min', 'Max', 'MS', 'RMS'}
        otherwise
            error('POOLING_TYPE is not supported.');
    end
end

if isempty(pcA.Location) || isempty(pcB.Location)
    error('No coordinates found in input point cloud(s).');
end

if isempty(pcA.Normal) || isempty(pcB.Normal)
    error('No normal vectors found in input point cloud(s).');
end



%% Association of points between point clouds A and B
% Loop over B and find nearest neighbor in A (set A as the reference)
[idBA, ~] = knnsearch(pcA.Location, pcB.Location);
% Loop over A and find nearest neighbor in B (set B as the reference)
[idAB, ~] = knnsearch(pcB.Location, pcA.Location);

possiMaxB=max(NPB,NPA(idBA));
possiMaxA=max(NPA,NPB(idAB));


%% Angular similarity score of B (set A as reference)
% Angular similarity between tangent planes of associated points
asBA = 1 - 2*acos(abs( sum(pcA.Normal(idBA,:).*pcB.Normal,2)./(sqrt(sum(pcA.Normal(idBA,:).^2,2)).*sqrt(sum(pcB.Normal.^2,2))) ))/pi;
asBA=asBA.*possiMaxB + (1-possiMaxB);
% Pooling
if strcmp(POOLING_TYPE, 'Mean')
    asimBA = nanmean(real(asBA));
elseif strcmp(POOLING_TYPE, 'Min')
    asimBA = nanmin(real(asBA));
elseif strcmp(POOLING_TYPE, 'Max')
    asimBA = nanmax(real(asBA));
elseif strcmp(POOLING_TYPE, 'MS')
    asimBA = nanmean(real(asBA).^2);
elseif strcmp(POOLING_TYPE, 'RMS')
    asimBA = sqrt(nanmean(real(asBA).^2));
else
    error('WrongInput');
end


%% Angular similarity score of A (set B as reference)
% Angular similarity between tangent planes of associated points
asAB = 1 - 2*acos(abs( sum(pcA.Normal.*pcB.Normal(idAB,:),2)./(sqrt(sum(pcA.Normal.^2,2)).*sqrt(sum(pcB.Normal(idAB,:).^2,2))) ))/pi;
asAB=asAB.*possiMaxA+(1-possiMaxA);
% Pooling
if strcmp(POOLING_TYPE, 'Mean')
    asimAB = nanmean(real(asAB));
elseif strcmp(POOLING_TYPE, 'Min')
    asimAB = nanmin(real(asAB));
elseif strcmp(POOLING_TYPE, 'Max')
    asimAB = nanmax(real(asAB));
elseif strcmp(POOLING_TYPE, 'MS')
    asimAB = nanmean(real(asAB).^2);
elseif strcmp(POOLING_TYPE, 'RMS')
    asimAB = sqrt(nanmean(real(asAB).^2));
else
    error(message('WrongInput'));
end


%% Symmetric angular similarity score
asimSym = nanmin(asimBA, asimAB);
