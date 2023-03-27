%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 0 - Boas práticas e definição das variáveis
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

pkg load symbolic;

syms T0 t0 t1 t n w0

g = @(t) e^(-t)

N = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 1 - Determinar a potência do sinal g(t)
% utilizando a Equação 2 dada pelo enunciado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Calculando a potência do sinal g(t)
Pg = 1/T0*int(g(t)^2, t, t0, t1)

T0 = 1;
t0 = 0;
t1 = T0 - t0;

val_Pg = eval(Pg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 2 - Faça a ANÁLISE em frequência do sinal
% g(t) determinando o termo Dn utilizando a
% Equação 3 dada pelo enunciado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Fazendo a análise do sinal
Dn = (1/T0)*int(g(t)*e^(-j*n*w0*t), t, t0, t1)

T0 = 1;
t0 = 0;
t1 = T0 - t0;
w0 = 2*pi/T0;
n = [-N:1:N];

arr_Dn = eval(Dn)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 3 - Para verificar a SÍNTESE gs(t) e
% comparar com o sinal original, utilize a 
% Equação 4 dada pelo enunciado, deixando o
% valor de N para que você possa observar a
% influência. Crie um gráfico sobrepondo
% o sinal original g(t) e o sinal sintetizado
% gs(t).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Fazendo a síntese do sinal


gs = 0;

for i = 1:length(n)
    gs = gs + arr_Dn(i)*e^(j*n(i)*w0*t);
endfor

tempo = [t0:0.01:t1*3];



for i = 1:length(tempo)
    t = tempo(i)
    y_arr(i) = eval(gs)
endfor

for i = 1:length(tempo)/3+1
    t = tempo(i)
    g_arr(i) = g(t)
endfor


figure(1);
plot(tempo, y_arr, "b", 'LineWidth', 2), title("Sinal no tempo"), xlabel("Tempo em segundos"), ylabel("Amplitude em Volts");

hold on; 

plot([t0:0.01:t1], g_arr, "r", 'LineWidth', 2);
plot([t1:0.01:t1*2], g_arr, "r", 'LineWidth', 2);
plot([t1*2:0.01:t1*3], g_arr, "r", 'LineWidth', 2);