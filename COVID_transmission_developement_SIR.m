function D = COVID_transmission_developement_SIR(D,PM,PI,PT,PD,ct)

    alive  = PI.N_population - D.Death(ct);
    
    % compute probability of infection for individuals --------------------
    prob_corona = (PT.S_Iu_corona  .* D.Iu_corona(ct)  + ...
                   PT.S_It_corona  .* D.It_corona(ct)  + ...
                   PT.S_ISu_corona .* D.ISu_corona(ct) + ...
                   PT.S_ISt_corona .* D.ISt_corona(ct));
    if PM.do_hos == 1
        prob_corona = prob_corona + PT.S_Ih_corona  .* D.Ih_corona(ct) + ...
                                    PT.S_ISh_corona .* D.ISh_corona(ct);
    end
    prob_corona = prob_corona ./ alive ./(PT.Social_distance);

    prob_flu    = (PT.S_Iu_flu .* D.Iu_flu(ct) + PT.S_ISu_flu .* D.ISu_flu(ct)) ...
                              ./ alive ./(PT.Social_distance);
               
    % lose immunity -------------------------------------------------------
    dR_2_S_flu             = D.R_flu(ct)      .* PD.R_2_S_flu;
    
    % get infected and show symptoms --------------------------------------
    dS_2_Iu_corona         = D.S_corona(ct)   .* prob_corona;
    dS_2_Iu_flu            = D.S_flu(ct)      .* prob_flu;

    % get worse -----------------------------------------------------------
    dIu_2_ISu_corona       = D.Iu_corona(ct)  .* PD.Iu_2_ISu_corona;
    dIt_2_ISt_corona       = D.It_corona(ct)  .* PD.It_2_ISt_corona;
    if PM.do_hos == 1
        dIh_2_ISh_corona   = D.Ih_corona(ct)  .* PD.Ih_2_ISh_corona;
    end
    dIu_2_ISu_flu          = D.Iu_flu(ct)     .* PD.Iu_2_ISu_flu;

    % get better ----------------------------------------------------------
    dISu_2_Iu_corona       = D.ISu_corona(ct) .* PD.ISu_2_Iu_corona;
    dISt_2_It_corona       = D.ISt_corona(ct) .* PD.ISt_2_It_corona;
    if PM.do_hos == 1
        dISh_2_Ih_corona   = D.ISh_corona(ct) .* PD.ISh_2_Ih_corona;
    end
    dISu_2_Iu_flu          = D.ISu_flu(ct)    .* PD.ISu_2_Iu_flu;

    % revover -------------------------------------------------------------
    dIu_2_R_corona         = D.Iu_corona(ct)  .* PD.Iu_2_R_corona;
    dIt_2_R_corona         = D.It_corona(ct)  .* PD.It_2_R_corona;
    if PM.do_hos == 1
        dIh_2_R_corona     = D.Ih_corona(ct)  .* PD.Ih_2_R_corona;
    end
    dIu_2_R_flu            = D.Iu_flu(ct)     .* PD.Iu_2_R_flu;

    % die -----------------------------------------------------------------
    dISu_2_D_corona        = D.ISu_corona(ct) .* PD.ISu_2_D_corona;
    dISt_2_D_corona        = D.ISt_corona(ct) .* PD.ISt_2_D_corona;
    if PM.do_hos == 1
        dISh_2_D_corona    = D.ISh_corona(ct) .* PD.ISh_2_D_corona;
    end
    dISu_2_D_flu           = D.ISu_flu(ct)    .* PD.ISu_2_D_flu;
    
    % Update desease number -----------------------------------------------  
    D.S_corona(ct+1)       = D.S_corona(ct)   - dS_2_Iu_corona;  
    D.S_flu(ct+1)          = D.S_flu(ct)      + dR_2_S_flu        - dS_2_Iu_flu;
    
    D.Iu_corona(ct+1)      = D.Iu_corona(ct)  + dS_2_Iu_corona    + dISu_2_Iu_corona  - dIu_2_ISu_corona - dIu_2_R_corona;
    D.It_corona(ct+1)      = D.It_corona(ct)  + dISt_2_It_corona  - dIt_2_ISt_corona  - dIt_2_R_corona;
    if PM.do_hos == 1
        D.Ih_corona(ct+1)  = D.Ih_corona(ct)  + dISh_2_Ih_corona  - dIh_2_ISh_corona  - dIh_2_R_corona;
    end
    D.Iu_flu(ct+1)         = D.Iu_flu(ct)     + dS_2_Iu_flu       + dISu_2_Iu_flu     - dIu_2_ISu_flu    - dIu_2_R_flu;
                    
    D.ISu_corona(ct+1)     = D.ISu_corona(ct) + dIu_2_ISu_corona  - dISu_2_Iu_corona  - dISu_2_D_corona;
    D.ISt_corona(ct+1)     = D.ISt_corona(ct) + dIt_2_ISt_corona  - dISt_2_It_corona  - dISt_2_D_corona;
    if PM.do_hos == 1
        D.ISh_corona(ct+1) = D.ISh_corona(ct) + dIh_2_ISh_corona  - dISh_2_Ih_corona  - dISh_2_D_corona;
    end
    D.ISu_flu(ct+1)        = D.ISu_flu(ct)    + dIu_2_ISu_flu     - dISu_2_Iu_flu     - dISu_2_D_flu;

    if PM.do_hos == 1
        D.R_corona(ct+1)   = D.R_corona(ct)   + dIu_2_R_corona    + dIt_2_R_corona    + dIh_2_R_corona;
    else
        D.R_corona(ct+1)   = D.R_corona(ct)   + dIu_2_R_corona    + dIt_2_R_corona;
    end
    D.R_flu(ct+1)          = D.R_flu(ct)      + dIu_2_R_flu       - dR_2_S_flu;

    if PM.do_hos == 1
        D.D_corona(ct+1)   = D.D_corona(ct)   + dISu_2_D_corona   + dISt_2_D_corona   + dISh_2_D_corona;
    else
        D.D_corona(ct+1)   = D.D_corona(ct)   + dISu_2_D_corona   + dISt_2_D_corona;
    end
    D.D_flu(ct+1)          = D.D_flu(ct)      + dISu_2_D_flu;
    
    % We neglect interaction due to people die from both disease
    % This seems to be a reasonable assumption in the stage of exponentia growth
    % More relistic and simple representation can be acchived using an agent-based model
    if PM.do_hos == 1
        D.Death(ct+1)      = D.Death(ct)      + dISu_2_D_corona   + dISt_2_D_corona   + dISh_2_D_corona    + dISu_2_D_flu;
    else
        D.Death(ct+1)      = D.Death(ct)      + dISu_2_D_corona   + dISt_2_D_corona   + dISu_2_D_flu;
    end
end