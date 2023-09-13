 %Função que coleta os dados otimizados dos parâmetros e cria um gráfico com
%os pontos e as curvas ajustadas:
function F05_Main
global p_
clc

% Inicia a contagem de tempo total para esta função:
tempo_i=tic;

% Carrega os dados necessários:
load Data.mat TExp Enzima T Dados1 Dados TExp1

% Executa a função F04_Minimizar, que retorna os valores dos parâmetros,
% o valor da função objetivo, o número de parâmetros do modelo e o tempo
% para o cálculo da função GA:
[p_,FO,n_param,Tempo_GA]=F04_Minimize;

%Cálculo do erro médio quadrático para Tri, Di, Mo e Est:
n_pontos=11*13;       % número de pontos experimentais

y_e1=zeros(10,8,11);
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
for i=1:11
    [~, y_e1(:,:,i)] = ode23tb(@(t,y)F02_ODESystem(t,y,T(i),Enzima(i)), TExp1, [Dados1(1,:,i) 1 1], options);
end

% Atualizar as condições iniciais para a próxima EDO:
CI2=F99_Conversion(y_e1);

% Resolvendo a segunda parte do experimento:
% Resolver para três tempos (1440,1441 e 1442), mas só o primeiro ponto interessa
y_e2=zeros(3,8,11);
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
for i=1:11
    [~, y_e2(:,:,i)] = ode23tb(@(t,y)F02_ODESystem(t,y,T(i),Enzima(i)), [1440 1441 1442], CI2(:,i), options);
end
% Remover as duas últimas linhas de y_e2:
y_e2(3,:,:)=[]; y_e2(2,:,:)=[];

% Atualizar as condições iniciais para a próxima EDO:
CI3=F99_Conversion(y_e2);

% Resolvendo a terceira parte do experimento:
% Resolver para três tempos (2880, 2881 e 4320), mas só os extremos importam
y_e3=zeros(3,8,11);
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
for i=1:11
    [~, y_e3(:,:,i)] = ode23tb(@(t,y)F02_ODESystem(t,y,T(i),Enzima(i)), [2880 2881 4320], CI3(:,i), options);
end
% Remover as segunda linha de y3:
y_e3(2,:,:)=[];

% Reunindo as três partes calculadas:
y_e=[y_e1;y_e2;y_e3];

% Cálculo do erro médio quadrático (EMQ)
EMQ_Tri=0; EMQ_Di=0; EMQ_Mo=0; EMQ_Est=0;

for i=1:11 %para os 11 experimentos
    for k=1:13 %para os 13 pontos
    EMQ_Tri=EMQ_Tri   +  (Data(k,1,i)-y_e(k,1,i)).^2/n_pontos;
    EMQ_Di=EMQ_Di     +  (Data(k,2,i)-y_e(k,2,i)).^2/n_pontos;
    EMQ_Mo=EMQ_Mo     +  (Data(k,3,i)-y_e(k,3,i)).^2/n_pontos;
    EMQ_Est=EMQ_Est   +  (Data(k,4,i)-y_e(k,4,i)).^2/n_pontos;
    end
end

% Raiz do eror médio quadrático (REMQ)
REMQ_Tri=sqrt(EMQ_Tri);
REMQ_Di= sqrt(EMQ_Di);
REMQ_Mo= sqrt(EMQ_Mo);
REMQ_Est=sqrt(EMQ_Est);

% Cálculo do Akaike:
AIC=n_pontos*log(FO/n_pontos)+2*n_param;
AICc=AIC+2*n_param*(n_param+1) / (n_pontos-n_param-1);





% Vetor de tempo especial para gerar gráficos:
TGraf1=0:15:1440; n=length(TGraf1);
TGraf2=1440:15:2880;
TGraf3=2880:15:4320;

y_g1=zeros(n,8,11);
for i=1:11
    [~, y_g1(:,:,i)] = ode23tb(@(t,y)F02_ODESystem(t,y,T(i),Enzima(i)), TGraf1, [Dados(1,:,i) 1 1], options);
end

% Atualizar as condições iniciais para a próxima EDO:
CI2=F99_Conversion(y_g1);

% Resolvendo a segunda parte do experimento:
y_g2=zeros(n,8,11);
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
for i=1:11
    [~, y_g2(:,:,i)] = ode23tb(@(t,y)F02_ODESystem(t,y,T(i),Enzima(i)), TGraf2, CI2(:,i), options);
end

% Atualizar as condições iniciais para a próxima EDO:
CI3=F99_Conversion(y_g2);


% Resolvendo a terceira parte do experimento:
y_g3=zeros(n,8,11);
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
for i=1:11
    [~, y_g3(:,:,i)] = ode23tb(@(t,y)F02_ODESystem(t,y,T(i),Enzima(i)), TGraf3, CI3(:,i), options);
end

y_g=[y_g1;y_g2;y_g3];
TGraf=[TGraf1,TGraf2,TGraf3];

% Gravar o dados no Excel: usa uma função atualizada chamada xlswrite1,
% que é mais rápida que a função original.

% Calcular tempo decorrido:
gravar_i=tic;

p_=p_';
fileName='Resultados.xlsx';
fileName_template='Modelo.xlsx';
copyfile(fileName_template,fileName)

%Dados 01
xlswrite1(fileName, TGraf','Exp01','B3');
xlswrite1(fileName, y_g(:,:,1),'Exp01','C3');
%Dados 02
xlswrite1(fileName, TGraf','Exp02','B3');
xlswrite1(fileName, y_g(:,:,2),'Exp02','C3');
%Dados 03
xlswrite1(fileName, TGraf','Exp03','B3');
xlswrite1(fileName, y_g(:,:,3),'Exp03','C3');
%Dados 04
xlswrite1(fileName, TGraf','Exp04','B3');
xlswrite1(fileName, y_g(:,:,4),'Exp04','C3');
%Dados 05
xlswrite1(fileName, TGraf','Exp05','B3');
xlswrite1(fileName, y_g(:,:,5),'Exp05','C3');
%Dados 06
xlswrite1(fileName, TGraf','Exp06','B3');
xlswrite1(fileName, y_g(:,:,6),'Exp06','C3');
%Dados 07
xlswrite1(fileName, TGraf','Exp07','B3');
xlswrite1(fileName, y_g(:,:,7),'Exp07','C3');
%Dados 08
xlswrite1(fileName, TGraf','Exp08','B3');
xlswrite1(fileName, y_g(:,:,8),'Exp08','C3');
%Dados 09
xlswrite1(fileName, TGraf','Exp09','B3');
xlswrite1(fileName, y_g(:,:,9),'Exp09','C3');
%Dados 10
xlswrite1(fileName, TGraf','Exp10','B3');
xlswrite1(fileName, y_g(:,:,10),'Exp10','C3');
%Dados 11
xlswrite1(fileName, TGraf','Exp11','B3');
xlswrite1(fileName, y_g(:,:,11),'Exp11','C3');
% Parâmetros
xlswrite1(fileName, p_(1:6),'Dados Gerais','D3');
xlswrite1(fileName, p_(7:12),'Dados Gerais','G3');
xlswrite1(fileName, p_(13:18),'Dados Gerais','D10');
xlswrite1(fileName, p_,'Dados Gerais','Q3');
% Erro médio quadrático
xlswrite1(fileName, EMQ_Tri,'Dados Gerais','K3');
xlswrite1(fileName, EMQ_Di,'Dados Gerais','K4');
xlswrite1(fileName, EMQ_Mo,'Dados Gerais','K5');
xlswrite1(fileName, EMQ_Est,'Dados Gerais','K6')
% Raiz do erro médio quadrático
xlswrite1(fileName, REMQ_Tri,'Dados Gerais','N3');
xlswrite1(fileName, REMQ_Di,'Dados Gerais','N4');
xlswrite1(fileName, REMQ_Mo,'Dados Gerais','N5');
xlswrite1(fileName, REMQ_Est,'Dados Gerais','N6');
% Função objetivo e Akaike
xlswrite1(fileName, FO,'Dados Gerais','K8');
xlswrite1(fileName, AIC,'Dados Gerais','K10');
xlswrite1(fileName, AICc,'Dados Gerais','K11');

gravar_xlsx=toc(gravar_i);
fprintf('Tempo XLSX: %g seconds.\n',gravar_xlsx);


%Gráfico das curvas e pontos, para os 11 experimentos:
grafico_i=tic;
figure;
set(gcf, 'Position', get(0,'Screensize')); %maximizar a figura

%Gráfico Experimentos 1 até 6:
for i=1:6
subplot(2,3,i);
% Curvas ajustadas:
plot(TGraf1,y_g1(:,1,i),'r', TGraf1,y_g1(:,2,i),'k', TGraf1,y_g1(:,3,i),'b',TGraf1,y_g1(:,4,i),'m','linewidth',2)
hold on
plot(TGraf2,y_g2(:,1,i),'r', TGraf2,y_g2(:,2,i),'k', TGraf2,y_g2(:,3,i),'b',TGraf2,y_g2(:,4,i),'m','linewidth',2)
plot(TGraf3,y_g3(:,1,i),'r', TGraf3,y_g3(:,2,i),'k', TGraf3,y_g3(:,3,i),'b',TGraf3,y_g3(:,4,i),'m','linewidth',2)
legend('Tri','Di','Mo','Est','Location','north','Orientation','horizontal')
hold on
%Gráfico dos pontos:
plot(TExp,Dados(:,1,i),'ro',  TExp,Dados(:,2,i),'ks',  TExp,Dados(:,3,i),'bd',  TExp,Dados(:,4,i),'mv',  'markersize',10,'linewidth',2)
%Legendas e textos:
xlabel('Tempo (min)', 'fontsize',16);
ylabel('Concentração (mol L^{-1})', 'fontsize',16);
title(['Experimento ',num2str(i)],'fontsize',16);
set(gca,'XTick',(0:720:4320),'YTick',(0:0.15:1.5));
axis([0 4320 0 1.5])
end



figure;
set(gcf, 'Position', get(0,'Screensize')); %maximizar a figura

%Gráfico Experimentos 7 até 11:
for i=1:5
subplot(2,3,i);
% Curvas ajustadas:
plot(TGraf1,y_g1(:,1,i+6),'r', TGraf1,y_g1(:,2,i+6),'k', TGraf1,y_g1(:,3,i+6),'b',TGraf1,y_g1(:,4,i+6),'m','linewidth',2)
hold on
plot(TGraf2,y_g2(:,1,i+6),'r', TGraf2,y_g2(:,2,i+6),'k', TGraf2,y_g2(:,3,i+6),'b',TGraf2,y_g2(:,4,i+6),'m','linewidth',2)
plot(TGraf3,y_g3(:,1,i+6),'r', TGraf3,y_g3(:,2,i+6),'k', TGraf3,y_g3(:,3,i+6),'b',TGraf3,y_g3(:,4,i+6),'m','linewidth',2)
legend('Tri','Di','Mo','Est','Location','north','Orientation','horizontal')
hold on
%Gráfico dos pontos:
plot(TExp,Dados(:,1,i+6),'ro',  TExp,Dados(:,2,i+6),'ks',  TExp,Dados(:,3,i+6),'bd',  TExp,Dados(:,4,i+6),'mv',  'markersize',10,'linewidth',2)
%Legendas e textos:
xlabel('Tempo (min)', 'fontsize',16);
ylabel('Concentração (mol L^{-1})', 'fontsize',16);
title(['Experimento ',num2str(i+6)],'fontsize',16);
set(gca,'XTick',(0:720:4320),'YTick',(0:0.15:1.5));
axis([0 4320 0 1.5])
end

text(5000,1.00,['A1 = ', num2str(p_(1)),'     Ea1 = ', num2str(10000*p_(7))],'fontsize',10); 
text(5000,0.95,['A2 = ', num2str(p_(2)),'      Ea2 = ', num2str(10000*p_(8))],'fontsize',10); 
text(5000,0.90,['A3 = ', num2str(p_(3)),'      Ea3 = ', num2str(10000*p_(9))],'fontsize',10); 
text(5000,0.85,['A4 = ', num2str(p_(4)),'      Ea4 = ', num2str(10000*p_(10))],'fontsize',10); 
text(5000,0.80,['A5 = ', num2str(p_(5)),'      Ea5 = ', num2str(10000*p_(11))],'fontsize',10); 
text(5000,0.75,['A6 = ', num2str(p_(6)),'      Ea6 = ', num2str(10000*p_(12))],'fontsize',10); 

text(5000,0.65,['K1 = ', num2str(p_(13)),'      K2 = ', num2str(p_(14))],'fontsize',10); 
text(5000,0.60,['K3 = ', num2str(p_(15)),'      K4 = ', num2str(p_(16))],'fontsize',10); 
text(5000,0.55,['K5 = ', num2str(p_(17)),'      K6 = ', num2str(p_(18))],'fontsize',10); 
text(5000,0.50,['ai = ', num2str(p_(19)),'      Eai = ', num2str(p_(20))],'fontsize',10); 

text(5000,0.45, ['REMQ Tri = ',num2str(REMQ_Tri),'mol/L       REMQ Di  = ' ,num2str(REMQ_Di),  'mol/L'],'fontsize',10);
text(5000,0.40, ['REMQ Mo = ',num2str(REMQ_Mo) ,'mol/L        REMQ Est = ',num2str(REMQ_Est),'mol/L'],'fontsize',10);
text(5000,0.35,['AIC     = ',num2str(AIC)     ,'            AICc =     '    ,num2str(AICc)],'fontsize',10);

text(5000,0.25,['a_et = ',num2str(y_g1(end,7,1)),'       a_T  = ' ,num2str(y_g1(end,8,1))],'fontsize',10);
text(5000,0.20,['a_et = ',num2str(y_g1(end,7,2)),'       a_T  = ' ,num2str(y_g1(end,8,2))],'fontsize',10);
text(5000,0.15,['a_et = ',num2str(y_g1(end,7,9)),'       a_T  = ' ,num2str(y_g1(end,8,9))],'fontsize',10);

hold off

grafico_f=toc(grafico_i);
fprintf('Tempo Gráficos: %g seconds.\n',grafico_f);

tempo_f=toc(tempo_i);
fprintf('Tempo Total: %g seconds.\n',tempo_f);

% Gravar os tempos:
xlswrite1(fileName, Tempo_GA,'Dados Gerais','K13');
xlswrite1(fileName, gravar_xlsx,'Dados Gerais','K14');
xlswrite1(fileName, grafico_f,'Dados Gerais','K15');
xlswrite1(fileName, tempo_f,'Dados Gerais','K16');

% Salvar no diretório as onze imagens;
% figura=zeros(11);
% for i=1:11
% figura(i)=figure('visible','off');
% plot(TGraf,y_g(:,1,i),'r', TGraf,y_g(:,2,i),'k', TGraf,y_g(:,3,i),'b',TGraf,y_g(:,4,i),'m','linewidth',2)
% legend('Tri','Di','Mo','Est','Location','north','Orientation','horizontal')
% hold on
% %Gráfico dos pontos:
% plot(TExp,Dados(:,1,i),'ro',  TExp,Dados(:,2,i),'ks',  TExp,Dados(:,3,i),'bd',  TExp,Dados(:,4,i),'mv',  'markersize',10,'linewidth',2)
% %Legendas e textos:
% axis([TGraf(1) TGraf(end) 0 0.9])
% xlabel('Tempo (min)', 'fontsize',16);
% ylabel('Concentração (mol L^{-1})', 'fontsize',16);
% title(['Experimento',num2str(i)], 'fontsize',16);
% set(gca,'XTick',(0:120:720),'YTick',(0:0.15:0.9),'fontsize',16);
% print(['Experimento',num2str(i)],'-dpng','-r300');
% close(figura(i));
% end

end