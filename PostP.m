 function [G,MP3,tt] = PostP(MP1,MOF1,PP_NoBin,PP_Count,PP_EpsilonNB,PP_MinPts,PP_BW,PP_MinArea,PP_ROI_flge,PP_ROI_SE,PP_ROI_Num,PP_FL_SZ,PP_FL_std,PP_SSIM_SE,PP_SSIM_std,PP_sigma,OI,GI,F_BZ,F_NM )
 clc;
 fprintf(1,'Post P....\n');
 %% 1st f.
 t1st=tic;
 [MP2,MOF2,dertaX,dertaY,flg] = filtering_1st(MP1,MOF1,PP_NoBin,PP_Count,OI);
 if flg==1
     G=zeros(size(GI));
     MP3=[];
     tt=0;
     return;
 end 
 dertaX=[dertaX,0];dertaY=[dertaY,0];
 [idx,~]=slowdbscan([dertaX',dertaY'],PP_EpsilonNB,PP_MinPts);
 idx=idx(1:end-1)';
 NoC=max(idx);
 if NoC>=10
     [idx,~]=slowdbscan([dertaX',dertaY'],20,PP_MinPts);
     idx=idx(1:end-1)';
     NoC=max(idx);
 end
 t1=toc(t1st);
 %
 figure('Name','Post-processing : : First-stage filtering and adaptive clustering');
 markerstyle = {'o','v','s','^','x','<','>','.','+','o','v','s','^','x','<','>','.','+','o','v','s','^','x','<','>','.','+','o','v','s','^','x','<','>','.','+'};
 colorstyle = colormap(hsv(NoC));
 atext={};
 aleg=[];
 imshow(OI);
 theta=0:2*pi/36:2*pi;
 for j=1:1:NoC
     p=idx==j;
     if sum(p)>0
         TEMP=MP2(:,p);
         [~,SZMP]=size(TEMP);
         for i=1:1:SZMP
             hold on;
             x1=TEMP(1,i);x2=TEMP(3,i);y1=TEMP(2,i);y2=TEMP(4,i);s1=TEMP(5,i);s2=TEMP(6,i);
             y=[x1,x2];x=[y1,y2];
             plot(y1+floor((F_BZ*s1)/2)*cos(theta),x1+floor((F_BZ*s1)/2)*sin(theta),'y','Linewidth',1.5);
             plot(y2+floor((F_BZ*s2)/2)*cos(theta),x2+floor((F_BZ*s2)/2)*sin(theta),'y','Linewidth',1.5);
             plot(x,y,'-','linewidth',1.5,'color',colorstyle(j,:));
         end
         atext=[atext;['C',num2str(j)]];
         aleg=[aleg;plot(x,y,'-','linewidth',1,'color',colorstyle(j,:))];
     end
 end
 hl=legend(aleg,atext);
 set(hl,'FontSize',26,'FontName','Times New Roman');
 
 figure('Name','Post-processing :: Cluster (first-stage filtering)');
 for i=1:1:NoC;
     p=idx==i;
     if sum(p)>0
         plot(dertaX(p),dertaY(p),'marker',char(markerstyle(i)),'color',colorstyle(i,:),'Linewidth',1.5,'MarkerSize',15, 'MarkerFaceColor',colorstyle(i,:));
         hold on;
     end
 end
 set(gcf,'position',[500,100,700,550]);
 set(gca,'FontSize',23,'FontName','Times New Roman');
 hl=legend(atext,'Location','NorthEastOutside');
 set(hl,'FontSize',26,'FontName','Times New Roman');
 xlabel('\Delta\itx','FontSize',26,'FontName','Times New Roman');
 ylabel('\Delta\ity','FontSize',26,'FontName','Times New Roman');
%  
 %
 %% 2nd f.
 t2st=tic;
 [idx] = filtering_2nd(idx,MOF2,PP_NoBin,PP_Count,F_NM );
 if sum(idx>=1)==0
     G=zeros(size(GI));
     MP3=[];
     tt=0;
     return;
 end 
 t2=toc(t2st);
 %
 figure('Name','Post-processing :: Second-stage filtering and adaptive clustering');
 markerstyle = {'o','v','s','^','x','<','>','.','+','o','v','s','^','x','<','>','.','+','o','v','s','^','x','<','>','.','+','o','v','s','^','x','<','>','.','+'};
 colorstyle = colormap(hsv(NoC));
 atext={};
 aleg=[];
 imshow(OI);
 theta=0:2*pi/36:2*pi;
 [SZ1,SZ2,~]=size(OI);
 for j=1:1:NoC
     p=idx==j;
     if sum(p)>0
         TEMP=MP2(:,p);
         [~,SZMP]=size(TEMP);
         for i=1:1:SZMP
             hold on;
             x1=TEMP(1,i);x2=TEMP(3,i);y1=TEMP(2,i);y2=TEMP(4,i);s1=TEMP(5,i);s2=TEMP(6,i);
             y=[x1,x2];x=[y1,y2];
             plot(y1+floor((F_BZ*s1)/2)*cos(theta),x1+floor((F_BZ*s1)/2)*sin(theta),'y','Linewidth',1.5);
             plot(y2+floor((F_BZ*s2)/2)*cos(theta),x2+floor((F_BZ*s2)/2)*sin(theta),'y','Linewidth',1.5);
             plot(x,y,'-','linewidth',1.5,'color',colorstyle(j,:));
         end
         atext=[atext;['C',num2str(j)]];
         aleg=[aleg;plot(x,y,'-','linewidth',1,'color',colorstyle(j,:))];
     end
 end
 hl=legend(aleg,atext);
 set(hl,'FontSize',26,'FontName','Times New Roman');
 %
 figure('Name','Post-processing :: Cluster (second-stage filtering)');
 for i=1:1:NoC;
     p=idx==i;
     if sum(p)>0
         plot(dertaX(p),dertaY(p),'marker',char(markerstyle(i)),'color',colorstyle(i,:),'Linewidth',1.5,'MarkerSize',15, 'MarkerFaceColor',colorstyle(i,:));
         hold on;
     end
 end
 set(gcf,'position',[500,100,700,550]);
 set(gca,'FontSize',23,'FontName','Times New Roman');
 hl=legend(atext,'Location','NorthEastOutside');
 set(hl,'FontSize',26,'FontName','Times New Roman');
 xlabel('\Delta\itx','FontSize',26,'FontName','Times New Roman');
 ylabel('\Delta\ity','FontSize',26,'FontName','Times New Roman');
 %
 %% Keypoint ROI map
 t3st=tic;
 [SZ1,SZ2,~]=size(OI);
 if PP_ROI_flge == 1
     ROI=zeros(SZ1,SZ2);
     [Y,X]=meshgrid(1:SZ2,1:SZ1);
     for j=1:1:NoC
         p=idx==j;
         if sum(p)>0
             TEMP=MP2(:,p);
             [~,SZMP]=size(TEMP);
             parfor i=1:1:SZMP
                 x1=TEMP(1,i);x2=TEMP(3,i);y1=TEMP(2,i);y2=TEMP(4,i);s1=TEMP(5,i);s2=TEMP(6,i);
                 PZ1=((Y-y1).^2+(X-x1).^2)<((floor((F_BZ*s1)/2))^2);
                 PZ2=((Y-y2).^2+(X-x2).^2)<((floor((F_BZ*s2)/2))^2);
                 ROI=ROI+PZ1+PZ2;
             end
         end
     end
     ROI=double(ROI);
     ROI = imdilate(ROI, strel('disk',PP_ROI_SE));
     SZ=ceil(6*sqrt(1/(2*PP_sigma)));
     [X,Y] = meshgrid(1:SZ,1:SZ);
     Y = (2.*Y-SZ-1)./2;
     X = (2.*X-SZ-1)./2;
     d=sqrt(X.^2+Y.^2);
     PZ=d>(SZ/2);
     fl=exp(-PP_sigma*d);
     fl(PZ)=0;
     ROIMap=imfilter(ROI,fl);
     temp=PP_ROI_Num*ones(size(fl));
     tempMap=imfilter(temp,fl);
     maxIs=mean(tempMap(:));
     minIs=0;
     ROIMap=(ROIMap-minIs)./(maxIs-minIs);
     ROIMap(ROIMap>1)=1;
 else
     ROIMap=ones(SZ1,SZ2);
 end
 t3=toc(t3st);
 %
 figure('Name','Post-processing :: Keypoint ROI based heatmap');
 imshow(ROIMap,[0,1]);
 %
 %% RANSAC+Localizing(SSIM+ROI)
 t4st=tic;
 RES=cell(1,NoC);
 GRD=cell(1,NoC);
 Map=zeros(size(GI));
 for i=1:1:NoC;
     p=idx==i;
     CMP=MP2(:,p);
     if size(CMP,2)>=3
         [results]=runRANSAC(CMP);
         if sum(results.CS)>=2
             RES{i}=results;
             [GRD{i},orgMap]= localizing(results,CMP,GI,ROIMap,PP_FL_SZ,PP_FL_std,PP_BW,PP_MinArea,PP_SSIM_SE,PP_SSIM_std);
             Map=Map+orgMap;
         else
             RES{i}=[];
             GRD{i}=zeros(size(GI));
         end
     else
         RES{i}=[];
         GRD{i}=zeros(size(GI));
     end
 end
 [M,N]=size(GI);
 G=zeros(M,N);
 p=idx>0;
 MP3=MP2(:,p);
 t4=toc(t4st);
 %
 figure('Name','Post-processing :: SSIM map');
 imshow(Map,[]);
 %
 %
 figure('Name','Post-processing :: Forgery localization for each cluster');
 flg=0;
 if NoC<=0 || NoC==2 || NoC==1
     PL=1;
     flg=1;
 elseif isprime(NoC)==0
     a=1:NoC;
     bc=a(mod(NoC,a)==0);
     PL=bc(end-1);
     
 else
     a=1:NoC+1;
     bc=a(mod(NoC+1,a)==0);
     PL=bc(end-1);
     flg=2;
 end
 if flg==0
     ha = tight_subplot(NoC/PL,PL,[.04 .04],[.04 .04],[.02 .02]);
     for i=1:1:NoC;
         axes(ha(i));imshow(GRD{1, i});text(200,200,['C',num2str(i)],'Color','y','FontSize',24,'FontName','Times New Roman');axis off;
         G=G+GRD{1, i};
     end
 elseif flg==1
     ha = tight_subplot(PL,NoC/PL,[.02 .02],[.04 .04],[.02 .02]);
     for i=1:1:NoC;
         axes(ha(i));imshow(GRD{1, i});text(200,200,['C',num2str(i)],'Color','y','FontSize',24,'FontName','Times New Roman');axis off;
         G=G+GRD{1, i};
     end
 else
     ha = tight_subplot((NoC+1)/PL,PL,[.02 .02],[.04 .04],[.02 .02]);
     for i=1:1:NoC;
         axes(ha(i));imshow(GRD{1, i});text(200,200,['C',num2str(i)],'Color','y','FontSize',24,'FontName','Times New Roman');axis off;
         G=G+GRD{1, i};
     end
     axes(ha(i+1));axis off;
 end
 %
 G(G~=0) =1;
 tt=t1+t2+t3+t4;
 end