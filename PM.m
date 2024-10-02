function varargout=PM(val)
% PM Generate +/- values
%
%   v = PM;
%   v = PM()            % generate [-1 1]
%   v = PM(val)         % generate [-val val]
%   [vm,vp] = PM(...)   % vm=-val, vp=val
%
%   use the alternate form 'plusminus'
%
%   Used to generate positive and negative versions of a given value.
%   This is useful for Monte-Carlo analysis and worst-case analysis.
%   This is also used to specify temp coefficients that are either + or -
%
%   See also: PLUSMINUS, MC, WC, TOLTC

narginchk(0,1)
nargoutchk(0,2)

if nargin<1, val = 1; end

v = [-val val];

if nargout==2
    varargout{1} = min(v);
    varargout{2} = max(v);
else
    varargout{1} = v;
end

% Copyright (c) 2024, Kerry S. Martin, martin@wild-wood.net