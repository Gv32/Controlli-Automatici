clear all
close all
s = tf('s')

F1 = 30/(s+15)
F2 = (3*s+3)/(s^3+10*s^2+24*s)

Kr = 1
d1 = 1
d2 = 4

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

%analisi specifiche statiche

%erorre inseguimento alla rampe < 0.1

%Kr/Kga < 0.1

Kc1 = Kr/(Kf1 * Kf2 * 0.1)

Kc2 = d1/(Kf1 * 0.05)

Kc3 = 0 %a causa del polo in F2

%studio del segno

%Kf1 e Kf2 concordi
%Tutti i poli a parte reale negativa
bode(F1*F2)
%una sola volta in 180 e una volta sola in 0

Kc = Kc1

%analisi specifiche dinamiche
wb = 20 %errore pari a 10% quindi da 18 a 22
wcd = 0.63*wb

s_hat = 0.20
Mr = (1+s_hat)/0.9

Mr = 2.47
Mf = 60-5*Mr

Ga1 = Kc * F1 * F2
figure,bode(Ga1)

%rete anticipatrice per recuperare 50 o 53 gradi
md = 3
xd = 1
taud = xd/wcd

Rd = (s*taud+1)/(s*taud/md+1)

Ga2 = Ga1 * Rd^2

[m,f]=bode(Ga2,wcd)

%rete ritardatrice
mi = 1.8
bode((1+s/mi)/(1+s))
xi = 30
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)

Ga3 = Ga2 * Ri
figure,margin(Ga3)

C = Kc * Rd^2 * Ri

W = feedback(C*F1*F2,1)
figure,step(W)
figure,bode(W)

%paramteri utili
%tempo di salita 0.156
%picco di risonanza 1.44
%errore inseguimento massimo a una sinusoide a seno di 0.2*t
sens=feedback(1,Ga3)
error_sens=bode(sens,0.2)
%errore 0.0211

wb = 21.9
ts = 2*pi/(20*wb)
ts = 0.007
gazoh = Ga3*(1/(1+(ts*s/2)))
figure,margin(gazoh)

cz1 = c2d(C,ts,'tustin') %1.17
cz2 = c2d(C,ts,'zoh')    %1.18
cz3 = c2d(C,ts,'match')  %1.18

%tustin number one