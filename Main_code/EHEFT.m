function energy=EHEFT(info,data)

    dataheft = data;
    info.m = dataheft.m;
    info.n = size(dataheft.ct,1);
    info.cmax = data.cmax;
    dataheft.aft = dataheft.hx;
    dataheft.w = dataheft.ct;
    dataheft.ckef = dataheft.c;
    dataheft.c = dataheft.st;
    dataheft.pre = dataheft.xh;
    dataheft.pkind = dataheft.p;
    dataheft.ps = dataheft.pkind;
    info.rank=rankqueen1(dataheft,info);
    sch=heft(dataheft,info);
    sol=initial_sol(sch,data);
    sol = opt_energy(sol,data,info);
    energy=decode(sol,info,data);
    
end