clear all
close all
s = tf('s')

F = (4*s^2+1200*s+90000)/(s^3+154*s^2+5600*s+20000)

[gm,x,wgm,y] = margin(F)

%anello aperto

N=10
Yinf = 4.5

x = 0.63*Yinf
step(F)

xy = 0.266

tauf = 0.2
tetaf = 0.266 - tauf

Fap = Yinf*exp(-tetaf*s)/(1+tauf*s)

hold on
step(Fap)
hold off

Kp = 1.2*tauf/(Yinf*tetaf)
Ti = 2*tetaf
Td = 0.5*tetaf

Pc = -N/Td

Rs = Kp*(1+1/(Ti*s)+(Td*s)/(1+Td/N*s))

Ga = F * Rs

figure,margin(Ga)

W = feedback(Ga,1)

figure,step(W)
figure,bode(W)