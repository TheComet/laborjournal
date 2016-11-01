function G = sani_transfer_function(T, r, order)
    s = tf('s');
    G = 1;
    for k = 1:order
        G = G / (1+s*r^k);
    end
end
