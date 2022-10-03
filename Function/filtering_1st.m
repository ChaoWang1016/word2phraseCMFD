function [MP,MOF,dertaX,dertaY,flg] = filtering_1st(MP,MOF,bin_num,T_count,II)
flg=0;
dertaX=MP(2,:)-MP(4,:);
dertaY=MP(1,:)-MP(3,:);
PZ=dertaY<0;
dertaX(PZ)=-dertaX(PZ);
dertaY(PZ)=-dertaY(PZ);
%
alpha=atan2d(dertaY,dertaX);
stp=180/bin_num(1,1);
bin=0:stp:180;
[bincounts] = histc(alpha,bin);
PZ=bincounts>T_count;
sbin=bin(PZ);
[~,SS]=size(sbin);
[~,SX]=size(dertaX);
PZ=zeros(1,SX);
for i=1:1:SS
    L=sbin(i);
    R=L+stp;
    pz1=alpha>=L;
    pz2=alpha<=R;
    pz=pz1&pz2;
    PZ=PZ|pz;
end
if sum(PZ)==0
    flg=1;
    return;
end
MP=MP(:,PZ);
MOF=MOF(:,PZ);
dertaX=dertaX(:,PZ);
dertaY=dertaY(:,PZ);
%
[WoI,LoI,~]=size(II);
rho=sqrt((dertaY).^2+(dertaX).^2);
stp=floor(sqrt(WoI^2+LoI^2))/bin_num(1,2);
bin=0:stp:floor(sqrt(WoI^2+LoI^2));
[bincounts] = histc(rho,bin);
PZ=bincounts>T_count;
sbin=bin(PZ);
[~,SS]=size(sbin);
[~,SX]=size(dertaX);
PZ=zeros(1,SX);
for i=1:1:SS
    L=sbin(i);
    R=L+stp;
    pz1=rho>=L;
    pz2=rho<=R;
    pz=pz1&pz2;
    PZ=PZ|pz;
end
if sum(PZ)==0
    flg=1;
    return;
end
MP=MP(:,PZ);
MOF=MOF(:,PZ);
dertaX=dertaX(:,PZ);
dertaY=dertaY(:,PZ);
end