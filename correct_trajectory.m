function [X,Y]=correct_trajectory(Sonares, X, Y, angulo, FC, thd, the)

    siz = size(Sonares,2);
    if(siz>3)
        media_d = min( median(Sonares([7 8],siz-3:siz),2) );
        media_e = min( median(Sonares([1 2],siz-3:siz),2) );

        angulo = wrapToPi(angulo*(pi/2048));
        if( abs( abs(angulo)-pi/2 ) < pi/6 )
            if(media_d < thd)
                X = X - FC*sign(angulo)/media_d*ones(size(X));
            elseif(media_e < the)
                X = X + FC*sign(angulo)/media_e*ones(size(X));
            end
        else
            if( abs(angulo) < pi/6 )
                sinal = 1;
            else
                sinal = -1;
            end
            if(media_e < the)
                Y = Y - FC*sinal/media_e*ones(size(Y));
            elseif(media_d < thd)
                Y = Y + FC*sinal/media_d*ones(size(Y));
            end
        end
    end 
end