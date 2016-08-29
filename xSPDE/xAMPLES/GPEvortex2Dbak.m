function [e] = GPEvortex2D()                                    
%   e  =  GPEvortex2D() tests xSPDE for a lattice of superfluid vortices
%   Tests a 2D GPE with vortices plus rotation 
%   xSPDE functions are licensed by Peter D. Drummond, (2015) - see License

in.name =       'GPEvortex2D';
in.dimension =  3; 
in.fields =     1;  
in.points =     [50,63,63];
in.ranges =     [20,20,20];
in.steps =      20;
in.boundaries = [1,1,1];
g          =    1;
om =            20;
L          =    @(a,r)       r.x.*xd1(a,3,r)-r.y.*xd1(a,2,r);
K          =    @(a,r)       0.5*(xd2(a,2,r)+xd2(a,3,r));
V          =    @(r)         0.5*(r.x.^2+r.y.^2);
in.initial =    @(w,r)       0.1+0*w;
rho        =    @(a)         conj(a(1,:)).*a(1,:);
%in.da     =     @normda;
in.da     =    @(a,xi,r)     -g*a(1,:).*(rho(a)-1)+om*L(a,r)+K(a,r);

%in.linear =     @(r)        0.5*(r.Dx.^2+r.Dy.^2); 
in.observe{1} = @(a,r) a(1,:).*conj(a(1,:));
in.observe{2} = @(a,r) a(1,:).*conj(a(1,:));
in.functions{2}=@(o,r) sqrt(o(1,:));
in.images    =  {2,2}; 
in.imagetype  = {1,2}; 
in.olabels =    {'|a_1|^2','|a_1|^2'};
e  =            xspde(in);                             %%main program

function b = normda(a,z,r)
%   b  =  NORMDA(a,z,r) is a normalized derivative
%   Takes a derivative and returns a normalized step
b = a+r.da1(a,z,r)*r.dtr;
norm = sqrt(xint(abs(b).^2,r.dx, r));
b = (b./norm-a)/r.dtr;
end
end                                                    %%end of function


