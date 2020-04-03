function [D,N_test,N_positive] = COVID_testing(D,Ptst,ct,N_kit)

    ct = ct + 1;
    
    mild_inq   = (D.Iu_corona(ct) + D.Iu_flu(ct))   .* Ptst.willing_mild;
    severe_inq = (D.ISu_corona(ct) + D.ISu_flu(ct)) .* Ptst.willing_severe;
    totl_inq   = mild_inq + severe_inq;
    
    if totl_inq > N_kit  
        
        if severe_inq > N_kit
            
            % only testing people with severe symptoms.
            N_test            = N_kit;
            N_postive_severe  = N_kit .* D.ISu_corona(ct) ./ (D.ISu_corona(ct) + D.ISu_flu(ct));
            N_postive_mild    = 0;
            
        else
            
            % After testing people with severe symptoms, other kits are used to test people with mild symptoms.
            N_test            = N_kit;
            N_postive_severe  = D.ISu_corona(ct) .* Ptst.willing_severe;
            N_postive_mild    = (N_kit - severe_inq) .* D.Iu_corona(ct) ./ (D.Iu_corona(ct) + D.Iu_flu(ct));
        end   
        
    else
        % every one with symptoms get tested            
        N_test            = totl_inq;
        N_postive_severe  = D.ISu_corona(ct) .* Ptst.willing_severe;
        N_postive_mild    = D.Iu_corona(ct)  .* Ptst.willing_mild;
    end
    
    D.ISt_corona(ct) = D.ISt_corona(ct) + N_postive_severe;
    D.It_corona(ct)  = D.It_corona(ct)  + N_postive_mild;
    
    D.ISu_corona(ct) = D.ISu_corona(ct) - N_postive_severe;
    D.Iu_corona(ct)  = D.Iu_corona(ct)  - N_postive_mild;
    
    N_positive = N_postive_severe + N_postive_mild; 

end