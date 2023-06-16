clear all
close all
s = tf('s')
F = (4*s^2+1200*s+90000)/(s^3+154*s^2+5600*s+20000)

%Controllo soluzione anello chiuso

[Gm,Pm,Wgm,Wpm] = margin(F)

%dato che Gm è infinito non è possibile usare la soluzione ad anello chiuso

%controllo soluzione anello aperto:
figure,step(F)
Kf = 4.5   %valore limite di F preso dal grafico

val = 0.63 * Kf  %2.83

%vedere dove la funzione valre 2.83
%il valore di 2.83 corrisponde a 0.266

tetaf = 0.025 %il valore di time del piede della retta tangente al grafico partendo dal punto più altro pari a 2.83 in questo caso
tauf = 0.266 - 0.025
tauf = 0.24

fup = Kf*exp(-tetaf*s)/(1+tauf*s)

figure,step(fup) %fup approssima F in maniera corretta in quanto sembrano uguali

Kp = 1.2*tauf/(Kf*tetaf)
Ti = 2*tetaf
Td = 0.5*tetaf
N = 10

Rs = Kp*(1+(1/Ti)+(Td/(1+(Td*s/10))))

Ga = F * Rs

figure,margin(Ga)

%margine di fase di 63 gradi come si vede dal grafico

W = feedback(Ga,1)
figure,step(W)

%Picco 17.9%
%Tempo di salita 0.00686