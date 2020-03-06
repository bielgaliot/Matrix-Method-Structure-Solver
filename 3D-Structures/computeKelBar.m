function Kel = computeKelBar(n_d,n_el,x,Tn,mat,Tmat)
R=zeros(2, 2*n_d);

for e=1:n_el %sacar long barra i llenar K_p
    
    x1=x(Tn(e,1),1);
    x2=x(Tn(e,2),1);
    y1=x(Tn(e,1),2);
    y2=x(Tn(e,2),2);
    
    if n_d==3
    z1=x(Tn(e,1),3);
    z2=x(Tn(e,2),3);
    l=sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);
    R=1/l*[x2-x1 y2-y1  z2-z1 0 0 0; 0 0 0 x2-x1 y2-y1 z2-z1];
    end
    
    if n_d==2
    l=sqrt((x2-x1)^2+(y2-y1)^2);
    R=1/l*[x2-x1 y2-y1 0 0; 0 0 x2-x1 y2-y1]; 
    end
    
 
    K_p=mat(Tmat(e),2)*mat(Tmat(e),1)/l*[1 -1; -1 1];
            
    Kel(:,:,e)=R.'*K_p*R;

end


%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
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
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%            Kel(i,j,e) - Term in (i,j) position of stiffness matrix for element e
%--------------------------------------------------------------------------



end