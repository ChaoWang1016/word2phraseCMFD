 function [MP,MF,MOF,tt] = Matching_word(F,OF,P,M_DIST,M_2NN,M_MM,OI,F_BZ)
 clc;
 fprintf(1,'Matching [word level]...\n');
 st1=tic;
 %% Prepro. the inputs
 [P,ia,~]=unique(P,'rows','stable');
 F{1,1}=F{1,1}(ia,:);F{2,1}=F{2,1}(ia,:);
 OF=OF(ia,:);
 %% Clustering
 [~,L1]=size(F{1,1});
 [~,L2]=size(F{2,1});
 U=horzcat(F{1,1},F{2,1},P,OF);
 Group1=cell(1,1);
 Group1{1,1}=U;
 for i=1:1:L1
     Group2=cell(1,2^i);
     for j=1:1:2^(i-1)
         temp = Group1{1,j};
         MaxIs = max(temp(:,i));
         MinIs = min(temp(:,i));
         MedIs = (MaxIs+MinIs)/2;
         pz1 = temp(:,i)<=MedIs;
         temp1 = temp(pz1,:); temp2 = temp(~pz1,:);
         Group2{1,2*j-1} = temp1;Group2{1,2*j} = temp2;
     end
     Group1=Group2;
 end
 t1=toc(st1);
 
 figure('Name','Feature Matching [word level] :: Coarse-grained matching'); imshow(OI), hold on;
 cmap =colormap(colorcube(2^L1+1));

 for index=1:1:2^L1
     U=Group1{1,index};
     P=U(:,L1+L2+1:L1+L2+3);
     P=real(P');
     plot(P(2,:),P(1,:),'.','MarkerSize',9,'MarkerEdgeColor',cmap(index,:),'MarkerEdgeColor',cmap(index,:));%,'MarkerSize',10
 end
 
 st2=tic;
 %% Matching
 UMP=cell(1,2^L1);
 UMF=cell(1,2^L1);
 UMOF=cell(1,2^L1);
 for index=1:1:2^L1
     U=Group1{1,index};
     F=U(:,L1+1:L1+L2);
     P=U(:,L1+L2+1:L1+L2+3);
     OF=U(:,L1+L2+4:end);
     F=horzcat(real(F),imag(F))';
     P=real(P');
     OF=OF';
     if size(F,2)<=2
         UMP{1,index}=[];
         UMOF{1,index}=[];
         UMF{1,index}=[];
     else
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
         MASKofMM=sml2<M_MM;
         MASKofDIST=dist>M_DIST;
         MASK=(MASKofSML|MASKofMM)&MASKofDIST;
         %%
         PZ=MASK(1,:);
         x1=P(1,PZ);
         x2=P(1,idx(1,PZ));
         y1=P(2,PZ);
         y2=P(2,idx(1,PZ));
         s1=P(3,PZ);
         s2=P(3,idx(1,PZ));
         temp=[x1;y1;x2;y2;s1;s2];
         UMP{1,index}=temp;
         mof1=OF(:,PZ);
         mof2=OF(:,idx(1,PZ));
         temp=[mof1;mof2];
         UMOF{1,index}=temp;
         mf1=F(:,PZ);
         mf2=F(:,idx(1,PZ));
         temp=[mf1;mf2];
         UMF{1,index}=temp;
     end
 end
%% Union
MP=[];
MOF=[];
MF=[];
for index=1:1:2^L1
    MP=horzcat(MP,UMP{1,index});
    MOF=horzcat(MOF,UMOF{1,index});
    MF=horzcat(MF,UMF{1,index});
end
t2=toc(st2);
tt=t1+t2;

figure('Name','Feature Matching [word level] :: Fine-grained matching');
imshow(OI);
[~,SZMP]=size(MP);
theta=0:2*pi/36:2*pi;
for i=1:1:SZMP
    hold on;
    x1=MP(1,i);x2=MP(3,i);y1=MP(2,i);y2=MP(4,i);s1=MP(5,i);s2=MP(6,i);
    x=[y1,y2]; y=[x1,x2]; 
    plot(y1+floor((F_BZ*s1)/2)*cos(theta),x1+floor((F_BZ*s1)/2)*sin(theta),'y','Linewidth',1.5);
    plot(y2+floor((F_BZ*s2)/2)*cos(theta),x2+floor((F_BZ*s2)/2)*sin(theta),'y','Linewidth',1.5);
    plot(x,y,'b-','linewidth',1.5);
end

end

 
 