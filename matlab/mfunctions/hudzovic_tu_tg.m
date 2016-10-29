% Input function must be a PTn element. This function will calculate the
% tangent in the point of inflection and use that to calculate Tu and Tg.
% xdata must be a vector of equispaced datapoints.
% Note that no smoothing is performed on the input function. Make sure to
% pre-process the curve as necessary if it has noise.
function [Tu, Tg] = hudzovic_tu_tg(xdata, ydata)

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
