clear all
close all
s = tf('s')

F = (3*s+6)/(s^4+6.5*s^3+12*s^2+4.5*s)
N = 10;

%Controllo soluzione anello chiuso

[Gm,Pm,Wgm,Wpm] = margin(F)

%Gm finito quindi ad anello chiuso

%controllo soluzione anello aperto:
figure,step(F)

Kpbar = Gm
Tbar = 2*pi/Wgm

Kp = 0.6 * Kpbar
Ti = 0.5* Tbar
Td = 0.125 * Tbar

Rs = Kp*(1+(1/(Ti*s))+((Td*s)/(1+(Td*s/N))))

Ga = F * Rs

margin (Ga)

W = feedback(Ga,1)

figure,bode(W)
figure,step(W)

%picco di risonana 9.72
%banda passante 2.18