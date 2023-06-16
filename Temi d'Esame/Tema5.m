clear all
close all
s = tf('s')

F = 0.1*(s+20)/(s*(s+1)*(s^2+2*s+100))

Kf = dcgain(s*F)

Kr = 1

%aggiunta polo al controllore per la rampa
%Kr/Kg < 0.04
Kc = Kr/(0.04)

bode(F)

Kc = 25

t_salita = 6
wb = 3/6.6
wcd = 0.63*wb

s_hat = 0.30
Mr = (1+s_hat)/0.9
Mr = 3.17

Mf = 60-5*Mr

Ga1 = Kc/s * F

bode(Ga1)

%67 da recuperare

%rete Pi
bode(1+s)
xz = 3.4
tauz = xz/wcd
Rz = 1+tauz*s

Ga2 = Ga1 * Rz

[m,f] = bode(Ga2,wcd)

%rete ritardatrice
mi = 20.79
bode((1+s/mi)/(1+s))
xi = 500
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)

Ga3 = Ga2 * Ri

margin(Ga3)

C = Kc/s * Ri * Rz

W = feedback(C * F,1)

figure,step(W)
figure,bode(W)

sens = feedback(1,Ga3)
figure,step(C*sens)