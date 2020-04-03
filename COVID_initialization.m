function D = COVID_initialization(PM,PI)

    % initializing COVID-19 -----------------------------------------------
    if PM.first_day_COVID <= 1
        D.S_corona(1)    = PI.N_population - PI.seed_corona;
    else
        D.S_corona(1)    = PI.N_population;
    end
    
    if PM.model == 2
        D.Eu_corona(1)   = 0;
    end
   
    if PM.first_day_COVID <= 1
        D.Iu_corona(1)   = PI.seed_corona;
    else
        D.Iu_corona(1)   = 0;
    end
    
    D.ISu_corona(1)      = 0;
    D.It_corona(1)       = 0;
    D.ISt_corona(1)      = 0;
    
    if PM.do_hos == 1
        D.Ih_corona(1)   = 0;
        D.ISh_corona(1)  = 0;
    end
    D.R_corona(1)        = 0;
    D.D_corona(1)        = 0;

    % initializing Seasonal Flu -------------------------------------------
    D.S_flu(1)           = PI.N_population - PI.seed_flu;
    
    if PM.model == 2
        D.Eu_flu(1)      = 0;
    end
    
    D.Iu_flu(1)          = PI.seed_flu;
    D.ISu_flu(1)         = 0;
    D.R_flu(1)           = 0;
    D.D_flu(1)           = 0;
   
    D.Death              = 0;
end