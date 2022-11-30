function door=detect_right(teste,x,y)

   a=min(find(teste(1:320)==min(teste(find(teste(1:320)>300)))));
   
   if(a+200<341)
       xtemp=x(a:a+200);
       ytemp=y(a:a+200);
   else
       xtemp=x(a-50:320);
       ytemp=y(a-50:320);  
   end
   
   [B, ~]=Polyfit(1,xtemp(find(xtemp~=0)), ytemp(find(xtemp~=0))) ;
   X = [ones(length(xtemp),1) xtemp];
   aux= ytemp-X*B;
   
   ids=find(aux>0);
   if(length(ids)>0)
       p1=[xtemp(ids(1)) ; ytemp(ids(1))];
       p2=[xtemp(ids(length(ids))) ; ytemp(ids(length(ids)))];
       l=(p2-p1);
   else
       l=1000000;
   end
    
   if( (norm(l)<1000) )
        if((norm(l)>600))
            door=[mean(xtemp(ids)); mean(ytemp(ids))];
        else
            door=0;
        end
   else
       door=0;
   end
   
end