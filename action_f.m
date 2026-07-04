function val = action_f(d, P)
%ACTION_F  Pairwise action function based on the paper (Eq. 11).
%
%   val = ACTION_F(d, P) returns the scalar action value phi(d) used in the
%   potential/interaction term. The function is active only within the
%   interval (2*r_in, R] and is zero outside this range.
%
%   Piecewise definition:
%       phi(d) = -k * ((d - (r_in + r_out)) * (d - R)) / (d - 2*r_in),   d in (2*r_in, R]
%              = 0,                                                     d > R
%
%   Notes:
%   - The denominator (d - 2*r_in) can become very small near d = 2*r_in.
%     A small positive threshold P.eps_d is used to avoid numerical issues.
%
%   Inputs:
%       d : inter-agent distance (scalar)
%       P : parameter struct with fields:
%           r_in, r_out, R, kappa, eps_d
%
%   Output:
%       val : action value phi(d) (scalar)

rin   = P.r_in;
rout  = P.r_out;
R     = P.R;
kcoef = P.kappa;

val = 0;

if (d > 2*rin) && (d <= R)
    denom = (d - 2*rin);
    if abs(denom) < P.eps_d
        denom = sign(denom) * P.eps_d;
    end

    val = -kcoef * ((d - (rin + rout)) * (d - R)) / denom;
else
    val = 0;
end
end
