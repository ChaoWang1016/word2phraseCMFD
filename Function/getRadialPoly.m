function [output] = getRadialPoly(order,rho,V,Roots)
% obtain the order and repetition
n = order;
% compute the radial polynomial
rho=rho*Roots(n+2);
output=besselj(V,rho);
end % end getRadialPoly method