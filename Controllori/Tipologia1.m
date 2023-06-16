clear all
close all
s = tf('s');
F1 = 30/(s+15);
F2 = (3*s+3)/(s^3+10*s^2+24*s);
Kr = 1;
d1 = 1;
d2 = 4;
Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

%nessun polo nell'origine perchè già dato dalla seconda funzione

%------------------------------------------------

%a
Kc1 = Kr/(0.1*Kf1*Kf2);

%------------------------------------------------

%b
Kc2 = (Kr*d1)/(0.05*Kf1);

%------------------------------------------------

%c
%d2 non influisce perchè il blocco prima ha uno polo nell'origine

%------------------------------------------------

%in questo caso si prende il K con valore più alto perchè più tringente
Kc = 40
%------------------------------------------------

%Calcolo segno Kc
%kf1 e kf2 concordi --- entrambi positivi
%assenza di poli a parte reale positiva --- non ci sono poli a parte reale positiva
%controllare i seguenti diagrammi di bode
bode(F1*F2)
%un solo attrversamento di 0db e -180 gradi ---> ok

%scegliamo il segno positivo perchè le specifiche sono rispettate


%analisi delle specifiche dinamiche

wb = 18
wcd = 11.5

Mr = 2.28 %db
%margine di fase 49 gradi


%funzioni ad anello
Ga1 = Kc * F1 * F2
figure,bode(Ga1)


%bisogna recuperare circa 55 gradi
%inseriamo due reti da 3

md = 3
xd = 1.7 %radice di 3
taud = xd / wcd
Rd = (1+taud*s)/(1+taud/md*s)

Ga2 = Ga1 * Rd^2

[m,f] = bode(Ga2,wcd)

%inseriamo una rete attenuatrice di 2.9
mi = 2.5
figure,bode((1+s/mi)/(1+s))
xi = 60
taui = xi / wcd
Ri = (1+taui/mi*s) / (s*taui+1)
Ga3 = Ga2 * Ri

figure,margin(Ga3)

C = Kc * Rd^2 * Ri;
W = feedback(C*F1*F2,1/Kr)
figure,step(W)
figure,bode(W)