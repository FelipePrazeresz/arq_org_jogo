📚 Prova de Cálculo: A Fuga da REC
Um jogo de reflexo e gerenciamento de risco desenvolvido em Assembly.

Você é um aluno do BSI (ou Eng. Comp) enfrentando o temido Professor P. Sua única chance de passar é "consultar" o celular (colar), mas cuidado: se o professor te pegar, é Reprovação imediata. Se você ficar nervoso e esconder o celular cedo demais, terá uma Crise de Ansiedade.

🎮 Como Jogar
Controles
ESPAÇO (Segurar): Esconde o celular (coloca a mão sobre a mesa).

ESPAÇO (Soltar): Usa o celular (necessário para colar, mas perigoso).

Mecânica do Semáforo
O jogo possui um indicador visual acima da lousa:

🟢 VERDE: Seguro. O professor está distraído.

🟡 AMARELO: Atenção. Prepare-se para esconder o celular.

🔴 VERMELHO: PERIGO! O professor olha para a turma. Você DEVE estar segurando ESPAÇO neste momento.

Condições de Derrota (Game Over)
Foi Pego: O professor olhou (Sinal Vermelho) e você não estava segurando espaço.

Ansiedade: Você segurou o espaço por muito tempo durante o sinal Verde ou Amarelo. O aluno entra em pânico e a prova é cancelada.

Progressão
O jogo possui 4 Níveis de dificuldade crescente:

P1: Velocidade Lenta.

P2: Velocidade Média.

P3: Velocidade Rápida.

REC: Velocidade Insana (Sobrevivência).

🛠️ Funcionalidades Técnicas
O jogo foi escrito inteiramente em Assembly para o processador hipotético (Simulador ICMC), operando em 1 MHz. Abaixo estão as principais funções implementadas:

1. Sistema de Renderização (Draw...)
O jogo utiliza renderização de caracteres ASCII com manipulação de cores via memória de vídeo.

DrawStaticScene: Renderiza o cenário base (Mesa, Corpo do Aluno, Lousa) para evitar flickering (piscar da tela).

DrawHandState: Alterna o sprite da mão direita entre '8' (Celular/Amarelo) e '\' (Escondido/Amarelo) baseado no input.

DrawProfFullBody: Desenha o professor completo. A cabeça é dinâmica (ProfTurnHead_Look vs ProfTurnHead_Normal) para indicar a direção do olhar.

DrawLousaText: Atualiza dinamicamente o texto da lousa (P1, P2, P3, REC) dependendo do nível armazenado na memória.

2. Máquina de Estados do Semáforo
O fluxo do jogo é controlado por fases sequenciais dentro do loop principal:

Fase Verde: Define um TempTimer longo. Aguarda input.

Fase Amarela: Define um TempTimer médio. Aguarda input.

Fase Vermelha: Define um TempTimer curto (0.5s), vira o sprite do professor e executa a verificação de colisão/estado.

3. Lógica de Input e Ansiedade (WaitLoop)
Para garantir que o jogo rode a 1 MHz sem travar o teclado, foi implementado um loop de verificação contínua:

Lê o teclado (inchar) a cada ciclo.

Se a tecla ESPAÇO estiver pressionada, decrementa o contador HideTimer (Ansiedade). Se zerar, dispara o Game Over.

Se a tecla estiver solta, reseta o HideTimer para o valor máximo (HIDE_LIMIT).

4. Introdução Cinematográfica (intro_sequence)
Uma sequência roteirizada de 4 cenas que conta a história do aluno antes do jogo começar:

O Sonho: Aluno feliz entrando no curso.

O Vilão: Introdução do Professor P.

O Trauma: Cena no psiquiatra.

A Decisão: "Reprovar não é uma opção".

Utiliza Delay3Sec para controlar o tempo de leitura dos textos.

📂 Estrutura de Memória e Variáveis
O jogo utiliza registradores e endereços de memória para gerenciar o estado global:
Level: Armazena o nível atual (1 a 4).
TestCounter: Conta quantos ciclos de semáforo foram vencidos no nível atual (0 a 3).
HideTimer: "Temporizador decrescente que simula a ""paciência/ansiedade"" ao segurar a tecla."
ReactionTime: Define a duração das fases Verde/Amarelo (diminui conforme o nível aumenta).

🚀 Como Executar
Abra o Simulador ICMC.
Carregue o arquivo .mif gerado a partir do código Assembly (.asm).
Certifique-se de que o clock está ajustado ou simulado para 1 MHz (ou ajuste os delays no código se necessário).
Inicie a simulação.
Mantenha o foco na janela do terminal do simulador para os inputs de teclado.
Desenvolvido para a disciplina de Organização de Computadores.
