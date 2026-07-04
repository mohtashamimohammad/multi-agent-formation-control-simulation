function y = bump(z, h)
%BUMP  Smooth compact-support weighting function.
%
%   y = BUMP(z, h) computes a smooth weighting profile commonly used to
%   taper graph weights with normalized distance z = d/R.
%
%   Definition (piecewise):
%       y(z) = 1,                                        0 <= z < h
%            = 0.5 * (1 + cos(pi*(z - h)/(1 - h))),      h <= z <= 1
%            = 0,                                        z > 1  (or z < 0)
%
%   Inputs:
%       z : normalized distance(s), can be scalar or array
%       h : transition parameter in (0, 1), sets where the taper begins
%
%   Output:
%       y : weight(s) with the same size as z

y = zeros(size(z));

% Constant region: full weight for sufficiently close neighbors
idx1 = (z >= 0) & (z < h);
y(idx1) = 1;

% Tapering region: smooth decay to zero on [h, 1]
idx2 = (z >= h) & (z <= 1);
y(idx2) = 0.5 * (1 + cos(pi*(z(idx2) - h)/(1 - h)));

% Outside support: y remains zero
end
