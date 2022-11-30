function [v, w, e]= controlo(X,Y, x, y, ang , K1, K2, K3,vmax)
    
  
    
    ex=X-x;
    ey=Y-y;
    e=sqrt(ex^2+ey^2);
    
    phi=atan2(ey,ex);
    alfa=angdiff(ang,phi);

    v=vmax*tanh(K1*e );
    w=vmax*( (1+ K2*(phi/alfa) )* ( tanh(K1*e)/e ) *sin(alfa) + K3*tanh(alfa)  );
    if(isnan(w))
        w=0;
    end

end