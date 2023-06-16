clear all
close all
s = tf('s')

F = (10*(s+10))/(s^2+0.5*s+25)
d1 = 1
%d2 = t
%d3=sin(1000t)
Kr = 1

Kf = dcgain(F)

%si aggiunge un polo nell'origine al controllore

Kc1 = Kr/(1.25e-4*Kf)

Kc2 = Kr/(2.5e-4*Kf)

Kc = Kc1 %perchè maggiore

bode(F/s) %un solo attraversamento a 0db e -180 gradi

%analisi dinamiche

ts = 0.045 %errore del 0.20 quindi da 0.32 a 0.048

wb = 3/ts
wcd = 0.63*wb

s_hat = 0.35
Mr = (1+s_hat)/0.9
Mr = 3.52 %portandolo in db

Mf = 60-5*Mr
%per il diagramma di nichols Mf = 38
%scegliamo il risultato di Mf perchè con più margine
Ga1 = F * Kc/s
figure,bode(Ga1)
%mi posiziono sul primo diagramma e vedo la fase(magnitude) dove frequency
%è uguale alla nostra wcd, in questo caso magnitude è positivo quindi il modulo andrà ad aumentare

%dal secondo diagramma vedo che posizionandomi a frequency pari a wcd si ha
%un valore pari a -191, quindi bisogna recuperare 191-180 gradi e poi altri
%gradi pari a Mf

%inseriamo una rete p
bode(1+s) %dato che vogliamo recuperare 62 gradi, per essere larghi, da questo comando mi posiziono nel secondo grafico e vedo quando la phase 
%è pari al nostro valore da voler recuperare, e vedo che la frequency è pari a 1.88

xz = 2.83
tauz= xz/wcd
Rz = (1+tauz*s)

Ga2 = Ga1 * Rz
[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 35.5
bode((1+s/mi)/(1+s))
xi = 350
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)
Ga3 = Ga2 * Ri
figure,margin(Ga3)

C = Kc/s * Rz * Ri

W = feedback(C * F,1/Kr)

figure,step(W)
figure,bode(W)