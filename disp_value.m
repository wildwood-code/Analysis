function str = disp_value(v, varargin) %suffix, unit, name, prec, eol, prefix)
% DISP_VALUE display analysis value using format (or format without display)
%   DISP_VALUE(v, Unit, name, prec, eol, prefix)
%   DISP_VALUE(v, suffix, unit, name, prec, eol, prefix)
%   str = DISP_VALUE(v, suffix, unit, name, prec, eol, prefix)
%
%    v = value to display (scalar, row, or column vector)
%
%    Unit = Unit object
%    suffix = scaling suffix ('m', 'u', 'n', 'p', 'f', 'k', 'M', 'MEG',
%                             'G', 'T')
%    unit = unit to display after suffix (default = none)
%    name = name to display before value (default = none)
%    eol = generate EOL after display (default = true)
%    prec = decimal precision (default = 3 digits after decimal point)
%
%    str = output string. If output argument is present, it will return
%          the formatted value and not display it.
%          eol is ignored if the value is displayed
%
%   % Example:
%   % R1 = 15.1215832e3;
%   % disp_value(R1, 'k', 'Ohm', 'R1')
%   % R1 = 15.122kOhm

% Kerry S. Martin, martin@wild-wood.net

narginchk(1,7)
if nargin<2
    is_unit = false;
    suffix="";
elseif isa(varargin{1},'Units.Unit')
    is_unit = true;
    suffix = "";
    unit = string(varargin{1}.name);
    scale = varargin{1}.scale;
else
    is_unit = false;
    suffix=string(varargin{1});
end

if is_unit
    narginchk(1,6) % one fewer allowed if Unit is specified
    if nargin<3
        name="";
    else
        name=string(varargin{2});
    end
    if nargin<4
        prec = 3;
    else
        prec = varargin{3};
    end
    if nargin<5
        eol = true;
    else
        eol = varargin{4};
    end
    if nargin<6
        prefix = "";
    else
        prefix = varargin{5};
    end
else
    switch suffix
        case 'k'
            scale = 1e3;
        case { 'M', 'meg', 'MEG', 'Meg' }
            scale = 1e6;
        case 'G'
            scale = 1e9;
        case 'T'
            scale = 1e12;
        case 'm'
            scale = 1e-3;
        case 'u'
            scale = 1e-6;
        case 'n'
            scale = 1e-9;
        case 'p'
            scale = 1e-12;
        case 'f'
            scale = 1e-15;
        otherwise
            scale = 1;
    end
    if nargin<3
        unit="";
    else
        unit=string(varargin{2});
    end
    if nargin<4
        name="";
    else
        name=string(varargin{3});
    end
    if nargin<5
        prec = 3;
    else
        prec = varargin{4};
    end
    if nargin<6
        eol = true;
    else
        eol = varargin{5};
    end
    if nargin<7
        prefix = "";
    else
        prefix = varargin{6};
    end
end

if ~isvector(v)
    error("disp_value will only work for a scalar, row, or column vector")
end

v = v / scale;

vals = v;
N = length(vals);

sf = "%." + string(prec) + "f";

if strlength(suffix)>0 || strlength(unit)>0
    % prepend suffix with a space if there is a suffix or unit to display
    suffix = " " + suffix;
end

is_scalar = isscalar(vals);
is_row = isrow(vals);

if is_scalar
    str = "";
else
    str = "[ ";
end

for i=1:N
    v = vals(i);
    
    if is_scalar
        strv = sprintf(sf, v);
    elseif is_row || i==N
        strv = sprintf(sf+" ", v);
    else
        strv = sprintf(sf+" ; ", v);
    end
    
    str = str + strv;
end

if ~is_scalar
    str = str + "]";
end

if strlength(name)>0
    str = sprintf("%s = %s%s", name, prefix, str);
end

str = sprintf("%s%s%s%s", prefix, str, suffix, unit);

if nargout==0
    fprintf("%s", str)
    if eol
        fprintf("\n")
    end
    clear str
end

% Copyright (c) 2024, Kerry S. Martin, martin@wild-wood.net