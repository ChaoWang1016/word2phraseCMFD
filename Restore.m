function  [OG] =   Restore(IG,flag,SZ1,SZ2)
if flag==1
    OG=imresize(IG,[SZ1,SZ2],'bicubic');
else
    OG=IG;
end
OG=OG>0.5;
end

