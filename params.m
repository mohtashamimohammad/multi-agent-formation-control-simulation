% params.m
clear; clc;

% Problem setup 
P.n = 6;          % number of agents
P.m = 2;          % workspace dimension (2D)

P.dt = 0.01;      % simulation time step
P.T  = 60;        % total simulation duration
P.t  = 0:P.dt:P.T;

%  Interaction radii (paper setup) 
P.r_in  = 3;       % inner radius
P.r_out = 5;       % outer radius
P.R     = 10;      % sensing/communication radius

%  Safety thresholds 
P.d_safe        = 2 * P.r_in;     % minimum admissible separation
P.d_safe_margin = P.d_safe + 0.4; % optional margin for reporting/plots

%  Randomization / reproducibility 
P.rng_seed = 1;

%  Graph weighting 
P.h_bump = 0.2;    % bump transition parameter (0 < h < 1)

%  Formation configuration 
P.formation_type = 'triangle';    % default scenario identifier

%  Potential/action term parameters 
% kappa controls the magnitude of the repulsive action near the safety
% boundary (d -> 2*r_in). Larger values increase repulsion strength.
P.kappa = 0.6;

% Numerical safeguard for the denominator in the action term (d - 2*r_in)
P.eps_d = 1e-6;

% Toggle for enabling/disabling the potential/action term
P.use_potential = true;

%  Formation term gains 
P.k1 = 0.8;
P.k2 = 1.0;
