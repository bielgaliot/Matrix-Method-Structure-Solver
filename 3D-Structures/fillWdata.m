function Wdata = fillWdata(g, x, Tn, mat, Tmat, n_dof, n_i, Weight)
FWD = zeros(n_dof/n_i, 1);

    %distribute bar weight
    for a=1:size(x,1)
        for e=1:size(Tn,1)
            %while 
                if (Tn(e,1)==a)||(Tn(e,2) == a)
                    
                l=sqrt( (x(Tn(e,1),1)-x(Tn(e,2),1)).^2  + (x(Tn(e,1),2)-x(Tn(e,2),2)).^2 ...
                + (x(Tn(e,1),3)-x(Tn(e,2),3)).^2 );

                FWD(a)= FWD(a)+ 0.5*g*l*mat(Tmat(e,1),2)*mat(Tmat(e,1),3);
                
                end
            %end
        end
    end
   
    
    %Distribute pilot weight
    FWD(1)=FWD(1)+0.5*Weight;
    FWD(2)=FWD(2)+0.5*Weight;
    
    
    
    Wdata=  [1 1 0;
             1 3 -FWD(1);
             2 1 0;
             2 3 -FWD(2);
             3 1 0;
             3 3 -FWD(3);
             4 1 0;
             4 3 -FWD(4);
             5 1 0;
             5 3 -FWD(5);
             6 1 0;
             6 3 -FWD(6);
            ];

end          