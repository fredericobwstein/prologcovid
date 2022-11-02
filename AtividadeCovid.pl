:- dynamic formulario/3.

formulario :- carrega('./formulario.bd'),
    format('~n*** Formulario de Triagem ***~n~n'),
    repeat,
    nome(Paciente),
    temperatura(Paciente),
    frequenciaCardiaca(Paciente),
    frequenciaResp(Paciente),
    pressaoSisto(Paciente),
    sa02(Paciente),
    dispneia(Paciente),
    idade(Paciente),
    comorbidade(Paciente),
    responde(Paciente),
    salva(formulario,'./formulario.bd').

carrega(Arquivo) :-
    exists_file(Arquivo),
    consult(Arquivo)
    ;
    true.

%===== Perguntas ======= %
nome(Paciente) :-
    format('~nNome do paciente: '),
    gets(Paciente).

temperatura(Paciente) :-
    format('~nTemperatura: '),
    gets(Temp),
    asserta(formulario(Paciente,temperatura,Temp)).

frequenciaCardiaca(Paciente) :-
    format('~nFrequencia cardiaca: '),
    gets(FreCard),
    asserta(formulario(Paciente,frequenciaCardiaca,FreCard)).

frequenciaResp(Paciente) :-
    format('~nFrequencia respiratoria: '),
    gets(FreResp),
    asserta(formulario(Paciente,frequenciaResp,FreResp)).

pressaoSisto(Paciente) :-
    format('~npressao arterial: '),
    gets(PreSis),
    asserta(formulario(Paciente,pressaoSisto,PreSis)).

sa02(Paciente) :-
    format('~nQual a sa02acao do oxigenio? (Sa02) : '),
    gets(SaO2),
    asserta(formulario(Paciente,sa02,SaO2)).

dispneia(Paciente) :-
    format('~nPossui dispneia? (sim ou nao) : '),
    gets(Dispn),
    asserta(formulario(Paciente,dispneia,Dispn)).

idade(Paciente) :-
    format('~nIdade: '),
    gets(Idade),
    asserta(formulario(Paciente,idade,Idade)).

comorbidade(Paciente) :-
    format('~nTem comorbidades: '),
    format('~nSe sim digite a quantidade, se nao digite 0 : '),
    gets(Como),
    asserta(formulario(Paciente,comorbidade,Como)).

salva(P,A) :-
    tell(A),
    listing(P),
    told.

gets(String) :-
    read_line_to_codes(user_input,Char),
    name(String,Char).

responde(Paciente) :-
    condicao(Paciente, Char),
    !,
    format('A condicao de ~w e ~w.~n',[Paciente,Char]).


%----------- Condições -----------

%======Muito grave======
condicao(Pct, gravissimo) :-
    formulario(Pct,frequenciaResp,Valor), Valor > 30;
    formulario(Pct,pressaoSisto,Valor), Valor < 90;
    formulario(Pct,sa02,Valor), Valor < 95;
    formulario(Pct,dispneia,Valor), Valor = "sim".

%========Grave========
condicao(Pct, grave) :-
    formulario(Pct,temperatura,Valor), Valor > 39;
    formulario(Pct,pressaoSisto,Valor), Valor >= 90, Valor =< 100;
    formulario(Pct,idade,Valor), Valor >= 80;
    formulario(Pct,comorbidade,Valor), Valor >= 2.

%=====Médio======
condicao(Pct, medio) :-
    formulario(Pct,temperatura,Valor), (Valor < 35; (Valor > 37, Valor =< 39));
    formulario(Pct,frequenciaCardiaca,Valor), Valor >= 100;
    formulario(Pct,frequenciaResp,Valor), Valor >= 19, Valor =< 30;
    formulario(Pct,idade,Valor), Valor >= 60, Valor =< 79;
    formulario(Pct,comorbidade,Valor), Valor = 1.


%=======Leve========
condicao(Pct, leve) :-
    formulario(Pct,temperatura,Valor), Valor >= 35, Valor =< 37;
    formulario(Pct,frequenciaCardiaca,Valor), Valor < 100;
    formulario(Pct,frequenciaResp,Valor), Valor =< 18;
    formulario(Pct,pressaoSisto,Valor), Valor > 100;
    formulario(Pct,sa02,Valor), Valor >= 95;
    formulario(Pct,dispneia,Valor), Valor = "nao";
    formulario(Pct,idade,Valor), Valor < 60;
    formulario(Pct,comorbidade,Valor), Valor = 0.
