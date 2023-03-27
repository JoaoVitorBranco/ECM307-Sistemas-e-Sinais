%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Nome: João Vitor Choueri Branco
% RA: 21.01075-7
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 1 - Boas práticas
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

pkg load symbolic % Carregando pacote simbólico

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 2 - Definindo variáveis
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DG = 7
Apos = DG
Aneg = -DG
T0 = -DG/2
T1 = DG/2
T2 = 4.5*DG
w = 2*sym(pi)/(T2-T0)

n = linspace(1,20,20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 3 - Definindo funções
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Definindo x(t), quando for sin e cos
syms t
xa = @(n, w, t) cos(n*w*t)
xb = @(n, w, t) sin(n*w*t)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Teste feito para verificar se as funções foram instaciadas corretamente
% tempo = [T0:0.1:T2]
%
%
% figure(1)
% plot(tempo, xa(1,w,tempo), 'LineWidth', 2)
% figure(2)
% plot(tempo, xb(1,w,tempo), 'LineWidth', 2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 4 - Achando os vetores com coeficientes an e bn
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Definindo an(t)
aN = int(Apos*xa(n, w, t), t, T0, T1)+int(Aneg*xa(n, w, t), t, T1, T2);
res_aN = eval(aN)

aD = int(xa(n, w, t).*xa(n, w, t), t, T0, T2);
res_aD = eval(aD)

an_num = res_aN./res_aD

%%% Definindo bn(t)
bN = int(Apos*xb(n, w, t), t, T0, T1)+int(Aneg*xb(n, w, t), t, T1, T2);
res_bN = eval(bN)

bD = int(xb(n, w, t).*xb(n, w, t), t, T0, T2);
res_bD = eval(bD)

bn_num = res_bN./res_bD

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 5 - Calculando o valor médio de ajuste para a aproximação de g(t)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Definindo an(t)
n_var = 0
aN_ajuste = int(Apos*xa(n_var, w, t), t, T0, T1)+int(Aneg*xa(n_var, w, t), t, T1, T2);
aD_ajuste = int(xa(n_var, w, t)*xa(n_var, w, t), t, T0, T2);

an_num_ajuste = aN_ajuste/aD_ajuste

%%% Definindo bn(t)
bN_ajuste = int(Apos*xb(n_var, w, t), t, T0, T1)+int(Aneg*xb(n_var, w, t), t, T1, T2);
bD_ajuste = int(xb(n_var, w, t)*xb(n_var, w, t), t, T0, T2);

bn_num_ajuste = bN_ajuste/bD_ajuste

%%% Achando o valor de ajuste para an_num e bn_num
%%% Como o valor de bn_num_ajuste deu "nan", ele será
% substituído por zero
ajuste_total = double(an_num_ajuste) + 0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 6 - Descobrir aproximação para função g(t): gs(t)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gs = 0;

for i = 1:length(n)

    gs = gs + an_num(i)*xa(n(i), w, t) + bn_num(i)*xb(n(i), w, t);

endfor

tempo = [T0:0.1:T2]

for i = 1:length(tempo)
    t = tempo(i)
    y_arr(i) = eval(gs)
endfor

figure(1);
plot(tempo, y_arr + ajuste_total, "b", 'LineWidth', 2);

hold on;

plot(tempo, Apos*(tempo>=T0 & tempo<=T1) + Aneg*(tempo>=T1 & tempo<T2), "r", 'LineWidth', 2);