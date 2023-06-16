clear all
close all
s = tf('s')
F1 = (1+s/0.1)/((1+s/0.2)*(1+s/10));
F2 = 1/s;
Kr = 1;
d = 1.5;

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

%dobbiamo aggiungere un polo nel controllore per rendere finito l'errore di
%inseguimento alla parabola

%errore di inseguimento alla parabola < 0.16
%Kr/Kga < 0.16
%Kr^2/(Kc*Kf1*Kf2) < 0.16
%Kc > Kr^2 / (0.16*Ff1*Kf2)
Kc = Kr^2 / (0.16*Kf1*Kf2)
Kc = 6.25

%il disturbo è pari a zero a causa del polo aggiunto al controllore

%1)poli a parte reale < 0
%2)Kf1 * Kf2 > 0
%3)Si controlla se esiste un solo attraversamento in 0 db e -180
bode(F1*F2/s) %si aggiunge s a causa del polo aggiunto al controllore

%segno positivi perchè i 3 punti sono rispettati

wb = 4
wcd = 0.63*wb
wcd = 2.5 %approssimo il valore precedente

%sovraelongazione massima < 25%
s_hat = 0.25
%Mr = (1+s_hat)/0.9
Mr = (1+s_hat)/0.9
Mr = 1.4 %assegno il valore per eliminare le cifre decimali

Mr = 2.9 %20log1.4 con calcolatrice per portare in db
Mf = 60-5*Mr
Mf = 46 %assegno il valore per eliminare le cifre decimali

Ga1 = Kc/s * F1 * F2
figure,bode(Ga1)
%ci posizioniamo sul valore pari a wcd e vediamo i gradi, e recuperiamo un
%valore pari a quelli necessari per arrivare a -180 e altri 46 gradi

%decidiamo di recuperare 70 gradi con una rete Pi, può essere usata solo se
%viene aggiunto un polo a zero nel controllore
bode(1+s)   %dal grafico vediamo quanti gradi recuperare
%alla frequenza di 2.75 si recuperano 70 gradi
xz = 2.75
tauz= xz/wcd
Rz = (1+tauz*s)

Ga2 = Ga1 * Rz
[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 5.6
bode((1+s/mi)/(1+s))
xi = 100
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)
Ga3 = Ga2 * Ri
figure,margin(Ga3)

C = Kc/s * Rz * Ri

W = feedback(C * F1 * F2,1/Kr)

figure,step(W)
figure,bode(W)

%valutazione parametri
%tempo di salita 0.64
%picco di risonanza 2.27
%valore massimo del comando applicato dal controllore progettato, quando
%l'ingresso è il gradino unitario e con un polo aggiunto all'origine
Wu = C * feedback(1,Ga3)
figure,step(Wu,0.2)
%il valore è pari al peak response pari a 1.26


%discretizzazione
t = 2*pi/(20*wb)
t = 0.08

Gazoh=Ga3/(1+s*t/2)
margin(Gazoh)

Cz1 = c2d(C,t,'tustin') %sovraelongazione = 1.28
Cz2 = c2d(C,t,'zoh') %sovraelongazione = 1.29
Cz3 = c2d(C,t,'match') %sovraelongazione = 1.28
