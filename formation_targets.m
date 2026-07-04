function Pstar = formation_targets(P, type)
%FORMATION_TARGETS  Relative target positions for desired formations.
%
%   Pstar = FORMATION_TARGETS(P, type) returns an n-by-m matrix of relative
%   target positions that define the desired formation shape.
%
%   Inputs:
%       P    : parameter struct with fields n, m, r_in, r_out
%       type : formation identifier (e.g., 'triangle' or 'hexagon')
%
%   Output:
%       Pstar : n-by-m matrix, each row is the relative target position of
%               one agent in the formation reference frame

n = P.n; m = P.m;
Pstar = zeros(n,m);

switch lower(type)
    case 'triangle'
    % Triangular formation for n = 6 using an equilateral triangle template:
    % three vertices plus three mid-edge points (total of 6 agents).
    %
    % The side length is chosen as L = 2*(r_in + r_out) to match the setup
    % used in the simulations.

    L = 2*(P.r_in + P.r_out);
    h = (sqrt(3)/2)*L;

    v1 = [0, 0];
    v2 = [L, 0];
    v3 = [L/2, h];

    m12 = (v1+v2)/2;
    m23 = (v2+v3)/2;
    m31 = (v3+v1)/2;

    Pstar(1,:) = v1;
    Pstar(2,:) = m12;
    Pstar(3,:) = v2;
    Pstar(4,:) = m23;
    Pstar(5,:) = v3;
    Pstar(6,:) = m31;

    case 'hexagon'
        % Regular hexagon template for n = 6, centered at the origin.
        % The scale is set using a = r_in + r_out as a nominal side length.

        a = P.r_in + P.r_out;
        Rhex = a;
        for i = 1:n
            ang = (i-1)*2*pi/n;
            Pstar(i,:) = [Rhex*cos(ang), Rhex*sin(ang)];
        end

    otherwise
        error('Unknown formation type');
end
end
