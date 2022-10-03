function [ IE ] = edger( II,G )

se = strel('disk',11);  
bwd=imdilate(G,se);
bwd=bwd-G;

bwd(bwd~=0)=1;
bwd=logical(bwd);
IE=II;
R=IE(:,:,1);
G=IE(:,:,2);
B=IE(:,:,3);
R(bwd)=0;
G(bwd)=255;
B(bwd)=0;
IE(:,:,1)=R;
IE(:,:,2)=G;
IE(:,:,3)=B;

end

