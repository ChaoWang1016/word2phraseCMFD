function [ block,points ] = cblock( I,points,sz )
[SZ1,SZ2,~] = size(I);
[NoP,~]=size(points);
flg=zeros(NoP,1);
block=zeros(NoP,sz^2);
parfor i = 1:NoP
    x=points(i,1);y=points(i,2);s=points(i,3);
    bz = floor((sz*s)/2);
    if x-bz>=1 && x+bz<=SZ1  && y-bz>=1 && y+bz<= SZ2
        I_block = I(x-bz:x+bz,y-bz:y+bz);
        I_block = imresize(I_block,[sz,sz],'bilinear');
        flg(i,1)=1;
    else
        I_block = zeros(sz,sz);
        flg(i,1)=0;
    end
    block(i,:)=reshape(I_block.',1,sz^2);
end
points(~flg,:)=[];block(~flg,:)=[];
end



