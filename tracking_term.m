function Utr = tracking_term(X, V, xr, vr, fr, Pstar)
%TRACKING_TERM  Reference tracking term for each agent.
%
%   Utr = TRACKING_TERM(X, V, xr, vr, fr, Pstar) computes the tracking
%   component of the control input for a double-integrator multi-agent
%   system. The term drives each agent's formation-relative position toward
%   the reference trajectory while tracking the reference velocity and
%   acceleration.
%
%   For agent i:
%       e_i   = x_i - p_i*
%       u_tr,i = - (e_i - x_r) - (v_i - v_r) + f_r
%
%   Inputs:
%       X     : agent positions (n-by-m)
%       V     : agent velocities (n-by-m)
%       xr    : reference position (m-by-1)
%       vr    : reference velocity (m-by-1)
%       fr    : reference acceleration (m-by-1)
%       Pstar : formation target offsets (n-by-m)
%
%   Output:
%       Utr : tracking control term for all agents (n-by-m)

n = size(X,1);
m = size(X,2);
Utr = zeros(n,m);

for i = 1:n
    ei = X(i,:) - Pstar(i,:);
    Utr(i,:) = -(ei - xr(:)') - (V(i,:) - vr(:)') + fr(:)';
end
end
