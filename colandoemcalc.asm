; ==============================================================================
; JOGO: PROVA DE CÁLCULO - HARDCORE (0.15s LOOK TIME)
; ==============================================================================

jmp start_program

; --- VARIÁVEIS ---
Level: var #1           
TestCounter: var #1     
HideTimer: var #1       
ReactionTime: var #1    
TempTimer: var #1       

; --- CONSTANTES ---
SPACE_KEY: var #1
static SPACE_KEY, #32

; Limite de Ansiedade (Aprox. 2s)
HIDE_LIMIT: var #1
static HIDE_LIMIT, #40000 

; --- STRINGS ---
str_c1_1: string "Um belo aluno do BSI seguiu para"
str_c1_2: string "o 2 semestre achando que ia ser"
str_c1_3: string "o curso mais coxa da USP."

str_c2_1: string "Entretanto, um vilao maligno,"
str_c2_2: string "chamado de Professor P,"
str_c2_3: string "veio ensinar calculo"
str_c2_4: string "e estragou seus planos."

str_c3_1: string "Esse aluno agora sofre de"
str_c3_2: string "ansiedade e, caso pense na"
str_c3_3: string "prova antes dela acontecer,"
str_c3_4: string "ele e obrigado a refaze-la."
str_psiquiatra: string "PSIQUIATRA"

str_c4_1: string "Reprovar nao e uma opcao."
str_c4_2: string "Entao, o aluno nao pode"
str_c4_3: string "ser pego colando."

str_nivel:   string "NIVEL:"
str_quest:   string "QUESTAO:"
str_barra:   string "/3"
str_limites: string "LIMITES"
str_p1: string "P1 "
str_p2: string "P2 "
str_p3: string "P3 "
str_rec: string "REC"

str_msg_l1: string "Se prepare para a prova de calculo!"
str_msg_l2_a: string "Ah, estava muito facil ne?"
str_msg_l2_b: string "Esta na hora de DERIVAR!"
str_msg_l3_a: string "A partir daqui e trivial..."
str_msg_l3_b: string "E so INTEGRAR!"
str_msg_l4_a: string "Achou que a REC ia ser MOLEZA?"
str_msg_l4_b: string "ACHOU ERRADO!"

str_3: string "3..."
str_2: string "2..."
str_1: string "1..."
str_go: string "JA!!!"
str_win:     string "APROVADO! DIPLOMA NA MAO!"
str_lose:    string "FOI PEGO COLANDO! REPROVADO!"
str_early:   string "CRISE DE ANSIEDADE! (SEGURE MENOS)"
str_retry:   string "APERTE ESPACO PARA REFAZER"

; ==============================================================================
; INICIALIZAÇÃO
; ==============================================================================
start_program:
    loadn r0, #1
    store Level, r0
    loadn r0, #0
    store TestCounter, r0
    jmp intro_sequence

; ==============================================================================
; INTRODUÇÃO (CINEMÁTICA)
; ==============================================================================
intro_sequence:
    ; --- CENA 1 ---
    call ClearScreen
    loadn r0, #0
    loadn r1, #str_c1_1
    loadn r2, #3840 ; Branco
    call PrintStringColor
    loadn r0, #40
    loadn r1, #str_c1_2
    call PrintStringColor
    loadn r0, #80
    loadn r1, #str_c1_3
    call PrintStringColor
    
    call DrawSceneIntro
    call Delay3Sec
    
    ; --- CENA 2 ---
    call ClearScreen
    loadn r0, #0
    loadn r1, #str_c2_1
    loadn r2, #3840
    call PrintStringColor
    loadn r0, #40
    loadn r1, #str_c2_2
    call PrintStringColor
    loadn r0, #80
    loadn r1, #str_c2_3
    call PrintStringColor
    loadn r0, #120
    loadn r1, #str_c2_4
    call PrintStringColor
    
    call DrawSceneIntro
    call Delay3Sec

    ; --- CENA 3 ---
    call ClearScreen
    loadn r0, #0
    loadn r1, #str_c3_1
    loadn r2, #3840
    call PrintStringColor
    loadn r0, #40
    loadn r1, #str_c3_2
    call PrintStringColor
    loadn r0, #80
    loadn r1, #str_c3_3
    call PrintStringColor
    loadn r0, #120
    loadn r1, #str_c3_4
    call PrintStringColor
    
    loadn r0, #605
    call DrawStudentSimple
    loadn r0, #630
    call DrawStudentSimple
    loadn r0, #588
    loadn r1, #str_psiquiatra
    loadn r2, #2816 ; Amarelo
    call PrintStringColor
    call Delay3Sec
    call Delay3Sec

    ; --- CENA 4 ---
    call ClearScreen
    loadn r0, #405
    loadn r1, #str_c4_1
    loadn r2, #2304 ; Vermelho
    call PrintStringColor
    loadn r0, #445
    loadn r1, #str_c4_2
    call PrintStringColor
    loadn r0, #485
    loadn r1, #str_c4_3
    call PrintStringColor
    
    loadn r0, #618
    call DrawProfFullBody
    call DrawLousaFrame
    call DrawLousaLimites
    loadn r0, #602
    call DrawStudentBody_Game 
    
    ; Desenha celular manual
    loadn r0, #643 
    loadn r1, #'8'
    loadn r2, #2816
    add r1, r1, r2
    outchar r1, r0
    
    call Delay3Sec
    call Delay3Sec

    jmp init_game

; ==============================================================================
; INICIO DO JOGO
; ==============================================================================
init_game:
    loadn r0, #1
    store Level, r0

level_start:
    loadn r0, #0
    store TestCounter, r0
    call SetDifficulty
    
    call ShowLevelMessage
    call CountDownSequence

test_loop:
    load r0, TestCounter
    loadn r1, #3
    cmp r0, r1
    jeq level_complete

    call ClearScreen
    call DrawSceneGameFull
    call DrawHUD
    
    ; Reseta Timer de Ansiedade para o Máximo
    load r0, HIDE_LIMIT
    store HideTimer, r0
    call DrawHandCell 

    ; --- FASE 1: VERDE (Seguro) ---
    call DrawTrafficLight_Green
    load r0, ReactionTime
    add r0, r0, r0 
    store TempTimer, r0
    call WaitLoop 

    ; --- FASE 2: AMARELO (Atenção) ---
    call DrawTrafficLight_Yellow
    load r0, ReactionTime
    store TempTimer, r0
    call WaitLoop

    ; --- FASE 3: VERMELHO (Perigo) ---
    call DrawTrafficLight_Red
    call ProfTurnHead_Look 
    
    ; Tensão: Professor olha por 0.15s
    loadn r0, #3000 
    store TempTimer, r0
    
    ; Loop Crítico
    call WaitLoopCheckRed 

    ; --- SUCESSO ---
    call ProfTurnHead_Normal
    
    load r0, TestCounter
    inc r0
    store TestCounter, r0
    
    call DrawTrafficLight_Green
    call DelayShort
    
    jmp test_loop

level_complete:
    load r0, Level
    loadn r1, #4
    cmp r0, r1
    jeq victory_screen
    inc r0
    store Level, r0
    jmp level_start

; ==============================================================================
; LÓGICA DE INPUT
; ==============================================================================

WaitLoop:
    push r0
    push r1
    push r2
    push r3
    
    load r1, SPACE_KEY
    
wl_cycle:
    inchar r2
    cmp r2, r1
    jeq wl_holding
    
wl_release:
    load r3, HIDE_LIMIT
    store HideTimer, r3
    call DrawHandCell
    jmp wl_next

wl_holding:
    load r3, HideTimer
    dec r3
    store HideTimer, r3
    
    loadn r2, #0
    cmp r3, r2
    jeq game_over_early
    
    call DrawHandHidden
    
wl_next:
    load r0, TempTimer
    dec r0
    store TempTimer, r0
    jnz wl_cycle
    
    pop r3
    pop r2
    pop r1
    pop r0
    rts

WaitLoopCheckRed:
    push r0
    push r1
    push r2
    push r3
    
    load r1, SPACE_KEY
    
wlr_cycle:
    inchar r2
    cmp r2, r1
    jeq wlr_holding
    
wlr_release:
    jmp game_over_caught

wlr_holding:
    load r3, HideTimer
    dec r3
    store HideTimer, r3
    
    loadn r2, #0
    cmp r3, r2
    jeq game_over_early 
    
    call DrawHandHidden
    
wlr_next:
    load r0, TempTimer
    dec r0
    store TempTimer, r0
    jnz wlr_cycle
    
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; --- Auxiliares ---
DrawHandCell:
    push r0
    push r1
    push r2
    loadn r0, #643
    loadn r1, #'8'
    loadn r2, #2816
    add r1, r1, r2
    outchar r1, r0
    pop r2
    pop r1
    pop r0
    rts

DrawHandHidden:
    push r0
    push r1
    push r2
    loadn r0, #643
    loadn r1, #92 ; \
    loadn r2, #2816
    add r1, r1, r2
    outchar r1, r0
    pop r2
    pop r1
    pop r0
    rts

; ==============================================================================
; CONFIGURAÇÃO
; ==============================================================================
SetDifficulty:
    push r0
    push r1
    load r0, Level
    loadn r1, #1
    cmp r0, r1
    jne sd_l2
    loadn r1, #250000 
    store ReactionTime, r1
    jmp sd_end
sd_l2:
    loadn r1, #2
    cmp r0, r1
    jne sd_l3
    loadn r1, #150000 
    store ReactionTime, r1
    jmp sd_end
sd_l3:
    loadn r1, #3
    cmp r0, r1
    jne sd_l4
    loadn r1, #90000 
    store ReactionTime, r1
    jmp sd_end
sd_l4:
    loadn r1, #50000 
    store ReactionTime, r1
sd_end:
    pop r1
    pop r0
    rts

ShowLevelMessage:
    call ClearScreen
    load r0, Level
    loadn r1, #1
    cmp r0, r1
    jeq msg_l1
    loadn r1, #2
    cmp r0, r1
    jeq msg_l2
    loadn r1, #3
    cmp r0, r1
    jeq msg_l3
    loadn r1, #4
    cmp r0, r1
    jeq msg_l4
    jmp msg_end
msg_l1:
    loadn r0, #402
    loadn r1, #str_msg_l1
    loadn r2, #3840
    call PrintStringColor
    jmp msg_wait
msg_l2:
    loadn r0, #405
    loadn r1, #str_msg_l2_a
    loadn r2, #2816
    call PrintStringColor
    loadn r0, #445
    loadn r1, #str_msg_l2_b
    call PrintStringColor
    jmp msg_wait
msg_l3:
    loadn r0, #405
    loadn r1, #str_msg_l3_a
    loadn r2, #2816
    call PrintStringColor
    loadn r0, #450
    loadn r1, #str_msg_l3_b
    call PrintStringColor
    jmp msg_wait
msg_l4:
    loadn r0, #405
    loadn r1, #str_msg_l4_a
    loadn r2, #2304 
    call PrintStringColor
    loadn r0, #450
    loadn r1, #str_msg_l4_b
    call PrintStringColor
    jmp msg_wait
msg_wait:
    call Delay3Sec
    call Delay3Sec
msg_end:
    rts

CountDownSequence:
    call ClearScreen
    call DrawSceneNoLight
    call DrawHUD
    
    loadn r0, #538
    loadn r1, #str_3
    loadn r2, #3840
    call PrintStringColor
    call Delay1Sec
    
    loadn r0, #538
    loadn r1, #str_2
    call PrintStringColor
    call Delay1Sec
    
    loadn r0, #538
    loadn r1, #str_1
    call PrintStringColor
    call Delay1Sec
    
    loadn r0, #538
    loadn r1, #str_go
    loadn r2, #512 ; Verde
    call PrintStringColor
    call Delay1Sec
    rts

; ==============================================================================
; DESENHO DE CENAS
; ==============================================================================

DrawSceneIntro:
    call DrawTrafficLight_Clear
    loadn r0, #602
    call DrawStudentBody_Intro 
    loadn r0, #618
    call DrawProfFullBody 
    call DrawLousaFrame
    call DrawLousaLimites 
    rts

DrawSceneNoLight:
    loadn r0, #602
    call DrawStudentBody_Game 
    loadn r0, #618
    call DrawProfFullBody
    call DrawLousaFrame
    call DrawLousaText 
    rts

DrawSceneGameFull:
    call DrawTrafficLight_Off
    loadn r0, #602
    call DrawStudentBody_Game 
    loadn r0, #618
    call DrawProfFullBody
    call DrawLousaFrame
    call DrawLousaText 
    rts

; --- ALUNO INTRO ---
DrawStudentBody_Intro:
    push r0
    push r1
    push r2
    push r3
    loadn r2, #2816 ; Amarelo
    loadn r3, #40
    ; Cabeca
    loadn r1, #'0'
    add r1, r1, r2
    outchar r1, r0
    ; Tronco 1
    push r0
    add r0, r0, r3
    dec r0
    loadn r1, #92 ; \
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #'|'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #'/'
    add r1, r1, r2
    outchar r1, r0
    pop r0
    ; Tronco 2
    push r0
    add r0, r0, r3
    add r0, r0, r3
    loadn r1, #'|'
    add r1, r1, r2
    outchar r1, r0
    pop r0
    ; Pernas
    add r0, r0, r3
    add r0, r0, r3
    add r0, r0, r3
    dec r0
    loadn r1, #'/'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #' '
    outchar r1, r0
    inc r0
    loadn r1, #92 
    add r1, r1, r2
    outchar r1, r0
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; --- ALUNO JOGO ---
DrawStudentBody_Game:
    push r0
    push r1
    push r2
    push r3
    loadn r2, #2816
    loadn r3, #40
    ; Cabeca
    loadn r1, #'0'
    add r1, r1, r2
    outchar r1, r0
    ; Tronco 1
    push r0
    add r0, r0, r3
    dec r0
    loadn r1, #92 
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #'|'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #' '
    outchar r1, r0
    pop r0
    ; Tronco 2
    push r0
    add r0, r0, r3
    add r0, r0, r3
    loadn r1, #'|'
    add r1, r1, r2
    outchar r1, r0
    pop r0
    ; Mesa Topo
    add r0, r0, r3
    add r0, r0, r3
    add r0, r0, r3
    dec r0 
    loadn r1, #'-'
    loadn r2, #3840
    add r1, r1, r2
    outchar r1, r0
    inc r0
    outchar r1, r0
    inc r0
    outchar r1, r0
    ; Mesa Pés
    add r0, r0, r3
    dec r0
    dec r0
    loadn r1, #'|'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    inc r0
    outchar r1, r0
    pop r3
    pop r2
    pop r1
    pop r0
    rts

DrawStudentSimple:
    call DrawStudentBody_Intro
    rts

; --- PROFESSOR ---
DrawProfFullBody:
    push r0
    push r1
    push r2
    push r3
    loadn r2, #2304 ; Vermelho
    loadn r3, #40
    call ProfTurnHead_Normal
    push r0
    add r0, r0, r3
    dec r0
    loadn r1, #'/'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #'|'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #92
    add r1, r1, r2
    outchar r1, r0
    pop r0
    push r0
    add r0, r0, r3
    add r0, r0, r3
    loadn r1, #'|'
    add r1, r1, r2
    outchar r1, r0
    pop r0
    add r0, r0, r3
    add r0, r0, r3
    add r0, r0, r3
    dec r0
    loadn r1, #'/'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #' '
    outchar r1, r0
    inc r0
    loadn r1, #92
    add r1, r1, r2
    outchar r1, r0
    pop r3
    pop r2
    pop r1
    pop r0
    rts

ProfTurnHead_Look:
    push r0
    push r1
    push r2
    loadn r0, #618
    loadn r2, #2304 
    dec r0
    loadn r1, #'-'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #'P'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #' '
    outchar r1, r0
    pop r2
    pop r1
    pop r0
    rts

ProfTurnHead_Normal:
    push r0
    push r1
    push r2
    loadn r0, #618
    loadn r2, #2304
    dec r0
    loadn r1, #' '
    outchar r1, r0
    inc r0
    loadn r1, #'P'
    add r1, r1, r2
    outchar r1, r0
    inc r0
    loadn r1, #'-'
    add r1, r1, r2
    outchar r1, r0
    pop r2
    pop r1
    pop r0
    rts

; --- LOUSA ---
DrawLousaFrame:
    push r0
    push r1
    push r2
    loadn r2, #3840 ; Branco
    loadn r0, #625
    loadn r1, #'-'
    add r1, r1, r2
    call Line13
    loadn r0, #665
    loadn r1, #'|'
    add r1, r1, r2
    outchar r1, r0
    loadn r0, #677
    outchar r1, r0
    loadn r0, #705
    outchar r1, r0
    loadn r0, #717
    outchar r1, r0
    loadn r0, #745
    outchar r1, r0
    loadn r0, #757
    outchar r1, r0
    loadn r0, #785
    loadn r1, #'-'
    add r1, r1, r2
    call Line13
    pop r2
    pop r1
    pop r0
    rts

Line13:
    push r3
    loadn r3, #13
l13_loop:
    outchar r1, r0
    inc r0
    dec r3
    jnz l13_loop
    pop r3
    rts

DrawLousaText:
    push r0
    push r1
    push r2
    push r3
    loadn r0, #709 
    load r3, Level
    loadn r1, #1
    cmp r3, r1
    jeq dlt_p1
    loadn r1, #2
    cmp r3, r1
    jeq dlt_p2
    loadn r1, #3
    cmp r3, r1
    jeq dlt_p3
    loadn r1, #4
    cmp r3, r1
    jeq dlt_rec
    jmp dlt_print
dlt_p1: loadn r1, #str_p1 
        jmp dlt_print
dlt_p2: loadn r1, #str_p2
        jmp dlt_print
dlt_p3: loadn r1, #str_p3
        jmp dlt_print
dlt_rec: loadn r1, #str_rec
dlt_print:
    loadn r2, #3840
    call PrintStringColor
    pop r3
    pop r2
    pop r1
    pop r0
    rts

DrawLousaLimites:
    push r0
    push r1
    push r2
    loadn r0, #706 
    loadn r1, #str_limites
    loadn r2, #3840
    call PrintStringColor
    pop r2
    pop r1
    pop r0
    rts

; --- SEMAFORO VERTICAL ---
DrawTrafficLight_Green:
    push r0
    push r1
    push r2
    loadn r0, #458
    loadn r1, #'O'
    loadn r2, #3840
    add r1, r1, r2
    outchar r1, r0
    loadn r0, #498
    outchar r1, r0
    loadn r0, #538
    loadn r1, #'X'
    loadn r2, #512 ; Verde
    add r1, r1, r2
    outchar r1, r0
    pop r2
    pop r1
    pop r0
    rts

DrawTrafficLight_Yellow:
    push r0
    push r1
    push r2
    loadn r0, #458
    loadn r1, #'O'
    loadn r2, #3840
    add r1, r1, r2
    outchar r1, r0
    loadn r0, #498
    loadn r1, #'X'
    loadn r2, #2816 ; Amarelo
    add r1, r1, r2
    outchar r1, r0
    loadn r0, #538
    loadn r1, #'O'
    loadn r2, #3840
    add r1, r1, r2
    outchar r1, r0
    pop r2
    pop r1
    pop r0
    rts

DrawTrafficLight_Red:
    push r0
    push r1
    push r2
    loadn r0, #458
    loadn r1, #'X'
    loadn r2, #2304 ; Vermelho
    add r1, r1, r2
    outchar r1, r0
    loadn r0, #498
    loadn r1, #'O'
    loadn r2, #3840
    add r1, r1, r2
    outchar r1, r0
    loadn r0, #538
    outchar r1, r0
    pop r2
    pop r1
    pop r0
    rts

DrawTrafficLight_Off:
    push r0
    push r1
    push r2
    loadn r1, #'O'
    loadn r2, #3840
    add r1, r1, r2
    loadn r0, #458
    outchar r1, r0
    loadn r0, #498
    outchar r1, r0
    loadn r0, #538
    outchar r1, r0
    pop r2
    pop r1
    pop r0
    rts

DrawTrafficLight_Clear:
    push r0
    push r1
    push r2
    loadn r1, #' '
    loadn r2, #3840
    add r1, r1, r2
    loadn r0, #458
    outchar r1, r0
    loadn r0, #498
    outchar r1, r0
    loadn r0, #538
    outchar r1, r0
    pop r2
    pop r1
    pop r0
    rts

; --- UTILS ---
DrawHUD:
    push r0
    push r1
    push r2
    loadn r0, #10
    loadn r1, #str_nivel
    loadn r2, #3840
    call PrintStringColor
    load r1, Level
    loadn r2, #'0'
    add r1, r1, r2
    loadn r2, #3840
    add r1, r1, r2
    loadn r0, #17
    outchar r1, r0
    loadn r0, #22
    loadn r1, #str_quest
    loadn r2, #3840
    call PrintStringColor
    load r1, TestCounter
    inc r1
    loadn r2, #'0'
    add r1, r1, r2
    loadn r2, #3840
    add r1, r1, r2
    loadn r0, #31
    outchar r1, r0
    inc r0
    loadn r1, #str_barra
    call PrintStringColor
    pop r2
    pop r1
    pop r0
    rts

PrintStringColor:
    push r3
    push r4
    push r5
ps_loop:
    loadi r3, r1
    loadn r4, #0
    cmp r3, r4
    jeq ps_end
    add r3, r3, r2
    outchar r3, r0
    inc r0
    inc r1
    jmp ps_loop
ps_end:
    pop r5
    pop r4
    pop r3
    rts

ClearScreen:
    push r0
    push r1
    push r2
    loadn r0, #0
    loadn r1, #1200
    loadn r2, #' '
cs_loop:
    outchar r2, r0
    inc r0
    cmp r0, r1
    jne cs_loop
    pop r2
    pop r1
    pop r0
    rts

game_over_caught:
    call ClearScreen
    loadn r0, #525
    loadn r1, #str_lose
    loadn r2, #2304
    call PrintStringColor
    jmp wait_restart

game_over_early:
    call ClearScreen
    loadn r0, #525
    loadn r1, #str_early
    loadn r2, #2304
    call PrintStringColor
    jmp wait_restart

victory_screen:
    call ClearScreen
    loadn r0, #525
    loadn r1, #str_win
    loadn r2, #2816 ; Amarelo
    call PrintStringColor
    jmp wait_restart

wait_restart:
    loadn r0, #605
    loadn r1, #str_retry
    loadn r2, #3840
    call PrintStringColor
    call FlushInput
    call WaitSpacePress
    jmp init_game

Delay1Sec:
    push r0
    push r1
    loadn r1, #25
d1_outer:
    loadn r0, #10000
d1_inner:
    dec r0
    jnz d1_inner
    dec r1
    jnz d1_outer
    pop r1
    pop r0
    rts

Delay3Sec:
    call Delay1Sec
    call Delay1Sec
    call Delay1Sec
    rts

DelayShort:
    push r0
    loadn r0, #30000
ds_l:
    dec r0
    jnz ds_l
    pop r0
    rts

FlushInput:
    push r0
    push r1
    loadn r1, #255
fi_l:
    inchar r0
    cmp r0, r1
    jne fi_l
    pop r1
    pop r0
    rts

WaitSpacePress:
    push r0
    push r1
    load r1, SPACE_KEY
wsp_l:
    inchar r0
    cmp r0, r1
    jne wsp_l
    pop r1
    pop r0
    rts