function [idx] = filtering_2nd(idx,MOF,bin_num,T_count,F_NM )
NoC=max(idx);
Le=size(MOF,1)/2;
m=F_NM(:,2);pz=m~=0;m=m(pz);
for i=1:1:NoC
    p=idx==i;
    MOFC=MOF(:,p);
    OF1=MOFC(1:Le,:);
    OF2=MOFC(Le+1:end,:);
    [~,cons]=meshgrid(1:size(OF1,2),m);
    alpha=angle(OF1./OF2)./cons;
    malpha=abs(mean(alpha,1));
    stp=pi/bin_num(1,1);
    bin=0:stp:pi;
    [bincounts] = histc(malpha,bin);
    [mv,mpz]=sort(bincounts);
    if mv(end)>=T_count
        L=bin(mpz(end));
        R=L+stp;
        pz1=malpha>=L;pz2=malpha<=R;pz=pz1&pz2;
        if mv(end-1)>=T_count
            L=bin(mpz(end-1));
            R=L+stp;
            pz1=malpha>=L;pz2=malpha<=R;temp=pz1&pz2;pz=pz|temp;
        end
        k=1;
        for j=1:1:size(p,1)
            if p(j)==1
                p(j)=(~pz(k))*p(j);k=k+1;
            end
        end
        idx(p)=0;
    else
        idx(p)=0;
    end
end
end