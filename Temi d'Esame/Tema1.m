clear all
close all
s = tf('s')

F1 = 2.5 * (1+s)/(1+0.5*s)^2
F2 = 30 * (1+0.1*s)/(s*(s+30)^2)
d1 = 0.01
%d2 = 0.2t
Kr = 1

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

Kc1 = Kr/(Kf1*Kf2*0.5)

%di/Kg < 0.01

Kc2 = d1/(Kf1*Kr*0.01)

%d2/Kg

Kc3 = 0.2/(Kf1*Kf2*Kr*0.2)

Kc = 510 %aumentiamo Kc maggiore di 24 per avere un modulo accettabile da recuperare

%segno

%Kf1*Kf2 positivo V
%Poli tutti parte reale <0 V
bode(F1*F2) %passa una sola volta da 0 e -180 V

%dinamiche

wb = 31.5 %erroe del 10% wb può andare da 31.5 a 38.5
wcd = 0.63*wb
wcd = 19.8

s_hat = 0.25
Mr = (1+s_hat)/0.9
Mr = 2.8
Mf = 60-5*Mr

Ga1 = Kc * F1 * F2
figure,bode(Ga1)

%rete anticipatrice
md = 3
xd = 0.78
taud=xd/wcd
Rd=(s*taud+1)/(s*taud/md+1)

Ga2 = Ga1*Rd^2

[m,f] = bode(Ga2,wcd)

figure,margin(Ga2)

C = Kc * Rd^2

W = feedback(C*F1*F2,1/Kr)

figure,step(W)
figure,bode(W)

%specifiche aggiuntive
%ts 0.0838
%picco risonanza 1.89
%errore di inseguimento alla sinusoide 0.047 prendendolo dai due comandi di
%sotto
sens=feedback(1,Ga2)
errore=bode(sens,0.2)

%discretizzazione

ts = (2*pi)/(20*36.5) %36.5 e il valore di wb quando si chiude l annello e si fa W
Gap = Ga2*1/(1+ts/2*s)
figure,margin(Gap)

Cz1 = c2d(C,ts,'tustin')
Cz2 = c2d(C,ts,'zoh')
Cz3 = c2d(C,ts,'match')

%tustin sempre number one