% Predicado para definir um bloco com nome, largura e altura
bloco(a, 2, 1).  % bloco 'a' com largura 2 e altura 1
bloco(b, 1, 1).  % bloco 'b' com largura 1 e altura 1
bloco(c, 1, 2).  % bloco 'c' com largura 1 e altura 2

% Predicado para definir a posição de um bloco na mesa
posicao(a, 1, 1).  % bloco 'a' está na posição (1,1) na mesa
posicao(b, 3, 1).  % bloco 'b' está na posição (3,1) na mesa
posicao(c, 1, 3).  % bloco 'c' está na posição (1,3) na mesa

% Predicado para verificar se uma posição na mesa está vazia
posicao_vazia(X, Y) :-
    \+ posicao(_, X, Y).  % Não há nenhum bloco na posição (X,Y) na mesa

% Predicado para verificar se o topo de uma posição na mesa está livre
topo_livre(X, Y, Bloco) :-
    bloco(Bloco, Largura, Altura),  % Obtém as dimensões do bloco
    Y1 is Y - Altura,  % Calcula a posição do topo do bloco
    Y1 > 0,  % Garante que o topo do bloco esteja acima da mesa
    % Verifica se não há nenhum bloco na área ocupada pelo topo do bloco
    \+ posicao(_, X, Y2), Y2 >= Y1, Y2 < Y, X2 is X + 1, X2 =< X + Largura - 1, X2 >= X.

% Predicado para verificar se um bloco está estável sobre outro
estavel(BlocoSuperior, BlocoInferior) :-
    posicao(BlocoSuperior, X1, Y1),
    posicao(BlocoInferior, X2, Y2),
    bloco(BlocoSuperior, Largura1, Altura1),
    bloco(BlocoInferior, Largura2, Altura2),
    CentroMassaX is X2 + (Largura2 - 1) / 2,
    CentroMassaY is Y2 - Altura1,
    % Verifica se o topo do bloco inferior está livre
    topo_livre(X2, Y2, BlocoInferior),
    % Verifica se o centro de massa do bloco superior está sobre o bloco inferior
    CentroMassaX >= X1, CentroMassaX < X1 + Largura1,
    CentroMassaY = Y1.

% Predicado para mover um bloco de uma posição para outra
mover(Bloco, De, Para) :-
    % Verifica se a posição de origem está ocupada pelo bloco a ser movido
    posicao(Bloco, DeX, DeY),
    De = (DeX, DeY),
    % Verifica se a posição de destino está vazia
    posicao_vazia(ParaX, ParaY),
    Para = (ParaX, ParaY),
    % Verifica se o bloco pode ser movido para a posição de destino
    topo_livre(ParaX, ParaY, Bloco),
    % Atualiza a posição do bloco
    retract(posicao(Bloco, DeX, DeY)),
    assertz(posicao(Bloco, ParaX, ParaY)).
