function [ F,OF,P ] = BFM(I,P,NM,blocksize)

radiusNum = 30;
anglesNum = 36;
len   = size(NM,1);
maxorder=max(NM(:,1));
BF = zeros(blocksize,blocksize,len);
WF = zeros(1,len);
for index = 1:len, n = NM(index,1); WF(index) = ((n>0)+1); end;
gf = @(x,y) max(0,1-abs(x)).*max(0,1-abs(y)); 
[X,Y] = meshgrid(1:blocksize,1:blocksize);
Y = (2.*Y-blocksize-1)./2;
X = (2.*X-blocksize-1)./2;
radiusMax = (blocksize-1)/2;
radiusMin = 0; 
radiusPoints = linspace(radiusMin,radiusMax,radiusNum);

V=1;
Roots=zeros(1,maxorder+2);
syms x;
Roots(1,1)=vpasolve(besselj(V, x) == 0, x);
for i=2:1:maxorder+2
    ST=Roots(1,i-1)+3; 
    Roots(1,i)=vpasolve(besselj(V, x) == 0, ST);
end

for indexA = 1:anglesNum;
    A  = (indexA-1)*360./anglesNum;
    for indexR = 1:radiusNum;
        R = radiusPoints(indexR);
        pX = X - R*cosd(A);
        pY = Y - R*sind(A);
        J = gf(pX,pY);
        R = 2*R/blocksize;
        for index = 1:len
            n = NM(index,1);
            m = NM(index,2);
            Rad = getRadialPoly(n,R,V,Roots).*(cosd(m*A) + 1i*sind(m*A));
            BF(:,:,index) = BF(:,:,index)+(J*Rad)*R*(1/(pi*(besselj(V+1,Roots(n+2)))^2));
        end;
    end;
end;
WF = WF./sqrt(sum(sum(abs(BF(:,:,1)).^2)));
%
[ block,P ]=cblock(I,P,blocksize);
moments=zeros(blocksize*blocksize,len);
for index = 1:len
        moments(:,index)=reshape(BF(:,:,index),[],1)*WF(index);%;   
end;
BFMs=block*moments;

%% Complex
Features_mag = abs(BFMs(:,1:maxorder+1));
temp=BFMs(:,maxorder+2:end);
A=temp;
B=zeros(size(A));
for m=1:1:maxorder
    st=(m-1)*(maxorder+1);
    B(:,st+1:st+maxorder)=A(:,st+2:st+maxorder+1);
    B(:,st+maxorder+1)=A(:,st+1);
end
Features_pha = A.*conj(B);
F ={Features_mag,Features_pha} ;
OF=BFMs(:,maxorder+2:end);
end

