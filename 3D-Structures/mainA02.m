%-------------------------------------------------------------------------%
% ASSIGNMENT 02
%-------------------------------------------------------------------------%
% Date: 2/3/20
% Author/s:Biel Galiot, Javier Roset
%
clc
clear;
close all;

%% INPUT DATA

% Geometric data
L = 0.75;
B = 3;
H = 0.75; 
d1 = 5e-3;
D2 = 2e-3;

% Mass
M = 120;

% Other
g = 9.81;
Weight = M*g; %N

%%%%%%%%%%%%%%%%%%%%%%%%%%   WIND GUST SELECTOR     %%%%%%%%%%%%%%%%%%%%

        gust=1;
        %gust=0;
        
%0 if no gust, 1 if there is a gust of wind (25% more aero loads)

%%%%%%%%%%%%%%%%%%%%%%     D1 SELECTOR (FOR BUCKLING)    %%%%%%%%%%%%%%%

        %D1 = 21e-3;
        %D1 = 22e-3;

%Change D1 to 22e-3 to prevent buckling when computing the structure with
%gust of wing


%% PREPROCESS

% Nodal coordinates matrix 
%  x(a,j) = coordinate of node a in the dimension j
x = [%     X      Y      Z
         2*L,    -L,     0; % (1)
         2*L,     L,     0; % (2)
         2*L,     0,     H; % (3)
           0,     0,     H; % (4)
           0,    -B,     H; % (5)
           0,     B,     H; % (6)
];

% Nodal connectivities  
%  Tnod(e,a) = global nodal number associated to node a of element e
Tn = [%     a      b
           1,     2; % (1)
           3,     4; % (2)
           3,     5; % (3)
           4,     5; % (4)
           3,     6; % (5)
           4,     6; % (6)
           1,     3; % (7)
           2,     3; % (8)
           1,     4; % (9)
           2,     4; % (10)
           1,     5; % (11)
           2,     6; % (12)
];

% Material properties matrix
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Density of material m
%  mat(m,4) = Section inertia of material m 
%  --more columns can be added for additional material properties--
mat = [% Young M.        Section A.    Density 
            70e9, pi/4*(D1^2-d1^2),       2200;  % Material (1)
           200e9,        pi/4*D2^2,       1300;  % Material (2)
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = [% Mat. index
                   1; % (1)
                   1; % (2)
                   1; % (3)
                   1; % (4)
                   1; % (5)
                   1; % (6)
                   1; % (7)
                   1; % (8)
                   2; % (9)
                   2; % (10)
                   2; % (11)
                   2; % (12)
];

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = [1 1 0;
          1 3 0;
          2 1 0;
          2 3 0;
          %1 2 0;
          %2 2 0;
          %3 3 0;
          %3 1 0;
          4 1 0;
          4 2 0;
          %4 3 0;
          ];

%% SOLVER
% Dimensions
n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tn,1);            % Total number of elements
n_nod = size(Tn,2);           % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 

%fill Weight of bars and pilot data
Wdata = fillWdata(g, x, Tn, mat, Tmat, n_dof, n_i, Weight); 



%Compute Aerodynamic fores
    WTotal=sum(Wdata(:,3)); 

    if gust==0
    Lift=-WTotal; % in N, negatie bc W is down and L is up
    T=((2*L)/H)*((-3/4)*WTotal+(Wdata(8,3)+Wdata(10,3)+Wdata(12,3)));
    D=-T;
    elseif gust~=0   
    Lift=-1.25*WTotal; % in N, negatie bc W is down and L is up
    T=((2*L)/H)*((-15/16)*WTotal+(Wdata(8,3)+Wdata(10,3)+Wdata(12,3)));
    D=-T;
    end

        %  External force matrix creation
        %  Fdata(k,1) = node at which the force is applied
        %  Fdata(k,2) = DOF (direction) at which the force is applied
        %  Fdata(k,3) = force magnitude in the corresponding DOF 
        
    %matrix of ONLY aerodynamic forces
    Fdata = [1 1 T/2;
             1 3 0;
             2 1 T/2;
             2 3 0;
             3 1 D/4;
             3 3 Lift/4;
             4 1 D/4;
             4 3 Lift/4;
             5 1 D/4;
             5 3 Lift/4;
             6 1 D/4;
             6 3 Lift/4;    
             ];
         

         
%Distribute total F in nodes (global force vector assembly)
nodeF = nodeForce(n_i, n_dof, Wdata, Fdata); 

% Computation of the DOFs connectivities
Td = connectDOFs(n_el,n_nod,n_i,Tn);

% Computation of element stiffness matrices
Kel = computeKelBar(n_d,n_el,x,Tn,mat,Tmat);

% Global matrix assembly
KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel);

% Apply conditions 
[vL,vR,uR] = applyCond(n_i,n_dof,fixNod);

% System resolution
[u,R] = solveSys(vL,vR,uR,KG,nodeF);

% Compute strain and stresses
[eps,sig] = computeStrainStressBar(n_d,n_el,u,Td,x,Tn,mat,Tmat);

%Compute inertia and max sigma for buckling claculation
[I, sig_max] = computeSigmax(x, Tn, mat, Tmat, n_el, D1, d1, D2);

buckling = assessBuck(sig, sig_max, Tn);

%% POSTPROCESS

% Plot deformed structure with stress of each bar
scale = 75; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x,Tn,u,sig,scale);
grid