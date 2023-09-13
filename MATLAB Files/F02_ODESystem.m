%Sistema de EDOs:
function sistema = F02_ODESystem(~,y,T,Enz)
global p_

% Equações diferenciais:
%   Tri = y(1)    Di = y(2)     Mo = y(3)
%   EE = y(4)     EtOH = y(5)   Gli = y(6)
%   Enz=y(7)      a=y(8)

% Parâmetros cinéticos para R(i):
%   A1 = p_(1)    A2 = p_(2)    A3 = p_(3)
%   A4 = p_(4)    A5 = p_(5)    A6 = p_(6)
       
%   Ea1 = p_(7)   Ea2 = p_(8)   Ea3 = p_(9)
%   Ea4 = p_(10)  Ea5 = p_(11)  Ea6 = p_(12)

% Constantes de equilíbrio K(i):
%   K1=p_(13)     K2=p_(14)     K3=p_(15)
%   K4=p_(16)     K5=p_(17)     K6=p_(18)

% Parâmetros cinéticos da inativação por etanol:
%   Ai=p_(19)     Eai=p_(20)

R=8.314;     % J / (mol K)

R1=p_(1)*exp(-(p_(7)*10000)/(R*T));
R2=p_(2)*exp(-(p_(8)*10000)/(R*T));
R3=p_(3)*exp(-(p_(9)*10000)/(R*T));
R4=p_(4)*exp(-(p_(10)*10000)/(R*T));
R5=p_(5)*exp(-(p_(11)*10000)/(R*T));
R6=p_(6)*exp(-(p_(12)*10000)/(R*T));

Kd=20.635*exp(-29747/(R*T));

% Ki=3.727*exp(-32546/(R*T));
Ki=p_(19)*exp(-(p_(20)*10000)/(R*T));

D = 1 + p_(13)*y(1)*y(5) + p_(14)*y(2)*y(4) + p_(15)*y(2)*y(5) + p_(16)*y(3)*y(4) + p_(17)*y(3)*y(5) + p_(18)*y(6)*y(4);

%Sistema de EDOs:
sistema = [    Enz*y(7)*y(8)*    (-R1*y(1)*y(5) + R2*y(2)*y(4) ) / D
               Enz*y(7)*y(8)*    ( R1*y(1)*y(5) - R2*y(2)*y(4) - R3*y(2)*y(5) + R4*y(3)*y(4) ) / D
               Enz*y(7)*y(8)*    ( R3*y(2)*y(5) - R4*y(3)*y(4) - R5*y(3)*y(5) + R6*y(6)*y(4) ) / D
               Enz*y(7)*y(8)*    ( R1*y(1)*y(5) - R2*y(2)*y(4) + R3*y(2)*y(5) - R4*y(3)*y(4) + R5*y(3)*y(5) - R6*y(6)*y(4) ) / D
               Enz*y(7)*y(8)*    (-R1*y(1)*y(5) + R2*y(2)*y(4) - R3*y(2)*y(5) + R4*y(3)*y(4) - R5*y(3)*y(5) + R6*y(6)*y(4) ) / D
               Enz*y(7)*y(8)*    ( R5*y(3)*y(5) - R6*y(6)*y(4)  ) / D
                  -y(7)*y(5)*y(5)*Ki
                  -y(8)*Kd];
end