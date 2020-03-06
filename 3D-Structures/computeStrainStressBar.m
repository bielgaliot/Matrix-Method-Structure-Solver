function [eps,sig] = computeStrainStressBar(n_d,n_el,u,Td,x,Tn,mat,Tmat)


for e=1:n_el
    
    x1=x(Tn(e,1),1);
    x2=x(Tn(e,2),1);
    y1=x(Tn(e,1),2);
    y2=x(Tn(e,2),2);
    
    
    if n_d==3
    z1=x(Tn(e,1),3);
    z2=x(Tn(e,2),3);
    l=sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);
    Re=1/l*[x2-x1 y2-y1  z2-z1 0 0 0; 0 0 0 x2-x1 y2-y1 z2-z1];
    end
    
    if n_d==2
    l=sqrt((x2-x1)^2+(y2-y1)^2);
    Re=1/l*[x2-x1 y2-y1 0 0; 0 0 x2-x1 y2-y1]; 
    end
   

    for i = 1:size(Tn,2)*n_d                    %calculamos el vector desplazamiento global de cada barra
        
        I = Td(e,i);
        ue(i,1) = u(I,1);
        
    end
    
    ue_local = Re * ue;                         % calculamos el vector desplazamiento local de cada barra
    strain(e,1) = 1/l *[-1,1] * ue_local; 
    stress(e,1) = mat(Tmat(e),1)*strain(e,1);   %calculamos la deformacion y la tension de cada barra   

end

eps = strain;
sig = stress



%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - u     Global displacement vector [n_dof x 1]
%            u(I) - Total displacement on global DOF I
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - eps   Strain vector [n_el x 1]
%            eps(e) - Strain of bar e
%   - sig   Stress vector [n_el x 1]
%            sig(e) - Stress of bar e
%--------------------------------------------------------------------------


end