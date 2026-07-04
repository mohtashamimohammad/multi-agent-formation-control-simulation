function [X0, V0] = init_condition(P)
%INIT_CONDITION  Initialize agent positions and velocities.
%
%   [X0, V0] = INIT_CONDITION(P) returns initial conditions for the
%   simulation.
%
%   Outputs:
%       X0 : initial agent positions (n-by-m)
%       V0 : initial agent velocities (n-by-m)
%
%   Notes:
%   - The position set below is specified for a 2D, 6-agent scenario as used
%     in the reference simulations.
%   - Velocities are initialized randomly with a fixed seed for
%     reproducibility.

X0 = [
     5  -15
     8   -8
    13   10
     3    8
    10   20
     7   26
];

rng(P.rng_seed);
V0 = -2 + 4*rand(P.n, P.m);
end
