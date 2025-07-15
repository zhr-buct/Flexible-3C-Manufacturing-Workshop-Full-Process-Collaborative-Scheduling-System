function optH=MPE(pop,info,fit,data)

    [~,index]=sort(fit);
    popb=pop(index(1),:);
    Rtotal=zeros(1,info.MPEn);
    poptemp=zeros(info.MPEn,size(pop,2));
    poptemp1=zeros(size(pop,1),size(pop,2),info.MPEn);
    poptemp2=zeros(size(pop,1),size(pop,2),info.MPEn);
    popt1=zeros(info.MPEn,size(pop,2),info.MPEv);
    popt2=zeros(info.MPEn,size(pop,2),info.MPEv);
    fitnew=zeros(info.MPEn,info.np);
    fitn=zeros(info.MPEn,info.MPEn);
    r=zeros(1,info.MPEn);
    for i=1:info.MPEn
        info.h=i/info.MPEn;
        poptemp1(:,:,i)=muPh(pop,popb,info);
        poptemp2(:,:,i)=CmPh(poptemp1(:,:,i),popb,info,fit);
    end
    for i=1:info.MPEn
        for j=1:info.np
            [fitnew(i,j),~,~]=decode_ACS(poptemp2(:,:,i),info,data);
        end
    end
    for i=1:info.MPEn
        Rtotal(i)=sum(fit)-sum(fitnew(i,:))/info.MPEn;
    end
    for I=2:info.MPEv
       
       %按照适应度函数值分布选取一个个体
       for i=info.MPEn
           temp=rand(1,1);
           tempfit=zeros(1,info.np);
           for j=1:info.np
               tempfit(j)=fitnew(i,j);
           end
           for j=1:info.np              
               if (sum(tempfit(1:j-1))<=temp)&&(temp<sum(tempfit(1:j)))
                   break
               end
           end
           poptemp(i,:)=poptemp2(j,:,i);
       end
       %继续生成子代种群
       for i=1:info.MPEn
            info.h=i/info.MPEn;
            info.np=info.MPEn;
            popt1(:,:,i)=muPh(poptemp,popb,info);
       end
       popt1=mod(popt1,1);
       for i=1:info.MPEn
           for j=1:size(popt1,1)
                [fitl(j,i),~,~]=decode_ACS(popt1(j,:,i),info,data);
           end
       end
       for i=1:info.MPEn
            popt2(:,:,i)=CmPh(popt1(:,:,i),popb,info,fitl(:,i));
       end 
       for i=1:info.MPEn
           for j=1:info.MPEn
               [fitn(i,j),~,~]=decode_ACS(popt2(:,:,i),info,data);
           end
       end
       for i=1:info.MPEn
           r(i)=sum(fit)-sum(fitn(i,:))/info.MPEn;
       end
       Rtotal=Rtotal+(info.dis)^(I-1)*r;
    end
    [~,index]=sort(Rtotal);
    optH=index(1)/info.MPEn;
end