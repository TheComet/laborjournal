# -*- coding: utf-8 -*-

# speed of light and elementary charge
c=299792458
e=1.6021766208e-19

# from the fitted data
mph=3.43140e-15
smph=6.56141e-17
m0=3.27197e-15
sm0=1.33856e-16
mk=4.70741e-15
smk=7.40421e-16

# systematic errors (30%)
off = 0.3
smph = (smph**2 + (mph*off)**2)**0.5
sm0 = (sm0**2 + (m0*off)**2)**0.5
smk = (smk**2 + (mk*off)**2)**0.5

# calculate Planck's constant
hph = mph * e
shph = e * smph
h0 = m0 * e
sh0 = e * sm0
hk = mk * e
shk = e * smk
print('hph: {}/{}'.format(hph, shph))
print('h0: {}/{}'.format(h0, sh0))
print('hk: {}/{}'.format(hk, shk))

# Calculate average constant with error
gi = (1/shph**2 + 1/sh0**2 + 1/shk**2)
h = (hph/shph**2 + h0/sh0**2 + hk/shk**2) / gi
sh = 1/gi**0.5
print('h: {}/{}'.format(h, sh))
