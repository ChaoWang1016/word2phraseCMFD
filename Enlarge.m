function  [OOI,OGI,flag,SZ1,SZ2]    =   Enlarge(IOI,IGI)
[SZ1,SZ2]=size(IGI);

if max([SZ1,SZ2])<3000
    factor=3000/max([SZ1,SZ2]);
    OOI=imresize(IOI,factor,'bicubic');OGI=imresize(IGI,factor,'bicubic');
    flag=1;
else
    OOI=IOI;OGI=IGI;
    flag=0;
end

end

