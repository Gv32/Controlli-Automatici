clear all
close all
s = tf('s')

F = -0.65/(s^3+4*s^2+1.75*s)
A = 9
Tp = 1   %Kr = 1/Tp
d1 = 5.5e-3
d2 = 5.5e-3
d3 = 10e-3

Kf = dcgain(s*F)

%errore inseguimento alla rampa < 0.2
%Kr/Kga < 0.2
%(1/Tp)/(A*F*Kc) < 0.2
Kc1 = (1/Tp)/(A*Kf*0.2*Tp)

%disturbo d1 fa specifica
%disturbo d1 < 6e-4
%d1/(Kc * A * Tp) < 6e-4
Kc2 = d1 / (A * 6e-4 * Tp)

%disturbo d2 < 1.5e-3
%d1 / (Kc * Kf * Tp * A) < 1.5e-3
Kc3 = d2 / (A * Tp * Kf * 1.5e-3)

%si prende il Kc con modulo maggiore, in questo caso Kc1
Kc = -Kc1

%studio del segno di Kc
figure,nyquist(A*F)
%in quanto dal diagramma si vede che tutti i valori stabili sono positivi,
%allora in valore di Kc sarà negativo
Kc = -Kc
Kc = -1.5

%analisi specifiche dinamiche
%tempo di salita < 1
%wb = 3/ts = 3 il tempo di salita viene dato dal testo che è 1
wb = 3
%wcd = 0.63 * wb
wcd = 0.63 * wb
wcd = 1.9

s_hat = 0.30
%Mr = (1+s_hat)/0.9
Mr = (1+s_hat)/0.9
Mr = 1.4
Mr = 3.17   %porto in db
%margine di fase da nichols = 40 gradi
Mff = 60-5*Mr
%margine di fase da formula 44

Ga = Tp * F * A * Kc
figure,bode(Ga)

%due reti anticipatrici
md = 4
xd = 1
taud = xd/wcd
Rd = (s*taud+1)/(s*taud/md+1)
Ga2 = Ga * Rd^2

[m,f] = bode(Ga2,wcd)

%rete attenuatrice
mi = 1.1
bode((1+s/mi)/(1+s))%da questo grafico si vede da dove si stabilizza
xi = 20 %in questo caso si stabilizza a 30 e si perde solo 1.4 di fase
taui = xi/wcd
Ri = (s*taui/mi+1)/(s*taui+1)
Ga3 = Ga2* Ri
figure,margin(Ga3)

C = Kc * Rd^2 * Ri  %Controllore con le reti e Kc
W = feedback(C*F*A,Tp)  
figure,step(W)     %Vediamo la sovraelongazione
figure,bode(W)     %Vediamo la banda passante a -3db per definizione

wb = 3.45
%valutzione parametri
%banda passante 3.45
%picco risonanza 2.38
%errore in retroazione
sens = feedback(1,Ga3) 
umax = bode(-C*sens,30) %30 pulsazione sinusoide

%discretizzazione

t = 2*pi/(20*wb)
t = 0.03

Gazoh=Ga3/(1+s*t/2)
margin(Gazoh)

Cz1 = c2d(C,t,'tustin')
Cz2 = c2d(C,t,'zoh')
Cz3 = c2d(C,t,'match')