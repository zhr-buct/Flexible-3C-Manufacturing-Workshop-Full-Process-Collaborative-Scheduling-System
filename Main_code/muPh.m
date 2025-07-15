function poptemp=muPh(pop,popb,info)

beta = 3/2;
alpha_u = (gamma(1+beta)*sin(pi*beta/2)/(gamma(((1+beta)/2)*beta*2^((beta-1)/2))))^(1/beta);
alpha_v = 1;
levy=zeros(1,size(pop,2));
for j=1:size(pop,2)
    u=normrnd(0,alpha_u,1);
    v=normrnd(0,alpha_v,1);
    levy(j) = u/(abs(v))^(1/beta);
end
levy=levy/100;
poptemp=pop;

for i=1:info.np/2
    poptemp(i,:)=pop(i,:)+info.h*levy;
end

poptemp=mod(pop,1);