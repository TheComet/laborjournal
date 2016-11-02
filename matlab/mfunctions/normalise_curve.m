% Depending on how many output variables you assign, this function will
% either compute the Tu/Tg constants as specified by Hudzovic, or compute
% the times t10, t50 and t90 as specified by L. Sani.
%
% Examples:
%    [t10, t50, t90] = normalise_curve(xdata, ydata, 'spline');
%    [Tu, Tg] = normalise_curve(xdata, ydata);
%
% Parameters:
%    xdata, ydata are vectors of XY data.
%    mode : Optional, and only relevant when calculating t10, t50, t90.
%
%           Can specify 'spline' or 'discrete'. Spline is the default mode
%           and causes the t10, t50, and t90 lookups to interpolate between
%           data points for a more accurate result. This requires that the
%           input data be monotonic and the X data be equispaced.
%
%           Descrete mode will work on any scattered XY data, but is less
%           accurate, because no interpolation method is used. The nearest
%           data point is snapped to.
function [a, b, c] = normalise_curve(xdata, ydata, mode)
    if nargout == 2
        if nargin > 2
            error('mode does nothing when calculating Tu/Tg');
        end
        [a, b] = calculate_tu_tg(xdata, ydata);
    elseif nargout == 3
        if nargin < 3
            [a, b, c] = calculate_t10_t50_t90(xdata, ydata);
        else
            [a, b, c] = calculate_t10_t50_t90(xdata, ydata, mode);
        end
    else
        error('Either use [Tu,Tg] = normalise_curve() or [t10,t50,t90] = normalise_curve()');
    end
end

function [t10, t50, t90] = calculate_t10_t50_t90(xdata, ydata, mode)
    if nargin < 3
        mode = 'spline';
    end
    if strcmp(mode, 'discrete')
        [t10, t50, t90] = do_discrete(xdata, ydata);
    elseif strcmp(mode, 'spline')
        [t10, t50, t90] = do_spline(xdata, ydata);
    else
        error('unknown option to calculate_t10_t50_t90');
    end
end

function [t10, t50, t90] = do_discrete(xdata, ydata)
    y10 = (ydata(end) - ydata(1)) * 0.1;
    y50 = (ydata(end) - ydata(1)) * 0.5;
    y90 = (ydata(end) - ydata(1)) * 0.9;
    for i = 1:length(ydata)
        if ydata(i) > y10
            t10 = xdata(i);
            break;
        end
    end
    for i = i:length(ydata)
        if ydata(i) > y50
            t50 = xdata(i);
            break;
        end
    end
    for i = i:length(ydata)
        if ydata(i) > y90
            t90 = xdata(i);
            break;
        end
    end
end

function [t10, t50, t90] = do_spline(xdata, ydata)
    t10 = spline(ydata, xdata, ydata(1) + (ydata(end)-ydata(1)) * 0.1);
    t50 = spline(ydata, xdata, ydata(1) + (ydata(end)-ydata(1)) * 0.5);
    t90 = spline(ydata, xdata, ydata(1) + (ydata(end)-ydata(1)) * 0.9);
end

% Input function must be a PTn element. This function will calculate the
% tangent in the point of inflection and use that to calculate Tu and Tg.
% xdata must be a vector of equispaced datapoints.
% Note that no smoothing is performed on the input function. Make sure to
% pre-process the curve as necessary if it has noise.
function [Tu, Tg] = calculate_tu_tg(xdata, ydata)

    % Find the point of inflection by searching for a maximum in the
    % derivative
    dx = xdata(2) - xdata(1);
    dy = diff(ydata) / dx;
    [inflection_gradient, inflection_index] = max(dy);
    
    % Get the coordinates of the inflection point, then construct a tangent
    % through it and find where it intersects with the horizontal line
    % placed at the lowest point of the input function.
    %
    % NOTE: The assumption is that ydata(1) is the lowest point of the
    % input function. This should be true for all PTn elements (no need for
    % min(ydata)).
    %
    % The formula used here was derived by hand from the equations:
    %   Tangent is defined as:
    %      line_y = line_x * inflection_gradient + q
    %   Intersection is defined as:
    %      ydata(1) = intersection * inflection_gradient + q
    %   --> solve for intersection
    line_x = xdata(inflection_index);
    line_y = ydata(inflection_index);
    intersection = (ydata(1) - line_y + line_x * inflection_gradient) / inflection_gradient;
    % Tu is the offset to the point of intersection
    Tu = intersection - xdata(1);
    
    % Tg is calculated similarly, except we intersect the tangent with the
    % maximum horizontal line (ydata(end)).
    intersection = (ydata(end) - line_y + line_x * inflection_gradient) / inflection_gradient;
    Tg = intersection - Tu - xdata(1);
end
