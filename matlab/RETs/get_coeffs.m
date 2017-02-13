function get_coeffs(z)

[b, a] = numden(z);
b = double(coeffs(b, 'All'));
a = double(coeffs(a, 'All'));

[r, p, k] = residue(b, a)

end
