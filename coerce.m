function v = coerce(v, vmin, vmax)
% COERCE - coerces a value to be within a given min/max range
%    v = COERCE(v, vmin, vmax)
%    v = COERCE(v, [vmin vmax])
%
%    Essentially, COERCE returns the intermediate value of the three
%    arguments.
%
%   % Example:
%   % Vout = 5.7;
%   % coerce(Vout, 0.0, 5.0)
%   %   result in ans = 5.0

% Kerry S. Martin, martin@wild-wood.net

narginchk(1,3)

if nargin>1
    if nargin<3
        vmax = max(vmin);
        vmin = min(vmin);
    elseif vmin>vmax
        vtmp = vmin;
        vmin = vmax;
        vmax = vtmp;
    end
    if vmin>v
        v = vmin;
    elseif vmax<v
        v = vmax;
    end
end

% Copyright (c) 2024, Kerry S. Martin, martin@wild-wood.net