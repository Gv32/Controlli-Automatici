clear all
close all
s = tf('s')

F = 400*(3-s)/((s+1)^2*(s+4)^2*(s+10))

[gm,x,wgm,wx] = margin(F)

N = 20

kpbar = gm
tbar = 2*pi/wgm

Kp = 0.6 * kpbar
Ti = 0.5 * tbar
Td = 0.125 * tbar

Rs = Kp*(1+1/(Ti*s)+(Td*s)/(1+Td*s/N))

Ga = Rs * F
figure,margin(Ga)
W = feedback(Ga,1)


figure,bode(W)
figure,step(W)

damp(W)