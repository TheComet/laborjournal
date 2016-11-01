function [t10, t50, t90] = calculate_t10_t50_t90(xdata, ydata, mode)
    if nargin < 3
        mode = 'discrete';
    end
    if strcmp(mode, 'discrete')
        [t10, t50, t90] = do_discrete(xdata, ydata);
    end
    if strcmp(mode, 'spline')
        [t10, t50, t90] = do_spline(xdata, ydata);
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
    t10 = spline(ydata, xdata, (ydata(end)-ydata(1)) * 0.1);
    t50 = spline(ydata, xdata, (ydata(end)-ydata(1)) * 0.5);
    t90 = spline(ydata, xdata, (ydata(end)-ydata(1)) * 0.9);
end
