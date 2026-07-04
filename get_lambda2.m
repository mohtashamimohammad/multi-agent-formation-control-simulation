function lam2 = get_lambda2(L)
%GET_LAMBDA2  Compute the algebraic connectivity (second-smallest eigenvalue).
%
%   lam2 = GET_LAMBDA2(L) returns the second-smallest eigenvalue of the
%   (numerically) symmetrized Laplacian matrix. This value is commonly
%   referred to as the algebraic connectivity (Fiedler value) and is used
%   as a connectivity metric for undirected graphs.
%
%   Input:
%       L : Laplacian matrix (n-by-n)
%
%   Output:
%       lam2 : algebraic connectivity (scalar). Returns 0 if the matrix size
%              is smaller than 2.

e = eig((L+L')/2);
e = sort(real(e), 'ascend');

if numel(e) < 2
    lam2 = 0;
else
    lam2 = e(2);
end
end
