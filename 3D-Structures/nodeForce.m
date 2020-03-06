function nodeF = nodeForce(n_i, n_dof,Wdata, Fdata)
nodeF = zeros(n_dof, 1);

Auxdata=[1 1 Wdata(1,3)+Fdata(1,3);
             1 3 Wdata(2,3)+Fdata(2,3);
             2 1 Wdata(3,3)+Fdata(3,3);
             2 3 Wdata(4,3)+Fdata(4,3);
             3 1 Wdata(5,3)+Fdata(5,3);
             3 3 Wdata(6,3)+Fdata(6,3);
             4 1 Wdata(7,3)+Fdata(7,3);
             4 3 Wdata(8,3)+Fdata(8,3);
             5 1 Wdata(9,3)+Fdata(9,3);
             5 3 Wdata(10,3)+Fdata(10,3);
             6 1 Wdata(11,3)+Fdata(11,3);
             6 3 Wdata(12,3)+Fdata(12,3);
             ];
    

for a=1:size(Wdata,1)
  
    %n_i*Auxdata(a,1)-(n_i-Auxdata(a,2));
    nodeF(n_i*Auxdata(a,1)-(n_i-Auxdata(a,2))) = Auxdata(a,3);

end

% for a=1:size(AeroFdata,1)
%     n_i*AeroFdata(a,1)-(n_i-AeroFdata(a,2))
%     
%     nodeF(n_i*AeroFdata(a,1)-(n_i-AeroFdata(a,2))) = Wdata(a,3)+Fdata(a,3)+AeroFdata(a,3);
%     
% end

end
