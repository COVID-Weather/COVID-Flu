function [PM,PI,PT,PD,Ptst,Phos] = COVID_parameters

    % Set model and case --------------------------------------------------
    PM.model             = 2;
    PM.do_hos            = 0;

    % Set initialization parameters ---------------------------------------
    PI.N_population      = 54000000; 
    PI.seed_corona       = 100;
    PI.seed_flu          = 10000;

    % Set disease transmission parameters ---------------------------------
    PT.Social_distance   = 1;  % each person meet, on average, one people per day
    
    PT.S_Iu_corona       = 0.45;
    PT.S_It_corona       = PT.S_Iu_corona;
    PT.S_Ih_corona       = 0.0;
    PT.S_ISu_corona      = PT.S_Iu_corona;
    PT.S_ISt_corona      = PT.S_It_corona;
    PT.S_ISh_corona      = PT.S_Ih_corona;

    PT.S_Iu_flu          = 0.3;
    PT.S_ISu_flu         = PT.S_Iu_flu;

    % Set disease development parameters ----------------------------------
    if PM.model == 2
        PD.Eu_2_Iu_corona= 0.2;
    end
    PD.Iu_2_ISu_corona   = 0.2;
    PD.ISu_2_Iu_corona   = 0.05;
    PD.Iu_2_R_corona     = 0.05;
    PD.ISu_2_D_corona    = 0.4;

    % assume that people who are confirmed but not treated will have the same
    % disease parameters as unconfirmed ones
    PD.It_2_ISt_corona   = PD.Iu_2_ISu_corona;
    PD.ISt_2_It_corona   = PD.ISu_2_Iu_corona;
    PD.It_2_R_corona     = PD.Iu_2_R_corona;
    PD.ISt_2_D_corona    = PD.ISu_2_D_corona;

    PD.Ih_2_ISh_corona   = 0.2;
    PD.ISh_2_Ih_corona   = 0.5;
    PD.Ih_2_R_corona     = 0.5;
    PD.ISh_2_D_corona    = 0.0;

    if PM.model == 2
        PD.Eu_2_Iu_flu   = 0.2;
    end
    PD.Iu_2_ISu_flu      = 0.02;
    PD.ISu_2_Iu_flu      = 0.1;
    PD.Iu_2_R_flu        = 0.2;
    PD.ISu_2_D_flu       = 0.5;
    PD.R_2_S_flu         = 0.00;

    % Set testing parameters ----------------------------------------------
    Ptst.willing_mild    = 0.3;
    Ptst.willing_severe  = 0.8;

    % Set hospital parameters ---------------------------------------------
    if PM.do_hos == 1
        Phos.capacity        = 1000000;
    else
        Phos.capacity        = nan;
    end
end