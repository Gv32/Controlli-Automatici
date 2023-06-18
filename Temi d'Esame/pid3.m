clear all
close all
s = tf('s')

F = 5000/((s+1)^2*(s^2+10*s+25)*(s^2+16*s+100))

[gm,x,wgm,wx] = margin(F)
N = 20
figure,step(F)

Yinf = 2

P = 0.63*Yinf

tauf = 1.6

tetaf = 2.72 - tauf

Fap = Yinf/(1+tauf*s)*exp(-tetaf*s)

hold on
step(Fap)
hold off

Kp = 1.2*tauf/(Yinf*tetaf)
Ti = 2*tetaf
Td = 0.5*tetaf

Rs = Kp*(1+1/(Ti*s)+(Td*s)/(1+Td*s/N))

Ga = Rs * F
figure,margin(Ga)
W = feedback(Ga,1)
figure,bode(W)
figure,step(W)