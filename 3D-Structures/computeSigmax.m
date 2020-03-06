function [I, sig_max] = computeSigmax(x, Tn, mat, Tmat, n_el, D1, d1, D2)

I=zeros(n_el,1);
l=zeros(n_el,1);
sig_max=zeros(n_el,1);

for e=1:size(Tn,1)
    
          
                l(e)=sqrt( (x(Tn(e,1),1)-x(Tn(e,2),1)).^2  + (x(Tn(e,1),2)-x(Tn(e,2),2)).^2 ...
                + (x(Tn(e,1),3)-x(Tn(e,2),3)).^2 );
            
            
            if Tmat(e,1)==1
           
                I(e) = (pi/4)*((D1/2)^4-(d1/2)^4);
                
            
            end
            
            if Tmat(e,1)==2
                
                I(e) = (pi/4)*(D2/2)^2;
                
            end
            
            sig_max(e)=-(pi^2*mat(Tmat(e,1),1)*I(e))/(mat(Tmat(e,1),2)*(l(e)^2));
               
            
end
   sig_max

end