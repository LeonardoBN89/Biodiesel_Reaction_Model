function CI = F99_Conversao (y)

load Dados.mat V N_EtOH

% Converter as concentrações das espécies em número de mols, multiplicando 
% pelo volume (mL):
% O índice "end" se refere à última linha do vetor
CI=zeros(8,11);
for j=1:6
    for k=1:11
        CI(j,k)=y(end,j,k)*(V(1,k)/1000);
    end
end

% Adicionar a quantidade extra de etanol N_EtOH2:
for k=1:11
    CI(5,k)=CI(5,k)+N_EtOH(k);
end

% Converter CI para concentração, dividindo pelo novo volume:
for j=1:6
    for k=1:11
        CI(j,k)=CI(j,k)/(V(2,k)/1000);
    end
end

% Adicionando colunas 7 e 8, de desativação enximática:
for j=7:8
    for k=1:11
        CI(j,k)=y(end,j,k);
    end
end





end