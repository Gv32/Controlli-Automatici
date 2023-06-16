clear all
close all
s=tf('s')

F1 = (-0.65)/(s^3+4*s^2+1.75*s)
Tp = 1
A = 9
d1 = 5.5e-3
d2 = 5.5e-3

Kf1 = dcgain(s*F1)

%nessun polo in c

Kc1 = Tp/(Kf1*A*0.2)

Kc2 = 5.5e-3/(A*6e-4)

Kc3 = 5.5e-3/(A*Kf1*1.5e-3)

Kc = 1.5

nyquist(F1)
Kc = -1.5

%analisi specifiche dinamiche

ts = 1
wb = 3/ts
wcd = 0.63*wb

s_hat = 0.3
Mr = (1+s_hat)/0.9
Mr = 3.2
Mf = 60-5*Mr

Ga1 = Kc * F1 * A

figure,bode(Ga1)

% rete anticipatrice
md = 4
xd = 0.87
taud = xd/wcd
Rd = (s*taud+1)/(s*taud/md+1)

Ga2 = Ga1 * Rd^2

[m,f] = bode(Ga2,wcd)

figure,margin(Ga2)

C = Kc * Rd^2

W = feedback(C*F1*A,Tp)

figure,step(W)
figure,bode(W)

%specifiche dinamiche soddisfatte

%banda passante 3.28
%picco risonanza 3.01
%valore massimo in modulo del comando che può essere indotto dal disturbp
%dp in retroazione dp = 10e-3sin(30t)
sens = feedback(1,Ga2)
error = bode(-C*sens*10e-3,30)
%errore 22.3142

%discretizzazione
wb = 3.28
ts = 2*pi/(20*ts)
gazoh = Ga2*(1/(1+ts/2*s))
cz1 = c2d(C,ts,'tustin')
cz2 = c2d(C,ts,'zoh')
cz3 = c2d(C,ts,'match')

%tustin migliore