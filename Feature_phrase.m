function [F_pl,P_pl,OF_pl,tt]  =	Feature_phrase(MP_wl,MF_wl,MOF_wl,F_K,F_sigma,OI)
 clc;
 fprintf(1,'Feature [phrase level]...\n');
 st1=tic;
 %% Prepro. the inputs
 P=[MP_wl([1,2,5],:),MP_wl([3,4,6],:)];
 [SZ1,~]=size(MF_wl);
 F=[MF_wl(1:SZ1/2,:),MF_wl(1+SZ1/2:end,:)];
 [SZ2,~]=size(MOF_wl);
 OF=[MOF_wl(1:SZ2/2,:),MOF_wl(1+SZ2/2:end,:)];
 %% Find K-NN of point in image space
 kdtree = vl_kdtreebuild(P(1:2,:), 'NumTrees', 1) ;
 [idx, ~] = vl_kdtreequery(kdtree, P(1:2,:), P(1:2,:), 'NumNeighbors', F_K+1);
 idx=idx(2:end,:);

 %% Comput GPP feature
 [~,SZ3]=size(idx);
 MazVal=zeros(SZ1/2,SZ3);
 parfor i=1:1:SZ3
     PZ=idx(:,i);
     temp=F(:,PZ);
     MazVal(:,i)=max(temp,[],2);
 end
 GPPF=F+MazVal;
 %% Edge based heatmap
[W] = heatmap_edge(OI,P,F_sigma);
[SZ2,~]=size(GPPF);
WGPPF=0.*GPPF;
for i=1:1:SZ2
    WGPPF(i,:)=W.*GPPF(i,:);
end
%% Output
F_pl=WGPPF;
P_pl=P;
OF_pl=OF;
tt=toc(st1);
end
