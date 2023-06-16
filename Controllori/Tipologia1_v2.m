clear all
close all
s = tf('s');
F1 = 30/(s+15);
F2 = (3*s+3)/(s^3+10*s^2+24*s);
Kr = 1;
d1 = 1;
d2 = 4;

Kf1 = dcgain(F1);
Kf2 = dcgain(s*F2);

%necessiterebbe un polo ma già presente in F2

%errore di inseguimento alla rampa < 0.1
%Kr/Kga < 0.1
%Kr^2 / (Kc * Kf1 * Kf2) < 0.1
%Kc > Kr^2/(0.1 * Kf1 * Kf2)        %guadagno controllore

Kc1 = Kr^2/(0.1 * Kf1 * Kf2)

%effetto del disturbo di < 0.05
%d1 / Kg1 < 0.05
%(dl * Kr) / (Kc * Kf1) < 0.05

Kc2 = (d1 * Kr)/(0.05 * Kf1)

% si sceglie il valore più alto, il terzo errore non si prende in
% considerazione perchè ha un polo nel origine la funzione di prima

Kc = 40


%studio del segno di Kc
%1)Poli a parte reale < 0
%2)Kf1 * Kf2 > 0
%3)Si controlla se esiste un solo attraversamento in 0 db e -180
bode(F1*F2)
%un solo attraversamento in entrambi quindi segno positivo

%analisi specifiche dinamiche


%banda passante circa 20, specifica soddisfatta se 18<cwb<22

wb = 20
wcd = 0.63 * 20
wcd = 13 %assegno il valore per eliminare le cifre decimali


%sovraelongazione massima < 20%
s_hat = 0.20
%Mr = (1+s_hat)/0.9
Mr = (1+s_hat)/0.9
Mr = 1.3 %assegno il valore per eliminare le cifre decimali

%margine di fase = 60-5*Mr(db)
Mr = 2.28 %calcolo il valore di Mr in decibel
Mf = 60-5*Mr %Margine di fase(non si deve arrivare sotto questo valore)
Mf = 49 %assegno il valore per eliminare le cifre decimali

Ga1 = 1/Kr * Kc * F1 * F2
figure,bode(Ga1)

%dato che wcd = 13, abbiamo una fase di -184, quindi bisogna recuperare
%prima 4 gradi e poi salire di un valore pari o superiore a Mf

%decidiamo di recuperare più fase per poi stabilizzare il modulo con una
%rete anticipatrice

%segliamo di prendere due reti da 4 centrate in 0.9
md = 4
xd = 0.9
taud = xd/wcd
Rd = (s*taud+1)/(s*taud/md+1)
Ga2 = Ga1 * Rd^2

[m,f] = bode(Ga2,wcd)

%con questa rete la fase arriva ad un valore di 59 da -180 ma il modulo
%raggiunge il valore di 1.6, in questo caso il modulo deve essere diminuito
%tramite una rete anticipatrice

mi = 1.6
bode((1+s/mi)/(1+s))%da questo grafico si vede da dove si stabilizza
xi = 25 %in questo caso si stabilizza a 30 e si perde solo 1.4 di fase
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)
Ga3 = Ga2* Ri
figure,margin(Ga3)

C = Kc * Rd^2 * Ri  %Controllore con le reti e Kc
W = feedback(C*F1*F2,1/Kr)  
figure,step(W)     %Vediamo la sovraelongazione
figure,bode(W)     %Vediamo la banda passante a -3db per definizione

%se una volta finito il controllore si è sopra la banda passante, conviene
%o ridurre wcd oppure il margine di fase


%parametri aggiuntivi

%faccio figure,step(W) e vedo dopo quanto tempo il grafico interseca per la
%prima volta 
%tempo di salita = 0.15

%Picco di risonanza della risposta in freqenza ---> dal diagramma del
%motulo tramite bode(W) e vedo il valore del peak response, in questo caso
%0.969

%errore di inserimento con segnale di sin(0.2t)
sens = feedback(1,Ga3)
erroresn = bode(sens,0.2)

%discretizazione
t = 2*pi/(20*wb)
t = 0.01

Gazoh=Ga3/(1+s*t/2)
margin(Gazoh)
Cz1 = c2d(C,t,'tustin') %sovraelongazione = 1.14 tempo di salita = 0.14
Cz2 = c2d(C,t,'zoh') %sovraelongazione = 1.214 tempo di salita = 0.1
Cz3 = c2d(C,t,'match') %sovraelongazione = 1.14 tempo di salita = 0.14

