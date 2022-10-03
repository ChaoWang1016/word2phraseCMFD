function [Ground,orgMap] = localizing(results,CMP,GI,ROIMap,PP_FL_SZ,PP_FL_std,PP_BW,PP_MinArea,PP_SE,PP_SSIM_std)
%%
H=fspecial('gaussian',[PP_FL_SZ,PP_FL_SZ],PP_FL_std);
GI=imfilter(GI,H);
%%
[SZ1,SZ2]=size(GI);
H = [results.Theta(1) -results.Theta(2) 0; results.Theta(2) results.Theta(1) 0; results.Theta(4) results.Theta(3) 1];
forward = maketform('affine',H);
[newWarp] = imtransform(GI,forward,'xdata',[1, SZ2],'ydata',[1, SZ1]);
temp=invert(affine2d(forward.tdata.T));
backward=maketform('affine',temp.T);
[inverse_newWarp] = imtransform(GI,backward,'xdata',[1, SZ2],'ydata',[1, SZ1]);
%%
A = newWarp;
B = GI;
C = inverse_newWarp;
[zncc1BW,org1] = correlation(B,A,ROIMap,PP_BW,PP_MinArea,PP_SE,PP_SSIM_std);
[zncc2BW,org2]= correlation(B,C,ROIMap,PP_BW,PP_MinArea,PP_SE,PP_SSIM_std);
zncc3BW = zncc1BW + zncc2BW;
zncc3BW(zncc3BW~=0) =1;
orgMap=org1+org2;
[p,q] = size(zncc3BW);
minarea = p * q * PP_MinArea; 
[l,n]=bwlabel(zncc3BW,4);
for i = 1:n
    [r,c] = find(l == i);
    num = numel(find(l == i));
    if num < minarea
         zncc3BW(sub2ind(size(zncc3BW), r, c)) = 0;
    end
end
PBW=zeros(SZ1,SZ2);PBW(sub2ind(size(PBW), [CMP(1,:)';CMP(3,:)'], [CMP(2,:)';CMP(4,:)']))=1;
[l,n]=bwlabel(zncc3BW,4);
for i = 1:n
    [r,c] = find(l == i);
    ABW=zeros(SZ1,SZ2);ABW(sub2ind(size(ABW), r, c))=1;
    U=PBW.*ABW;    
    if sum(U(:)) < 3
        zncc3BW(sub2ind(size(zncc3BW), r, c)) = 0;
    end
end
Ground = zncc3BW;
end