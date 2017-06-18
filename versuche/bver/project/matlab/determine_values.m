function [ohm, tol, ppm] = determine_values(img)
    brown = 0.057;
    red = 0;

    ring_values = [2, 2, 0, 0, 1];
    [ohm, tol, ppm] = decode(ring_values);
end

function [ohm, tol, ppm] = decode(ring_values)
    if length(ring_values) == 4
        [ohm, tol, ppm] = decode_4_rings(ring_values);
    elseif length(ring_values) == 5
        [ohm, tol, ppm] = decode_5_rings(ring_values);
    elseif length(ring_valeus) == 6
        [ohm, tol, ppm] = decode_6_rings(ring_values);
    else
        error('You dun fucked something up mate');
    end
end

function [ohm, tol, ppm] = decode_4_rings(ring_values)
    ohm = (ring_values(1)*10 + ring_values(2)) * 10^ring_values(3);
    tol = lookup_tolerance(ring_values(4));
    ppm = 0;
end

function [ohm, tol, ppm] = decode_5_rings(ring_values)
    ohm = (ring_values(1)*100 + ring_values(2)*10 + ring_values(3)) * 10^ring_values(4);
    tol = lookup_tolerance(ring_values(5));
    ppm = 0;
end

function [ohm, tol, ppm] = decode_6_rings(ring_values)
    ohm = (ring_values(1)*100 + ring_values(2)*10 + ring_values(3)) * 10^ring_values(4);
    tol = lookup_tolerance(ring_values(5));
    if ring_values(6) == 1
        ppm = 100;
    elseif ring_values(6) == 2
        ppm = 50;
    elseif ring_values(6) == 3
        ppm = 15;
    elseif ring_values(6) == 4
        ppm = 25;
    else
        ppm = -1;
    end
end

function tol = lookup_tolerance(ring_value)
    if ring_value == -2  % silver
        tol = 0.1;
    elseif ring_value == -1 % gold
        tol = 0.05;
    elseif ring_value == 1 % brown
        tol = 0.01;
    elseif ring_value == 2 % red
        tol = 0.02;
    elseif ring_value == 5 % green
        tol = 0.005;
    elseif ring_value == 6 % blue
        tol = 0.0025;
    elseif ring_vaule == 7 % purple
        tol = 0.001;
    else
        tol = -1;
    end
end
