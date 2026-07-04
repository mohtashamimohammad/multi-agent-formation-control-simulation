function [xr, vr, fr] = navigator(t)
%NAVIGATOR  Reference trajectory and its derivatives.
%
%   [xr, vr, fr] = NAVIGATOR(t) returns the reference position xr(t),
%   reference velocity vr(t) = d/dt xr(t), and reference acceleration
%   fr(t) = d/dt vr(t) for the virtual leader trajectory used in the
%   simulations.
%
%   Reference trajectory:
%       xr(t) = [ t ;
%                 -(64/3) * sin(t/8) ]
%
%   Outputs:
%       xr : 2-by-1 reference position
%       vr : 2-by-1 reference velocity
%       fr : 2-by-1 reference acceleration

xr = [ t;
      -64*sin(t/8)/3 ];

vr = [ 1;
      -64*(cos(t/8))*(1/8)/3 ];

fr = [ 0;
      -64*(-sin(t/8))*(1/8)^2/3 ];
end
