function varargout=plusminus(val)
% PLUSMINUS Generate +/- values
%
%   v = PLUSMINUS;
%   v = PLUSMINUS()            % generate [-1 1]
%   v = PLUSMINUS(val)         % generate [-val val]
%   [vm,vp] = PLUSMINUS(...)   % vm=-val, vp=val
%
%   use the alternate form 'PM'
%
%   Used to generate positive and negative versions of a given value.
%   This is useful for Monte-Carlo analysis and worst-case analysis.
%   This is also used to specify temp coefficients that are either + or -
%
%   See also: PM, MC, WC, TOLTC

narginchk(0,1)
nargoutchk(0,2)

if nargin<1, val = 1; end

if nargout==2
    [varargout{1}, varargout{2}] = Analysis.PM(val);
else
    varargout{1} = Analysis.PM(val);
end