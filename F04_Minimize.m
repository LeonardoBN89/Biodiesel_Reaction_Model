%Função que minimiza a função objetivo:
function [parametros,FO,n,tempo_f] = F04_Minimize(~)

%Limites inferiores e superiores para os parâmetros:
%      A1      A2      A3       A4       A5       A6          
%      Ea1     Ea2     Ea3      Ea4      Ea5      Ea6
%      K1      K2      K3       K4       K5       K6
% lower=[0.00    0.00    0.00     0.00     0.00     0.00 ...
%        0.00    0.00    0.00     0.00     0.00     0.00 ...
%        0.00    0.00    0.00     0.00     0.00     0.00 0 2.7];
lower=.85*[11.63
12.09
14.52
5.13
23.10
14.12
0.06
4.52
0.23
4.79
4.99
3.47
1.20
11.06
10.01
11.59
16.08
22.38
3.7
3.25];
%      A1      A2      A3       A4       A5       A6          
%      Ea1     Ea2     Ea3      Ea4      Ea5      Ea6
%      K1      K2      K3       K4       K5       K6
% upper=[Inf     Inf     Inf      Inf      Inf      Inf ...
%        5       5       5        5        5        5   ...
%        Inf     Inf     Inf      Inf      Inf      Inf Inf 3.5];
upper=1.15*[11.63
12.09
14.52
5.13
23.10
14.12
0.06
4.52
0.23
4.79
4.99
3.47
1.20
11.06
10.01
11.59
16.08
22.38
3.7
3.25];

% Número de parâmetros do modelo:
n=length(lower);

%Inicia a contagem de tempo para a função ga:
tempo_i=tic;

% Opções para a função GA:
% 'display','iter' mostra as iterações no Command Window
% 'PopulationSize' define o número da população
% 'Generations' define o número de gerações (iterações)
% 'UseParallel' usa cálculos paralelos (todos os núcleos do processador)
options=gaoptimset('display','iter','PopulationSize',50,'Generations',10,'UseParallel',true);

% Sintaxe para o GA: x = ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,options)
% 1:     função que contém uma expressão para os Mínimos Quadrados
% 2:     número de parâmetros a serem encontrados
% 3 e 4: sistema de inequação linear, da forma A*x <= b
% 5 e 6: sistema de equação linear, da forma Aeq*x = beq
% 7 e 8: limites inferior e superior para a busca dos parâmetros
% 9:     restrições não-lineares
% 10:    opções

%                            1          2 3  4  5  6    7     7   9    10   
[parametros,FO] = ga(@F03_SolveODE,n,[],[],[],[],lower,upper,[],options);

% Calcula o tempo para o GA finalizar e escreve na Command Window este
% valor:
tempo_f=toc(tempo_i);
fprintf('Tempo GA: %g seconds.\n',tempo_f);
end