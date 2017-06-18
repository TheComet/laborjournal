function [ohm, tol, ppm] = rescol2value(img)
    ring_colours = split_rings(img);
    ring_values = zeros(1, length(ring_colours));
    [a,~]=size(ring_colours);
    for i = 1:a
        colour = ring_colours(i,:);
        
        % black, grey, white
        if abs(colour(1) - colour(2)) < 0.1 && abs(colour(1) - colour(3)) < 0.1
            if colour(1) < 0.4
                value = 0; % black
            elseif colour(1) < 0.7
                value = 0; % grey
            else
                value = 0; % white
            end
        else
            %colour = rgb2hsv(colour);
            % red or brown
            %if colour(1) < 0.13 || colour(1) > 0.87
            %    if colour(3) < 0.4
            %        value = 1; % brown
            %    else
            %        value = 2; % red
            %    end
            %elseif colour(1) >= 0.13 && colour(1) < 0.28
            %    value = 3; % orange
            %elseif colour(1) >= 0.28 && colour(1) < 0.40
            %    value = 4; % yellow
            %elseif colour(1) >= 0.40 && colour(1) < 0.50
            %    value = 5; % green
            %elseif colour(1) >= 0.50 && colour(1) < 0.74
            %    value = 6; % blue
            %else
            %    value = 7; % purple
            %end
            value=2+rgb2ind(cat(3,colour(1),colour(2),colour(3)), ...
                [
%                70 70 70
                255 0 0
                255 150 0
                255 255 0
                60  255 0
                0 60 255
                128 0 255            
                ]/255);
        end
        ring_values(i) = value;
    end
    [ohm, tol, ppm] = decode(ring_values);
end

function ring_colours = split_rings(img)
    body_hsv = [0.56, 0.3, 0.6];
    body_tol = [0.05, 0.15, 0.3];
    img = rgb2hsv(img);
    imfilt = abs((img(:,:,1)-body_hsv(1)) < body_tol(1)) .* abs((img(:,:,2)-body_hsv(2))<body_tol(2) .* abs((img(:,:,3)-body_hsv(3))<body_tol(3)));
    imfilt = imdilate(imfilt, ones(10));
    imagesc(img);
    img = hsv2rgb(img .* (1 - imfilt));
    
    ring_colours = [];
    flag = 0;
    last_i = 1;
    for i = 1:length(img)
        if img(i,:,1) == 0 && img(i,:,2) == 0 && img(i,:,3) == 0
            if flag == 1
                flag = 0;
                r = mean(img(last_i+1:i-1,:,1));
                g = mean(img(last_i+1:i-1,:,2));
                b = mean(img(last_i+1:i-1,:,3));
                ring_colours(end + 1,:) = [r, g, b];
            else
                last_i = i;
            end
        else
            flag = 1;
        end
    end
end

function [ohm, tol, ppm] = decode(ring_values)
    while length(ring_values) <4
        ring_values(end+1)=0;
    end
    if length(ring_values) == 4
        [ohm(1), tol(1), ppm(1)] = decode_4_rings(ring_values);
        [ohm(2), tol(2), ppm(2)] = decode_4_rings(ring_values(end:-1:1));
    elseif length(ring_values) == 5
        [ohm(1), tol(1), ppm(1)] = decode_5_rings(ring_values);
        [ohm(2), tol(2), ppm(2)] = decode_5_rings(ring_values(end:-1:1));
    elseif length(ring_values) == 6
        [ohm(1), tol(1), ppm(1)] = decode_6_rings(ring_values);
        [ohm(2), tol(2), ppm(2)] = decode_6_rings(ring_values(end:-1:1));
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
    elseif ring_value == 7 % purple
        tol = 0.001;
    else
        tol = -1;
    end
end
