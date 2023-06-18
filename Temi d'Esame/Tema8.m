clear all
close all
s = tf('s')

F1 = 5/s
F2 = (s+20)/((s+1)*(s+5)^2)

Kr = 1

d1 = 0.5
%d2 = 0.1t

Kf1 = dcgain(s*F1)
Kf2 = dcgain(F2)

%specifiche statiche
Kc1 = Kr/(0.05*Kf1*Kf2)

Kc2 = 0.1/(0.01*Kf1*Kf2)

bode(F1*F2)

Kc = Kc1

%specifiche dinamiche
T_salita = 1
wb = 3/T_salita
wcd = 0.63*wb

Mr = 2.5
Mf = 60-5*Mr

Ga1 = Kc*F1*F2*1/Kr

figure,bode(Ga1)

%Recuperare Mr + 8 gradi

%Rete Derivatrice
md = 4
xd = 1
taud = xd/wcd
Rd = (s*taud+1)/(s*taud/md+1)

Ga2 = Ga1 * Rd^2

[m,f] = bode(Ga2,wcd)

%rete Integratrice
mi = 8.18
bode((1+s/mi)/(1+s))
xi = 230
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc * Ri * Rd^2

W = feedback(C*F1*F2,Kr)

figure,bode(W)
figure,step(W)

%banda passante 3.65
%sovrelongazine massima 18.9
%valore comando risposta al gradino
val = Kc*mi/md