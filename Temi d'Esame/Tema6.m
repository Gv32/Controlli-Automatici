clear all
close all
s = tf('s')

F = 8*(s+15)/(9*s*(s+1)*(s^2+s+100))
%errore 6t+3t^2

Kf = dcgain(s*F)

%sia aggiunge un polo al controllore per la parabola

Kc = 3/(45*Kf)
Kc = 0.55

wb = 3/4.2
wcd = 0.63*wb

s_hat = 0.30
Mr = (1+s_hat)/0.9
Mr = 3.17

Mf = 60-5*Mr

Ga1 = Kc/s * F

figure,bode(Ga1)

%rete PI

bode(1+s)
xz = 3.5
tauz = xz/wcd
Rz = 1 + tauz*s

Ga2 = Ga1 * Rz


figure,margin(Ga2)
[m,f] = bode(Ga2,wcd)

C = Kc/s * Rz

W = feedback(C*F,1)
figure,step(W)