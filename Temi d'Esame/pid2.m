clear all
close all
s=tf('s')

F = 1/((s+1)^2*(s+4)^2*(s^2+14*s+100))

[gm,x,wgm,wx] = margin(F)

N = 20
Kpbar = gm
Tbar = 2*pi/wgm

Kp = 0.6 * Kpbar
Ti = 0.5 * Tbar
Td = 0.125 * Tbar

Rs = Kp*(1+1/(Ti*s)+(Td*s)/(1+Td*s/N))

Ga = F * Rs

W = feedback(Ga,1)

figure,margin(Ga)

figure,step(W)
figure,bode(W)