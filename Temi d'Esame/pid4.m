clear all
close all
s = tf('s')

F = 2*(s+10)/(s*(s+1)*(s+8)^2)

[mg,x,wmg,y] = margin(F)

Kpbar = mg
Tbar = 2*pi/wmg

Kp = Kpbar * 0.6
Ti = Tbar * 0.5
Td = Tbar * 0.125

N = 10

Pc = -N/Td

Rs = Kp*(1+1/(Ti*s)+Td*s/(1+Td*s/N))

Ga = F * Rs

figure,margin(Ga)

W = feedback(Ga,1)

figure,bode(W)