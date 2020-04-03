function D = COVID_hospital(D,Phos,ct)

    ct = ct + 1;
    
    total_inq  = D.ISh_corona(ct) + D.Ih_corona(ct) + D.ISt_corona(ct) + D.It_corona(ct);
    ergent_inq = D.ISh_corona(ct) + D.Ih_corona(ct) + D.ISt_corona(ct);
    exist_inq  = D.ISh_corona(ct) + D.Ih_corona(ct);
    
    if exist_inq >= Phos.capacity
        disp('hospital is full !')
    else
        if ergent_inq >= Phos.capacity
            enter_severe = Phos.capacity - exist_inq;
            enter_mild   = 0;
        else
            if total_inq >= Phos.capacity
                enter_severe = D.ISt_corona(ct);
                enter_mild   = Phos.capacity - exist_inq - D.ISt_corona(ct);
            else
                enter_severe = D.ISt_corona(ct);
                enter_mild   = D.It_corona(ct);
            end
        end
    end
       
    D.ISh_corona(ct) = D.ISh_corona(ct) + enter_severe; 
    D.Ih_corona(ct)  = D.Ih_corona(ct)  + enter_mild;
    
    D.ISt_corona(ct) = D.ISt_corona(ct) - enter_severe;
    D.It_corona(ct)  = D.It_corona(ct)  - enter_mild;
end