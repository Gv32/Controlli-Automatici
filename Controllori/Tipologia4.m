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

%Kr/Kg < 0.05
%Kr/(Kc * Kf1 * Kf2 * 1/Kr) < 0.05

Kc1 = Kr^2 / (0.05*Kf1*Kf2)

%secondo errore non si considera
%terzo errore

%coeff_rampa/(Kc*Kf1*Kf2*1/Kr) < 0.01

Kc2 = 0.1/(0.01*Kf1*Kf2)

Kc = Kc1

bode(F1*F2) %segno positivo

%tempo di salita pari a un secondo con errore che va da 0.8 a 1.2
ts = 1
wb = 3/1
wcd = wb * 0.63

%picco di risonanza non superiore a 2.5
Mf = 60-5*2.5
%margine di fase da nicols circa 42 gradi

Ga1 = Kc * F1 * F2 * 1/Kr
bode(Ga1)

%recuperiamo dai 60 ai 65 gradi

%rete anticipatrice,due reti da 4 centrae in 1
md = 4
xd = 1
taud = xd/wcd
Rd = (s*taud+1)/(s*taud/md +1)
Ga2 = Ga1 * Rd^2
[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 8.1
bode((1+s/mi)/(1+s))
xi = 120
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)
Ga3 = Ga2* Ri
figure,margin(Ga3)

C = Kc * Rd^2 * Ri
W = feedback(C*F1*F2,1/Kr)

figure,step(W)
figure,bode(W)

%specifiche dinamiche soddisfatte

%valutazione parametri
figure,bode(W)
%wb = 3.72
figure,step(W)
s_hat = 0.22
%il valore massimo del comando applicato al controllore quando r(t)=1 in
%assenza didisturbi
Wu = C * feedback(1,Ga3);
figure,step(Wu,0.2)
%in questo caso

%discretizzazione
wb = 3.72
ts = 2*pi/(20*wb)
ts = 0.02
Gazoh=Ga3/(1+s*ts/2)

margin(Gazoh)
Cz1 = c2d(C,ts,'tustin') %tempo salita 0.89 sovraelong 1.235
Cz2 = c2d(C,ts,'zoh') %tempo salita 0.822 sovraelong 1.24
Cz3 = c2d(C,ts,'match') %tempo salita 0.89 sovraelong 1.235