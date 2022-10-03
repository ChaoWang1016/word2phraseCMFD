function [RhoXY,OrgRhoXY] = correlation(X,Y,ROIMap,PP_BW,PP_MinArea,PP_SE,PP_SSIM_std)
X=double(X);
Y=double(Y);
%% SSIM + ROI
[~, OrgRhoXY] = ssim(X,Y,'Radius',PP_SSIM_std,'Exponents',[3,1,2]);
RhoXY = OrgRhoXY.*ROIMap;
%%
RhoXY( RhoXY >= PP_BW) = 1;
RhoXY( RhoXY < PP_BW) = 0;
sedisk = strel('disk',PP_SE);
RhoXY = imopen(RhoXY, sedisk);
[p,q] = size(RhoXY);
minarea = p * q * PP_MinArea; 
[l,n]=bwlabel(RhoXY,4);
for i = 1:n
    [r,c] = find(l == i);
    num = numel(find(l == i));
    if num < minarea
        RhoXY(r,c) = 0;
    end
end
RhoXY = imfill(RhoXY,'holes');
end