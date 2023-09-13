%Função de resolve o sistema de EDOs em função dos parâmetros cinéticos
%desconhecidos e introduz a função objetivo LS, que deve ser minimizada:
function LS = F03_SolveODE(par)
global p_ 
p_ =  par;

% Carregar os dados:
load Data.mat TExp1 Enzima T Dados Dados1 Dados2 Dados3

%Resolver o sistema de EDOs, para a primeira parte dos experimentos:
y1=zeros(10,8,11); %10 pontos, 8 equações diferenciais e 11 experimentos
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
for i=1:11
    [~, y1(:,:,i)] = ode23tb(@(t,y)F02_ODESystem(t,y,T(i),Enzima(i)), TExp1, [Dados(1,:,i) 1 1], options);
end

% Atualizar as condições iniciais para a próxima EDO:
CI2=F99_Conversion(y1);

% Resolvendo a segunda parte do experimento:
% Resolver para três tempos (1440,1441 e 1442), mas só o primeiro ponto interessa
y2=zeros(3,8,11);

for i=1:11
    [~, y2(:,:,i)] = ode23tb(@(t,y)F02_ODESystem(t,y,T(i),Enzima(i)), [1440 1441 1442], CI2(:,i), options);
end
% Remover as duas últimas linhas de y2:
y2(3,:,:)=[]; y2(2,:,:)=[];

% Atualizar as condições iniciais para a próxima EDO:
CI3=F99_Conversion(y2);

% Resolvendo a terceira parte do experimento:
% Resolver para três tempos (2880, 2881 e 4320), mas só os extremos importam
y3=zeros(3,8,11);
for i=1:11
    [~, y3(:,:,i)] = ode23tb(@(t,y)F02_ODESystem(t,y,T(i),Enzima(i)), [2880 2881 4320], CI3(:,i), options);
end
% Remover as segunda linha de y3:
y3(2,:,:)=[];


% Mínimos quadrados
% Primeira parte:
LS=0;
for i=1:11 %experimento
    for j=1:4 %espécie
        for k=1:10 %pontos
           LS=LS+  (Dados1(k,j,i)-y1(k,j,i)).^2;
        end
    end
end
% Segunda parte:
for i=1:11 %experimento
    for j=1:4 %espécie
        for k=1 %pontos
           LS=LS+  (Dados2(k,j,i)-y2(k,j,i)).^2;
        end
    end
end
% Terceira parte:
for i=1:11 %experimento
    for j=1:4 %espécie
        for k=1:2 %pontos
           LS=LS+  (Dados3(k,j,i)-y3(k,j,i)).^2;
        end
    end
end

end