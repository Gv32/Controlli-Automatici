clear all
close all
s = tf('s')

A = 0.1
F = (s-20)/(s*(s+10))
d1 = 0.1
d2 = 0.2

Kf = dcgain(s*F)

%errore inseguimneto ai due disturbi costanti e al gradino coperti dal polo
%in 0

Kc = 10

nyquist(F)

Kc = -10

wb = 2.5 %errore del 10% 2.25/2.75
wcd = 0.63*wb
wcd = 1.58

Mr = 3.5
Mf = 60-5*Mr %43 gradi da recuperare

Ga1 = Kc/s * F * A

figure,bode(Ga1)
%57 gradi totali da recuperare

%rete p
bode(1+s)
xz = 2
tauz = xz/wcd
Rz = 1+tauz*s
Ga2 = Ga1 * Rz

[m,f] = bode(Ga2,wcd)
%rete ritardatrice
mi = 1.78
bode((1+s/mi)/(1+s))
xi = 55
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc/s * Ri * Rz

W = feedback(C*F*A,1)

figure,step(W)
figure,bode(W)