function [PR,RC,F1,TIME] = Output(G,GT,t1,t2,t3,t4,t5,t6,P,F,MP_wl,MP_pl,FMP,OIName)
clc;

[~,measure] = getFmeasure(G,GT);
Precision=measure.PPV*100;
Recall=measure.TPR*100;
F1=measure.FM*100;
disp(table([t1;t2;t3;t4;t5;t6;t1+t2+t3+t4+t5+t6],'RowNames',{'Point';'Feature[word]';'Matching[word]';'Feature[phrase]';'Matching[phrase]';'Post P.';'Total'},'VariableNames',{'Time'}));
disp(table([size(P,2);size(F{1,1},1);size(MP_wl,2);size(MP_pl,2);size(FMP,2)],'RowNames',{'Points';'Features';'Matches[word]';'Matches[phrase]';'Filtered M.'},'VariableNames',{'Number'}));
disp(table([F1;Precision;Recall],'RowNames',{'F1';'Precision';'Recall'},'VariableNames',{'Measure'}));
G=logical(G);
% GT=logical(GT);
GT=GT>150;
[M,N]=size(G);
MASK=128*ones(M,N,3);
MASK1=MASK(:,:,1);MASK2=MASK(:,:,2);MASK3=MASK(:,:,3);
MASK1(GT)=255;MASK2(GT)=255;MASK3(GT)=255;
T=GT&G;
MASK1(T)=0;MASK2(T)=200;MASK3(T)=50;
F=xor(GT,G);
FP=F&G;
MASK1(FP)=255;MASK2(FP)=0;MASK3(FP)=0;
MASK(:,:,1)=MASK1;MASK(:,:,2)=MASK2;MASK(:,:,3)=MASK3;
figure('Name','Final detection map');
imshow(uint8(MASK));

end