clear all
close all
s = tf('s')

F1 = (1+s/0.1)/((1+s/0.2)*(1+s/10))
F2 = 1/s

Kr = 1
d = 1.5

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

%inserisco polo per la parabola

%kr/Kga < 0.16

Kc1 = Kr/(Kf1*Kf2*0.16)

Kc = Kc1

bode(F1*F2)

%specifiche dinamiche

wb = 4
wcd = 0.63*wb

s_hat = 0.25
Mr = (1+s_hat)/0.9
Mr = 2.85
Mf = 60-5*Mr

Ga1 = Kc/s * F1 * F2

bode(Ga1)

%Rete PI
xz = 3.45
bode(1+s)
tauz = xz/wcd
Rz = 1 + tauz*s

Ga2 = Ga1 * Rz

[m,f] = bode(Ga2,wcd)

%Rete attenuatrice
mi = 6.84
bode((1+s/mi)/(1+s))
xi = 65
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc/s * Rz * Ri

W = feedback(C*F1*F2,1)

figure,step(W)
figure,bode(W)

sens = feedback(1,Ga3)
x = bode(C*sens,0.5)