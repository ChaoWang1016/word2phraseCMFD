function [W] = heatmap_edge(OI,P,sigma)
%% detect edge

load('model.mat');
E=edgesDetect(OI,model);

%% heatmap
SZ=ceil(6*sqrt(1/(2*sigma)));
[X,Y] = meshgrid(1:SZ,1:SZ);
Y = (2.*Y-SZ-1)./2;
X = (2.*X-SZ-1)./2;
d=sqrt(X.^2+Y.^2);
PZ=d>(SZ/2);
fl=exp(-sigma*d);
fl(PZ)=0;
map=imfilter(E,fl);
%
figure('Name','Feature Description [phrase level] :: Edge based heatmap');
imshow(map,[]);
%
%% get wights
i=P(1,:); j=P(2,:);
W=map(sub2ind(size(map),i,j));
maxIs=max(W);
minIs=min(W);
W=(W-minIs)./(maxIs-minIs);
W=W+1;
end