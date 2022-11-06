function varargout=toltc(vnom, tol, tc, temp)
% TOLTC Tolerance and Temperature Coefficient
%
%   [vmin,vmax]=TOLTC(vnom)   % just produces vnom with no variation
%   [vmin,vmax]=TOLTC(vnom, tol)
%   [vmin,vmax]=TOLTC(vnom, tol, tc, temp)
%   [vmin,vmax]=TOLTC(vnom, tol, tc)  % default temp -40 to +125 nom +25
%   [vmin,vnom,vmax]=TOLTC(...)
%   vals=TOLTC(...)   % produces a row vector [vmin vnom vmax]
%
%     vnom is the nominal value (must be a scalar greater than zero)
%     tol is the tolerance (0 = 0%, 0.01 = 1%, 0.10 = 10%, etc)
%       2 element vector is [tolmin tolmax]   ex/ [-0.20 0.10]
%     tc is the temperature coefficient (1/degC)
%       0 is TC==0 i.e. no variation with temperature
%       >0 is positive TC
%       <0 is negative TC
%       [tc1 tc2] is multiple TC (positive or negative) use plusminus
%     temp is temperature specification in degrees Celsius
%       scalar is eithet Tmax (if > 25) or Tmin (if <= 25)
%       default Tmin = -40, default Tmax = 125, default Tnom is 25
%       2 element vector is Tmin and Tmax
%       3 element vector is Tmin, Tnom, and Tmax
%
%   See also: PLUSMINUS

narginchk(1,4)
nargoutchk(0,3)

% assign default values
if nargin<2, tol = 0.0; end
if nargin<3, tc = 0.0; end
if nargin<4, temp = [-40 25 125]; end

% sanity checking and argument manipulation
if vnom<=0, error('Nominal value must be greater than 0'), end
if isscalar(tol)
    tol = [-tol tol];  % defaults to +/- tol
elseif ~isvector(tol) || length(tol)~=2
    error('Tolerance must be a scalar or 2 element vector')
end
tol = sort(tol);
if isscalar(tc)
    tc = [tc tc];  % defaults to keep the sign for tc (use 2 vec for +/-)
elseif ~isvector(tc) || length(tc)~=2
    error('TC must be a scalar or 2 element vector')
end
tc = sort(tc);
if isscalar(temp)
    if temp<=25
        temp = [temp 25 125];
    else
        temp = [-40 25 temp];
    end
elseif ~isvector(temp) || length(temp)>3
    error('Temp must be a scalar or 2 or 3 element vector')
elseif length(temp)==2
    temp = [temp(1) 25 temp(2)];
end
temp = sort(temp);

% calculate tol variation
vtmin = vnom*(1+tol(1));
vtmax = vnom*(1+tol(2));

% calculate TC variation
th = temp(3)-temp(2);
tl = temp(1)-temp(2);
tv1 = 1+tc(1)*th;
tv2 = 1+tc(1)*tl;
tv3 = 1+tc(2)*th;
tv4 = 1+tc(2)*tl;
tv = [tv1 tv2 tv3 tv4];
tvmin = min(tv);
tvmax = max(tv);

% calculate total variation
vmin = vtmin*tvmin;
vmax = vtmax*tvmax;

if nargout==3
    varargout{1} = vmin;
    varargout{2} = vnom;
    varargout{3} = vmax;
elseif nargout==2
    varargout{1} = vmin;
    varargout{2} = vmax;
else
    varargout{1} = [vmin vnom vmax];
end
    