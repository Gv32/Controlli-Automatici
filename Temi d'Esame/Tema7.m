clear all
close all
s = tf('s')

F1 = (s+40)/(s+2)
F2 = 80/(s^2+13*s+256)

Kr = 1
d1 = 0.5
d2 = 0.2

Kf1 = dcgain(F1)
Kf2 = dcgain(F2)

%Statistiche statiche
%inserisco polo per inseguimento alla rampa

Kc1 = Kr/(0.04*Kf1*Kf2)

bode(F1*F2)

%Kc positivo

Kc = Kc1

%specifiche dinamiche

t_salita = 0.2 % errore del 20%
wb = 3/t_salita
wcd = 0.63*wb

s_hat = 0.35
Mr = (1+s_hat)/0.9
Mr = 3.52
Mf = 60-5*Mr

Ga1 = Kc/s * F1 * F2 * 1/Kr

figure,bode(Ga1) %11 da recuperare

%recuperare 43+11 gradi minimo

%Rete PI

bode(1+s)
xi = 2.3
tauz = xi/wcd
Rz = 1+tauz*s

Ga2 = Ga1 * Rz

[m,f] = bode(Ga2,wcd)

%Rete Integratrice
mi = 1.74
bode((1+s/mi)/(1+s))
xi = 40
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)

Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc/s * Rz * Ri

W = feedback(C*F1*F2,1)

figure,bode(W)
figure,step(W)

%specifiche soddisfatte

%specifiche statiche soddisfatte

%calcolo parametri
%banda passante 18.7
%picco di risonanza 3.41
%errore massimo comando risposta al gradino
sens = feedback(1,Ga3)
step(C*sens)

%discretizzazione
wb = 18.7
ts = 2*pi/(20*wb)

Gazoh = Ga3 * 1/(1+ts/2*s)
figure,margin(Gazoh)
cz1 = c2d(C,ts,'tustin')
cz2 = c2d(C,ts,'zoh')
cz3 = c2d(C,ts,'match')
