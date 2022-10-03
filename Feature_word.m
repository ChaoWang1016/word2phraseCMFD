function [F,OF,P,tt]=Feature_word(GI,P,F_NM,F_BZ)
%% BFM based feature
clc;
fprintf(1,'Feature...\n');
st=tic;
P = P';
[F,OF,P] = BFM(GI,P,F_NM,F_BZ);
F=F';
tt = toc(st);
end

