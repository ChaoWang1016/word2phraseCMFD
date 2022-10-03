function [MP_pl,MOF_pl,tt]  =	Matching_phrase(F_pl,OF_pl,P_pl,M_Dist,M_2NN,OI,F_BZ)
 clc;
 fprintf(1,'Matching [phrase level]...\n');
 st1=tic;
 %% Prepro. the inputs
 F=F_pl;OF=OF_pl;P=P_pl;
 [P,ia,~]=unique(P','rows','stable');
 P=P';
 F=F(:,ia);
 OF=OF(:,ia);
 %% 
 kdtree = vl_kdtreebuild(F, 'NumTrees', 1) ;
 [idx, ~] = vl_kdtreequery(kdtree, F, F, 'NumNeighbors', 3);
 idx=idx(2:end,:);
 [~,SZ]=size(F);
 %% 2NN
 sml1=zeros(1,SZ);
 sml2=zeros(1,SZ);
 dist=zeros(1,SZ);
 PZ=idx(1,:); MPF=F(:,PZ); sml1(1,:)=sqrt(sum((MPF-F).^2));
 MPP=P(:,PZ); dist(1,:)=sqrt(sum((MPP-P).^2));
 PZ=idx(2,:); MPF=F(:,PZ); sml2(1,:)=sqrt(sum((MPF-F).^2));
 MASKofSML=(sml1./sml2)<M_2NN;
 MASKofDIST=dist>M_Dist;
 MASK=MASKofSML&MASKofDIST;
 %%
 PZ=MASK(1,:);
 x1=P(1,PZ);
 x2=P(1,idx(1,PZ));
 y1=P(2,PZ);
 y2=P(2,idx(1,PZ));
 s1=P(3,PZ);
 s2=P(3,idx(1,PZ));
 temp=[x1;y1;x2;y2;s1;s2];
 MP=temp;
 mof1=OF(:,PZ);
 mof2=OF(:,idx(1,PZ));
 temp=[mof1;mof2];
 MOF=temp;
 %% Output
 MP_pl=MP;
 MOF_pl=MOF;
 tt=toc(st1);
 %%
%  
 figure('Name','Feature Matching [phrase level]');
 imshow(OI);
 [~,SZMP]=size(MP);
 theta=0:2*pi/36:2*pi;
 for i=1:1:SZMP
     hold on;
     x1=MP(1,i);x2=MP(3,i);y1=MP(2,i);y2=MP(4,i);s1=MP(5,i);s2=MP(6,i);
     y=[x1,x2];x=[y1,y2];
     plot(y1+floor((F_BZ*s1)/2)*cos(theta),x1+floor((F_BZ*s1)/2)*sin(theta),'y','Linewidth',1.5);
     plot(y2+floor((F_BZ*s2)/2)*cos(theta),x2+floor((F_BZ*s2)/2)*sin(theta),'y','Linewidth',1.5);
     plot(x,y,'b-','linewidth',1.5);
 end
%  
end