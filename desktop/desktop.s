        .setcpu "65C02"         ; TODO: Reduce down to 6502

        .include "apple2.inc"
        .include "../inc/apple2.inc"
        .include "../inc/auxmem.inc"
        .include "../inc/prodos.inc"
        .include "../a2d.inc"
        .include "../desktop.inc"

;;; ==================================================
;;; DeskTop - the actual application
;;; ==================================================


;;; AUX memory segment - follows the A2D GUI library

        .org $8E00

        ;; Entry point for "DESKTOP"
        .assert * = DESKTOP, error, "DESKTOP entry point must be at $8E00"

        jmp     DESKTOP_DIRECT

.macro A2D_RELAY2_CALL call, addr
        ldy     #call
        .if .paramcount = 1
        lda     #0
        ldx     #0
        .else
        lda     #<(addr)
        ldx     #>(addr)
        .endif
        jsr     A2D_RELAY2
.endmacro

L8E03:  .byte   $08,$00
L8E05:  .byte   $00
L8E06:  .byte   $00
L8E07:  .byte   $00
L8E08:  .byte   $00
L8E09:  .byte   $00
L8E0A:  .byte   $00
L8E0B:  .byte   $00
L8E0C:  .byte   $00
L8E0D:  .byte   $00
L8E0E:  .byte   $00
L8E0F:  .byte   $00
L8E10:  .byte   $00
L8E11:  .byte   $00
L8E12:  .byte   $00
L8E13:  .byte   $00
L8E14:  .byte   $00
L8E15:  .byte   $00
L8E16:  .byte   $00
L8E17:  .byte   $00
L8E18:  .byte   $00
L8E19:  .byte   $00
L8E1A:  .byte   $00
L8E1B:  .byte   $00
L8E1C:  .byte   $00
L8E1D:  .byte   $00
L8E1E:  .byte   $00
L8E1F:  .byte   $00
L8E20:  .byte   $00
L8E21:  .byte   $00
L8E22:  .byte   $00
L8E23:  .byte   $00
L8E24:  .byte   $00

.proc draw_bitmap_params2
left:   .word   0
top:    .word   0
addr:   .addr   0
stride: .word   0
hoff:   .word   0
voff:   .word   0
width:  .word   0
height: .word   0
.endproc

.proc draw_bitmap_params
left:   .word   0
top:    .word   0
addr:   .addr   0
stride: .word   0
hoff:   .word   0
voff:   .word   0
.endproc

        .byte   $00,$00
L8E43:  .byte   $00,$00

.proc fill_rect_params6
left:   .word   0
top:    .word   0
right:  .word   0
bottom: .word   0
.endproc

.proc measure_text_params
addr:   .addr   text_buffer
length: .byte   0
width:  .word   0
.endproc
set_text_mask_params :=  measure_text_params::width + 1 ; re-used

.proc draw_text_params
addr:   .addr   text_buffer
length: .byte   0
.endproc

text_buffer:
        .res    19, 0

white_pattern2:
        .byte   %11111111
        .byte   %11111111
        .byte   %11111111
        .byte   %11111111
        .byte   %11111111
        .byte   %11111111
        .byte   %11111111
        .byte   %11111111
        .byte   $FF

black_pattern:
        .byte   %00000000
        .byte   %00000000
        .byte   %00000000
        .byte   %00000000
        .byte   %00000000
        .byte   %00000000
        .byte   %00000000
        .byte   %00000000
        .byte   $FF

checkerboard_pattern2:
        .byte   %01010101
        .byte   %10101010
        .byte   %01010101
        .byte   %10101010
        .byte   %01010101
        .byte   %10101010
        .byte   %01010101
        .byte   %10101010
        .byte   $FF

dark_pattern:
        .byte   %00010001
        .byte   %01000100
        .byte   %00010001
        .byte   %01000100
        .byte   %00010001
        .byte   %01000100
        .byte   %00010001
        .byte   %01000100
        .byte   $FF

light_pattern:
        .byte   %11101110
        .byte   %10111011
        .byte   %11101110
        .byte   %10111011
        .byte   %11101110
        .byte   %10111011
        .byte   %11101110
        .byte   %10111011
L8E94:  .byte   $FF

L8E95:
        L8E96 := * + 1
        L8E97 := * + 2
        .res    128, 0

L8F15:  .res    256, 0

L9015:  .byte   $00
L9016:  .byte   $00
L9017:  .byte   $00
L9018:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00

drag_outline_buffer:
        .res    680, 0

L933E:  .byte   $00

.proc query_target_params2
queryx: .word   0
queryy: .word   0
element:.byte   0
id:     .byte   0
.endproc

.proc query_screen_params
left:   .word   0
top:    .word   0
addr:   .addr   A2D_SCREEN_ADDR
stride: .word   A2D_SCREEN_STRIDE
L934D:
hoff:   .word   0
voff:   .word   0
width:  .word   560-1
height: .word   192-1
pattern:.res    8, $FF
mskand: .byte   A2D_DEFAULT_MSKAND
mskor:  .byte   A2D_DEFAULT_MSKOR
xpos:   .word   0
ypos:   .word   0
hthick: .byte   1
vthick: .byte   1
mode:   .byte   $96             ; ???
tmask:  .byte   0
font:   .addr   A2D_DEFAULT_FONT
.endproc

.proc query_state_params
id:     .byte   0
addr:   .addr   set_state_params
.endproc

.proc set_state_params
left:   .word   0
top:    .word   0
addr:   .addr   0
stride: .word   0
hoff:   .word   0
voff:   .word   0
width:  .word   0
height: .word   0
pattern:.res    8, 0
mskand: .byte   0
mskor:  .byte   0
xpos:   .word   0
ypos:   .word   0
hthick: .byte   0
vthick: .byte   0
mode:   .byte   0
tmask:  .byte   0
font:   .addr   0
.endproc

        .byte   $00,$00,$00
        .byte   $00,$FF,$80

        ;; Used for FILL_MODE params
const0a:.byte   0
const1a:.byte   1
const2a:.byte   2
const3a:.byte   3
const4a:.byte   4
        .byte   5, 6, 7

        ;; DESKTOP command jump table
L939E:  .addr   0               ; $00
        .addr   L9419           ; $01
        .addr   L9454           ; $02
        .addr   L94C0           ; $03
        .addr   L9508           ; $04
        .addr   L95A2           ; $05
        .addr   L9692           ; $06
        .addr   L96D2           ; $07
        .addr   L975B           ; $08
        .addr   L977D           ; $09
        .addr   L97F7           ; $0A
        .addr   L9EBE           ; $0B
        .addr   LA2A6           ; $0C REDRAW_ICONS
        .addr   L9EFB           ; $0D
        .addr   L958F           ; $0E

.macro  DESKTOP_DIRECT_CALL    op, addr, label
        jsr DESKTOP_DIRECT
        .byte op
        .addr addr
.endmacro

        ;; DESKTOP entry point (after jump)
DESKTOP_DIRECT:

        ;; Stash return value from stack, adjust by 3
        ;; (command byte, params addr)
        pla
        sta     call_params
        clc
        adc     #<3
        tax
        pla
        sta     call_params+1
        adc     #>3
        pha
        txa
        pha

        ;; Save $06..$09 on the stack
        ldx     #0
:       lda     $06,x
        pha
        inx
        cpx     #4
        bne     :-

        ;; Point ($06) at call command
        lda     call_params
        clc
        adc     #<1
        sta     $06
        lda     call_params+1
        adc     #>1
        sta     $07

        ldy     #0
        lda     ($06),y
        asl     a
        tax
        lda     L939E,x
        sta     dispatch + 1
        lda     L939E+1,x
        sta     dispatch + 2
        iny
        lda     ($06),y
        tax
        iny
        lda     ($06),y
        sta     $07
        stx     $06

dispatch:
        jsr     $0000

        tay
        ldx     #$03
L9409:  pla
        sta     $06,x
        dex
        cpx     #$FF
        bne     L9409
        tya
        rts

call_params:  .addr     0

.proc set_pos_params2
xcoord: .word   0
ycoord: .word   0
.endproc

;;; ==================================================

;;; DESKTOP $01 IMPL

L9419:
        ldy     #$00
        lda     ($06),y
        ldx     L8E95
        beq     L9430
        dex
L9423:  .byte   $DD
        .byte   $96
L9425:  stx     $05F0
        dex
        bpl     L9423
        bmi     L9430
        lda     #$01
        rts

L9430:  jsr     L943E
        jsr     L9F98
        lda     #$01
        tay
        sta     ($06),y
        lda     #$00
        rts

L943E:  ldx     L8E95
        sta     L8E96,x
        inc     L8E95
        asl     a
        tax
        lda     $06
        sta     L8F15,x
        lda     $07
        sta     L8F15+1,x
        rts

;;; ==================================================

;;; DESKTOP $02 IMPL

L9454:  ldx     L8E95
        beq     L9466
        dex
        ldy     #$00
        lda     ($06),y
L945E:  cmp     L8E96,x
        beq     L9469
        dex
        bpl     L945E
L9466:  lda     #$01
        rts

L9469:  asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        ldy     #$01
        lda     ($06),y
        bne     L947E
        lda     #$02
        rts

L947E:  lda     L9015
        beq     L9498
        dey
        lda     ($06),y
        ldx     L9016
        dex
L948A:  cmp     L9017,x
        beq     L9495
        dex
        bpl     L948A
        jmp     L949D

L9495:  lda     #$03
        rts

L9498:  lda     #$01
        sta     L9015
L949D:  ldx     L9016
        ldy     #$00
        lda     ($06),y
        sta     L9017,x
        inc     L9016
        lda     ($06),y
        ldx     #$01
        jsr     LA324
        ldy     #$00
        lda     ($06),y
        ldx     #$01
        jsr     LA2E3
        jsr     L9F9F
        lda     #$00
        rts

;;; ==================================================

;;; DESKTOP $03 IMPL

L94C0:
        ldx     L8E95
        beq     L94D2
        dex
        ldy     #$00
        lda     ($06),y
L94CA:  cmp     L8E96,x
        beq     L94D5
        dex
        bpl     L94CA
L94D2:  lda     #$01
        rts

L94D5:  asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        lda     L9015
        bne     L94E9
        jmp     L9502

L94E9:  ldx     L9016
        dex
        ldy     #$00
        lda     ($06),y
L94F1:  cmp     L9017,x
        beq     L94FC
        dex
        bpl     L94F1
        jmp     L9502

L94FC:  jsr     L9F9F
        lda     #$00
        rts

L9502:  jsr     L9F98
        lda     #$00
        rts

;;; ==================================================

;;; DESKTOP $04 IMPL

L9508:
        ldy     #$00
        ldx     L8E95
        beq     L951A
        dex
        lda     ($06),y
L9512:  cmp     L8E96,x
        beq     L951D
        dex
        bpl     L9512
L951A:  lda     #$01
        rts

L951D:  asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        ldy     #$01
        lda     ($06),y
        bne     L9532
        lda     #$02
        rts

L9532:  jsr     LA18A
        A2D_CALL A2D_SET_FILL_MODE, const0a
        jsr     LA39D
        ldy     #$00
        lda     ($06),y
        ldx     L8E95
        jsr     LA2E3
        dec     L8E95
        lda     #$00
        ldx     L8E95
        sta     L8E96,x
        ldy     #$01
        lda     #$00
        sta     ($06),y
        lda     L9015
        beq     L958C
        ldx     L9016
        dex
        ldy     #$00
        lda     ($06),y
L9566:  cmp     L9017,x
        beq     L9571
        dex
        bpl     L9566
        jmp     L958C

L9571:  ldx     L9016
        jsr     LA324
        dec     L9016
        lda     L9016
        bne     L9584
        lda     #$00
        sta     L9015
L9584:  lda     #$00
        ldx     L9016
        sta     L9017,x
L958C:  lda     #$00
        rts

;;; ==================================================

;;; DESKTOP $0E IMPL

L958F:
        ldy     #$00
        lda     ($06),y
        asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        jmp     LA39D

;;; ==================================================

;;; DESKTOP $05 IMPL

L95A2:
        jmp     L9625

L95A5:
L95A6 := * + 1
        .res    128, 0

L9625:  lda     L9454
        beq     L9639
        lda     L9017
        sta     L95A5
        DESKTOP_DIRECT_CALL $B, $95A5
        jmp     L9625

L9639:  ldx     #$7E
        lda     #$00
L963D:  sta     L95A6,x
        dex
        bpl     L963D
        ldx     #$00
        stx     L95A5
L9648:  lda     L8E96,x
        asl     a
        tay
        lda     L8F15,y
        sta     $08
        lda     L8F15+1,y
        sta     $09
        ldy     #$02
        lda     ($08),y
        and     #$0F
        ldy     #$00
        cmp     ($06),y
        bne     L9670
        ldy     #$00
        lda     ($08),y
        ldy     L95A5
        sta     L95A6,y
        inc     L95A5
L9670:  inx
        cpx     L8E95
        bne     L9648
        ldx     #$00
        txa
        pha
L967A:  lda     L95A6,x
        bne     L9681
        pla
        rts

L9681:  sta     L95A5
        DESKTOP_DIRECT_CALL $2, $95A5
        pla
        tax
        inx
        txa
        pha
        jmp     L967A

;;; ==================================================

;;; DESKTOP $06 IMPL

L9692:
        jmp     L9697

L9695:  .byte   0
L9696:  .byte   0

L9697:  lda     L8E95
        sta     L9696
L969D:  ldx     L9696
        cpx     #$00
        beq     L96CF
        dec     L9696
        dex
        lda     L8E96,x
        sta     L9695
        asl     a
        tax
        lda     L8F15,x
        sta     $08
        lda     L8F15+1,x
        sta     $09
        ldy     #$02
        lda     ($08),y
        and     #$0F
        ldy     #$00
        cmp     ($06),y
        bne     L969D
        DESKTOP_DIRECT_CALL $4, $9695
        jmp     L969D
L96CF:  lda     #$00
        rts

;;; ==================================================

;;; DESKTOP $07 IMPL

L96D2:
        jmp     L96D7

L96D5:  .byte   0
L96D6:  .byte   0

L96D7:  lda     L8E95
        sta     L96D6
L96DD:  ldx     L96D6
        bne     L96E5
        lda     #$00
        rts

L96E5:  dec     L96D6
        dex
        lda     L8E96,x
        sta     L96D5
        asl     a
        tax
        lda     L8F15,x
        sta     $08
        lda     L8F15+1,x
        sta     $09
        ldy     #$02
        lda     ($08),y
        and     #$0F
        ldy     #$00
        cmp     ($06),y
        bne     L96DD
        ldy     #$00
        lda     ($08),y
        ldx     L8E95
        jsr     LA2E3
        dec     L8E95
        lda     #$00
        ldx     L8E95
        sta     L8E96,x
        ldy     #$01
        lda     #$00
        sta     ($08),y
        lda     L9015
        beq     L9758
        ldx     #$00
        ldy     #$00
L972B:  lda     ($08),y
        cmp     L9017,x
        beq     L973B
        inx
        cpx     L9016
        bne     L972B
        jmp     L9758

L973B:  lda     ($08),y
        ldx     L9016
        jsr     LA324
        dec     L9016
        lda     L9016
        bne     L9750
        lda     #$00
        sta     L9015
L9750:  lda     #$00
        ldx     L9016
        sta     L9017,x
L9758:  jmp     L96DD

;;; ==================================================

;;; DESKTOP $08 IMPL

L975B:
        ldx     #$00
        txa
        tay
L975F:  sta     ($06),y
        iny
        inx
        cpx     #$14
        bne     L975F
        ldx     #$00
        ldy     #$00
L976B:  lda     L9017,x
        sta     ($06),y
        cpx     L9016
        beq     L977A
        iny
        inx
        jmp     L976B

L977A:  lda     #$00
        rts

;;; ==================================================

;;; DESKTOP $09 IMPL

L977D:
        jmp     L9789

        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0

L9789:  ldy     #$03
L978B:  lda     ($06),y
        sta     set_pos_params2,y
        dey
        bpl     L978B
        lda     $06
        sta     $08
        lda     $07
        sta     $09
        ldy     #$05
        lda     ($06),y
        sta     L97F5
        A2D_CALL A2D_SET_POS, set_pos_params2
        ldx     #$00
L97AA:  cpx     L8E95
        bne     L97B9
        ldy     #$04
        lda     #$00
        sta     ($08),y
        sta     L97F6
        rts

L97B9:  txa
        pha
        lda     L8E96,x
        asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        ldy     #$02
        lda     ($06),y
        and     #$0F
        cmp     L97F5
        bne     L97E0
        jsr     LA18A
        A2D_CALL $17, L8E03
        bne     L97E6
L97E0:  pla
        tax
        inx
        jmp     L97AA

L97E6:  pla
        tax
        lda     L8E96,x
        ldy     #$04
        sta     ($08),y
        sta     L97F6
        rts

        rts

        .byte   0
L97F5:  .byte   0
L97F6:  .byte   0

;;; ==================================================

;;; DESKTOP $0A IMPL

L97F7:
        ldy     #$00
        lda     ($06),y
        sta     L982A
        tya
        sta     ($06),y
        ldy     #$04
L9803:  lda     ($06),y
        sta     L9C8D,y
        sta     L9C91,y
        dey
        cpy     #$00
        bne     L9803
        jsr     LA365
        lda     L982A
        jsr     L9EB4
        sta     $06
        stx     $07
        ldy     #$02
        lda     ($06),y
        and     #$0F
        sta     L9829
        jmp     L983D

L9829:  .byte   $00
L982A:  .byte   $00,$00
L982C:  .byte   $00
L982D:  .byte   $00
L982E:  .byte   $00
L982F:  .byte   $00
L9830:  .byte   $00
L9831:  .byte   $00
L9832:  .byte   $00
L9833:  .byte   $00
L9834:  .byte   $00
L9835:  .byte   $00,$00,$00,$00,$00,$00,$00,$00

L983D:  lda     #$00
        sta     L9830
        sta     L9833
L9845:  A2D_CALL $2C, L933E
        lda     L933E
        cmp     #$04
        beq     L9857
L9852:  lda     #$02
        jmp     L9C65

L9857:  lda     query_target_params2::queryx
        sec
        sbc     L9C8E
        sta     L982C
        lda     query_target_params2::queryx+1
        sbc     L9C8F
        sta     L982D
        lda     query_target_params2::queryy
        sec
        sbc     L9C90
        sta     L982E
        lda     query_target_params2::queryy+1
        sbc     L9C91
        sta     L982F
        lda     L982D
        bpl     L988C
        lda     L982C
        cmp     #$FB
        bcc     L98AC
        jmp     L9893

L988C:  lda     L982C
        cmp     #$05
        bcs     L98AC
L9893:  lda     L982F
        bpl     L98A2
        lda     L982E
        cmp     #$FB
        bcc     L98AC
        jmp     L9845

L98A2:  lda     L982E
        cmp     #$05
        bcs     L98AC
        jmp     L9845

L98AC:  lda     L9016
        cmp     #$15
        bcc     L98B6
        jmp     L9852

L98B6:  lda     #<drag_outline_buffer
        sta     $08
        lda     #>drag_outline_buffer
        sta     $08+1
        lda     L9015
        bne     L98C8
        lda     #$03
        jmp     L9C65

L98C8:  lda     L9017
        jsr     L9EB4
        sta     $06
        stx     $07
        ldy     #$02
        lda     ($06),y
        and     #$0F
        sta     L9832
        A2D_CALL A2D_QUERY_SCREEN, query_screen_params
        ldx     #$07
L98E3:  lda     query_screen_params::L934D,x
        sta     L9835,x
        dex
        bpl     L98E3
        ldx     L9016
        stx     L9C74
L98F2:  lda     L9016,x
        jsr     L9EB4
        sta     $06
        stx     $07
        ldy     #$00
        lda     ($06),y
        cmp     #$01
        bne     L9909
        ldx     #$80
        stx     L9833
L9909:  sta     L9834
        DESKTOP_DIRECT_CALL $D, $9834
        beq     L9954
        jsr     LA18A
        lda     L9C74
        cmp     L9016
        beq     L9936
        jsr     LA365
        lda     $08
        sec
        sbc     #$22
        sta     $08
        bcs     L992D
        dec     $09
L992D:  ldy     #$01
        lda     #$80
        sta     ($08),y
        jsr     LA382
L9936:  ldx     #$21
        ldy     #$21
L993A:  lda     L8E03,x
        sta     ($08),y
        dey
        dex
        bpl     L993A
        lda     #$08
        ldy     #$00
        sta     ($08),y
        lda     $08
        clc
        adc     #$22
        sta     $08
        bcc     L9954
        inc     $09
L9954:  dec     L9C74
        beq     L995F
        ldx     L9C74
        jmp     L98F2

L995F:  ldx     #$07
L9961:  lda     drag_outline_buffer+2,x
        sta     L9C76,x
        dex
        bpl     L9961
        lda     #<drag_outline_buffer
        sta     $08
        lda     #>drag_outline_buffer
        sta     $08+1
L9972:  ldy     #$02
L9974:  lda     ($08),y
        cmp     L9C76
        iny
        lda     ($08),y
        sbc     L9C77
        bcs     L9990
        lda     ($08),y
        sta     L9C77
        dey
        lda     ($08),y
        sta     L9C76
        iny
        jmp     L99AA

L9990:  dey
        lda     ($08),y
        cmp     L9C7A
        iny
        lda     ($08),y
        sbc     L9C7B
        bcc     L99AA
        lda     ($08),y
        sta     L9C7B
        dey
        lda     ($08),y
        sta     L9C7A
        iny
L99AA:  iny
        lda     ($08),y
        cmp     L9C78
        iny
        lda     ($08),y
        sbc     L9C79
        bcs     L99C7
        lda     ($08),y
        sta     L9C79
        dey
        lda     ($08),y
        sta     L9C78
        iny
        jmp     L99E1

L99C7:  dey
        lda     ($08),y
        cmp     L9C7C
        iny
        lda     ($08),y
        sbc     L9C7D
        bcc     L99E1
        lda     ($08),y
        sta     L9C7D
        dey
        lda     ($08),y
        sta     L9C7C
        iny
L99E1:  iny
        cpy     #$22
        bne     L9974
        ldy     #$01
        lda     ($08),y
        beq     L99FC
        lda     $08
        clc
        adc     #$22
        sta     $08
        lda     $09
        adc     #$00
        sta     $09
        jmp     L9972

L99FC:  A2D_CALL A2D_SET_PATTERN, checkerboard_pattern2
        A2D_CALL A2D_SET_FILL_MODE, const2a
        A2D_CALL A2D_DRAW_POLYGONS, drag_outline_buffer
L9A0E:  A2D_CALL $2C, L933E
        lda     L933E
        cmp     #$04
        beq     L9A1E
        jmp     L9BA5

L9A1E:  ldx     #$03
L9A20:  lda     query_target_params2,x
        cmp     L9C92,x
        bne     L9A31
        dex
        bpl     L9A20
        jsr     L9E14
        jmp     L9A0E

L9A31:  ldx     #$03
L9A33:  lda     query_target_params2,x
        sta     L9C92,x
        dex
        bpl     L9A33
        lda     L9830
        beq     L9A84
        lda     L9831
        sta     query_target_params2::id
        DESKTOP_DIRECT_CALL $9, $933F
        lda     query_target_params2::element
        cmp     L9830
        beq     L9A84
        A2D_CALL A2D_SET_PATTERN, checkerboard_pattern2
        A2D_CALL A2D_SET_FILL_MODE, const2a
        A2D_CALL A2D_DRAW_POLYGONS, drag_outline_buffer
        DESKTOP_DIRECT_CALL $B, $9830
        A2D_CALL A2D_SET_PATTERN, checkerboard_pattern2
        A2D_CALL A2D_SET_FILL_MODE, const2a
        A2D_CALL A2D_DRAW_POLYGONS, drag_outline_buffer
        lda     #$00
        sta     L9830
L9A84:  lda     query_target_params2::queryx
        sec
        sbc     L9C8E
        sta     L9C96
        lda     query_target_params2::queryx+1
        sbc     L9C8F
        sta     L9C97
        lda     query_target_params2::queryy
        sec
        sbc     L9C90
        sta     L9C98
        lda     query_target_params2::queryy+1
        sbc     L9C91
        sta     L9C99
        jsr     L9C9E
        ldx     #$00
L9AAF:  lda     L9C7A,x
        clc
        adc     L9C96,x
        sta     L9C7A,x
        lda     L9C7B,x
        adc     L9C97,x
        sta     L9C7B,x
        lda     L9C76,x
        clc
        adc     L9C96,x
        sta     L9C76,x
        lda     L9C77,x
        adc     L9C97,x
        sta     L9C77,x
        inx
        inx
        cpx     #$04
        bne     L9AAF
        lda     #$00
        sta     L9C75
        lda     L9C77
        bmi     L9AF7
        lda     L9C7A
        cmp     #$30
        lda     L9C7B
        sbc     #$02
        bcs     L9AFE
        jsr     L9DFA
        jmp     L9B0E

L9AF7:  jsr     L9CAA
        bmi     L9B0E
        bpl     L9B03
L9AFE:  jsr     L9CD1
        bmi     L9B0E
L9B03:  jsr     L9DB8
        lda     L9C75
        ora     #$80
        sta     L9C75
L9B0E:  lda     L9C79
        bmi     L9B31
        lda     L9C78
        cmp     #$0D
        lda     L9C79
        sbc     #$00
        bcc     L9B31
        lda     L9C7C
        cmp     #$C0
        lda     L9C7D
        sbc     #$00
        bcs     L9B38
        jsr     L9E07
        jmp     L9B48

L9B31:  jsr     L9D31
        bmi     L9B48
        bpl     L9B3D
L9B38:  jsr     L9D58
        bmi     L9B48
L9B3D:  jsr     L9DD9
        lda     L9C75
        ora     #$40
        sta     L9C75
L9B48:  bit     L9C75
        bpl     L9B52
        .byte   $50
L9B4E:  .byte   $03
        jmp     L9A0E

L9B52:  A2D_CALL A2D_DRAW_POLYGONS, drag_outline_buffer
        lda     #<drag_outline_buffer
        sta     $08
        lda     #>drag_outline_buffer
        sta     $08+1
L9B60:  ldy     #$02
L9B62:  lda     ($08),y
        clc
        adc     L9C96
        sta     ($08),y
        iny
        lda     ($08),y
        adc     L9C97
        sta     ($08),y
        iny
        lda     ($08),y
        clc
        adc     L9C98
        sta     ($08),y
        iny
        lda     ($08),y
        adc     L9C99
        sta     ($08),y
        iny
        cpy     #$22
        bne     L9B62
        ldy     #$01
        lda     ($08),y
        beq     L9B9C
        lda     $08
        clc
        adc     #$22
        sta     $08
        bcc     L9B99
        inc     $09
L9B99:  jmp     L9B60

L9B9C:  A2D_CALL A2D_DRAW_POLYGONS, drag_outline_buffer
        jmp     L9A0E

L9BA5:  A2D_CALL A2D_DRAW_POLYGONS, drag_outline_buffer
        lda     L9830
        beq     L9BB9
        DESKTOP_DIRECT_CALL $B, $9830
        jmp     L9C63

L9BB9:  A2D_CALL A2D_QUERY_TARGET, query_target_params2
        lda     query_target_params2::id
        cmp     L9832
        beq     L9BE1
        bit     L9833
        bmi     L9BDC
        lda     query_target_params2::id
        bne     L9BD4
L9BD1:  jmp     L9852

L9BD4:  ora     #$80
        sta     L9830
        jmp     L9C63

L9BDC:  lda     L9832
        beq     L9BD1
L9BE1:  jsr     LA365
        A2D_CALL A2D_QUERY_SCREEN, query_screen_params
        A2D_CALL A2D_SET_STATE, query_screen_params
        ldx     L9016
L9BF3:  dex
        bmi     L9C18
        txa
        pha
        lda     L9017,x
        asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        jsr     LA18A
        A2D_CALL A2D_SET_FILL_MODE, const0a
        jsr     LA39D
        pla
        tax
        jmp     L9BF3

L9C18:  jsr     LA382
        ldx     L9016
        dex
        txa
        pha
        lda     #<drag_outline_buffer
        sta     $08
        lda     #>drag_outline_buffer
        sta     $09
L9C29:  lda     L9017,x
        asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        ldy     #$02
        lda     ($08),y
        iny
        sta     ($06),y
        lda     ($08),y
        iny
        sta     ($06),y
        lda     ($08),y
        iny
        sta     ($06),y
        lda     ($08),y
        iny
        sta     ($06),y
        pla
        tax
        dex
        bmi     L9C63
        txa
        pha
        lda     $08
        clc
        adc     #$22
        sta     $08
        bcc     L9C60
        inc     $09
L9C60:  jmp     L9C29

L9C63:  lda     #$00
L9C65:  tay
        jsr     LA382
        tya
        tax
        ldy     #$00
        lda     L9830
        sta     ($06),y
        txa
        rts

L9C74:  .byte   $00
L9C75:  .byte   $00
L9C76:  .byte   $00
L9C77:  .byte   $00
L9C78:  .byte   $00
L9C79:  .byte   $00
L9C7A:  .byte   $00
L9C7B:  .byte   $00
L9C7C:  .byte   $00
L9C7D:  .byte   $00
L9C7E:  .byte   $00
L9C7F:  .byte   $00
L9C80:  .byte   $0D
L9C81:  .byte   $00
L9C82:  .byte   $30
L9C83:  .byte   $02
L9C84:  .byte   $C0
L9C85:  .byte   $00
L9C86:  .byte   $00
L9C87:  .byte   $00
L9C88:  .byte   $00
L9C89:  .byte   $00
L9C8A:  .byte   $00
L9C8B:  .byte   $00
L9C8C:  .byte   $00
L9C8D:  .byte   $00
L9C8E:  .byte   $00
L9C8F:  .byte   $00
L9C90:  .byte   $00
L9C91:  .byte   $00
L9C92:  .byte   $00,$00,$00,$00
L9C96:  .byte   $00
L9C97:  .byte   $00
L9C98:  .byte   $00
L9C99:  .byte   $00,$00,$00,$00,$00
L9C9E:  ldx     #$07
L9CA0:  lda     L9C76,x
        sta     L9C86,x
        dex
        bpl     L9CA0
        rts

L9CAA:  lda     L9C76
        cmp     L9C7E
        bne     L9CBD
        lda     L9C77
        cmp     L9C7F
        bne     L9CBD
        lda     #$00
        rts

L9CBD:  lda     #$00
        sec
        sbc     L9C86
        sta     L9C96
        lda     #$00
        sbc     L9C87
        sta     L9C97
        jmp     L9CF5

L9CD1:  lda     L9C7A
        cmp     L9C82
        bne     L9CE4
        lda     L9C7B
        cmp     L9C83
        bne     L9CE4
        lda     #$00
        rts

L9CE4:  lda     #$30
        sec
        sbc     L9C8A
        sta     L9C96
        lda     #$02
        sbc     L9C8B
        sta     L9C97
L9CF5:  lda     L9C86
        clc
        adc     L9C96
        sta     L9C76
        lda     L9C87
        adc     L9C97
        sta     L9C77
        lda     L9C8A
        clc
        adc     L9C96
        sta     L9C7A
        lda     L9C8B
        adc     L9C97
        sta     L9C7B
        lda     L9C8E
        clc
        adc     L9C96
        sta     L9C8E
        lda     L9C8F
        adc     L9C97
        sta     L9C8F
        lda     #$FF
        rts

L9D31:  lda     L9C78
        cmp     L9C80
        bne     L9D44
        lda     L9C79
        cmp     L9C81
        bne     L9D44
        lda     #$00
        rts

L9D44:  lda     #$0D
        sec
        sbc     L9C88
        sta     L9C98
        lda     #$00
        sbc     L9C89
        sta     L9C99
        jmp     L9D7C

L9D58:  lda     L9C7C
        cmp     L9C84
        bne     L9D6B
        lda     L9C7D
        cmp     L9C85
        bne     L9D6B
        lda     #$00
        rts

L9D6B:  lda     #$BF
        sec
        sbc     L9C8C
        sta     L9C98
        lda     #$00
        sbc     L9C8D
        sta     L9C99
L9D7C:  lda     L9C88
        clc
        adc     L9C98
        sta     L9C78
        lda     L9C89
        adc     L9C99
        sta     L9C79
        lda     L9C8C
        clc
        adc     L9C98
        sta     L9C7C
        lda     L9C8D
        adc     L9C99
        sta     L9C7D
        lda     L9C90
        clc
        adc     L9C98
        sta     L9C90
        lda     L9C91
        adc     L9C99
        sta     L9C91
        lda     #$FF
        rts

L9DB8:  lda     L9C86
        sta     L9C76
        lda     L9C87
        sta     L9C77
        lda     L9C8A
        sta     L9C7A
        lda     L9C8B
        sta     L9C7B
        lda     #$00
        sta     L9C96
        sta     L9C97
        rts

L9DD9:  lda     L9C88
        sta     L9C78
        lda     L9C89
        sta     L9C79
        lda     L9C8C
        sta     L9C7C
        lda     L9C8D
        sta     L9C7D
        lda     #$00
        sta     L9C98
        sta     L9C99
        rts

L9DFA:  lda     query_target_params2::queryx+1
        sta     L9C8F
        lda     query_target_params2::queryx
        sta     L9C8E
        rts

L9E07:  lda     query_target_params2::queryy+1
        sta     L9C91
        lda     query_target_params2::queryy
        sta     L9C90
        rts

L9E14:  bit     L9833
        bpl     L9E1A
        rts

L9E1A:  jsr     LA365
L9E1D:  A2D_CALL A2D_QUERY_TARGET, query_target_params2
        lda     query_target_params2::element
        bne     L9E2B
        sta     query_target_params2::id
L9E2B:  DESKTOP_DIRECT_CALL $9, $933F
        lda     query_target_params2::element
        bne     L9E39
        jmp     L9E97

L9E39:  ldx     L9016
        dex
L9E3D:  cmp     L9017,x
        beq     L9E97
        dex
        bpl     L9E3D
        sta     L9EB3
        cmp     #$01
        beq     L9E6A
        asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        ldy     #$02
        lda     ($06),y
        and     #$0F
        sta     L9831
        lda     ($06),y
        and     #$70
        bne     L9E97
        lda     L9EB3
L9E6A:  sta     L9830
        A2D_CALL A2D_SET_PATTERN, checkerboard_pattern2
        A2D_CALL A2D_SET_FILL_MODE, const2a
        A2D_CALL A2D_DRAW_POLYGONS, drag_outline_buffer
        DESKTOP_DIRECT_CALL $2, $9830
        A2D_CALL A2D_SET_PATTERN, checkerboard_pattern2
        A2D_CALL A2D_SET_FILL_MODE, const2a
        A2D_CALL A2D_DRAW_POLYGONS, drag_outline_buffer
L9E97:  A2D_CALL A2D_QUERY_SCREEN, query_screen_params
        A2D_CALL A2D_SET_STATE, query_screen_params
        A2D_CALL A2D_SET_PATTERN, checkerboard_pattern2
        A2D_CALL A2D_SET_FILL_MODE, const2a
        jsr     LA382
        rts

L9EB3:  .byte   0
L9EB4:  asl     a
        tay
        lda     L8F15+1,y
        tax
        lda     L8F15,y
        rts

;;; ==================================================

;;; DESKTOP $08 IMPL

L9EBE:
        jmp     L9EC3

        .byte   0
L9EC2:  .byte   0
L9EC3:  lda     L9015
        bne     L9ECB
        lda     #$01
        rts

L9ECB:  ldx     L9016
        ldy     #$00
        lda     ($06),y
        jsr     LA324
        ldx     L9016
        lda     #$00
        sta     L9016,x
        dec     L9016
        lda     L9016
        bne     L9EEA
        lda     #$00
        sta     L9015
L9EEA:  ldy     #$00
        lda     ($06),y
        sta     L9EC2
        DESKTOP_DIRECT_CALL $3, $9EC2
        lda     #0
        rts

        rts

;;; ==================================================

;;; DESKTOP $0D IMPL

L9EFB:
        jmp     L9F07

L9EFE:  .byte   0
L9EFF:  .byte   0
L9F00:  .byte   0
L9F01:  .byte   0
L9F02:  .byte   0
L9F03:  .byte   0
L9F04:  .byte   0
L9F05:  .byte   0
L9F06:  .byte   0
L9F07:  ldy     #$00
        lda     ($06),y
        sta     L9EFE
        ldy     #$08
L9F10:  lda     ($06),y
        sta     L9EFE,y
        dey
        bne     L9F10
        lda     L9EFE
        asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        jsr     LA18A
        lda     L8E07
        cmp     L9F05
        lda     L8E08
        sbc     L9F06
        bpl     L9F8C
        lda     L8E1B
        cmp     L9F01
        lda     L8E1C
        sbc     L9F02
        bmi     L9F8C
        lda     L8E19
        cmp     L9F03
        lda     L8E1A
        sbc     L9F04
        bpl     L9F8C
        lda     L8E15
        cmp     L9EFF
        lda     L8E16
        sbc     L9F00
        bmi     L9F8C
        lda     L8E23
        cmp     L9F05
        lda     L8E24
        sbc     L9F06
        bmi     L9F8F
        lda     L8E21
        cmp     L9F03
        lda     L8E22
        sbc     L9F04
        bpl     L9F8C
        lda     L8E0D
        cmp     L9EFF
        lda     L8E0E
        sbc     L9F00
        bpl     L9F8F
L9F8C:  lda     #$00
        rts

L9F8F:  lda     #$01
        rts

L9F92:  .byte   0
L9F93:  .byte   0
L9F94:  .byte   0
        .byte   0
        .byte   0
        .byte   0
L9F98:  lda     #$00
        sta     L9F92
        beq     L9FA4
L9F9F:  lda     #$80
        sta     L9F92
L9FA4:  ldy     #$02
        lda     ($06),y
        and     #$0F
        bne     L9FB4
        lda     L9F92
        ora     #$40
        sta     L9F92
L9FB4:  ldy     #$03
L9FB6:  lda     ($06),y
        sta     L8E22,y
        iny
        cpy     #$09
        bne     L9FB6
        jsr     LA365
        lda     draw_bitmap_params2::addr
        sta     $08
        lda     draw_bitmap_params2::addr+1
        sta     $09
        ldy     #$0B
L9FCF:  lda     ($08),y
        sta     draw_bitmap_params2::addr,y
        dey
        bpl     L9FCF
        bit     L9F92
        bpl     L9FDF
        jsr     LA12C
L9FDF:  jsr     LA382
        ldy     #$09
L9FE4:  lda     ($06),y
        sta     fill_rect_params6::bottom,y
        iny
        cpy     #$1D
        bne     L9FE4
L9FEE:  lda     draw_text_params::length
        sta     measure_text_params::length
        A2D_CALL A2D_MEASURE_TEXT, measure_text_params
        lda     measure_text_params::width
        cmp     draw_bitmap_params2::width
        bcs     LA010
        inc     draw_text_params::length
        ldx     draw_text_params::length
        lda     #$20
        sta     text_buffer-1,x
        jmp     L9FEE

LA010:  lsr     a
        sta     set_pos_params2::xcoord+1
        lda     draw_bitmap_params2::width
        lsr     a
        sta     set_pos_params2
        lda     set_pos_params2::xcoord+1
        sec
        sbc     set_pos_params2::xcoord
        sta     set_pos_params2::xcoord
        lda     draw_bitmap_params2::left
        sec
        sbc     set_pos_params2::xcoord
        sta     set_pos_params2::xcoord
        lda     draw_bitmap_params2::left+1
        sbc     #$00
        sta     set_pos_params2::xcoord+1
        lda     draw_bitmap_params2::top
        clc
        adc     draw_bitmap_params2::height
        sta     set_pos_params2::ycoord
        lda     draw_bitmap_params2::top+1
        adc     #$00
        sta     set_pos_params2::ycoord+1
        lda     set_pos_params2::ycoord
        clc
        adc     #$01
        sta     set_pos_params2::ycoord
        lda     set_pos_params2::ycoord+1
        adc     #$00
        sta     set_pos_params2::ycoord+1
        lda     set_pos_params2::ycoord
        clc
        adc     font_height
        sta     set_pos_params2::ycoord
        lda     set_pos_params2::ycoord+1
        adc     #$00
        sta     set_pos_params2::ycoord+1
        ldx     #$03
LA06E:  lda     set_pos_params2,x
        sta     L9F94,x
        dex
        bpl     LA06E
        bit     L9F92
        bvc     LA097
        A2D_CALL A2D_QUERY_SCREEN, query_screen_params
        jsr     LA63F
LA085:  jsr     LA6A3
        jsr     LA097
        lda     L9F93
        bne     LA085
        A2D_CALL A2D_SET_BOX, query_screen_params
        rts

LA097:  A2D_CALL A2D_HIDE_CURSOR, DESKTOP_DIRECT ; These params should be ignored - bogus?
        A2D_CALL A2D_SET_FILL_MODE, const4a
        bit     L9F92
        bpl     LA0C2
        bit     L9F92
        bvc     LA0B6
        A2D_CALL A2D_SET_FILL_MODE, const0a
        jmp     LA0C2

LA0B6:  A2D_CALL A2D_DRAW_BITMAP, draw_bitmap_params
        A2D_CALL A2D_SET_FILL_MODE, const2a
LA0C2:  A2D_CALL A2D_DRAW_BITMAP, draw_bitmap_params2
        ldy     #$02
        lda     ($06),y
        and     #$80
        beq     LA0F2
        jsr     LA14D
        A2D_CALL A2D_SET_PATTERN, dark_pattern
        bit     L9F92
        bmi     LA0E6
        A2D_CALL A2D_SET_FILL_MODE, const3a
        beq     LA0EC
LA0E6:  A2D_CALL A2D_SET_FILL_MODE, const1a
LA0EC:  A2D_CALL A2D_FILL_RECT, fill_rect_params6
LA0F2:  ldx     #$03
LA0F4:  lda     L9F94,x
        sta     set_pos_params2,x
        dex
        bpl     LA0F4
        A2D_CALL A2D_SET_POS, set_pos_params2
        bit     L9F92
        bmi     LA10C
        lda     #$7F
        bne     LA10E
LA10C:  lda     #$00
LA10E:  sta     set_text_mask_params
        A2D_CALL A2D_SET_TEXT_MASK, set_text_mask_params
        lda     text_buffer+1
        and     #$DF
        sta     text_buffer+1
        A2D_CALL A2D_DRAW_TEXT, draw_text_params
        A2D_CALL A2D_SHOW_CURSOR
        rts

LA12C:  ldx     #$0F
LA12E:  lda     draw_bitmap_params2,x
        sta     draw_bitmap_params,x
        dex
        bpl     LA12E
        ldy     L8E43
LA13A:  lda     draw_bitmap_params::stride
        clc
        adc     draw_bitmap_params::addr
        sta     draw_bitmap_params::addr
        bcc     LA149
        inc     draw_bitmap_params::addr+1
LA149:  dey
        bpl     LA13A
        rts

LA14D:  ldx     #$00
LA14F:  lda     draw_bitmap_params2::left,x
        clc
        adc     draw_bitmap_params2::hoff,x
        sta     fill_rect_params6,x
        lda     draw_bitmap_params2::left+1,x
        adc     draw_bitmap_params2::hoff+1,x
        sta     fill_rect_params6::left+1,x
        lda     draw_bitmap_params2::left,x
        clc
        adc     draw_bitmap_params2::width,x
        sta     fill_rect_params6::right,x
        lda     draw_bitmap_params2::left+1,x
        adc     draw_bitmap_params2::width+1,x
        sta     fill_rect_params6::right+1,x
        inx
        inx
        cpx     #$04
        bne     LA14F
        lda     fill_rect_params6::bottom
        sec
        sbc     #$01
        sta     fill_rect_params6::bottom
        bcs     LA189
        dec     fill_rect_params6::bottom+1
LA189:  rts

LA18A:  jsr     LA365
        ldy     #$06
        ldx     #$03
LA191:  lda     ($06),y
        sta     L8E05,x
        dey
        dex
        bpl     LA191
        lda     L8E07
        sta     L8E0B
        lda     L8E08
        sta     L8E0C
        lda     L8E05
        sta     L8E21
        lda     L8E06
        sta     L8E22
        ldy     #$07
        lda     ($06),y
        sta     $08
        iny
        lda     ($06),y
        sta     $09
        ldy     #$08
        lda     ($08),y
        clc
        adc     L8E05
        sta     L8E09
        sta     L8E0D
        iny
        lda     ($08),y
        adc     L8E06
        sta     L8E0A
        sta     L8E0E
        ldy     #$0A
        lda     ($08),y
        clc
        adc     L8E07
        sta     L8E0F
        iny
        lda     ($08),y
        adc     L8E08
        sta     L8E10
        lda     L8E0F
        clc
        adc     #$02
        sta     L8E0F
        sta     L8E13
        sta     L8E1F
        sta     L8E23
        lda     L8E10
        adc     #$00
        sta     L8E10
        sta     L8E14
        sta     L8E20
        sta     L8E24
        lda     font_height
        clc
        adc     L8E0F
        sta     L8E17
        sta     L8E1B
        lda     L8E10
        adc     #$00
        sta     L8E18
        sta     L8E1C
        ldy     #$1C
        ldx     #$13
LA22A:  lda     ($06),y
        sta     text_buffer-1,x
        dey
        dex
        bpl     LA22A
LA233:  lda     draw_text_params::length
        sta     measure_text_params::length
        A2D_CALL A2D_MEASURE_TEXT, measure_text_params
        ldy     #$08
        lda     measure_text_params::width
        cmp     ($08),y
        bcs     LA256
        inc     draw_text_params::length
        ldx     draw_text_params::length
        lda     #$20
        sta     text_buffer-1,x
        jmp     LA233

LA256:  lsr     a
        sta     LA2A5
        lda     ($08),y
        lsr     a
        sta     LA2A4
        lda     LA2A5
        sec
        sbc     LA2A4
        sta     LA2A4
        lda     L8E05
        sec
        sbc     LA2A4
        sta     L8E1D
        sta     L8E19
        lda     L8E06
        sbc     #$00
        sta     L8E1E
        sta     L8E1A
        inc     measure_text_params::width
        inc     measure_text_params::width
        lda     L8E19
        clc
        adc     measure_text_params::width
        sta     L8E11
        sta     L8E15
        lda     L8E1A
        adc     #$00
        sta     L8E12
        sta     L8E16
        jsr     LA382
        rts

LA2A4:  .byte   0
LA2A5:  .byte   0

;;; ==================================================

DESKTOP_REDRAW_ICONS_IMPL:

LA2A6:
        jmp     LA2AE

LA2A9:  .byte   0
LA2AA:  jsr     LA382
        rts

LA2AE:  jsr     LA365
        ldx     L8E95
        dex
LA2B5:  bmi     LA2AA
        txa
        pha
        lda     L8E96,x
        asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        ldy     #$02
        lda     ($06),y
        and     #$0F
        bne     LA2DD
        ldy     #$00
        lda     ($06),y
        sta     LA2A9
        DESKTOP_DIRECT_CALL $3, $A2A9
LA2DD:  pla
        tax
        dex
        jmp     LA2B5

LA2E3:  stx     LA322
        sta     LA323
        ldx     #$00
LA2EB:  lda     L8E96,x
        cmp     LA323
        beq     LA2FA
        inx
        cpx     L8E95
        bne     LA2EB
        rts

LA2FA:  lda     L8E97,x
        sta     L8E96,x
        inx
        cpx     L8E95
        bne     LA2FA
        ldx     L8E95
LA309:  cpx     LA322
        beq     LA318
        lda     L8E94,x
        sta     L8E95,x
        dex
        jmp     LA309

LA318:  ldx     LA322
        lda     LA323
        sta     L8E95,x
        rts

LA322:  .byte   0
LA323:  .byte   0
LA324:  stx     LA363
        sta     LA364
        ldx     #$00
LA32C:  lda     L9017,x
        cmp     LA364
        beq     LA33B
        inx
        cpx     L9016
        bne     LA32C
        rts

LA33B:  lda     L9018,x
        sta     L9017,x
        inx
        cpx     L9016
        bne     LA33B
        ldx     L9016
LA34A:  cpx     LA363
        beq     LA359
        lda     L9015,x
        sta     L9016,x
        dex
        jmp     LA34A

LA359:  ldx     LA363
        lda     LA364
        sta     L9016,x
        rts

LA363:  .byte   0
LA364:  .byte   0
LA365:  pla
        sta     LA380
        pla
        sta     LA381
        ldx     #$00
LA36F:  lda     $06,x
        pha
        inx
        cpx     #$04
        bne     LA36F
        lda     LA381
        pha
        lda     LA380
        pha
        rts

LA380:  .byte   0
LA381:  .byte   0
LA382:  pla
        sta     LA39B
        pla
        sta     LA39C
        ldx     #$03
LA38C:  pla
        sta     $06,x
        dex
        bpl     LA38C
        lda     LA39C
        pha
        lda     LA39B
        pha
        rts

LA39B:  .byte   0
LA39C:  .byte   0
LA39D:  A2D_CALL A2D_QUERY_SCREEN, query_screen_params
        A2D_CALL A2D_SET_STATE, query_screen_params
        jmp     LA3B9

LA3AC:  .byte   0
LA3AD:  .byte   0
LA3AE:  .byte   0
LA3AF:  .byte   0
LA3B0:  .byte   0
LA3B1:  .byte   0
LA3B2:  .byte   0
LA3B3:  .byte   0
        .byte   0
        .byte   0
        .byte   0
LA3B7:  .byte   0
LA3B8:  .byte   0
LA3B9:  ldy     #$00
        lda     ($06),y
        sta     LA3AC
        iny
        iny
        lda     ($06),y
        and     #$0F
        sta     LA3AD
        beq     LA3F4
        lda     #$80
        sta     LA3B7
        A2D_CALL A2D_SET_PATTERN, white_pattern2
        A2D_CALL $41, LA3B8
        lda     LA3B8
        sta     query_state_params
        A2D_CALL A2D_QUERY_STATE, query_state_params
        jsr     LA4CC
        jsr     LA938
        jsr     LA41C
        jmp     LA446

LA3F4:  A2D_CALL A2D_QUERY_SCREEN, query_screen_params
        jsr     LA63F
LA3FD:  jsr     LA6A3
        jsr     LA411
        lda     L9F93
        bne     LA3FD
        A2D_CALL A2D_SET_BOX, query_screen_params
        jmp     LA446

LA411:  lda     #$00
        sta     LA3B7
        A2D_CALL A2D_SET_PATTERN, checkerboard_pattern2
LA41C:  lda     L8E07
        sta     LA3B1
        lda     L8E08
        sta     LA3B2
        lda     L8E1D
        sta     LA3AF
        lda     L8E1E
        sta     LA3B0
        ldx     #$03
LA436:  lda     L8E15,x
        sta     LA3B3,x
        dex
        bpl     LA436
        A2D_CALL $15, L8E03
        rts

LA446:  jsr     LA365
        ldx     L8E95
        dex
LA44D:  cpx     #$FF
        bne     LA466
        bit     LA3B7
        bpl     LA462
        A2D_CALL A2D_QUERY_SCREEN, query_screen_params
        A2D_CALL A2D_SET_STATE, set_state_params
LA462:  jsr     LA382
        rts

LA466:  txa
        pha
        lda     L8E96,x
        cmp     LA3AC
        beq     LA4C5
        asl     a
        tax
        lda     L8F15,x
        sta     $08
        lda     L8F15+1,x
        sta     $09
        ldy     #$02
        lda     ($08),y
        and     #$07
        cmp     LA3AD
        bne     LA4C5
        lda     L9015
        beq     LA49D
        ldy     #$00
        lda     ($08),y
        ldx     #$00
LA492:  cmp     L9017,x
        beq     LA4C5
        inx
        cpx     L9016
        bne     LA492
LA49D:  ldy     #$00
        lda     ($08),y
        sta     LA3AE
        bit     LA3B7
        bpl     LA4AC
        jsr     LA4D3
LA4AC:  DESKTOP_DIRECT_CALL $D, $A3AE
        beq     LA4BA

        DESKTOP_DIRECT_CALL $3, $A3AE

LA4BA:  bit     LA3B7
        bpl     LA4C5
        lda     LA3AE
        jsr     LA4DC
LA4C5:  pla
        tax
        dex
        jmp     LA44D

LA4CB:  .byte   0

LA4CC:  lda     #$80
        sta     LA4CB
        bmi     LA4E2
LA4D3:  pha
        lda     #$40
        sta     LA4CB
        jmp     LA4E2

LA4DC:  pha
        lda     #$00
        sta     LA4CB
LA4E2:  ldy     #$00
LA4E4:  lda     set_state_params,y
        sta     LA567,y
        iny
        cpy     #$04
        bne     LA4E4
        ldy     #$08
LA4F1:  lda     set_state_params,y
        sta     LA567-4,y
        iny
        cpy     #$0C
        bne     LA4F1
        bit     LA4CB
        bmi     LA506
        bvc     LA56F
        jmp     LA5CB

LA506:  ldx     #$00
LA508:  lda     L8E05,x
        sec
        sbc     LA567
        sta     L8E05,x
        lda     L8E06,x
        sbc     LA568
        sta     L8E06,x
        lda     L8E07,x
        sec
        sbc     LA569
        sta     L8E07,x
        lda     L8E08,x
        sbc     LA56A
        sta     L8E08,x
        inx
        inx
        inx
        inx
        cpx     #$20
        bne     LA508
        ldx     #$00
LA538:  lda     L8E05,x
        clc
        adc     LA56B
        sta     L8E05,x
        lda     L8E06,x
        adc     LA56C
        sta     L8E06,x
        lda     L8E07,x
        clc
        adc     LA56D
        sta     L8E07,x
        lda     L8E08,x
        adc     LA56E
        sta     L8E08,x
        inx
        inx
        inx
        inx
        cpx     #$20
        bne     LA538
        rts

LA567:  .byte   0
LA568:  .byte   0
LA569:  .byte   0
LA56A:  .byte   0
LA56B:  .byte   0
LA56C:  .byte   0
LA56D:  .byte   0
LA56E:  .byte   0
LA56F:  pla
        tay
        jsr     LA365
        tya
        asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        ldy     #$03
        lda     ($06),y
        clc
        adc     LA567
        sta     ($06),y
        iny
        lda     ($06),y
        adc     LA568
        sta     ($06),y
        iny
        lda     ($06),y
        clc
        adc     LA569
        sta     ($06),y
        iny
        lda     ($06),y
        adc     LA56A
        sta     ($06),y
        ldy     #$03
        lda     ($06),y
        sec
        sbc     LA56B
        sta     ($06),y
        iny
        lda     ($06),y
        sbc     LA56C
        sta     ($06),y
        iny
        lda     ($06),y
        sec
        sbc     LA56D
        sta     ($06),y
        iny
        lda     ($06),y
        sbc     LA56E
        sta     ($06),y
        jsr     LA382
        rts

LA5CB:  pla
        tay
        jsr     LA365
        tya
        asl     a
        tax
        lda     L8F15,x
        sta     $06
        lda     L8F15+1,x
        sta     $07
        ldy     #$03
        lda     ($06),y
        sec
        sbc     LA567
        sta     ($06),y
        iny
        lda     ($06),y
        sbc     LA568
        sta     ($06),y
        iny
        lda     ($06),y
        sec
        sbc     LA569
        sta     ($06),y
        iny
        lda     ($06),y
        sbc     LA56A
        sta     ($06),y
        ldy     #$03
        lda     ($06),y
        clc
        adc     LA56B
        sta     ($06),y
        iny
        lda     ($06),y
        adc     LA56C
        sta     ($06),y
        iny
        lda     ($06),y
        clc
        adc     LA56D
        sta     ($06),y
        iny
        lda     ($06),y
        adc     LA56E
        sta     ($06),y
        jsr     LA382
        rts

LA627:  .byte   $00
LA628:  .byte   $00
LA629:  .byte   $00
LA62A:  .byte   $00
LA62B:  .byte   $00
LA62C:  .byte   $00,$00,$00

.proc set_box_params2
left:   .word   0
top:    .word   0
addr:   .addr   A2D_SCREEN_ADDR
stride: .word   A2D_SCREEN_STRIDE
hoff:   .word   0
voff:   .word   0
width:  .word   0
height: .word   0
.endproc

LA63F:  jsr     LA18A
        lda     L8E07
        sta     LA629
        sta     set_box_params2::voff
        sta     set_box_params2::top
        lda     L8E08
        sta     LA62A
        sta     set_box_params2::voff+1
        sta     set_box_params2::top+1
        lda     L8E19
        sta     LA627
        sta     set_box_params2::hoff
        sta     set_box_params2::left
        lda     L8E1A
        sta     LA628
        sta     set_box_params2::hoff+1
        sta     set_box_params2::left+1
        ldx     #$03
LA674:  lda     L8E15,x
        sta     LA62B,x
        sta     set_box_params2::width,x
        dex
        bpl     LA674
        lda     LA62B
        cmp     #$2F
        lda     LA62C
        sbc     #$02
        bmi     LA69C
        lda     #$2E
        sta     LA62B
        sta     set_box_params2::width
        lda     #$02
        sta     LA62C
        sta     set_box_params2::width+1
LA69C:  A2D_CALL A2D_SET_BOX, set_box_params2
        rts

LA6A3:  lda     #$00
        jmp     LA6C7

.proc query_target_params
queryx: .word   0
queryy: .word   0
element:.byte   0
id:     .byte   0
.endproc

LA6AE:  .byte   $00
LA6AF:  .byte   $00
LA6B0:  .byte   $00
LA6B1:  .byte   $00
LA6B2:  .byte   $00
LA6B3:  .byte   $00
LA6B4:  .byte   $00
LA6B5:  .byte   $00
LA6B6:  .byte   $00
LA6B7:  .byte   $00
LA6B8:  .byte   $00
LA6B9:  .byte   $00
LA6BA:  .byte   $00
LA6BB:  .byte   $00
LA6BC:  .byte   $00
LA6BD:  .byte   $00
LA6BE:  .byte   $00
LA6BF:  .byte   $00
LA6C0:  .byte   $00
LA6C1:  .byte   $00
LA6C2:  .byte   $00
LA6C3:  .byte   $00
LA6C4:  .byte   $00
LA6C5:  .byte   $00
LA6C6:  .byte   $00
LA6C7:  lda     L9F93
        beq     LA6FA
        lda     set_box_params2::width
        clc
        adc     #$01
        sta     set_box_params2::hoff
        sta     set_box_params2::left
        lda     set_box_params2::width+1
        adc     #$00
        sta     set_box_params2::hoff+1
        sta     set_box_params2::left+1
        ldx     #$05
LA6E5:  lda     LA629,x
        sta     set_box_params2::voff,x
        dex
        bpl     LA6E5
        lda     set_box_params2::voff
        sta     set_box_params2::top
        lda     set_box_params2::voff+1
        sta     set_box_params2::top+1
LA6FA:  lda     set_box_params2::hoff
        sta     LA6B3
        sta     LA6BF
        lda     set_box_params2::hoff+1
        sta     LA6B4
        sta     LA6C0
        lda     set_box_params2::voff
        sta     LA6B5
        sta     LA6B9
        lda     set_box_params2::voff+1
        sta     LA6B6
        sta     LA6BA
        lda     set_box_params2::width
        sta     LA6B7
        sta     LA6BB
        lda     set_box_params2::width+1
        sta     LA6B8
        sta     LA6BC
        lda     set_box_params2::height
        sta     LA6BD
        sta     LA6C1
        lda     set_box_params2::height+1
        sta     LA6BE
        sta     LA6C2
        lda     #$00
        sta     LA6B0
LA747:  lda     LA6B0
        cmp     #$04
        bne     LA775
        lda     #$00
        sta     LA6B0
LA753:  A2D_CALL A2D_SET_BOX, set_box_params2
        lda     set_box_params2::width+1
        cmp     LA62C
        bne     LA76F
        lda     set_box_params2::width
        cmp     LA62B
        bcc     LA76F
        lda     #$00
        sta     L9F93
        rts

LA76F:  lda     #$01
        sta     L9F93
        rts

LA775:  lda     LA6B0
        asl     a
        asl     a
        tax
        ldy     #$00
LA77D:  lda     LA6B3,x
        sta     query_target_params,y
        iny
        inx
        cpy     #$04
        bne     LA77D
        inc     LA6B0
        A2D_CALL A2D_QUERY_TARGET, query_target_params
        lda     query_target_params::element
        beq     LA747
        lda     query_target_params::id
        sta     query_state_params
        A2D_CALL A2D_QUERY_STATE, query_state_params
        jsr     LA365
        A2D_CALL A2D_QUERY_WINDOW, query_target_params::id
        lda     LA6AE
        sta     $06
        lda     LA6AF
        sta     $07
        ldy     #$01
        lda     ($06),y
        and     #$01
        bne     LA7C3
        sta     LA6B2
        beq     LA7C8
LA7C3:  lda     #$80
        sta     LA6B2
LA7C8:  ldy     #$04
        lda     ($06),y
        and     #$80
        sta     LA6B1
        iny
        lda     ($06),y
        and     #$80
        lsr     a
        ora     LA6B1
        sta     LA6B1
        lda     set_state_params::left
        sec
        sbc     #2
        sta     set_state_params::left
        lda     set_state_params::left+1
        sbc     #0
        sta     set_state_params::left+1
        lda     set_state_params::hoff
        sec
        sbc     #2
        sta     set_state_params::hoff
        lda     set_state_params::hoff+1
        sbc     #0
        sta     set_state_params::hoff+1
        bit     LA6B2
        bmi     LA820
        lda     set_state_params::top
        sec
        sbc     #$0E
        sta     set_state_params::top
        bcs     LA812
        dec     set_state_params::top+1
LA812:  lda     set_state_params::voff
        sec
        sbc     #$0E
        sta     set_state_params::voff
        bcs     LA820
        dec     set_state_params::voff+1
LA820:  bit     LA6B1
        bpl     LA833
        lda     set_state_params::height
        clc
        adc     #$0C
        sta     set_state_params::height
        bcc     LA833
        inc     set_state_params::height+1
LA833:  bit     LA6B1
        bvc     LA846
        lda     set_state_params::width
        clc
        adc     #$14
        sta     set_state_params::width
        bcc     LA846
        inc     set_state_params::width+1
LA846:  jsr     LA382
        lda     set_state_params::width
        sec
        sbc     set_state_params::hoff
        sta     LA6C3
        lda     set_state_params::width+1
        sbc     set_state_params::hoff+1
        sta     LA6C4
        lda     set_state_params::height
        sec
        sbc     set_state_params::voff
        sta     LA6C5
        lda     set_state_params::height+1
        sbc     set_state_params::voff+1
        sta     LA6C6
        lda     LA6C3
        clc
        adc     set_state_params::left
        sta     LA6C3
        lda     set_state_params::left+1
        adc     LA6C4
        sta     LA6C4
        lda     LA6C5
        clc
        adc     set_state_params::top
        sta     LA6C5
        lda     LA6C6
        adc     set_state_params::top+1
        sta     LA6C6
        lda     set_box_params2::width
        cmp     LA6C3
        lda     set_box_params2::width+1
        sbc     LA6C4
        bmi     LA8B7
        lda     LA6C3
        clc
        adc     #$01
        sta     set_box_params2::width
        lda     LA6C4
        adc     #$00
        sta     set_box_params2::width+1
        jmp     LA8D4

LA8B7:  lda     set_state_params::left
        cmp     set_box_params2::hoff
        lda     set_state_params::left+1
        sbc     set_box_params2::hoff+1
        bmi     LA8D4
        lda     set_state_params::left
        sta     set_box_params2::width
        lda     set_state_params::left+1
        sta     set_box_params2::width+1
        jmp     LA6FA

LA8D4:  lda     set_state_params::top
        cmp     set_box_params2::voff
        lda     set_state_params::top+1
        sbc     set_box_params2::voff+1
        bmi     LA8F6
        lda     set_state_params::top
        sta     set_box_params2::height
        lda     set_state_params::top+1
        sta     set_box_params2::height+1
        lda     #$01
        sta     L9F93
        jmp     LA6FA

LA8F6:  lda     LA6C5
        cmp     set_box_params2::height
        lda     LA6C6
        sbc     set_box_params2::height+1
        bpl     LA923
        lda     LA6C5
        clc
        adc     #$02
        sta     set_box_params2::voff
        sta     set_box_params2::top
        lda     LA6C6
        adc     #$00
        sta     set_box_params2::voff+1
        sta     set_box_params2::top+1
        lda     #$01
        sta     L9F93
        jmp     LA6FA

LA923:  lda     set_box_params2::width
        sta     set_box_params2::hoff
        sta     set_box_params2::left
        lda     set_box_params2::width+1
        sta     set_box_params2::hoff+1
        sta     set_box_params2::left+1
        jmp     LA753

LA938:  lda     set_state_params::top
        clc
        adc     #$0F
        sta     set_state_params::top
        lda     set_state_params::top+1
        adc     #0
        sta     set_state_params::top+1
        lda     set_state_params::voff
        clc
        adc     #$0F
        sta     set_state_params::voff
        lda     set_state_params::voff+1
        adc     #0
        sta     set_state_params::voff+1
        A2D_CALL A2D_SET_STATE, set_state_params
        rts

        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00


        ;; 5.25" Floppy Disk
LA980:  .addr   LA9AC           ; address
        .word   4               ; stride
        .word   0               ; left
        .word   1               ; top
        .word   26              ; width
        .word   15              ; height

LA9AC:
        .byte   px(%1010101),px(%0101010),px(%1010101),px(%0101010)
        .byte   px(%1111111),px(%1111111),px(%1111111),px(%1111111)
        .byte   px(%1100000),px(%0000011),px(%1000000),px(%0000110)
        .byte   px(%1100000),px(%0000011),px(%1000000),px(%0000111)
        .byte   px(%1100000),px(%0000011),px(%1000000),px(%0000110)
        .byte   px(%1100000),px(%0000011),px(%1000000),px(%0000111)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000110)
        .byte   px(%1100000),px(%0000011),px(%1000000),px(%0000111)
        .byte   px(%1100000),px(%0000111),px(%1100000),px(%0000110)
        .byte   px(%1100000),px(%0000011),px(%1000000),px(%0000111)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000110)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000111)
        .byte   px(%1011000),px(%0000000),px(%0000000),px(%0000110)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000111)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000110)
        .byte   px(%1111111),px(%1111111),px(%1111111),px(%1111111)

        ;; RAM Disk
LA9CC:  .addr   LA9D8           ; address
        .word   6               ; stride
        .word   1               ; left (???)
        .word   0               ; top
        .word   38              ; width
        .word   11              ; height
LA9D8:
        .byte   px(%1111111),px(%1111111),px(%1111111),px(%1111111),px(%1111111),px(%1111101)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0001110)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0001101)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0001110)
        .byte   px(%1100000),px(%0001111),px(%1000111),px(%1100110),px(%0000110),px(%0001101)
        .byte   px(%1100000),px(%0001100),px(%1100110),px(%0110111),px(%1011110),px(%0001110)
        .byte   px(%1100000),px(%0001111),px(%1000111),px(%1110110),px(%1110110),px(%0001101)
        .byte   px(%1100000),px(%0001100),px(%1100110),px(%0110110),px(%0000110),px(%0001110)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0001101)
        .byte   px(%1111111),px(%1111111),px(%1111111),px(%1001100),px(%1100110),px(%0001110)
        .byte   px(%0101010),px(%1010101),px(%0101010),px(%1001100),px(%1100110),px(%0001101)
        .byte   px(%1010101),px(%0101010),px(%1010101),px(%1111111),px(%1111111),px(%1111110)

        ;; 3.5" Floppy Disk
LAA20:  .addr   LAA2C           ; address
        .word   3               ; stride
        .word   0               ; left
        .word   0               ; top
        .word   20              ; width
        .word   11              ; height
LAA2C:
        .byte   px(%1111111),px(%1111111),px(%1111110)
        .byte   px(%1100011),px(%0000000),px(%1100111)
        .byte   px(%1100011),px(%0000000),px(%1100111)
        .byte   px(%1100011),px(%1111111),px(%1100011)
        .byte   px(%1100000),px(%0000000),px(%0000011)
        .byte   px(%1100000),px(%0000000),px(%0000011)
        .byte   px(%1100111),px(%1111111),px(%1110011)
        .byte   px(%1100110),px(%0000000),px(%0110011)
        .byte   px(%1100110),px(%0000000),px(%0110011)
        .byte   px(%1100110),px(%0000000),px(%0110011)
        .byte   px(%1100110),px(%0000000),px(%0110011)
        .byte   px(%1111111),px(%1111111),px(%1111111)

        ;; Hard Disk
LAA50:  .addr   LAA5C           ; address
        .word   8               ; stride
        .word   1               ; left
        .word   0               ; top
        .word   51              ; width
        .word   9               ; height
LAA5C:
        .byte   px(%0111111),px(%1111111),px(%1111111),px(%1111111),px(%1111111),px(%1111111),px(%1111111),px(%1110101)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0011010)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0011101)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0011010)
        .byte   px(%1100011),px(%1000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0011101)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0011101)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0011010)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0011101)
        .byte   px(%0111111),px(%1111111),px(%1111111),px(%1111111),px(%1111111),px(%1111111),px(%1111111),px(%1110101)
        .byte   px(%1010111),px(%0101010),px(%1010101),px(%0101010),px(%1010101),px(%0101010),px(%1010111),px(%0101010)

        ;; Trash Can
LAAAC:  .addr   LAAB8           ; address
        .word   5               ; stride
        .word   7               ; left
        .word   1               ; top
        .word   27              ; width
        .word   18              ; height
LAAB8:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%1010101),PX(%1111111),px(%1010101),px(%0000000)
        .byte   px(%0000000),px(%0101010),PX(%1100011),px(%0101010),px(%0000000)
        .byte   px(%0000000),PX(%1111111),PX(%1111111),PX(%1111111),px(%0000000)
        .byte   px(%0000000),px(%1100000),px(%0000000),PX(%0000011),px(%0000000)
        .byte   px(%0000000),PX(%1111111),PX(%1111111),PX(%1111111),px(%0000000)
        .byte   px(%0000000),px(%1100000),px(%0000000),px(%0000011),px(%0000000)
        .byte   px(%0000000),px(%1100001),px(%0000100),px(%0010011),px(%0000000)
        .byte   px(%0000000),px(%1100010),px(%0001000),px(%0100011),px(%0000000)
        .byte   px(%0000000),px(%1100010),px(%0001000),px(%0100011),px(%0000000)
        .byte   px(%0000000),px(%1100010),px(%0001000),px(%0100011),px(%0000000)
        .byte   px(%0000000),px(%1100010),px(%0001000),px(%0100011),px(%0000000)
        .byte   px(%0000000),px(%1100010),px(%0001000),px(%0100011),px(%0000000)
        .byte   px(%0000000),px(%1100010),px(%0001000),px(%0100011),px(%0000000)
        .byte   px(%0000000),px(%1100010),px(%0001000),px(%0100011),px(%0000000)
        .byte   px(%0000000),px(%1100010),px(%0001000),px(%0100011),px(%0000000)
        .byte   px(%0000000),px(%1100001),px(%0000100),px(%0010011),px(%0000000)
        .byte   px(%0000000),px(%1100000),px(%0000000),px(%0000011),px(%0000000)
        .byte   px(%0000000),PX(%1111111),PX(%1111111),PX(%1111111),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)

label_apple:
        PASCAL_STRING A2D_GLYPH_CAPPLE
label_file:
        PASCAL_STRING "File"
label_view:
        PASCAL_STRING "View"
label_special:
        PASCAL_STRING "Special"
label_startup:
        PASCAL_STRING "Startup"
label_selector:
        PASCAL_STRING "Selector"

label_new_folder:
        PASCAL_STRING "New Folder ..."
label_open:
        PASCAL_STRING "Open"
label_close:
        PASCAL_STRING "Close"
label_close_all:
        PASCAL_STRING "Close All"
label_select_all:
        PASCAL_STRING "Select All"
label_copy_file:
        PASCAL_STRING "Copy a File ..."
label_delete_file:
        PASCAL_STRING "Delete a File ..."
label_eject:
        PASCAL_STRING "Eject"
label_quit:
        PASCAL_STRING "Quit"

label_by_icon:
        PASCAL_STRING "By Icon"
label_by_name:
        PASCAL_STRING "By Name"
label_by_date:
        PASCAL_STRING "By Date"
label_by_size:
        PASCAL_STRING "By Size"
label_by_type:
        PASCAL_STRING "By Type"

label_check_drives:
        PASCAL_STRING "Check Drives"
label_format_disk:
        PASCAL_STRING "Format a Disk ..."
label_erase_disk:
        PASCAL_STRING "Erase a Disk ..."
label_disk_copy:
        PASCAL_STRING "Disk Copy ..."
label_lock:
        PASCAL_STRING "Lock ..."
label_unlock:
        PASCAL_STRING "Unlock ..."
label_get_info:
        PASCAL_STRING "Get Info ..."
label_get_size:
        PASCAL_STRING "Get Size ..."
label_rename_icon:
        PASCAL_STRING "Rename an Icon ..."

LAC44:  .word   6
        .addr   1, label_apple, apple_menu, 0,0,0
        .addr   2, label_file, file_menu, 0,0,0
        .addr   4, label_view, view_menu, 0,0,0
        .addr   5, label_special, special_menu, 0,0,0
        .addr   8, label_startup, startup_menu, 0,0,0
        .addr   3, label_selector, selector_menu, 0,0,0

.macro  DEFINE_MENU count
        .word   count, 0, 0
.endmacro
.macro  DEFINE_MENU_ITEM saddr, shortcut1, shortcut2
        .if .paramcount > 1
        .word   1
        .byte   shortcut1
        .byte   shortcut2
        .else
        .word   0
        .byte   0
        .byte   0
        .endif
        .addr   saddr
.endmacro
.macro  DEFINE_MENU_SEPARATOR
        .addr   $0040, $0013, $0000
.endmacro

file_menu:
        DEFINE_MENU 12
        DEFINE_MENU_ITEM label_new_folder, 'F', 'f'
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_open, 'O', 'o'
        DEFINE_MENU_ITEM label_close, 'C', 'c'
        DEFINE_MENU_ITEM label_close_all, 'B', 'b'
        DEFINE_MENU_ITEM label_select_all, 'A', 'a'
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_copy_file, 'Y', 'y'
        DEFINE_MENU_ITEM label_delete_file, 'D', 'd'
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_eject, 'E', 'e'
        DEFINE_MENU_ITEM label_quit, 'Q', 'q'

view_menu:
        DEFINE_MENU 5
        DEFINE_MENU_ITEM label_by_icon, 'J', 'j'
        DEFINE_MENU_ITEM label_by_name, 'N', 'n'
        DEFINE_MENU_ITEM label_by_date, 'T', 't'
        DEFINE_MENU_ITEM label_by_size, 'K', 'k'
        DEFINE_MENU_ITEM label_by_type, 'L', 'l'

special_menu:
        DEFINE_MENU 13
        DEFINE_MENU_ITEM label_check_drives
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_format_disk, 'S', 's'
        DEFINE_MENU_ITEM label_erase_disk, 'Z', 'z'
        DEFINE_MENU_ITEM label_disk_copy
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_lock
        DEFINE_MENU_ITEM label_unlock
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_get_info, 'I', 'i'
        DEFINE_MENU_ITEM label_get_size
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_rename_icon

        .addr   $0000,$0000

        .res    168, 0

        .byte   $04
        .byte   $00,$02,$00,$8C,$01,$62,$00,$05
        .byte   $00,$03,$00,$8B,$01,$61,$00,$28
        .byte   $00,$51,$00,$8C,$00,$5C,$00,$C1
        .byte   $00,$1E,$00,$25,$01,$29,$00,$04
        .byte   $01,$51,$00,$68,$01,$5C,$00,$C8
        .byte   $00,$51,$00,$F0,$00,$5C,$00,$04
        .byte   $01,$51,$00,$2C,$01,$5C,$00,$40
        .byte   $01,$51,$00,$68,$01,$5C,$00

        PASCAL_STRING {"OK            ",A2D_GLYPH_RETURN}

        .byte   $09
        .byte   $01,$5B,$00,$2D,$00,$5B,$00,$CD
        .byte   $00,$5B,$00,$09,$01,$5B,$00,$45
        .byte   $01,$5B,$00,$1C,$00,$70,$00,$1C
        .byte   $00,$87,$00,$00,$7F,$27,$00,$19
        .byte   $00,$68,$01,$50,$00,$28,$00,$3C
        .byte   $00,$68,$01,$50,$00,$41,$00,$2B
        .byte   $00,$41,$00,$33,$00,$41,$00,$23
        .byte   $00,$8A,$01,$2A,$00,$41,$00,$2B
        .byte   $00,$8A,$01,$32,$00

LAE96:  PASCAL_STRING "Cancel        Esc"
LAEA8:  PASCAL_STRING " Yes"
LAEAD:  PASCAL_STRING " No"
LAEB1:  PASCAL_STRING " All"
LAEB6:  PASCAL_STRING "Source filename:"
LAEC7:  PASCAL_STRING "Destination filename:"

        .byte   $04,$00,$02,$00
        .byte   $8C,$01,$6C,$00,$05,$00,$03,$00
        .byte   $8B,$01,$6B,$00

LAEED:  PASCAL_STRING "Apple II DeskTop"
LAEFE:  PASCAL_STRING "Copyright Apple Computer Inc., 1986"
LAF22:  PASCAL_STRING "Copyright Version Soft, 1985 - 1986"
LAF46:  PASCAL_STRING "All Rights Reserved"
LAF5A:  PASCAL_STRING "Authors: Stephane Cavril, Bernard Gallet, Henri Lamiraux"
LAF93:  PASCAL_STRING "Richard Danais and Luc Barthelet"
LAFB4:  PASCAL_STRING "With thanks to: A. Gerard, J. Gerber, P. Pahl, J. Bernard"
LAFEE:  PASCAL_STRING "November 26, 1986"
LB000:  PASCAL_STRING "Version 1.1"

LB00C:  PASCAL_STRING "Copy ..."
LB015:  PASCAL_STRING "Now Copying "
LB022:  PASCAL_STRING "from:"
LB028:  PASCAL_STRING "to :"
LB02D:  PASCAL_STRING "Files remaining to copy: "
LB047:  PASCAL_STRING "That file already exists. Do you want to write over it ?"
LB080:  PASCAL_STRING "This file is too large to copy, click OK to continue."

        .byte   $6E,$00,$23
        .byte   $00,$AA,$00,$3B,$00

LB0BE:  PASCAL_STRING "Delete ..."
LB0C9:  PASCAL_STRING "Click OK to delete:"
LB0DD:  PASCAL_STRING "Clicking OK will immediately empty the trash of:"
LB10E:  PASCAL_STRING "File:"
LB114:  PASCAL_STRING "Files remaining to be deleted:"
LB133:  PASCAL_STRING "This file is locked, do you want to delete it anyway ?"

        .byte   $91,$00,$3B,$00,$C8,$00,$3B,$00,$2C,$01,$3B,$00

LB176:  PASCAL_STRING "New Folder ..."
LB185:  PASCAL_STRING "in:"
LB189:  PASCAL_STRING "Enter the folder name:"
LB1A0:  PASCAL_STRING "Rename an Icon ..."
LB1B3:	PASCAL_STRING "Rename: "
LB1BC:  PASCAL_STRING "New name:"
LB1C6:  PASCAL_STRING "Get Info ..."
LB1D3:  PASCAL_STRING "Name"
LB1D8:  PASCAL_STRING "Locked"
LB1DF:  PASCAL_STRING "Size"
LB1E4:  PASCAL_STRING "Creation date"
LB1F2:  PASCAL_STRING "Last modification"
LB204:  PASCAL_STRING "Type"
LB209:  PASCAL_STRING "Write protected"
LB219:  PASCAL_STRING "Blocks free/size"
LB22A:  PASCAL_STRING ": "

        .byte   $A0,$00,$3B,$00
        .byte   $91,$00,$3B,$00,$C8,$00,$3B,$00
        .byte   $B9,$00,$3B,$00,$CD,$00,$3B,$00
        .byte   $C3,$00,$3B,$00

LB245:  PASCAL_STRING "Format a Disk ..."
LB257:  PASCAL_STRING "Select the location where the disk is to be formatted"
LB28D:  PASCAL_STRING "Enter the name of the new volume:"
LB2AF:  PASCAL_STRING "Do you want to format "
LB2C6:  PASCAL_STRING "Formatting the disk...."
LB2DE:  PASCAL_STRING "Formatting error. Check drive, then click OK to try again."
LB319:  PASCAL_STRING "Erase a Disk ..."
LB32A:  PASCAL_STRING "Select the location where the disk is to be erased"
LB35D:  PASCAL_STRING "Do you want to erase "
LB373:  PASCAL_STRING "Erasing the disk...."
LB388:  PASCAL_STRING "Erasing error. Check drive, then click OK to try again."
LB3C0:  PASCAL_STRING "Unlock ..."
LB3CB:  PASCAL_STRING "Click OK to unlock "
LB3DF:  PASCAL_STRING "Files remaining to be unlocked: "
LB400:  PASCAL_STRING "Lock ..."
LB409:  PASCAL_STRING "Click OK to lock "
LB41B:  PASCAL_STRING "Files remaining to be locked: "
LB43A:  PASCAL_STRING "Get Size ..."
LB447:  PASCAL_STRING "Number of files"
LB457:  PASCAL_STRING "Blocks used on disk"

        .byte   $6E,$00,$23,$00,$6E,$00,$2B,$00

LB473:  PASCAL_STRING "DownLoad ..."
LB480:  PASCAL_STRING "The RAMCard is full. The copy was not completed."
LB4B1:  PASCAL_STRING " "
LB4B3:  PASCAL_STRING "Warning !"
LB4BD:  PASCAL_STRING "Please insert the system disk."
LB4DC:  PASCAL_STRING "The Selector list is full. You must delete an entry"
LB50C:  PASCAL_STRING "before you can add new entries."
LB530:  PASCAL_STRING "A window must be closed before opening this new catalog."

LB569:  PASCAL_STRING "There are too many windows open on the desktop !"
LB59A:  PASCAL_STRING "Do you want to save the new Selector list"
LB5C4:  PASCAL_STRING "on the system disk ?"


        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00

show_alert_indirection:
        jmp     show_alert_dialog

alert_bitmap:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),px(%0000000),PX(%1111111),PX(%1111111),px(%0000000),px(%0000000)
        .byte   px(%0111100),px(%1111100),px(%0000001),px(%1110000),PX(%0000111),px(%0000000),px(%0000000)
        .byte   px(%0111100),px(%1111100),px(%0000011),px(%1100000),px(%0000011),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0000111),PX(%1100111),px(%1111001),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0001111),PX(%1100111),px(%1111001),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),px(%1111001),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),px(%1110011),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),PX(%1100111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),PX(%1001111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),PX(%0011111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),px(%1111110),PX(%0111111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),px(%1111100),PX(%1111111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),px(%1111100),PX(%1111111),px(%0000000),px(%0000000)
        .byte   px(%0111110),px(%0000000),PX(%0111111),PX(%1111111),PX(%1111111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1100000),PX(%1111111),px(%1111100),PX(%1111111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1100001),PX(%1111111),PX(%1111111),PX(%1111111),px(%0000000),px(%0000000)
        .byte   px(%0111000),px(%0000011),PX(%1111111),PX(%1111111),px(%1111110),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)

.proc alert_bitmap_params
        .word   $14             ; left
        .word   $8              ; top
        .addr   alert_bitmap    ; addr
        .word   7               ; stride
        .word   0               ; left
        .word   0               ; top
        .word   $24             ; width
        .word   $17             ; height
.endproc

alert_rect:
        .word   $41, $57, $1E5, $8E
alert_inner_frame_rect1:
        .word   $4, $2, $1A0, $35
alert_inner_frame_rect2:
        .word   $5, $3, $19F, $34

LB6D3:  .byte   $41
LB6D4:  .byte   $00
LB6D5:  .byte   $57
LB6D6:  .byte   $00,$00,$20,$80,$00,$00,$00,$00
        .byte   $00
LB6DF:  .byte   $A4
LB6E0:  .byte   $01
LB6E1:  .byte   $37,$00

ok_label:
        PASCAL_STRING {"OK            ",A2D_GLYPH_RETURN}

try_again_rect:
        .word   $14,$25,$78,$30
try_again_pos:
        .word   $0019,$002F

cancel_rect:
        .word   $12C,$25,$190,$30
cancel_pos:  .word   $0131,$002F
        .word   $00BE,$0010
LB70F:  .word   $004B,$001D

alert_action:  .byte   $00
LB714:  .byte   $00
LB715:  .byte   $00

try_again_label:
        PASCAL_STRING "Try Again     A"
cancel_label:
        PASCAL_STRING "Cancel     Esc"

LB735:  PASCAL_STRING "System Error"
LB742:  PASCAL_STRING "I/O error"
LB74C:  PASCAL_STRING "No device connected"
LB760:  PASCAL_STRING "The disk is write protected."
LB77D:  PASCAL_STRING "The syntax of the pathname is invalid."
LB7A4:  PASCAL_STRING "Part of the pathname doesn't exist."
LB7C8:  PASCAL_STRING "The volume cannot be found."
LB7E4:  PASCAL_STRING "The file cannot be found."
LB7FE:  PASCAL_STRING "That name already exists. Please use another name."
LB831:  PASCAL_STRING "The disk is full."
LB843:  PASCAL_STRING "The volume directory cannot hold more than 51 files."
LB878:  PASCAL_STRING "The file is locked."
LB88C:  PASCAL_STRING "This is not a ProDOS disk."
LB8A7:  PASCAL_STRING "There is another volume with that name on the desktop."
LB8DE:  PASCAL_STRING "There are 2 volumes with the same name."
LB906:  PASCAL_STRING "This file cannot be run."
LB91F:  PASCAL_STRING "That name is too long."
LB936:  PASCAL_STRING "Please insert source disk"
LB950:  PASCAL_STRING "Please insert destination disk"
LB96F:  PASCAL_STRING "BASIC.SYSTEM not found"

        ;; number of alert messages
alert_count:
        .byte   $14

        ;; message number-to-index table
        ;; (look up by scan to determine index)
alert_table:
        .byte   $00,$27,$28,$2B,$40,$44,$45,$46
        .byte   $47,$48,$49,$4E,$52,$57,$F9,$FA
        .byte   $FB,$FC,$FD,$FE

        ;; alert index to string address
prompt_table:
        .addr   LB735,LB742,LB74C,LB760,LB77D,LB7A4,LB7C8,LB7E4
        .addr   LB7FE,LB831,LB843,LB878,LB88C,LB8A7,LB8DE,LB906
        .addr   LB91F,LB936,LB950,LB96F

        ;; alert index to action (0 = Cancel, $80 = Try Again)
alert_action_table:
        .byte   $00,$00,$00,$80,$00,$80,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$80,$80,$00

        ;; Show alert; prompt number in X (???), A = ???
.proc show_alert_dialog
        pha
        txa
        pha
        A2D_RELAY2_CALL A2D_HIDE_CURSOR
        A2D_RELAY2_CALL A2D_SET_CURSOR, pointer_cursor
        A2D_RELAY2_CALL A2D_SHOW_CURSOR
        sta     ALTZPOFF
        sta     ROMIN2
        jsr     $FBDD
        sta     ALTZPON
        lda     LCBANK1
        lda     LCBANK1
        ldx     #$03
        lda     #$00
LBA0B:  sta     $D239,x
        sta     $D241,x
        dex
        bpl     LBA0B
        lda     #$26
        sta     $D245
        lda     #$02
        sta     $D246
        lda     #$B9
        sta     $D247
        lda     #$00
        sta     $D248
        A2D_RELAY2_CALL A2D_SET_STATE, $D239
        lda     LB6D3
        ldx     LB6D4
        jsr     LBF8B
        sty     LBFCA
        sta     LBFCD
        lda     LB6D3
        clc
        adc     LB6DF
        pha
        lda     LB6D4
        adc     LB6E0
        tax
        pla
        jsr     LBF8B
        sty     LBFCC
        sta     LBFCE
        lda     LB6D5
        sta     LBFC9
        clc
        adc     LB6E1
        sta     LBFCB
        A2D_RELAY2_CALL A2D_HIDE_CURSOR
        jsr     LBE08
        A2D_RELAY2_CALL A2D_SHOW_CURSOR
        A2D_RELAY2_CALL A2D_SET_FILL_MODE, const0
        A2D_RELAY2_CALL A2D_FILL_RECT, alert_rect ; alert background
        A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2 ; ensures corners are inverted
        A2D_RELAY2_CALL A2D_DRAW_RECT, alert_rect ; alert outline
        A2D_RELAY2_CALL A2D_SET_BOX, $B6D3
        A2D_RELAY2_CALL A2D_DRAW_RECT, alert_inner_frame_rect1 ; inner 2x border
        A2D_RELAY2_CALL A2D_DRAW_RECT, alert_inner_frame_rect2
        A2D_RELAY2_CALL A2D_SET_FILL_MODE, const0 ; restores normal mode
        A2D_RELAY2_CALL A2D_HIDE_CURSOR
        A2D_RELAY2_CALL A2D_DRAW_BITMAP, alert_bitmap_params
        A2D_RELAY2_CALL A2D_SHOW_CURSOR
        pla
        tax
        pla
        ldy     alert_count
        dey
LBAE5:  cmp     alert_table,y
        beq     LBAEF
        dey
        bpl     LBAE5
        ldy     #$00
LBAEF:  tya
        asl     a
        tay
        lda     prompt_table,y
        sta     LB714
        lda     prompt_table+1,y
        sta     LB715
        cpx     #$00
        beq     LBB0B
        txa
        and     #$FE
        sta     alert_action
        jmp     LBB14

.macro DRAW_PASCAL_STRING addr
        lda     #<(addr)
        ldx     #>(addr)
        jsr     draw_pascal_string
.endmacro

LBB0B:  tya
        lsr     a
        tay
        lda     alert_action_table,y
        sta     alert_action
LBB14:  A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        bit     alert_action
        bpl     LBB5C
        A2D_RELAY2_CALL A2D_DRAW_RECT, cancel_rect
        A2D_RELAY2_CALL A2D_SET_POS, cancel_pos
        DRAW_PASCAL_STRING cancel_label
        bit     alert_action
        bvs     LBB5C
        A2D_RELAY2_CALL A2D_DRAW_RECT, try_again_rect
        A2D_RELAY2_CALL A2D_SET_POS, try_again_pos
        DRAW_PASCAL_STRING try_again_label
        jmp     LBB75
.endproc

LBB5C:  A2D_RELAY2_CALL A2D_DRAW_RECT, try_again_rect
        A2D_RELAY2_CALL A2D_SET_POS, try_again_pos
        DRAW_PASCAL_STRING ok_label
LBB75:  A2D_RELAY2_CALL A2D_SET_POS, $B70F
        lda     LB714
        ldx     LB715
        jsr     draw_pascal_string
LBB87:  A2D_RELAY2_CALL A2D_GET_INPUT, alert_input_params
        lda     alert_input_params
        cmp     #$01
        bne     LBB9A
        jmp     LBC0C

LBB9A:  cmp     #$03
        bne     LBB87
        lda     alert_input_params+1
        and     #$7F
        bit     alert_action
        bpl     LBBEE
        cmp     #$1B
        bne     LBBC3
        A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        A2D_RELAY2_CALL A2D_FILL_RECT, cancel_rect
        lda     #$01
        jmp     LBC55

LBBC3:  bit     alert_action
        bvs     LBBEE
        cmp     #$61
        bne     LBBE3
LBBCC:  A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        A2D_RELAY2_CALL A2D_FILL_RECT, try_again_rect
        lda     #$00
        jmp     LBC55

LBBE3:  cmp     #$41
        beq     LBBCC
        cmp     #$0D
        beq     LBBCC
        jmp     LBB87

LBBEE:  cmp     #$0D
        bne     LBC09
        A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        A2D_RELAY2_CALL A2D_FILL_RECT, try_again_rect
        lda     #$02
        jmp     LBC55

LBC09:  jmp     LBB87

LBC0C:  jsr     LBDE1
        A2D_RELAY2_CALL A2D_SET_POS, alert_input_params+1
        bit     alert_action
        bpl     LBC42
        A2D_RELAY2_CALL A2D_TEST_BOX, cancel_rect
        cmp     #$80
        bne     LBC2D
        jmp     LBCE9

LBC2D:  bit     alert_action
        bvs     LBC42
        A2D_RELAY2_CALL A2D_TEST_BOX, try_again_rect
        cmp     #$80
        bne     LBC52
        jmp     LBC6D

LBC42:  A2D_RELAY2_CALL A2D_TEST_BOX, try_again_rect
        cmp     #$80
        bne     LBC52
        jmp     LBD65

LBC52:  jmp     LBB87

LBC55:  pha
        A2D_RELAY2_CALL A2D_HIDE_CURSOR
        jsr     LBE5D
        A2D_RELAY2_CALL A2D_SHOW_CURSOR
        pla
        rts

LBC6D:  A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        A2D_RELAY2_CALL A2D_FILL_RECT, try_again_rect
        lda     #$00
        sta     LBCE8
LBC84:  A2D_RELAY2_CALL A2D_GET_INPUT, alert_input_params
        lda     alert_input_params
        cmp     #$02
        beq     LBCDB
        jsr     LBDE1
        A2D_RELAY2_CALL A2D_SET_POS, alert_input_params+1
        A2D_RELAY2_CALL A2D_TEST_BOX, try_again_rect
        cmp     #$80
        beq     LBCB5
        lda     LBCE8
        beq     LBCBD
        jmp     LBC84

LBCB5:  lda     LBCE8
        bne     LBCBD
        jmp     LBC84

LBCBD:  A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        A2D_RELAY2_CALL A2D_FILL_RECT, try_again_rect
        lda     LBCE8
        clc
        adc     #$80
        sta     LBCE8
        jmp     LBC84

LBCDB:  lda     LBCE8
        beq     LBCE3
        jmp     LBB87

LBCE3:  lda     #$00
        jmp     LBC55

LBCE8:  .byte   0
LBCE9:  A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        A2D_RELAY2_CALL A2D_FILL_RECT, cancel_rect
        lda     #$00
        sta     LBD64
LBD00:  A2D_RELAY2_CALL A2D_GET_INPUT, alert_input_params
        lda     alert_input_params
        cmp     #$02
        beq     LBD57
        jsr     LBDE1
        A2D_RELAY2_CALL A2D_SET_POS, alert_input_params+1
        A2D_RELAY2_CALL A2D_TEST_BOX, cancel_rect
        cmp     #$80
        beq     LBD31
        lda     LBD64
        beq     LBD39
        jmp     LBD00

LBD31:  lda     LBD64
        bne     LBD39
        jmp     LBD00

LBD39:  A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        A2D_RELAY2_CALL A2D_FILL_RECT, cancel_rect
        lda     LBD64
        clc
        adc     #$80
        sta     LBD64
        jmp     LBD00

LBD57:  lda     LBD64
        beq     LBD5F
        jmp     LBB87

LBD5F:  lda     #$01
        jmp     LBC55

LBD64:  .byte   0
LBD65:  lda     #$00
        sta     LBDE0
        A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        A2D_RELAY2_CALL A2D_FILL_RECT, try_again_rect
LBD7C:  A2D_RELAY2_CALL A2D_GET_INPUT, alert_input_params
        lda     alert_input_params
        cmp     #$02
        beq     LBDD3
        jsr     LBDE1
        A2D_RELAY2_CALL A2D_SET_POS, alert_input_params+1
        A2D_RELAY2_CALL A2D_TEST_BOX, try_again_rect
        cmp     #$80
        beq     LBDAD
        lda     LBDE0
        beq     LBDB5
        jmp     LBD7C

LBDAD:  lda     LBDE0
        bne     LBDB5
        jmp     LBD7C

LBDB5:  A2D_RELAY2_CALL A2D_SET_FILL_MODE, const2
        A2D_RELAY2_CALL A2D_FILL_RECT, try_again_rect
        lda     LBDE0
        clc
        adc     #$80
        sta     LBDE0
        jmp     LBD7C

LBDD3:  lda     LBDE0
        beq     LBDDB
        jmp     LBB87

LBDDB:  lda     #$02
        jmp     LBC55

LBDE0:  .byte   0
LBDE1:  lda     alert_input_params+1
        sec
        sbc     LB6D3
        sta     alert_input_params+1
        lda     alert_input_params+2
        sbc     LB6D4
        sta     alert_input_params+2
        lda     $D20B
        sec
        sbc     LB6D5
        sta     $D20B
        lda     $D20C
        sbc     LB6D6
        sta     $D20C
        rts

LBE08:  lda     #$00
        sta     LBE37
        lda     #$08
        sta     LBE38
        lda     LBFC9
        jsr     LBF10
        lda     LBFCB
        sec
        sbc     LBFC9
        tax
        inx
LBE21:  lda     LBFCA
        sta     LBE5C
LBE27:  lda     LBE5C
        lsr     a
        tay
        sta     LOWSCR
        bcs     LBE34
        sta     HISCR
LBE34:  lda     ($06),y
LBE37           := * + 1
LBE38           := * + 2
        sta     $1234
        inc     LBE37
        bne     LBE41
        inc     LBE38
LBE41:  lda     LBE5C
        cmp     LBFCC
        bcs     LBE4E
        inc     LBE5C
        bne     LBE27
LBE4E:  jsr     LBF52
        dex
        bne     LBE21
        lda     LBE37
        ldx     LBE38
        rts

        .byte   0
LBE5C:  .byte   0
LBE5D:  lda     #$00
        sta     LBEBC
        lda     #$08
        sta     LBEBD
        ldx     LBFCD
        ldy     LBFCE
        lda     #$FF
        cpx     #$00
        beq     LBE78
LBE73:  clc
        rol     a
        dex
        bne     LBE73
LBE78:  sta     LBF0C
        eor     #$FF
        sta     LBF0D
        lda     #$01
        cpy     #$00
        beq     LBE8B
LBE86:  sec
        rol     a
        dey
        bne     LBE86
LBE8B:  sta     LBF0E
        eor     #$FF
        sta     LBF0F
        lda     LBFC9
        jsr     LBF10
        lda     LBFCB
        sec
        sbc     LBFC9
        tax
        inx
        lda     LBFCA
        sta     LBF0B
LBEA8:  lda     LBFCA
        sta     LBF0B
LBEAE:  lda     LBF0B
        lsr     a
        tay
        sta     LOWSCR
        bcs     LBEBB
        sta     HISCR
LBEBB:  .byte   $AD
LBEBC:  .byte   0
LBEBD:  php
        pha
        lda     LBF0B
        cmp     LBFCA
        beq     LBEDD
        cmp     LBFCC
        bne     LBEEB
        lda     ($06),y
        and     LBF0F
        sta     ($06),y
        pla
        and     LBF0E
        ora     ($06),y
        pha
        jmp     LBEEB

LBEDD:  lda     ($06),y
        and     LBF0D
        sta     ($06),y
        pla
        and     LBF0C
        ora     ($06),y
        pha
LBEEB:  pla
        sta     ($06),y
        inc     LBEBC
        bne     LBEF6
        inc     LBEBD
LBEF6:  lda     LBF0B
        cmp     LBFCC
        bcs     LBF03
        inc     LBF0B
        bne     LBEAE
LBF03:  jsr     LBF52
        dex
        bne     LBEA8
        rts

        .byte   $00
LBF0B:  .byte   $00
LBF0C:  .byte   $00
LBF0D:  .byte   $00
LBF0E:  .byte   $00
LBF0F:  .byte   $00

LBF10:  sta     LBFCF
        and     #$07
        sta     LBFB0
        lda     LBFCF
        and     #$38
        sta     LBFAF
        lda     LBFCF
        and     #$C0
        sta     LBFAE
        jsr     LBF2C
        rts

LBF2C:  lda     LBFAE
        lsr     a
        lsr     a
        ora     LBFAE
        pha
        lda     LBFAF
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        sta     LBF51
        pla
        ror     a
        sta     $06
        lda     LBFB0
        asl     a
        asl     a
        ora     LBF51
        ora     #$20
        sta     $07
        clc
        rts

LBF51:  .byte   0
LBF52:  lda     LBFB0
        cmp     #$07
        beq     LBF5F
        inc     LBFB0
        jmp     LBF2C

LBF5F:  lda     #$00
        sta     LBFB0
        lda     LBFAF
        cmp     #$38
        beq     LBF74
        clc
        adc     #$08
        sta     LBFAF
        jmp     LBF2C

LBF74:  lda     #$00
        sta     LBFAF
        lda     LBFAE
        clc
        adc     #$40
        sta     LBFAE
        cmp     #$C0
        beq     LBF89
        jmp     LBF2C

LBF89:  sec
        rts

LBF8B:  ldy     #$00
        cpx     #$02
        bne     LBF96
        ldy     #$49
        clc
        adc     #$01
LBF96:  cpx     #$01
        bne     LBFA4
        ldy     #$24
        clc
        adc     #$04
        bcc     LBFA4
        iny
        sbc     #$07
LBFA4:  cmp     #$07
        bcc     LBFAD
        sbc     #$07
        iny
        bne     LBFA4
LBFAD:  rts

LBFAE:  .byte   $00
LBFAF:  .byte   $00
LBFB0:  .byte   $00,$FF,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00
LBFC9:  .byte   $00
LBFCA:  .byte   $00
LBFCB:  .byte   $00
LBFCC:  .byte   $00
LBFCD:  .byte   $00
LBFCE:  .byte   $00
LBFCF:  .byte   $00

        ;; Draw pascal string; address in (X,A)
.proc draw_pascal_string
        ptr := $06

        sta     ptr
        stx     ptr+1
        ldy     #$00
        lda     (ptr),y         ; Check length
        beq     end
        sta     ptr+2
        inc     ptr
        bne     call
        inc     ptr+1
call:   A2D_RELAY2_CALL A2D_DRAW_TEXT, ptr
end:    rts
.endproc

        ;; A2D call in Y, params addr (X,A)
.proc A2D_RELAY2
        sty     call
        sta     addr
        stx     addr+1
        jsr     A2D
call:   .byte   0
addr:   .addr   0
        rts
.endproc

        .byte   0
        .byte   0
        .byte   0
        .byte   0

        .assert * = $C000, error, "Segment expected to fill through $C000"

;;; ==================================================
;;;
;;; $C000 - $CFFF is I/O Space
;;;
;;; ==================================================

        .org $D000

;;; Various routines callable from MAIN

;;; ==================================================
;;; A2D call from main>aux, call in Y, params at (X,A)
.proc A2D_RELAY_IMPL
        .assert * = A2D_RELAY, error, "Entry point mismatch"
        sty     addr-1
        sta     addr
        stx     addr+1
        sta     RAMRDON
        sta     RAMWRTON
        A2D_CALL 0, 0, addr
        sta     RAMRDOFF
        sta     RAMWRTOFF
        rts
.endproc

;;; ==================================================
;;; SET_POS with params at (X,A) followed by DRAW_TEXT call

.proc SETPOS_RELAY
        .assert * = SETPOS_RELAY, error, "Entry point mismatch"
        sta     addr
        stx     addr+1
        sta     RAMRDON
        sta     RAMWRTON
        A2D_CALL A2D_SET_POS, 0, addr
        A2D_RELAY_CALL A2D_DRAW_TEXT, text_buffer2
        tay
        sta     RAMRDOFF
        sta     RAMWRTOFF
        tya
        rts
.endproc

.macro SETPOS_RELAY_CALL addr
        lda     #<addr
        ldx     #>addr
        jsr     SETPOS_RELAY
.endmacro

;;; ==================================================
;;; DESKTOP call from main>aux, call in Y params at (X,A)

.proc DESKTOP_RELAY
        .assert * = DESKTOP_RELAY, error, "Entry point mismatch"
        sty     addr-1
        sta     addr
        stx     addr+1
        sta     RAMRDON
        sta     RAMWRTON
        DESKTOP_CALL 0, 0, addr
        tay
        sta     RAMRDOFF
        sta     RAMWRTOFF
        tya
        rts
.endproc

.macro DESKTOP_RELAY_CALL call, addr
        ldy     #(call)
.if .paramcount > 1
        lda     #<(addr)
        ldx     #>(addr)
.else
        lda     #0
        ldx     #0
.endif
        jsr     DESKTOP_RELAY
.endmacro

;;; ==================================================
;;; Find first 0 in AUX $1F80 ... $1F7F; if present,
;;; mark it 1 and return index+1 in A

.proc DESKTOP_FIND_SPACE_IMPL
        .assert * = DESKTOP_FIND_SPACE, error, "Entry point mismatch"
        sta     RAMRDON
        sta     RAMWRTON
        ldx     #0
loop:   lda     $1F80,x
        beq     :+
        inx
        cpx     #$7F
        bne     loop
        rts

:       inx
        txa
        dex
        tay
        lda     #1
        sta     $1F80,x
        sta     RAMRDOFF
        sta     RAMWRTOFF
        tya
        rts
.endproc

;;; ==================================================
;;; Zero the AUX $1F80 table entry in A

.proc DESKTOP_FREE_SPACE
        tay
        sta     RAMRDON
        sta     RAMWRTON
        dey
        lda     #0
        sta     $1F80,y
        sta     RAMRDOFF
        sta     RAMWRTOFF
        rts
.endproc

;;; ==================================================
;;; Copy data to/from buffers (see bufnum / buf3 / table1/2) ???

.proc DESKTOP_COPY_BUF_IMPL
        ptr := $6

from:
        lda     #$80
        bne     :+              ; always

to:
        lda     #$00

:       sta     flag
        jsr     desktop_main_push_addrs_from_zp

        lda     bufnum
        asl     a               ; * 2
        tax
        lda     table1,x        ; copy table1 entry to ptr
        sta     ptr
        lda     table1+1,x
        sta     ptr+1

        sta     RAMRDON
        sta     RAMWRTON
        bit     flag
        bpl     set_length

        ;; assign length from buf3
        lda     buf3len
        ldy     #0
        sta     (ptr),y
        jmp     set_copy_ptr

        ;; assign length to buf3
set_length:
        ldy     #0
        lda     (ptr),y
        sta     buf3len

set_copy_ptr:
        lda     table2,x         ; copy table2 entry to ptr
        sta     ptr
        lda     table2+1,x
        sta     ptr+1
        bit     flag
        bmi     copy_from

        ;; copy into buf3
        ldy     #0              ; flag clear...
:       cpy     buf3len
        beq     done
        lda     (ptr),y
        sta     buf3,y
        iny
        jmp     :-

        ;; copy from buf3
copy_from:
        ldy     #0
:       cpy     buf3len
        beq     done
        lda     buf3,y
        sta     (ptr),y
        iny
        jmp     :-

done:   sta     RAMRDOFF
        sta     RAMWRTOFF
        jsr     desktop_main_pop_addrs_to_zp
        rts

flag:   .byte   0
        rts                     ; ???
.endproc
        DESKTOP_COPY_FROM_BUF := DESKTOP_COPY_BUF_IMPL::from
        DESKTOP_COPY_TO_BUF := DESKTOP_COPY_BUF_IMPL::to

;;; ==================================================
;;; Assign active state to desktop_winid window

.proc DESKTOP_ASSIGN_STATE
        src := $6
        dst := $8

        sta     RAMRDON
        sta     RAMWRTON
        A2D_CALL A2D_GET_STATE, src ; grab window state

        lda     desktop_winid   ; which desktop window?
        asl     a
        tax
        lda     win_table,x     ; window table
        sta     dst
        lda     win_table+1,x
        sta     dst+1
        lda     dst
        clc
        adc     #20             ; add offset
        sta     dst
        bcc     :+
        inc     dst+1

:       ldy     #35             ; copy 35 bytes into window state
loop:   lda     (src),y
        sta     (dst),y
        dey
        bpl     loop

        sta     RAMRDOFF
        sta     RAMWRTOFF
        rts
.endproc

;;; ==================================================
;;; From MAIN, load AUX (X,A) into A

.proc DESKTOP_AUXLOAD
        stx     op+2
        sta     op+1
        sta     RAMRDON
        sta     RAMWRTON
op:     lda     $1234
        sta     RAMRDOFF
        sta     RAMWRTOFF
        rts
.endproc

;;; ==================================================
;;; From MAIN, show alert

;;; ...with prompt #0
.proc DESKTOP_SHOW_ALERT0
        ldx     #$00
        ;; fall through
.endproc

;;; ... with prompt # in X
.proc DESKTOP_SHOW_ALERT
        sta     RAMRDON
        sta     RAMWRTON
        jsr     show_alert_indirection
        sta     RAMRDOFF
        sta     RAMWRTOFF
        rts
.endproc

;;; ============================================================

        .res    154, 0

const0: .byte   0
const1: .byte   1
const2: .byte   2
const3: .byte   3
const4: .byte   4
const5: .byte   5
const6: .byte   6
const7: .byte   7

alert_input_params:
        .byte   $00,$00,$00,$00,$00,$00

        .byte   $00,$00,$00,$00,$00
        .addr   buffer

.proc buffer
        .res    56, $0

        ;; Looks like a window definition?
id:     .byte   0
flags:  .byte   0
title:  .addr   0
hscroll:.byte   A2D_CWS_NOSCROLL
vscroll:.byte   A2D_CWS_NOSCROLL
hsmax:  .byte   0
hspos:  .byte   0
vsmax:  .byte   0
vspos:  .byte   0
        .byte   0,0             ; ???
w1:     .word   0
h1:     .word   0
w2:     .word   0
h2:     .word   0
addr:   .addr   A2D_SCREEN_ADDR
stride: .word   A2D_SCREEN_STRIDE
hoff:   .word   0
voff:   .word   0
width:  .word   10
height: .word   10
pattern:.res    8, $FF
mskand: .byte   A2D_DEFAULT_MSKAND
mskor:  .byte   A2D_DEFAULT_MSKOR
xpos:   .word   0
ypos:   .word   0
hthick: .byte   1
vthick: .byte   1
mode:   .byte   0
tmask:  .byte   0
font:   .addr   A2D_DEFAULT_FONT

        .byte   $FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$FF
.endproc

LD293:
        .byte   px(%1010101)
        .byte   PX(%0101010)
        .byte   px(%1010101)
        .byte   PX(%0101010)
        .byte   px(%1010101)
        .byte   PX(%0101010)
        .byte   px(%1010101)
        .byte   PX(%0101010)

        .byte   $FF,$06,$EA
        .byte   $00,$00,$00,$00,$88,$00,$08,$00
        .byte   $13,$00,$00,$00,$00,$00,$00

;;; Cursors (bitmap - 2x12 bytes, mask - 2x12 bytes, hotspot - 2 bytes)

;;; Pointer

pointer_cursor:
        .byte   px(%0000000),px(%0000000)
        .byte   px(%0100000),px(%0000000)
        .byte   px(%0110000),px(%0000000)
        .byte   px(%0111000),px(%0000000)
        .byte   px(%0111100),px(%0000000)
        .byte   px(%0111110),px(%0000000)
        .byte   px(%0111111),px(%0000000)
        .byte   px(%0101100),px(%0000000)
        .byte   px(%0000110),px(%0000000)
        .byte   px(%0000110),px(%0000000)
        .byte   px(%0000011),px(%0000000)
        .byte   px(%0000000),px(%0000000)
        .byte   px(%1100000),px(%0000000)
        .byte   px(%1110000),px(%0000000)
        .byte   px(%1111000),px(%0000000)
        .byte   px(%1111100),px(%0000000)
        .byte   px(%1111110),px(%0000000)
        .byte   px(%1111111),px(%0000000)
        .byte   px(%1111111),px(%1000000)
        .byte   px(%1111111),px(%0000000)
        .byte   px(%0001111),px(%0000000)
        .byte   px(%0001111),px(%0000000)
        .byte   px(%0000111),px(%1000000)
        .byte   px(%0000111),px(%1000000)
        .byte   1,1

;;; Insertion Point
LD2DF:
        .byte   px(%0000000),px(%0000000)
        .byte   px(%0110001),px(%1000000)
        .byte   px(%0001010),px(%0000000)
        .byte   px(%0000100),px(%0000000)
        .byte   px(%0000100),px(%0000000)
        .byte   px(%0000100),px(%0000000)
        .byte   px(%0000100),px(%0000000)
        .byte   px(%0000100),px(%0000000)
        .byte   px(%0001010),px(%0000000)
        .byte   px(%0110001),px(%1000000)
        .byte   px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000)
        .byte   px(%0110001),px(%1000000)
        .byte   px(%1111011),px(%1100000)
        .byte   px(%0111111),px(%1000000)
        .byte   px(%0001110),px(%0000000)
        .byte   px(%0001110),px(%0000000)
        .byte   px(%0001110),px(%0000000)
        .byte   px(%0001110),px(%0000000)
        .byte   px(%0001110),px(%0000000)
        .byte   px(%0111111),px(%1000000)
        .byte   px(%1111011),px(%1100000)
        .byte   px(%0110001),px(%1000000)
        .byte   px(%0000000),px(%0000000)
        .byte   4, 5

;;; Watch
LD311:
        .byte   px(%0000000),px(%0000000)
        .byte   px(%0011111),px(%1100000)
        .byte   px(%0011111),px(%1100000)
        .byte   px(%0100000),px(%0010000)
        .byte   px(%0100001),px(%0010000)
        .byte   px(%0100110),px(%0011000)
        .byte   px(%0100000),px(%0010000)
        .byte   px(%0100000),px(%0010000)
        .byte   px(%0011111),px(%1100000)
        .byte   px(%0011111),px(%1100000)
        .byte   px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000)
        .byte   px(%0011111),px(%1100000)
        .byte   px(%0111111),px(%1110000)
        .byte   px(%0111111),px(%1110000)
        .byte   px(%1111111),px(%1111000)
        .byte   px(%1111111),px(%1111000)
        .byte   px(%1111111),px(%1111100)
        .byte   px(%1111111),px(%1111000)
        .byte   px(%1111111),px(%1111000)
        .byte   px(%0111111),px(%1110000)
        .byte   px(%0111111),px(%1110000)
        .byte   px(%0011111),px(%1100000)
        .byte   px(%0000000),px(%0000000)
        .byte   5, 5

        .res    384, 0

        .byte   $00,$00

alert_bitmap2:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),px(%0000000),PX(%1111111),PX(%1111111),px(%0000000),px(%0000000)
        .byte   px(%0111100),px(%1111100),px(%0000001),px(%1110000),PX(%0000111),px(%0000000),px(%0000000)
        .byte   px(%0111100),px(%1111100),px(%0000011),px(%1100000),px(%0000011),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0000111),PX(%1100111),px(%1111001),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0001111),PX(%1100111),px(%1111001),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),px(%1111001),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),px(%1110011),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),PX(%1100111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),PX(%1001111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),PX(%1111111),PX(%0011111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),px(%1111110),PX(%0111111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),px(%1111100),PX(%1111111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1111100),PX(%0011111),px(%1111100),PX(%1111111),px(%0000000),px(%0000000)
        .byte   px(%0111110),px(%0000000),PX(%0111111),PX(%1111111),PX(%1111111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1100000),PX(%1111111),px(%1111100),PX(%1111111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1100001),PX(%1111111),PX(%1111111),PX(%1111111),px(%0000000),px(%0000000)
        .byte   px(%0111000),px(%0000011),PX(%1111111),PX(%1111111),px(%1111110),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0111111),px(%1100000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)

LD56D:
        .word   $28, $8         ; left, top
        .addr   alert_bitmap2
        .byte   $07             ; stride
        .byte   $00
        .word   0, 0, $24, $17  ; hoff, voff, width, height

        ;; Looks like window param blocks starting here

.proc winF
id:     .byte   $0F
flags:  .byte   A2D_CWF_NOTITLE
title:  .addr   0
hscroll:.byte   A2D_CWS_NOSCROLL
vscroll:.byte   A2D_CWS_NOSCROLL
hsmax:  .byte   0
hspos:  .byte   0
vsmax:  .byte   0
vspos:  .byte   0
        .byte   0,0             ; ???
w1:     .word   $96
h1:     .word   $32
w2:     .word   $1F4
h2:     .word   $8C
left:   .word   $4B
top:    .word   $23
addr:   .addr   A2D_SCREEN_ADDR
stride: .word   A2D_SCREEN_STRIDE
hoff:   .word   0
voff:   .word   0
width:  .word   $190
height: .word   $64
pattern:.res    8, $FF
mskand: .byte   A2D_DEFAULT_MSKAND
mskor:  .byte   A2D_DEFAULT_MSKOR
xpos:   .word   0
ypos:   .word   0
hthick: .byte   1
vthick: .byte   1
fill:   .byte   0
tmask:  .byte   A2D_DEFAULT_TMASK
font:   .addr   A2D_DEFAULT_FONT
next:   .addr   0
.endproc

.proc win12
id:     .byte   $12
flags:  .byte   A2D_CWF_NOTITLE
title:  .addr   0
hscroll:.byte   A2D_CWS_NOSCROLL
vscroll:.byte   A2D_CWS_NOSCROLL
hsmax:  .byte   0
hspos:  .byte   0
vsmax:  .byte   0
vspos:  .byte   0
        .byte   0,0             ; ???
w1:     .word   $96
h1:     .word   $32
w2:     .word   $1F4
h2:     .word   $8C
left:   .word   $19
top:    .word   $14
addr:   .addr   A2D_SCREEN_ADDR
stride: .word   A2D_SCREEN_STRIDE
hoff:   .word   0
voff:   .word   0
width:  .word   $1F4
height: .word   $99
pattern:.res    8, $FF
mskand: .byte   A2D_DEFAULT_MSKAND
mskor:  .byte   A2D_DEFAULT_MSKOR
xpos:   .word   0
ypos:   .word   0
hthick: .byte   1
vthick: .byte   1
mode:   .byte   0
tmask:  .byte   A2D_DEFAULT_TMASK
font:   .addr   A2D_DEFAULT_FONT
next:   .addr   0
.endproc

.proc win15
id:     .byte   $15
flags:  .byte   A2D_CWF_NOTITLE
title:  .addr   0
hscroll:.byte   A2D_CWS_NOSCROLL
vscroll:.byte   A2D_CWS_SCROLL_NORMAL
hsmax:  .byte   0
hspos:  .byte   0
vsmax:  .byte   3
vspos:  .byte   0
        .byte   0,0             ; ???
w1:     .word   $64
h1:     .word   $46
w2:     .word   $64
h2:     .word   $46
left:   .word   $35
top:    .word   $32
addr:   .addr   A2D_SCREEN_ADDR
stride: .word   A2D_SCREEN_STRIDE
hoff:   .word   0
voff:   .word   0
width:  .word   $7D
height: .word   $46
pattern:.res    8, $FF
mskand: .byte   A2D_DEFAULT_MSKAND
mskor:  .byte   A2D_DEFAULT_MSKOR
xpos:   .word   0
ypos:   .word   0
hthick: .byte   1
vthick: .byte   1
mode:   .byte   0
tmask:  .byte   A2D_DEFAULT_TMASK
font:   .addr   A2D_DEFAULT_FONT
next:   .addr   0
.endproc

.proc win18
id:     .byte   $18
flags:  .byte   A2D_CWF_NOTITLE
title:  .addr   0
hscroll:.byte   A2D_CWS_NOSCROLL
vscroll:.byte   A2D_CWS_NOSCROLL
hsmax:  .byte   0
hspos:  .byte   0
vsmax:  .byte   0
vspos:  .byte   0
        .byte   0,0             ; ???
w1:     .word   $96
h1:     .word   $32
w2:     .word   $1F4
h2:     .word   $8C
state:
left:   .word   $50
top:    .word   $28
addr:   .addr   A2D_SCREEN_ADDR
stride: .word   A2D_SCREEN_STRIDE
hoff:   .word   0
voff:   .word   0
width:  .word   $190
height: .word   $6E
pattern:.res    8, $FF
mskand: .byte   A2D_DEFAULT_MSKAND
mskor:  .byte   A2D_DEFAULT_MSKOR
xpos:   .word   0
ypos:   .word   0
hthick: .byte   1
vthick: .byte   1
mode:   .byte   0
tmask:  .byte   A2D_DEFAULT_TMASK
font:   .addr   A2D_DEFAULT_FONT
next:   .addr   0
.endproc

.proc win1B
id:     .byte   $1B
flags:  .byte   A2D_CWF_NOTITLE
title:  .addr   0
hscroll:.byte   A2D_CWS_NOSCROLL
vscroll:.byte   A2D_CWS_NOSCROLL
hsmax:  .byte   0
hspos:  .byte   0
vsmax:  .byte   0
vspos:  .byte   0
        .byte   0,0             ; ???
w1:     .word   $96
h1:     .word   $32
w2:     .word   $1F4
h2:     .word   $8C
left:   .word   $69
top:    .word   $19
addr:   .addr   A2D_SCREEN_ADDR
stride: .word   A2D_SCREEN_STRIDE
hoff:   .word   0
voff:   .word   0
width:  .word   $15E
height: .word   $6E
pattern:.res    8, $FF
mskand: .byte   A2D_DEFAULT_MSKAND
mskor:  .byte   A2D_DEFAULT_MSKOR
xpos:   .word   0
ypos:   .word   0
hthick: .byte   1
vthick: .byte   1
mode:   .byte   0
tmask:  .byte   A2D_DEFAULT_TMASK
font:   .addr   A2D_DEFAULT_FONT
next:   .addr   0
.endproc

        ;; Coordinates for labels?
        .byte   $28,$00,$25,$00,$68,$01,$2F,$00,$2D,$00,$2E,$00,$28,$00,$3D,$00,$68,$01,$47,$00,$2D,$00,$46,$00,$00,$00,$12,$00,$28,$00,$12,$00,$28,$00,$23,$00,$28,$00,$00,$00

        .word   $4B, $23        ; left, top
        .addr   A2D_SCREEN_ADDR
        .word   A2D_SCREEN_STRIDE
        .word   0, 0            ; width, height

        .byte   $66,$01,$64,$00,$00,$04,$00,$02,$00,$5A,$01,$6C,$00,$05,$00,$03,$00,$59,$01,$6B,$00,$06,$00,$16,$00,$58,$01,$16,$00,$06,$00,$59,$00,$58,$01,$59,$00,$D2,$00,$5C,$00,$36,$01,$67,$00,$28,$00,$5C,$00,$8C,$00,$67,$00,$D7,$00,$66,$00,$2D,$00,$66,$00,$82,$00,$07,$00,$DC,$00,$13,$00

LD718:  PASCAL_STRING "Add an Entry ..."
LD729:  PASCAL_STRING "Edit an Entry ..."
LD73B:  PASCAL_STRING "Delete an Entry ..."
LD74F:  PASCAL_STRING "Run an Entry ..."

LD760:  PASCAL_STRING "Run list"
        PASCAL_STRING "Enter the full pathname of the run list file:"
        PASCAL_STRING "Enter the name (14 characters max)  you wish to appear in the run list"
        PASCAL_STRING "Add a new entry to the:"
        PASCAL_STRING {A2D_GLYPH_OAPPLE,"1 Run list"}
        PASCAL_STRING {A2D_GLYPH_OAPPLE,"2 Other Run list"}
        PASCAL_STRING "Down load:"
        PASCAL_STRING {A2D_GLYPH_OAPPLE,"3 at first boot"}
        PASCAL_STRING {A2D_GLYPH_OAPPLE,"4 at first use"}
        PASCAL_STRING {A2D_GLYPH_OAPPLE,"5 never"}
        PASCAL_STRING "Enter the full pathname of the run list file:"

        .byte   $00,$00,$00,$00,$00,$00,$00
        .byte   $00,$06,$00,$17,$00,$58,$01,$57
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00

        PASCAL_STRING "the DOS 3.3 disk in slot   drive   ?"

        .byte   $1A,$22

        PASCAL_STRING "the disk in slot   drive   ?"

        .byte   $12
        .byte   $1A,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$14,$00,$00,$00,$00
        .byte   $01,$06,$00,$00,$00,$00,$00,$00
        .byte   $01,$00

        PASCAL_STRING "  "

        PASCAL_STRING "Files"

        PASCAL_STRING "       "

        .byte   $00,$00,$00,$00,$0D
        .byte   $00,$00,$00,$00,$00,$7D,$00,$00
        .byte   $00,$02,$00,$00,$00,$00,$00,$02
        .byte   $01,$02,$00,$00,$57,$01,$28,$00
        .byte   $6B,$01,$30,$00,$6B,$01,$38,$00
        .byte   $57,$01,$4B,$00,$6B,$01,$53,$00
        .byte   $6B,$01,$5B,$00,$6B,$01,$63,$00
        .byte   $5A,$01,$29,$00,$64,$01,$2F,$00
        .byte   $5A,$01,$31,$00,$64,$01,$37,$00
        .byte   $5A,$01,$4C,$00,$64,$01,$52,$00
        .byte   $5A,$01,$54,$00,$64,$01,$5A,$00
        .byte   $5A,$01,$5C,$00,$64,$01,$62,$00
        .byte   $5A,$01,$29,$00,$E0,$01,$30,$00
        .byte   $5A,$01,$31,$00,$E0,$01,$37,$00
        .byte   $5A,$01,$4C,$00,$E0,$01,$53,$00
        .byte   $5A,$01,$54,$00,$E0,$01,$5B,$00
        .byte   $5A,$01,$5C,$00,$E0,$01,$63,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$04,$00,$02,$00,$F0,$01
        .byte   $97,$00,$1B,$00,$10,$00,$AE,$00
        .byte   $1A,$00,$C1,$00,$3A,$00,$25,$01
        .byte   $45,$00,$C1,$00,$59,$00,$25,$01
        .byte   $64,$00,$C1,$00,$2C,$00,$25,$01
        .byte   $37,$00,$C1,$00,$49,$00,$25,$01
        .byte   $54,$00,$C1,$00,$1E,$00,$25,$01
        .byte   $29,$00,$43,$01,$1E,$00,$43,$01
        .byte   $64,$00,$81,$D3,$00

        .word   $C6,$63
        PASCAL_STRING {"OK            ",A2D_GLYPH_RETURN}

        .word   $C6,$44
        PASCAL_STRING "Close"

        .word   $C6,$36
        PASCAL_STRING "Open"

        .word   $C6,$53
        PASCAL_STRING "Cancel        Esc"

        .word   $C6,$28
        PASCAL_STRING "Change Drive"

        .byte   $1C,$00,$19,$00,$1C
        .byte   $00,$70,$00,$1C,$00,$87,$00,$00
        .byte   $7F

        PASCAL_STRING " Disk: "

        PASCAL_STRING "Copy a File ..."
        PASCAL_STRING "Source filename:"
        PASCAL_STRING "Destination filename:"

        .byte   $1C,$00,$71,$00,$CF,$01,$7C,$00
        .byte   $1E,$00,$7B,$00,$1C,$00,$88,$00
        .byte   $CF,$01,$93,$00,$1E,$00,$92,$00

        PASCAL_STRING "Delete a File ..."
        PASCAL_STRING "File to delete:"

        .res    40, 0

        .addr   sd0s, sd1s, sd2s, sd3s, sd4s, sd5s, sd6s
        .addr   sd7s, sd8s, sd9s, sd10s, sd11s, sd12s, sd13s

        .addr   selector_menu

        ;; Buffer for Run List entries
run_list_entries:
        .res    896, 0

        .byte   $00

        ;; Used by DESKTOP_COPY_*_BUF
        .assert * = bufnum, error, "Entry point mismatch"
bufnum: .byte   $00
buf3len:.byte   0
buf3:   .res    256, 0

        ;; Buffer for desktop windows
win_table:
        .addr   0,win1,win2,win3,win4,win5,win6,win7,win8

        .addr   $0000
        .repeat 8,i
        .addr   buf2+i*$41
        .endrepeat

        .byte   $00,$00,$00,$00,$00

        .res    144, 0

        .byte   $00,$00,$00,$00,$0D,$00,$00,$00

        .res    440, 0

        .byte   $00,$00,$00,$00,$7F,$64,$00,$1C
        .byte   $00,$1E,$00,$32,$00,$1E,$00,$40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$04,$00,$00,$00,$04,$00,$00
        .byte   $04,$00,$00,$00,$00,$00,$04,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00

        .addr   str_all

LE27C:  DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM sd0s
        DEFINE_MENU_ITEM sd1s
        DEFINE_MENU_ITEM sd2s
        DEFINE_MENU_ITEM sd3s
        DEFINE_MENU_ITEM sd4s
        DEFINE_MENU_ITEM sd5s
        DEFINE_MENU_ITEM sd6s
        DEFINE_MENU_ITEM sd7s
        DEFINE_MENU_ITEM sd8s
        DEFINE_MENU_ITEM sd9s
        DEFINE_MENU_ITEM sd10s
        DEFINE_MENU_ITEM sd11s
        DEFINE_MENU_ITEM sd12s
        DEFINE_MENU_ITEM sd13s

startup_menu:
        DEFINE_MENU 7
        DEFINE_MENU_ITEM s00
        DEFINE_MENU_ITEM s01
        DEFINE_MENU_ITEM s02
        DEFINE_MENU_ITEM s03
        DEFINE_MENU_ITEM s04
        DEFINE_MENU_ITEM s05
        DEFINE_MENU_ITEM s06

str_all:PASCAL_STRING "All"

sd0:    A2D_DEFSTRING "Slot    drive       ", sd0s
sd1:    A2D_DEFSTRING "Slot    drive       ", sd1s
sd2:    A2D_DEFSTRING "Slot    drive       ", sd2s
sd3:    A2D_DEFSTRING "Slot    drive       ", sd3s
sd4:    A2D_DEFSTRING "Slot    drive       ", sd4s
sd5:    A2D_DEFSTRING "Slot    drive       ", sd5s
sd6:    A2D_DEFSTRING "Slot    drive       ", sd6s
sd7:    A2D_DEFSTRING "Slot    drive       ", sd7s
sd8:    A2D_DEFSTRING "Slot    drive       ", sd8s
sd9:    A2D_DEFSTRING "Slot    drive       ", sd9s
sd10:   A2D_DEFSTRING "Slot    drive       ", sd10s
sd11:   A2D_DEFSTRING "Slot    drive       ", sd11s
sd12:   A2D_DEFSTRING "Slot    drive       ", sd12s
sd13:   A2D_DEFSTRING "Slot    drive       ", sd13s

s00:    PASCAL_STRING "Slot 0 "
s01:    PASCAL_STRING "Slot 0 "
s02:    PASCAL_STRING "Slot 0 "
s03:    PASCAL_STRING "Slot 0 "
s04:    PASCAL_STRING "Slot 0 "
s05:    PASCAL_STRING "Slot 0 "
s06:    PASCAL_STRING "Slot 0 "

        .addr   sd0, sd1, sd2, sd3, sd4, sd5, sd6, sd7
        .addr   sd8, sd9, sd10, sd11, sd12, sd13

        PASCAL_STRING "ProFile Slot x     "
        PASCAL_STRING "UniDisk 3.5  Sx,y  "
        PASCAL_STRING "RAMCard Slot x      "
        PASCAL_STRING "Slot    drive       "

selector_menu:
        DEFINE_MENU 5
        DEFINE_MENU_ITEM label_add
        DEFINE_MENU_ITEM label_edit
        DEFINE_MENU_ITEM label_del
        DEFINE_MENU_ITEM label_run, '0', '0'
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM run_list_entries + 0 * $10, '1', '1'
        DEFINE_MENU_ITEM run_list_entries + 1 * $10, '2', '2'
        DEFINE_MENU_ITEM run_list_entries + 2 * $10, '3', '3'
        DEFINE_MENU_ITEM run_list_entries + 3 * $10, '4', '4'
        DEFINE_MENU_ITEM run_list_entries + 4 * $10, '5', '5'
        DEFINE_MENU_ITEM run_list_entries + 5 * $10, '6', '6'
        DEFINE_MENU_ITEM run_list_entries + 6 * $10, '7', '7'
        DEFINE_MENU_ITEM run_list_entries + 7 * $10, '8', '8'

label_add:
        PASCAL_STRING "Add an Entry ..."
label_edit:
        PASCAL_STRING "Edit an Entry ..."
label_del:
        PASCAL_STRING "Delete an Entry ...      "
label_run:
        PASCAL_STRING "Run an Entry ..."

        ;; Apple Menu
apple_menu:
        DEFINE_MENU 1
        DEFINE_MENU_ITEM label_about
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM buf + 0 * $10
        DEFINE_MENU_ITEM buf + 1 * $10
        DEFINE_MENU_ITEM buf + 2 * $10
        DEFINE_MENU_ITEM buf + 3 * $10
        DEFINE_MENU_ITEM buf + 4 * $10
        DEFINE_MENU_ITEM buf + 5 * $10
        DEFINE_MENU_ITEM buf + 6 * $10
        DEFINE_MENU_ITEM buf + 7 * $10

label_about:
        PASCAL_STRING "About Apple II DeskTop ... "

buf:    .res    $80, 0

        .byte   $01,$00,$01,$00,$9A,$E6,$8E,$E6
        .byte   $00,$00,$00,$00,$00,$00,$01,$00
        .byte   $01,$00,$B7,$E6,$8E,$E6,$00,$00
        .byte   $00,$00,$00,$00,$01,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$B9,$E6

        PASCAL_STRING "Apple II DeskTop Version 1.1"

        .byte   $01,$20,$04
        .byte   $52,$69,$65,$6E,$00,$00,$00,$5D
        .byte   $E7,$A9,$E7,$F5,$E7,$41,$E8,$8D
        .byte   $E8,$D9,$E8,$25,$E9,$71,$E9,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$70,$00,$00,$00,$8C
        .byte   $00,$00,$00,$E7,$00,$00,$00

.proc text_buffer2
        .addr   data
        .byte   0
data:   .res    55, 0
.endproc

.macro WIN_PARAMS_DEFN window_id, label, buflabel
.proc label
id:     .byte   window_id
flags:  .byte   A2D_CWF_ADDCLOSE | A2D_CWF_ADDRESIZE
title:  .addr   buflabel
hscroll:.byte   A2D_CWS_SCROLL_NORMAL
vscroll:.byte   A2D_CWS_SCROLL_NORMAL
hsmax:  .byte   3
hspos:  .byte   0
vsmax:  .byte   3
vspos:  .byte   0
        .byte   0,0             ; ???
w1:     .word   170
h1:     .word   50
w2:     .word   545
h2:     .word   175
left:   .word   20
top:    .word   27
addr:   .addr   A2D_SCREEN_ADDR
stride: .word   A2D_SCREEN_STRIDE
hoff:   .word   0
voff:   .word   0
width:  .word   440
height: .word   120
pattern:.res    8, $FF
mskand: .byte   A2D_DEFAULT_MSKAND
mskor:  .byte   A2D_DEFAULT_MSKOR
xpos:   .word   0
ypos:   .word   0
hthick: .byte   1
vthick: .byte   1
mode:   .byte   0
tmask:  .byte   A2D_DEFAULT_TMASK
font:   .addr   A2D_DEFAULT_FONT
next:   .addr   0
.endproc
buflabel:.res    18, 0
.endmacro

        WIN_PARAMS_DEFN 1, win1, win1buf
        WIN_PARAMS_DEFN 2, win2, win2buf
        WIN_PARAMS_DEFN 3, win3, win3buf
        WIN_PARAMS_DEFN 4, win4, win4buf
        WIN_PARAMS_DEFN 5, win5, win5buf
        WIN_PARAMS_DEFN 6, win6, win6buf
        WIN_PARAMS_DEFN 7, win7, win7buf
        WIN_PARAMS_DEFN 8, win8, win8buf

buf2:   .res    560, 0

        PASCAL_STRING " Items"

        .byte   $08,$00,$0A,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00

        PASCAL_STRING "K in disk"
        PASCAL_STRING "K available"
        PASCAL_STRING "      "

        .byte   $00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00

        ;; Used by DESKTOP_COPY_*_BUF
table1: .addr   $1B00,$1B80,$1C00,$1C80,$1D00,$1D80,$1E00,$1E80,$1F00
table2: .addr   $1B01,$1B81,$1C01,$1C81,$1D01,$1D81,$1E01,$1E81,$1F01

desktop_winid:
        .byte   $00

        .res    64, 0
        .word   500, 160
        .res    150, 0

        .assert * = $ED00, error, "Segment expected to fill through $ED00"

;;; ==================================================
;;;
;;; $ED00 - $FAFF is data buffers
;;;
;;; ==================================================

        .org $FB00

LFB00:  .addr type_table
LFB02:  .addr type_icons
LFB04:  .addr LFB11
LFB06:  .addr type_names

type_table:
        .byte   8
        .byte   FT_TYPELESS, FT_SRC, FT_TEXT, FT_BINARY
        .byte   FT_DIRECTORY, FT_SYSTEM, FT_BASIC, FT_BAD

        ;; ???
LFB11:  .byte   $60,$50,$50,$50,$20,$00,$10,$30,$10

type_names:
        .byte   " ???"

        ;; Same order as icon list below
        .byte   " ???", " SRC", " TXT", " BIN"
        .byte   " DIR", " SYS", " BAS", " SYS"

        .byte   " BAD"

type_icons:
        .addr  gen, src, txt, bin, dir, sys, bas, app

.macro  DEFICON addr, stride, left, top, width, height
        .addr   addr
        .word   stride, left, top, width, height
.endmacro

gen:    DEFICON generic_icon, 4, 0, 0, 27, 17
src:
txt:    DEFICON text_icon, 4, 0, 0, 27, 17
bin:    DEFICON binary_icon, 4, 0, 0, 27, 17
dir:    DEFICON folder_icon, 4, 0, 0, 27, 17
sys:    DEFICON sys_icon, 4, 0, 0, 27, 17
bas:    DEFICON basic_icon, 4, 0, 0, 27, 17
app:    DEFICON app_icon, 5, 0, 0, 34, 17

;;; Generic

generic_icon:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1000000)
        .byte   px(%1000000),px(%0000000),PX(%0000001),px(%1100000)
        .byte   px(%1000000),px(%0000000),PX(%0000001),px(%0110000)
        .byte   px(%1000000),px(%0000000),PX(%0000001),px(%0011000)
        .byte   px(%1000000),px(%0000000),PX(%0000001),PX(%0001100)
        .byte   px(%1000000),px(%0000000),PX(%0000001),PX(%0000110)
        .byte   px(%1000000),px(%0000000),PX(%0000001),PX(%0000011)
        .byte   px(%1000000),px(%0000000),PX(%0000001),PX(%1111111)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)

generic_mask:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1000000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1100000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1110000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1111000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1111100)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1111110)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)

;;; Text File

text_icon:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1000000)
        .byte   px(%1000000),px(%0000000),PX(%0000001),px(%1100000)
        .byte   px(%1001100),px(%0111110),PX(%0111111),px(%0110000)
        .byte   px(%1000000),px(%0000000),PX(%0000001),px(%0011000)
        .byte   px(%1001111),px(%1100111),px(%1000001),PX(%0001100)
        .byte   px(%1000000),px(%0000000),px(%0000001),px(%0000110)
        .byte   px(%1001111),px(%0011110),px(%0110001),PX(%0000011)
        .byte   px(%1000000),px(%0000000),PX(%0000001),PX(%1111111)
        .byte   px(%1000000),px(%0000000),px(%0000000),px(%0000001)
        .byte   px(%1001111),px(%1100110),px(%0111100),px(%1111001)
        .byte   px(%1000000),px(%0000000),px(%0000000),px(%0000001)
        .byte   px(%1001111),px(%0011110),px(%1111111),px(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1001111),px(%0011111),px(%1001111),px(%1100001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)

text_mask:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1000000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1100000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1110000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1111000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1111100)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),px(%1111110)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)

;;; Binary

binary_icon:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),PX(%0000001),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0000110),px(%0110000),px(%0000000)
        .byte   px(%0000000),px(%0011000),px(%0001100),px(%0000000)
        .byte   px(%0000000),px(%1100000),px(%0000011),px(%0000000)
        .byte   px(%0000011),px(%0000000),px(%0000000),px(%1100000)
        .byte   px(%0001100),px(%0011000),px(%0011000),px(%0011000)
        .byte   px(%0110000),px(%0100100),px(%0101000),px(%0000110)
        .byte   px(%1000000),px(%0100100),px(%0001000),px(%0000001)
        .byte   px(%0110000),px(%0100100),px(%0001000),px(%0000110)
        .byte   px(%0001100),px(%0011000),px(%0001000),px(%0011000)
        .byte   px(%0000011),px(%0000000),px(%0000000),px(%1100000)
        .byte   px(%0000000),px(%1100000),px(%0000011),px(%0000000)
        .byte   px(%0000000),px(%0011000),px(%0001100),px(%0000000)
        .byte   px(%0000000),px(%0000110),px(%0110000),px(%0000000)
        .byte   px(%0000000),PX(%0000001),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)

binary_mask:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),PX(%0000001),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0000111),px(%1110000),px(%0000000)
        .byte   px(%0000000),PX(%0011111),px(%1111100),px(%0000000)
        .byte   px(%0000000),PX(%1111111),PX(%1111111),px(%0000000)
        .byte   px(%0000011),PX(%1111111),PX(%1111111),px(%1100000)
        .byte   PX(%0001111),PX(%1111111),PX(%1111111),px(%1111000)
        .byte   PX(%0111111),PX(%1111111),PX(%1111111),px(%1111110)
        .byte   PX(%0001111),PX(%1111111),PX(%1111111),px(%1111000)
        .byte   px(%0000011),PX(%1111111),PX(%1111111),px(%1100000)
        .byte   px(%0000000),PX(%1111111),PX(%1111111),px(%0000000)
        .byte   px(%0000000),PX(%0011111),px(%1111100),px(%0000000)
        .byte   px(%0000000),px(%0000111),px(%1110000),px(%0000000)
        .byte   px(%0000000),PX(%0000001),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)

;;; Folder
folder_icon:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0011111),px(%1111110),px(%0000000),px(%0000000)
        .byte   px(%0100000),px(%0000001),px(%0000000),px(%0000000)
        .byte   PX(%0111111),PX(%1111111),PX(%1111111),px(%1111110)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   px(%1000000),px(%0000000),px(%0000000),PX(%0000001)
        .byte   PX(%0111111),PX(%1111111),PX(%1111111),px(%1111110)

folder_mask:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   PX(%0011111),px(%1111110),px(%0000000),px(%0000000)
        .byte   PX(%0111111),PX(%1111111),px(%0000000),px(%0000000)
        .byte   PX(%0111111),PX(%1111111),PX(%1111111),px(%1111110)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%0111111),PX(%1111111),PX(%1111111),px(%1111110)

;;; System (no .SYSTEM suffix)

sys_icon:
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0110000),px(%0000000),px(%0000000),px(%0000110)
        .byte   px(%0110011),px(%1111111),px(%1111111),px(%1100110)
        .byte   px(%0110011),px(%0000000),px(%0010000),px(%1100110)
        .byte   px(%0110011),px(%0000000),px(%0100000),px(%1100110)
        .byte   px(%0110011),px(%0010000),px(%1000100),px(%1100110)
        .byte   px(%0110011),px(%0100000),px(%0001000),px(%1100110)
        .byte   px(%0110011),px(%1111111),px(%1111111),px(%1100110)
        .byte   px(%0110000),px(%0000000),px(%0000000),px(%0000110)
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%1111111),px(%1111111),px(%1111111),px(%1111111)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000011)
        .byte   px(%1100110),px(%0000000),px(%0000000),px(%0000011)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000011)
        .byte   px(%1111111),px(%1111111),px(%1111111),px(%1111111)
        .byte   px(%1100000),px(%0000000),px(%0000000),px(%0000011)
        .byte   px(%1111111),px(%1111111),px(%1111111),px(%1111111)

sys_mask:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0001111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0011111),px(%1111111),px(%1111111),px(%1111100)
        .byte   px(%0011111),px(%1111111),px(%1111111),px(%1111100)
        .byte   px(%0011111),px(%1111111),px(%1111111),px(%1111100)
        .byte   px(%0011111),px(%1111111),px(%1111111),px(%1111100)
        .byte   px(%0011111),px(%1111111),px(%1111111),px(%1111100)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)

;;; Basic

basic_icon:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),PX(%0000001),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0000110),px(%0110000),px(%0000000)
        .byte   px(%0000000),px(%0011000),px(%0001100),px(%0000000)
        .byte   px(%0000000),px(%1100000),px(%0000011),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0111110),px(%0111000),px(%1111010),px(%0111100)
        .byte   px(%0100010),px(%1000100),px(%1000010),px(%1000110)
        .byte   px(%0111100),px(%1111100),px(%1111010),px(%1000000)
        .byte   px(%0100010),px(%1000100),px(%0001010),px(%1000110)
        .byte   px(%0111110),px(%1000100),px(%1111010),px(%0111100)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%1100000),px(%0000011),px(%0000000)
        .byte   px(%0000000),px(%0011000),px(%0001100),px(%0000000)
        .byte   px(%0000000),px(%0000110),px(%0110000),px(%0000000)
        .byte   px(%0000000),PX(%0000001),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)

basic_mask:
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),PX(%0000001),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0000111),px(%1110000),px(%0000000)
        .byte   px(%0000000),PX(%0011111),px(%1111100),px(%0000000)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   PX(%1111111),PX(%1111111),PX(%1111111),PX(%1111111)
        .byte   px(%0000000),PX(%0011111),px(%1111100),px(%0000000)
        .byte   px(%0000000),px(%0000111),px(%1110000),px(%0000000)
        .byte   px(%0000000),PX(%0000001),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000)

;;; System (with .SYSTEM suffix)

app_icon:
        .byte   px(%0000000),px(%0000000),px(%0011000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%1100110),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000011),px(%0000001),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0001100),px(%0000000),px(%0110000),px(%0000000)
        .byte   px(%0000000),px(%0110000),px(%0000000),px(%0001100),px(%0000000)
        .byte   px(%0000001),px(%1000000),px(%0000000),px(%0000011),px(%0000000)
        .byte   px(%0000110),px(%0000000),px(%0000000),px(%0000000),px(%1100000)
        .byte   px(%0011000),px(%0000000),px(%0000001),px(%1111100),px(%0011000)
        .byte   px(%1100000),px(%0000000),px(%0000110),px(%0000011),px(%0000110)
        .byte   px(%0011000),px(%0000000),px(%0011000),px(%1110000),px(%1111000)
        .byte   px(%0000110),px(%0000111),px(%1111111),px(%1111100),px(%0011110)
        .byte   px(%0000001),px(%1000000),px(%0110000),px(%1100000),px(%0011110)
        .byte   px(%0000000),px(%0110000),px(%0001110),px(%0000000),px(%0011110)
        .byte   px(%0000000),px(%0001100),px(%0000001),PX(%1111111),px(%1111110)
        .byte   px(%0000000),px(%0000011),px(%0000001),px(%1000000),px(%0011110)
        .byte   px(%0000000),px(%0000000),px(%1100110),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0011000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)

app_mask:
        .byte   px(%0000000),px(%0000000),px(%0011000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%1111110),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000011),px(%1111111),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0001111),px(%1111111),px(%1110000),px(%0000000)
        .byte   px(%0000000),px(%0111111),px(%1111111),px(%1111100),px(%0000000)
        .byte   px(%0000001),px(%1111111),px(%1111111),px(%1111111),px(%0000000)
        .byte   px(%0000111),px(%1111111),px(%1111111),px(%1111111),px(%1100000)
        .byte   px(%0011111),px(%1111111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%1111111),px(%1111111),px(%1111111),px(%1111111),px(%1111110)
        .byte   px(%0011111),px(%1111111),px(%1111111),px(%1111111),px(%1111100)
        .byte   px(%0000111),px(%1111111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0000001),px(%1111111),px(%1111111),px(%1111111),px(%1111000)
        .byte   px(%0000000),px(%0111111),px(%1111111),px(%1111100),px(%1111000)
        .byte   px(%0000000),px(%0001111),px(%1111111),px(%1111000),px(%0000000)
        .byte   px(%0000000),px(%0000011),px(%1111111),px(%1000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%1111110),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0011000),px(%0000000),px(%0000000)
        .byte   px(%0000000),px(%0000000),px(%0000000),px(%0000000),px(%0000000)

        .res    70, 0

.proc desktop_main
L0000           := $0000
L0006           := $0006
L0020           := $0020
L0800           := $0800
L0CB8           := $0CB8
L0CD7           := $0CD7
L0CF9           := $0CF9
L0D14           := $0D14

        .org $4000

        ;; Jump table
L4000:  jmp     L4042
L4003:  jmp     A2D_RELAY
L4006:  jmp     L8259
L4009:  jmp     L830F
        jmp     L5E78
        jmp     DESKTOP_AUXLOAD
L4012:  jmp     L5050
L4015:  jmp     L40F2
L4018:  jmp     DESKTOP_RELAY
        jmp     L8E81
L401E:  jmp     L6D2B
L4021:  jmp     L46BA
        jmp     DESKTOP_COPY_TO_BUF
        jmp     DESKTOP_COPY_FROM_BUF
        jmp     L490E
L402D:  jmp     L8707
L4030:  jmp     DESKTOP_SHOW_ALERT0
L4033:  jmp     DESKTOP_SHOW_ALERT
        jmp     L46DE
        jmp     L489A
        jmp     L488A
        jmp     L8E89

        ;; API entry point
L4042:  cli
        sta     ALTZPON
        lda     LCBANK1
        lda     LCBANK1
        jsr     L4530
        ldx     #$00
L4051:  cpx     buf3len
        beq     L4069
        txa
        pha
        lda     buf3,x
        jsr     L86E3
        ldy     #$01
        jsr     DESKTOP_RELAY
        pla
        tax
        inx
        jmp     L4051

L4069:  lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_FROM_BUF
        lda     #$00
        sta     $D2A9
        sta     $D2AA
        sta     L40DF
        sta     $E26F
        lda     L599F
        beq     L4088
        tay
        jsr     DESKTOP_SHOW_ALERT0
L4088:  jsr     L4510
        inc     L40DF
        inc     L40DF
        lda     L40DF
        cmp     $D2AB
        bcc     L40A6
        lda     #$00
        sta     L40DF
        jsr     L4563
        beq     L40A6
        jsr     L40E0
L40A6:  jsr     L464E
        jsr     L48E6
        lda     $D208
        cmp     #$01
        beq     L40B7
        cmp     #$05
        bne     L40BD
L40B7:  jsr     L43E7
        jmp     L4088

L40BD:  cmp     #$03
        bne     L40C7
        jsr     L435A
        jmp     L4088

L40C7:  cmp     #$06
        bne     L40DC
        jsr     L4510
        lda     desktop_winid
        sta     L40F0
        lda     #$80
        sta     L40F1
        jsr     L410D
L40DC:  jmp     L4088

L40DF:  .byte   $00
L40E0:  tsx
        stx     $E256
        sta     $E25B
        jsr     L59A0
        lda     #$00
        sta     $E25B
        rts

L40F0:  .byte   $00
L40F1:  .byte   $00
L40F2:  jsr     L4510
        lda     desktop_winid
        sta     L40F0
        lda     #$00
        sta     L40F1
L4100:  jsr     L48F0
        lda     $D208
        cmp     #$06
        bne     L412B
        jsr     L48E6
L410D:  jsr     L4113
        jmp     L4100

L4113:  A2D_RELAY_CALL A2D_REDRAW_WINDOW, $D209
        bne     L4151
        jsr     L4153
        A2D_RELAY_CALL $3F      ; ???
        rts

L412B:  lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     L40F0
        sta     desktop_winid
        beq     L4143
        bit     L4CA1
        bmi     L4143
        jsr     L4244
L4143:  bit     L40F1
        bpl     L4151
        DESKTOP_RELAY_CALL DESKTOP_REDRAW_ICONS
L4151:  rts

L4152:  .byte   0
L4153:  lda     $D209
        cmp     #$09
        bcc     L415B
        rts

L415B:  sta     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     #$80
        sta     L4152
        lda     bufnum
        sta     $D212
        jsr     L4505
        jsr     L78EF
        lda     desktop_winid
        jsr     L8855
        jsr     DESKTOP_ASSIGN_STATE
        lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$16
        lda     (L0006),y
        sec
        sbc     $D217
        sta     L4242
        iny
        lda     (L0006),y
        sbc     $D218
        sta     L4243
        lda     L4242
        cmp     #$0F
        lda     L4243
        sbc     #$00
        bpl     L41CB
        jsr     L6E8A
        ldx     #$0B
        ldy     #$1F
        lda     $D215,x
        sta     (L0006),y
        dey
        dex
        lda     $D215,x
        sta     (L0006),y
        ldx     #$03
        ldy     #$17
        lda     $D215,x
        sta     (L0006),y
        dey
        dex
        lda     $D215,x
        sta     (L0006),y
L41CB:  ldx     bufnum
        dex
        lda     $E6D1,x
        bpl     L41E2
        jsr     L6C19
        lda     #$00
        sta     L4152
        lda     desktop_winid
        jmp     L8874

L41E2:  lda     bufnum
        sta     $D212
        jsr     L44F2
        jsr     L6E52
        ldx     #$07
L41F0:  lda     $D21D,x
        sta     $E230,x
        dex
        bpl     L41F0
        lda     #$00
        sta     L4241
L41FE:  lda     L4241
        cmp     buf3len
        beq     L4227
        tax
        lda     buf3,x
        sta     $E22F
        DESKTOP_RELAY_CALL $0D, $E22F
        beq     L4221
        DESKTOP_RELAY_CALL $03, $E22F
L4221:  inc     L4241
        jmp     L41FE

L4227:  lda     #$00
        sta     L4152
        lda     bufnum
        sta     $D212
        jsr     L44F2
        jsr     L6E6E
        lda     desktop_winid
        jsr     L8874
        jmp     L4510

L4241:  .byte   0
L4242:  .byte   0
L4243:  .byte   0
L4244:  lda     $DF21
        bne     L424A
L4249:  rts

L424A:  lda     #$00
        sta     L42C3
        lda     $DF20
        beq     L42A5
        cmp     desktop_winid
        bne     L4249
        lda     desktop_winid
        sta     $D212
        jsr     L4505
        jsr     L6E8E
        ldx     #$07
L4267:  lda     $D21D,x
        sta     $E230,x
        dex
        bpl     L4267
L4270:  lda     L42C3
        cmp     $DF21
        beq     L42A2
        tax
        lda     $DF22,x
        sta     $E22F
        jsr     L8915
        DESKTOP_RELAY_CALL $0D, $E22F
        beq     L4296
        DESKTOP_RELAY_CALL $03, $E22F
L4296:  lda     $E22F
        jsr     L8893
        inc     L42C3
        jmp     L4270

L42A2:  jmp     L4510

L42A5:  lda     L42C3
        cmp     $DF21
        beq     L42A2
        tax
        lda     $DF22,x
        sta     $E22F
        DESKTOP_RELAY_CALL $03, $E22F
        inc     L42C3
        jmp     L42A5

L42C3:  .byte   $00
L42C4:  .byte   $B2
L42C5:  .byte   $4B,$0E,$49,$BF,$4B,$BF,$4B,$BF
        .byte   $4B,$BF,$4B,$BF,$4B,$BF,$4B,$BF
        .byte   $4B,$BF,$4B,$B7,$4F,$0E,$49,$EA
        .byte   $4D,$72,$4E,$50,$4F,$62,$56,$0E
        .byte   $49,$A2,$4C,$5F,$4D,$0E,$49,$50
        .byte   $50,$AA,$50,$0F,$49,$0F,$49,$0F
        .byte   $49,$0F,$49,$0E,$49,$A2,$49,$A2
        .byte   $49,$A2,$49,$A2,$49,$A2,$49,$A2
        .byte   $49,$A2,$49,$A2,$49,$F9,$50,$67
        .byte   $52,$85,$52,$A3,$52,$C1,$52,$01
        .byte   $59,$0E,$49,$40,$53,$5B,$53,$5C
        .byte   $4F,$0E,$49,$87,$53,$81,$53,$0E
        .byte   $49,$75,$53,$7B,$53,$0E,$49,$8D
        .byte   $53,$01,$59,$0E,$49,$A0,$59,$A0
        .byte   $59,$A0,$59,$A0,$59,$A0,$59,$A0
        .byte   $59,$A0,$59,$A0,$59,$D1,$5A,$D1
        .byte   $5A,$D1,$5A,$D1,$5A,$D1,$5A,$D1
        .byte   $5A,$D1,$5A
L4350:  .byte   $00,$14,$2C,$46,$50,$50,$6A,$7E
        .byte   $8C
L4359:  .byte   $00
L435A:  lda     $D20A
        bne     L4362
        jmp     L4394

L4362:  cmp     #$03
        bne     L4367
        rts

L4367:  lda     $D209
        ora     #$20
        cmp     #$68
        bne     L4373
        jmp     L5441

L4373:  bit     L4359
        bpl     L4394
        cmp     #$77
        bne     L437F
        jmp     L5702

L437F:  cmp     #$67
        bne     L4386
        jmp     L578E

L4386:  cmp     #$6D
        bne     L438D
        jmp     L579A

L438D:  cmp     #$78
        bne     L4394
        jmp     L57A6

L4394:  lda     $D209
        sta     $E25C
        lda     $D20A
        beq     L43A1
        lda     #$01
L43A1:  sta     $E25D
        A2D_RELAY_CALL $32, $E25A ; ???
L43AD:  ldx     $E25A
        bne     L43B3
        rts

L43B3:  dex
        lda     L4350,x
        tax
        ldy     $E25B
        dey
        tya
        asl     a
        sta     L43E5
        txa
        clc
        adc     L43E5
        tax
        lda     L42C4,x
        sta     L43E5
        lda     L42C5,x
        sta     L43E5+1
        jsr     L43E0
        A2D_RELAY_CALL $33, $E25A ; ???
        rts

L43E0:  tsx
        stx     $E256
        L43E5 := *+1
        jmp     $1234           ; self-modified
L43E7:  tsx
        stx     $E256
        A2D_RELAY_CALL A2D_QUERY_TARGET, $D209
        lda     $D20D
        bne     L4418
        jsr     L85FC
        sta     $D2AA
        lda     #$00
        sta     $D20E
        DESKTOP_RELAY_CALL $09, $D209
        lda     $D20D
        beq     L4415
        jmp     L67D7

L4415:  jmp     L68AA

L4418:  cmp     #$01
        bne     L4428
        A2D_RELAY_CALL A2D_MENU_CLICK, $E25A
        jmp     L43AD

L4428:  pha
        lda     desktop_winid
        cmp     $D20E
        beq     L4435
        pla
        jmp     L4459

L4435:  pla
        cmp     #$02
        bne     L4443
        jsr     L85FC
        sta     $D2AA
        jmp     L5B1C

L4443:  cmp     #$03
        bne     L444A
        jmp     L60DB

L444A:  cmp     #$04
        bne     L4451
        jmp     L619B

L4451:  cmp     #$05
        bne     L4458
        jmp     L61CA

L4458:  rts

L4459:  jmp     L445D

L445C:  .byte   0
L445D:  jsr     L6D2B
        ldx     $D20E
        dex
        lda     $EC26,x
        sta     $E22F
        lda     $E22F
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$01
        lda     (L0006),y
        beq     L44A6
        ora     #$80
        sta     (L0006),y
        iny
        lda     (L0006),y
        and     #$0F
        sta     L445C
        jsr     L8997
        DESKTOP_RELAY_CALL $02, $E22F
        jsr     L4510
        lda     L445C
        sta     $DF20
        lda     #$01
        sta     $DF21
        lda     $E22F
        sta     $DF22
L44A6:  A2D_RELAY_CALL A2D_RAISE_WINDOW, $D20E
        lda     $D20E
        sta     desktop_winid
        sta     bufnum
L44B8:  jsr     DESKTOP_COPY_TO_BUF
        jsr     L6C19
        lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     #$00
        sta     $E269
        A2D_RELAY_CALL $36, $E267 ; ???
        ldx     desktop_winid
        dex
        lda     $E6D1,x
        and     #$0F
        sta     $E268
        inc     $E268
        lda     #$01
        sta     $E269
        A2D_RELAY_CALL $36, $E267 ; ???
        rts

L44F2:  A2D_RELAY_CALL A2D_QUERY_STATE, $D212
        A2D_RELAY_CALL A2D_SET_STATE, $D215
        rts

L4505:  A2D_RELAY_CALL A2D_QUERY_STATE, $D212
        rts

        rts

L4510:  A2D_RELAY_CALL A2D_QUERY_SCREEN, $D239
        A2D_RELAY_CALL A2D_SET_STATE, $D239
        rts

L4523:  jsr     L40F2
        DESKTOP_RELAY_CALL DESKTOP_REDRAW_ICONS
        rts

L4530:  ldx     #$00
        ldy     $BF31
L4535:  lda     $BF32,y
        and     #$0F
        cmp     #$0B
        beq     L4559
L453E:  dey
        bpl     L4535
        stx     L4597
        stx     L45A0
        jsr     L45B2
        ldx     L45A0
        beq     L4558
L454F:  lda     L45A0,x
        sta     L45A9,x
        dex
        bpl     L454F
L4558:  rts

L4559:  lda     $BF32,y
        inx
        sta     L4597,x
        bne     L453E
        rts

L4563:  lda     L45A0
        beq     L4579
        jsr     L45B2
        ldx     L45A0
L456E:  lda     L45A0,x
        cmp     L45A9,x
        bne     L457C
        dex
        bne     L456E
L4579:  lda     #$00
        rts

L457C:  lda     L45A0,x
        sta     L45A9,x
        lda     L4597,x
        ldy     $BF31
L4588:  cmp     $BF32,y
        beq     L4591
        dey
        bpl     L4588
        rts

L4591:  tya
        clc
        adc     #$03
        rts

        .byte   $00
L4597:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00
L45A0:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00
L45A9:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00
L45B2:  ldx     L4597
        beq     L45C6
        stx     L45A0
L45BA:  lda     L4597,x
        jsr     L45C7
        sta     L45A0,x
        dex
        bne     L45BA
L45C6:  rts

L45C7:  sta     L4637
        txa
        pha
        tya
        pha
        ldx     #$11
        lda     L4637
        and     #$80
        beq     L45D9
        ldx     #$21
L45D9:  stx     L45EC
        lda     L4637
        and     #$70
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     L45EC
        sta     L45EC
        L45EC := *+1
        lda     $BF00
        sta     L0006+1
        lda     #0
        sta     L0006
        ldy     #$07
        lda     (L0006),y
        bne     L4627
        ldy     #$FF
        lda     (L0006),y
        clc
        adc     #$03
        sta     L0006
        lda     L4637
        pha
        rol     a
        pla
        php
        and     #$20
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        plp

        adc     #1
        sta     L463A

        jsr     L4634
        .byte   0               ; ???
        .addr   $4639

        lda     $463E
        and     #$10
        beq     $4627
        lda     #$FF
        bne     $4629
L4627:  lda     #$00
L4629:  sta     L4638
        pla
        tay
        pla
        tax
        lda     L4638
        rts

L4634:  jmp     (L0006)

L4637:  .byte   $00
L4638:  .byte   $00,$03
L463A:  .byte   $01,$3E,$46,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00
L464E:  lda     $D343
        beq     L465E
        bit     $D344
        bmi     L4666
        jsr     L67AB
        jmp     L4666

L465E:  bit     $D344
        bmi     L4666
        jsr     L67A3
L4666:  lda     $DF21
        beq     L46A8
        lda     $DF20
        bne     L4691
        lda     $DF21
        cmp     #$02
        bcs     L4697
        lda     $DF22
        cmp     $EBFB
        bne     L468B
        jsr     L678A
        jsr     L670C
        lda     #$00
        sta     $E26F
        rts

L468B:  jsr     L6782
        jmp     L469A

L4691:  jsr     L678A
        jmp     L469A

L4697:  jsr     L6782
L469A:  bit     $E26F
        bmi     L46A7
        jsr     L6747
        lda     #$80
        sta     $E26F
L46A7:  rts

L46A8:  bit     $E26F
        bmi     L46AE
        rts

L46AE:  jsr     L678A
        jsr     L670C
        lda     #$00
        sta     $E26F
        rts

L46BA:  sty     L46CE
        sta     L46CF
        stx     L46CF+1
        php
        sei
        sta     ALTZPOFF
        sta     ROMIN2
        jsr     MLI
L46CE:  .byte   $00
L46CF:  .addr   L0000
        sta     ALTZPON
        tax
        lda     LCBANK1
        lda     LCBANK1
        plp
        txa
        rts

L46DE:  jmp     L46F3

        .byte   $0A,$20,$02,$00
L46E5:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00
L46F3:  jsr     L488A
        ldx     #$FF
L46F8:  inx
        lda     $D355,x
        sta     $0220,x
        cpx     $D355
        bne     L46F8
        inx
        lda     #$2F
        sta     $0220,x
        ldy     #$00
L470C:  iny
        inx
        lda     $D345,y
        sta     $0220,x
        cpy     $D345
        bne     L470C
        stx     $0220
        ldy     #$C4
        lda     #$E1
        ldx     #$46
        jsr     L46BA
        beq     L472B
        jsr     DESKTOP_SHOW_ALERT0
        rts

L472B:  lda     L46E5
        cmp     #$FC
        bne     L4738
        jsr     L47B8
        jmp     L4755

L4738:  cmp     #$06
        bne     L4748
        lda     BUTN0
        ora     BUTN1
        bmi     L4755
        jsr     L489A
        rts

L4748:  cmp     #$FF
        beq     L4755
        cmp     #$B3
        beq     L4755
        lda     #$FA
        jsr     L4802
L4755:  DESKTOP_RELAY_CALL $06, $0000
        A2D_RELAY_CALL $3A      ; ???
        A2D_RELAY_CALL A2D_SET_MENU, $E680
        ldx     $D355
L4773:  lda     $D355,x
        sta     $0220,x
        dex
        bpl     L4773
        ldx     $D345
L477F:  lda     $D345,x
        sta     $0280,x
        dex
        bpl     L477F
        lda     #$80
        ldx     #$02
        jsr     L4842
        lda     #$20
        ldx     #$02
        jsr     L4842
        jsr     L48BE
        lda     #$90
        sta     L5B19
        lda     #$02
        sta     L5B19+1
        jmp     L5AEE

        .byte   $0A,$00,$18,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00
L47B8:  ldx     $D355
        stx     L4816
L47BE:  lda     $D355,x
        sta     $1800,x
        dex
        bpl     L47BE
        inc     $1800
        ldx     $1800
        lda     #$2F
        sta     $1800,x
L47D2:  ldx     $1800
        ldy     #$00
L47D7:  inx
        iny
        lda     L4817,y
        sta     $1800,x
        cpy     L4817
        bne     L47D7
        stx     $1800
        ldy     #$C4
        lda     #$A6
        ldx     #$47
        jsr     L46BA
        bne     L47F3
        rts

L47F3:  ldx     L4816
L47F6:  lda     $1800,x
        cmp     #$2F
        beq     L4808
        dex
        bne     L47F6
L4800:  lda     #$FE
L4802:  jsr     DESKTOP_SHOW_ALERT0
        pla
        pla
        rts

L4808:  cpx     #$01
        beq     L4800
        stx     $1800
        dex
        stx     L4816
        jmp     L47D2

L4816:  .byte   $00
L4817:  PASCAL_STRING "Basic.system"
        .res    30, 0

L4842:  sta     L0006
        stx     $07
        ldy     #$00
        lda     (L0006),y
        tay
L484B:  lda     (L0006),y
        cmp     #$61
        bcc     L4859
        cmp     #$7B
        bcs     L4859
        and     #$DF
        sta     (L0006),y
L4859:  dey
        bne     L484B
        rts

L485D:  .byte   $00
L485E:  .byte   $E0
L485F:  .byte   $00
L4860:  .byte   $D0,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00
L488A:  jsr     L48AA
        A2D_RELAY_CALL A2D_SET_CURSOR, $D311
        jsr     L48B4
        rts

L489A:  jsr     L48AA
        A2D_RELAY_CALL A2D_SET_CURSOR, $D2AD
        jsr     L48B4
        rts

L48AA:  A2D_RELAY_CALL A2D_HIDE_CURSOR
        rts

L48B4:  A2D_RELAY_CALL A2D_SHOW_CURSOR
        rts

L48BE:  ldx     $E196
        inx
L48C2:  lda     $E196,x
        sta     $BF31,x
        dex
        bpl     L48C2
        rts

L48CC:  sta     $D2AC
        ldy     #$0C
        lda     #$AC
        ldx     #$D2
        jsr     LA500
        rts

        lda     #$88
        sta     L48E4
        lda     #$40
        sta     L48E4+1

        L48E4 := *+1
        jmp     $1234           ; self-modified

L48E6:  A2D_RELAY_CALL A2D_GET_INPUT, $D208
        rts

L48F0:  A2D_RELAY_CALL $2C, $D208 ; ???
        rts

L48FA:  A2D_RELAY_CALL A2D_SET_FILL_MODE, $D202
        rts

L4904:  A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        rts

L490E:  rts

        jsr     L488A
        lda     #$02
        jsr     L8E81
        bmi     L4961
        lda     $E25B
        cmp     #$03
        bcs     L492E
        lda     #$06
        jsr     L8E81
        bmi     L4961
        lda     #$03
        jsr     L8E81
        bmi     L4961
L492E:  jsr     L489A
        lda     $E25B
        jsr     L9000
        sta     L498F
        jsr     L488A
        lda     #$08
        jsr     L8E89
        lda     $E25B
        cmp     #$04
        bne     L4961
        lda     L498F
        bpl     L4961
        jsr     L4AAD
        jsr     L4A77
        jsr     L4AFD
        bpl     L497A
        jsr     L8F24
        bmi     L4961
        jsr     L4968
L4961:  jsr     L489A
        jsr     L4523
        rts

L4968:  jsr     L4AAD
        ldx     $0840
L496E:  lda     $0840,x
        sta     $D355,x
        dex
        bpl     L496E
        jmp     L4A17

L497A:  jsr     L4AAD
        ldx     L0800
L4980:  lda     L0800,x
        sta     $D355,x
        dex
        bpl     L4980
        jsr     L4A17
        jmp     L4961

L498F:  .byte   $00,$0A
L4991:  .byte   $20
L4992:  .byte   $02,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        jmp     L49A6

L49A5:  .byte   0
L49A6:  lda     $E25B
        sec
        sbc     #$06
        sta     L49A5
        jsr     L86A7
        clc
        adc     #$1E
        sta     L0006
        txa
        adc     #$DB
        sta     $07
        ldy     #$0F
        lda     (L0006),y
        asl     a
        bmi     L49FA
        bcc     L49E0
        jsr     L4AFD
        beq     L49FA
        lda     L49A5
        jsr     L4AEA
        beq     L49ED
        lda     L49A5
        jsr     L4A47
        jsr     L8F24
        bpl     L49ED
        jmp     L4523

L49E0:  jsr     L4AFD
        beq     L49FA
        lda     L49A5
        jsr     L4AEA
        bne     L49FA
L49ED:  lda     L49A5
        jsr     L4B5F
        sta     L0006
        stx     $07
        jmp     L4A0A

L49FA:  lda     L49A5
        jsr     L86C1
        clc
        adc     #$9E
        sta     L0006
        txa
        adc     #$DB
        sta     $07
L4A0A:  ldy     #$00
        lda     (L0006),y
        tay
L4A0F:  lda     (L0006),y
        sta     $D355,y
        dey
        bpl     L4A0F
L4A17:  ldy     $D355
L4A1A:  lda     $D355,y
        cmp     #$2F
        beq     L4A24
        dey
        bpl     L4A1A
L4A24:  dey
        sty     L4A46
        ldx     #$00
        iny
L4A2B:  iny
        inx
        lda     $D355,y
        sta     $D345,x
        cpy     $D355
        bne     L4A2B
        stx     $D345
        lda     L4A46
        sta     $D355
        lda     #$00
        jmp     L46DE

L4A46:  .byte   0
L4A47:  pha
        jsr     L86C1
        clc
        adc     #$9E
        sta     L0006
        txa
        adc     #$DB
        sta     $07
        ldy     #$00
        lda     (L0006),y
        tay
L4A5A:  lda     (L0006),y
        sta     L0800,y
        dey
        bpl     L4A5A
        pla
        jsr     L4B5F
        sta     $08
        stx     $09
        ldy     #$00
        lda     ($08),y
        tay
L4A6F:  lda     ($08),y
        sta     $0840,y
        dey
        bpl     L4A6F
L4A77:  ldy     L0800
L4A7A:  lda     L0800,y
        cmp     #$2F
        beq     L4A84
        dey
        bne     L4A7A
L4A84:  dey
        sty     L0800
        ldy     $0840
L4A8B:  lda     $0840,y
        cmp     #$2F
        beq     L4A95
        dey
        bne     L4A8B
L4A95:  dey
        sty     $0840
        lda     #$00
        sta     L0006
        lda     #$08
        sta     $07
        lda     #$40
        sta     $08
        lda     #$08
        sta     $09
        jsr     L4D19
        rts

L4AAD:  ldy     $D355
L4AB0:  lda     $D355,y
        sta     L0800,y
        dey
        bpl     L4AB0
        lda     #$40
        ldx     #$08
        jsr     L4B15
        ldy     L0800
L4AC3:  lda     L0800,y
        cmp     #$2F
        beq     L4ACD
        dey
        bne     L4AC3
L4ACD:  dey
L4ACE:  lda     L0800,y
        cmp     #$2F
        beq     L4AD8
        dey
        bne     L4ACE
L4AD8:  dey
        ldx     $0840
L4ADC:  iny
        inx
        lda     L0800,y
        sta     $0840,x
        cpy     L0800
        bne     L4ADC
        rts

L4AEA:  jsr     L4B5F
        sta     L4991
        stx     L4992
        ldy     #$C4
        lda     #$90
        ldx     #$49
        jsr     L46BA
        rts

L4AFD:  sta     ALTZPOFF
        lda     LCBANK2
        lda     LCBANK2
        lda     $D3FF
        tax
        sta     ALTZPON
        lda     LCBANK1
        lda     LCBANK1
        txa
        rts

L4B15:  sta     L4B2B
        stx     L4B2C
        sta     ALTZPOFF
        lda     LCBANK2
        lda     LCBANK2
        ldx     $D3EE
L4B27:  lda     $D3EE,x

        L4B2B := *+1
        L4B2C := *+2
        sta     $1234,x

        dex
        bpl     L4B27
        sta     ALTZPON
        lda     LCBANK1
        lda     LCBANK1
        rts
        sta     L4B50
        stx     L4B51
        sta     ALTZPOFF
        lda     LCBANK2
        lda     LCBANK2
        ldx     $D3AD
L4B4C:  lda     $D3AD,x
        L4B50 := *+1
        L4B51 := *+2
        sta     $1234,x
        dex
        bpl     L4B4C
        sta     ALTZPON
        lda     LCBANK1
        lda     LCBANK1
        rts

L4B5F:  sta     L4BB0
        lda     #$76
        ldx     #$4F
        jsr     L4B15
        lda     L4BB0
        jsr     L86C1
        clc
        adc     #$9E
        sta     L0006
        txa
        adc     #$DB
        sta     $07
        ldy     #$00
        lda     (L0006),y
        sta     L4BB1
        tay
L4B81:  lda     (L0006),y
        and     #$7F
        cmp     #$2F
        beq     L4B8C
        dey
        bne     L4B81
L4B8C:  dey
L4B8D:  lda     (L0006),y
        and     #$7F
        cmp     #$2F
        beq     L4B98
        dey
        bne     L4B8D
L4B98:  dey
        ldx     L4F76
L4B9C:  inx
        iny
        lda     (L0006),y
        sta     L4F76,x
        cpy     L4BB1
        bne     L4B9C
        stx     L4F76
        lda     #$76
        ldx     #$4F
        rts

L4BB0:  .byte   0
L4BB1:  .byte   0
        ldy     #$00
        lda     #$00
        ldx     #$00
        jsr     LA500
        jmp     L4523

        .byte   $80,$20         ; ???
        bpl     L4C07
        jsr     L488A
        lda     $E25B
        sec
        sbc     #$03
        jsr     L86A7
        clc
        adc     #$F2
        sta     L0006
        txa
        adc     #$E5
        sta     $07
        ldy     #$00
        lda     (L0006),y
        tay
        clc
        adc     $4C87
        pha
        tax
L4BE3:  lda     (L0006),y
        sta     L4C88,x
        dex
        dey
        bne     L4BE3
        pla
        sta     L4C88
        ldx     L4C88
L4BF3:  lda     L4C88,x
        cmp     #$20
        bne     L4BFF
        lda     #$2E
        sta     L4C88,x
L4BFF:  dex
        bne     L4BF3
        jsr     L4C4E
        bmi     L4C4A
L4C07:  lda     L4C7C
        sta     L4C7E
        sta     L4C86
        jsr     L4C64
        jsr     L4C6D
        lda     #$80
        sta     L4CA1
        jsr     L489A
        jsr     L4510
        A2D_RELAY_CALL A2D_CONFIGURE_ZP_USE, $D2A7
        A2D_RELAY_CALL A2D_CONFIGURE_ZP_USE, $4BBE
        jsr     L0800
        A2D_RELAY_CALL A2D_CONFIGURE_ZP_USE, $D2A7
        lda     #$00
        sta     L4CA1
        jsr     L4510
        jsr     L4523
L4C4A:  jsr     L489A
        rts

L4C4E:  ldy     #$C8
        ldx     #$4C
        lda     #$77
        jsr     L46BA
        bne     L4C5A
        rts

L4C5A:  lda     #$00
        jsr     L48CC
        beq     L4C4E
        lda     #$FF
        rts

L4C64:  ldy     #$CA
        ldx     #$4C
        lda     #$7D
        jmp     L46BA

L4C6D:  ldy     #$CC
        ldx     #$4C
        lda     #$85
        jmp     L46BA

        .byte   $00,$03,$88,$4C,$00,$1C
L4C7C:  .byte   $00,$04
L4C7E:  .byte   $00,$00,$08,$00,$14,$00,$00,$01
L4C86:  .byte   $00,$09
L4C88:  PASCAL_STRING "Desk.acc/"
        .res    15, 0
L4CA1:  .byte   $00
        jsr     L488A
        lda     #$03
        jsr     L8E81
        bmi     L4CD6
        lda     #$04
        jsr     L8E81
        bmi     L4CD6
        jsr     L489A
        lda     #$00
        jsr     L5000
        pha
        jsr     L488A
        lda     #$07
        jsr     L8E89
        jsr     L489A
        pla
        bpl     L4CCD
        jmp     L4CD6

L4CCD:  jsr     L4D19
        jsr     L4523
        jsr     L8F18
L4CD6:  pha
        jsr     L489A
        pla
        bpl     L4CE0
        jmp     L4523

L4CE0:  lda     #$C9
        ldx     #$DF
        jsr     L6FAF
        beq     L4CF1
        pha
        jsr     L6F0D
        pla
        jmp     L5E78

L4CF1:  ldy     #$01
L4CF3:  iny
        lda     $DFC9,y
        cmp     #$2F
        beq     L4D01
        cpy     $DFC9
        bne     L4CF3
        iny
L4D01:  dey
        sty     $DFC9
        lda     #$C9
        ldx     #$DF
        jsr     L6FB7
        lda     #$C9
        ldx     #$DF
        ldy     $DFC9
        jsr     L6F4B
        jmp     L4523

L4D19:  ldy     #$00
        lda     (L0006),y
        tay
L4D1E:  lda     (L0006),y
        sta     $E00A,y
        dey
        bpl     L4D1E
        ldy     #$00
        lda     ($08),y
        tay
L4D2B:  lda     ($08),y
        sta     $DFC9,y
        dey
        bpl     L4D2B
        lda     #$C9
        ldx     #$DF
        jsr     L6F90
        ldx     #$01
        iny
        iny
L4D3E:  lda     $DFC9,y
        sta     $E04B,x
        cpy     $DFC9
        beq     L4D4E
        iny
        inx
        jmp     L4D3E

L4D4E:  stx     $E04B
        lda     $DFC9
        sec
        sbc     $E04B
        sta     $DFC9
        dec     $DFC9
        rts

        jsr     L488A
        lda     #$03
        jsr     L8E81
        bmi     L4D9D
        lda     #$05
        jsr     L8E81
        bmi     L4D9D
        jsr     L489A
        lda     #$01
        jsr     L5000
        pha
        jsr     L488A
        lda     #$07
        jsr     L8E89
        jsr     L489A
        pla
        bpl     L4D8A
        jmp     L4D9D

L4D8A:  ldy     #$00
        lda     (L0006),y
        tay
L4D8F:  lda     (L0006),y
        sta     $E00A,y
        dey
        bpl     L4D8F
        jsr     L4523
        jsr     L8F1B
L4D9D:  pha
        jsr     L489A
        pla
        bpl     L4DA7
        jmp     L4523

L4DA7:  lda     #$0A
        ldx     #$E0
        jsr     L6F90
        sty     $E00A
        lda     #$0A
        ldx     #$E0
        jsr     L6FAF
        beq     L4DC2
        pha
        jsr     L6F0D
        pla
        jmp     L5E78

L4DC2:  ldy     #$01
L4DC4:  iny
        lda     $E00A,y
        cmp     #$2F
        beq     L4DD2
        cpy     $E00A
        bne     L4DC4
        iny
L4DD2:  dey
        sty     $E00A
        lda     #$0A
        ldx     #$E0
        jsr     L6FB7
        lda     #$0A
        ldx     #$E0
        ldy     $E00A
        jsr     L6F4B
        jmp     L4523

        ldx     #$00
L4DEC:  cpx     $DF21
        bne     L4DF2
        rts

L4DF2:  txa
        pha
        lda     $DF22,x
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        and     #$70
        bne     L4E10
        ldy     #$00
        lda     (L0006),y
        jsr     L6A8A
        jmp     L4E14

L4E10:  cmp     #$40
        bcc     L4E1A
L4E14:  pla
        tax
        inx
        jmp     L4DEC

L4E1A:  sta     L4E71
        lda     $DF21
        cmp     #$02
        bcs     L4E14
        pla
        lda     desktop_winid
        jsr     L86FB
        sta     L0006
        stx     $07
        ldy     #$00
        lda     (L0006),y
        tay
L4E34:  lda     (L0006),y
        sta     $D355,y
        dey
        bpl     L4E34
        lda     $DF22
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$09
        lda     (L0006),y
        tax
        clc
        adc     #$09
        tay
        dex
        dey
L4E51:  lda     (L0006),y
        sta     $D344,x
        dey
        dex
        bne     L4E51
        ldy     #$09
        lda     (L0006),y
        tax
        dex
        dex
        stx     $D345
        lda     L4E71
        cmp     #$20
        bcc     L4E6E
        lda     L4E71
L4E6E:  jmp     L46DE

L4E71:  .byte   0
L4E72:  lda     desktop_winid
        bne     L4E78
        rts

L4E78:  jsr     L6D2B
        dec     $EC2E
        lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        ldx     desktop_winid
        dex
        lda     $E6D1,x
        bmi     L4EB4
        DESKTOP_RELAY_CALL $07, desktop_winid
        lda     $DD9E
        sec
        sbc     buf3len
        sta     $DD9E
        ldx     #$00
L4EA5:  cpx     buf3len
        beq     L4EB4
        lda     buf3,x
        jsr     DESKTOP_FREE_SPACE
        inx
        jmp     L4EA5

L4EB4:  ldx     #$00
        txa
L4EB7:  sta     buf3,x
        cpx     buf3len
        beq     L4EC3
        inx
        jmp     L4EB7

L4EC3:  sta     buf3len
        jsr     DESKTOP_COPY_FROM_BUF
        lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, desktop_winid
        ldx     desktop_winid
        dex
        lda     $EC26,x
        sta     $E22F
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        and     #$7F
        sta     (L0006),y
        and     #$0F
        sta     $DF20
        jsr     L8997
        DESKTOP_RELAY_CALL $02, $E22F
        jsr     L4510
        lda     #$01
        sta     $DF21
        lda     $E22F
        sta     $DF22
        ldx     desktop_winid
        dex
        lda     $EC26,x
        jsr     L7345
        ldx     desktop_winid
        dex
        lda     #$00
        sta     $EC26,x
        A2D_RELAY_CALL A2D_QUERY_TOP, desktop_winid
        lda     desktop_winid
        bne     L4F3C
        DESKTOP_RELAY_CALL DESKTOP_REDRAW_ICONS
L4F3C:  lda     #$00
        sta     $E269
        A2D_RELAY_CALL $36, $E267 ; ???
        jsr     L66A2
        jmp     L4510

L4F50:  lda     desktop_winid
        beq     L4F5B
        jsr     L4E72
        jmp     L4F50

L4F5B:  rts

        lda     #$00
        jsr     L8E81
        bmi     L4F66
        jmp     L0800

L4F66:  rts

L4F67:  .byte   $00
L4F68:  .byte   $00
L4F69:  .byte   $00,$07,$76,$4F,$C3,$0F,$00,$00
        .byte   $0D
L4F72:  .byte   $00,$00,$00,$00
L4F76:  .res    64
        .byte   $00
        lda     desktop_winid
        sta     L4F67
        ldy     #$03
        lda     #$67
        ldx     #$4F
        jsr     LA500
L4FC6:  lda     desktop_winid
        beq     L4FD4
        jsr     L86FB
        sta     L4F68
        stx     L4F69
L4FD4:  lda     #$80
        sta     L4F67
        ldy     #$03
        lda     #$67
        ldx     #$4F
        jsr     LA500
        beq     L4FE7
        jmp     L504B

L4FE7:  stx     $07
        stx     L504F
        sty     L0006
        sty     L504E
        ldy     #$00
        lda     (L0006),y
        tay
L4FF6:  lda     (L0006),y
        sta     L4F76,y
        dey
        bpl     L4FF6
        ldx     #$03
L5000:  lda     $BF90,x
        sta     L4F72,x
        dex
        bpl     L5000
        ldy     #$C0
        lda     #$6A
        ldx     #$4F
        jsr     L46BA
        beq     L5027
        jsr     DESKTOP_SHOW_ALERT0
        lda     L504E
        sta     L4F68
        lda     L504F
        sta     L4F69
        jmp     L4FC6

        rts

L5027:  lda     #$40
        sta     L4F67
        ldy     #$03
        lda     #$67
        ldx     #$4F
        jsr     LA500
        lda     #$76
        ldx     #$4F
        jsr     L6F90
        sty     L4F76
        lda     #$76
        ldx     #$4F
        jsr     L6FAF
        beq     L504B
        jsr     L5E78
L504B:  jmp     L4523

L504E:  .byte   0
L504F:  .byte   0
L5050:  lda     $DF20
        beq     L5056
L5055:  rts

L5056:  lda     $DF21
        beq     L5055
        cmp     #$01
        bne     L5067
        lda     $DF22
        cmp     $EBFB
        beq     L5055
L5067:  lda     #$00
        tax
        tay
L506B:  lda     $DF22,y
        cmp     $EBFB
        beq     L5077
        sta     $1800,x
        inx
L5077:  iny
        cpy     $DF21
        bne     L506B
        dex
        stx     L5098
        jsr     L8F15
L5084:  ldx     L5098
        lda     $1800,x
        sta     L533F
        jsr     L59A8
        dec     L5098
        bpl     L5084
        jmp     L4523

L5098:  .byte   $00
L5099:  .byte   $AF,$DE,$AD,$DE
L509D:  .byte   $18,$FB,$5C,$04,$D0,$E0
L50A3:  .byte   $04,$00,$00,$00,$00,$00,$00
        ldx     #$03
L50AC:  lda     L5099,x
        sta     $0102,x
        dex
        bpl     L50AC
        sta     ALTZPOFF
        lda     LCBANK2
        lda     LCBANK2
        ldx     #$05
L50C0:  lda     L509D,x
        sta     $D100,x
        dex
        bpl     L50C0
        sta     ALTZPOFF
        lda     ROMIN2
        jsr     SETVID
        jsr     SETKBD
        jsr     INIT
        jsr     HOME
        sta     TXTSET
        sta     LOWSCR
        sta     LORES
        sta     MIXCLR
        sta     DHIRESOFF
        sta     CLRALTCHAR
        sta     CLR80VID
        sta     CLR80COL
        jsr     MLI
        .byte   $65
        .addr   L50A3
        ldx     desktop_winid
        bne     L50FF
        rts

L50FF:  dex
        lda     $E6D1,x
        bne     L5106
        rts

L5106:  lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        ldx     #$00
        txa
L5112:  cpx     buf3len
        beq     L511E
        sta     buf3,x
        inx
        jmp     L5112

L511E:  sta     buf3len
        lda     #$00
        ldx     desktop_winid
        dex
        sta     $E6D1,x
        jsr     L52DF
        lda     desktop_winid
        sta     $D212
        jsr     L4505
        jsr     L6E8E
        jsr     L4904
        A2D_RELAY_CALL A2D_FILL_RECT, $D21D
        lda     desktop_winid
        jsr     L7D5D
        sta     L51EB
        stx     L51EC
        sty     L51ED
        lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$1F
        lda     #$00
L5162:  sta     (L0006),y
        dey
        cpy     #$1B
        bne     L5162
        ldy     #$23
        ldx     #$03
L516D:  lda     L51EB,x
        sta     (L0006),y
        dey
        dex
        bpl     L516D
        lda     desktop_winid
        jsr     L763A
        lda     desktop_winid
        sta     $D212
        jsr     L44F2
        jsr     L6E52
        lda     #$00
        sta     L51EF
L518D:  lda     L51EF
        cmp     buf3len
        beq     L51A7
        tax
        lda     buf3,x
        jsr     L86E3
        ldy     #$01
        jsr     DESKTOP_RELAY
        inc     L51EF
        jmp     L518D

L51A7:  jsr     L4510
        jsr     L6E6E
        jsr     DESKTOP_COPY_FROM_BUF
        jsr     L6DB1
        lda     $DF20
        beq     L51E3
        lda     $DF21
        beq     L51E3
        sta     L51EF
L51C0:  ldx     L51EF
        lda     $DF21,x
        sta     $E22F
        jsr     L8915
        jsr     L6E8E
        DESKTOP_RELAY_CALL $02, $E22F
        lda     $E22F
        jsr     L8893
        dec     L51EF
        bne     L51C0
L51E3:  lda     #$00
        sta     bufnum
        jmp     DESKTOP_COPY_TO_BUF

L51EB:  .byte   0
L51EC:  .byte   0
L51ED:  .byte   0
        .byte   0
L51EF:  .byte   0
L51F0:  ldx     desktop_winid
        dex
        sta     $E6D1,x
        lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        jsr     L7D9C
        jsr     DESKTOP_COPY_FROM_BUF
        lda     desktop_winid
        sta     $D212
        jsr     L4505
        jsr     L6E8E
        jsr     L4904
        A2D_RELAY_CALL A2D_FILL_RECT, $D21D
        lda     desktop_winid
        jsr     L7D5D
        sta     L5263
        stx     L5264
        sty     L5265
        lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$1F
        lda     #$00
L523B:  sta     (L0006),y
        dey
        cpy     #$1B
        bne     L523B
        ldy     #$23
        ldx     #$03
L5246:  lda     L5263,x
        sta     (L0006),y
        dey
        dex
        bpl     L5246
        lda     #$80
        sta     L4152
        jsr     L4510
        jsr     L6C19
        jsr     L6DB1
        lda     #$00
        sta     L4152
        rts

L5263:  .byte   0
L5264:  .byte   0
L5265:  .byte   0
        .byte   0
        ldx     desktop_winid
        bne     L526D
        rts

L526D:  dex
        lda     $E6D1,x
        cmp     #$81
        bne     L5276
        rts

L5276:  cmp     #$00
        bne     L527D
        jsr     L5302
L527D:  jsr     L52DF
        lda     #$81
        jmp     L51F0

        ldx     desktop_winid
        bne     L528B
        rts

L528B:  dex
        lda     $E6D1,x
        cmp     #$82
        bne     L5294
        rts

L5294:  cmp     #$00
        bne     L529B
        jsr     L5302
L529B:  jsr     L52DF
        lda     #$82
        jmp     L51F0

        ldx     desktop_winid
        bne     L52A9
        rts

L52A9:  dex
        lda     $E6D1,x
        cmp     #$83
        bne     L52B2
        rts

L52B2:  cmp     #$00
        bne     L52B9
        jsr     L5302
L52B9:  jsr     L52DF
        lda     #$83
        jmp     L51F0

        ldx     desktop_winid
        bne     L52C7
        rts

L52C7:  dex
        lda     $E6D1,x
        cmp     #$84
        bne     L52D0
        rts

L52D0:  cmp     #$00
        bne     L52D7
        jsr     L5302
L52D7:  jsr     L52DF
        lda     #$84
        jmp     L51F0

L52DF:  lda     #$00
        sta     $E269
        A2D_RELAY_CALL $36, $E267 ; ???
        lda     $E25B
        sta     $E268
        lda     #$01
        sta     $E269
        A2D_RELAY_CALL $36, $E267 ; ???
        rts

L5302:  DESKTOP_RELAY_CALL $07, desktop_winid
        lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     $DD9E
        sec
        sbc     buf3len
        sta     $DD9E
        ldx     #$00
L5320:  cpx     buf3len
        beq     L5334
        lda     buf3,x
        jsr     DESKTOP_FREE_SPACE
        lda     #$00
        sta     buf3,x
        inx
        jmp     L5320

L5334:  jsr     DESKTOP_COPY_FROM_BUF
        lda     #$00
        sta     bufnum
        jmp     DESKTOP_COPY_TO_BUF

L533F:  .byte   0
        lda     #$01
        jsr     L8E81
        bmi     L535A
        lda     #$04
        jsr     L0800
        bne     L5357
        stx     L533F
        jsr     L4523
        jsr     L59A4
L5357:  jmp     L4523

L535A:  rts

        lda     #$01
        jsr     L8E81
        bmi     L5372
        lda     #$05
        jsr     L0800
        bne     L5372
        stx     L533F
        jsr     L4523
        jsr     L59A4
L5372:  jmp     L4523

        jsr     L8F09
        jmp     L4523

        jsr     L8F27
        jmp     L4523

        jsr     L8F0F
        jmp     L4523

        jsr     L8F0C
        jmp     L4523

        jsr     L8F12
        pha
        jsr     L4523
        pla
        beq     L5398
        rts

L5398:  lda     $DF20
        bne     L53B5
        ldx     #$00
        ldy     #$00
L53A1:  lda     $DF22,x
        cmp     #$01
        beq     L53AC
        sta     L5428,y
        iny
L53AC:  inx
        cpx     $DF22
        bne     L53A1
        sty     L5427
L53B5:  lda     #$FF
        sta     L5426
L53BA:  inc     L5426
        lda     L5426
        cmp     $DF21
        bne     L53D0
        lda     $DF20
        bne     L53CD
        jmp     L540E

L53CD:  jmp     L5E78

L53D0:  tax
        lda     $DF22,x
        jsr     L5431
        bmi     L53BA
        jsr     L86FB
        sta     L0006
        stx     $07
        ldy     #$00
        lda     (L0006),y
        tay
        lda     L0006
        jsr     L6FB7
        lda     L704B
        beq     L53BA
L53EF:  dec     L704B
        ldx     L704B
        lda     L704C,x
        cmp     desktop_winid
        beq     L5403
        sta     $D20E
        jsr     L4459
L5403:  jsr     L61DC
        lda     L704B
        bne     L53EF
        jmp     L53BA

L540E:  ldx     L5427
L5411:  lda     L5428,x
        sta     L533F
        jsr     L59A8
        ldx     L5427
        dec     L5427
        dex
        bpl     L5411
        jmp     L4523

L5426:  .byte   0
L5427:  .byte   0
L5428:  .res    9, 0
L5431:  ldx     #$07
L5433:  cmp     $EC26,x
        beq     L543E
        dex
        bpl     L5433
        lda     #$FF
        rts

L543E:  inx
        txa
        rts

L5441:  jmp     L544D

L5444:  .byte   0
L5445:  .byte   0
L5446:  .byte   0
L5447:  .byte   0
L5448:  .byte   0
L5449:  .byte   0
L544A:  .byte   0
        .byte   0
        .byte   0
L544D:  lda     #$00
        sta     $1800
        .byte   $AD
L5453:  and     $EC
        bne     L545A
        jmp     L54C5

L545A:  tax
        dex
        lda     $E6D1,x
        bpl     L5464
        jmp     L54C5

L5464:  lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$1C
L5479:  lda     (L0006),y
        sta     $E214,y
        iny
        cpy     #$24
        bne     L5479
        ldx     #$00
L5485:  cpx     buf3len
        beq     L54BD
        txa
        pha
        lda     buf3,x
        sta     $E22F
        jsr     L8915
        DESKTOP_RELAY_CALL $0D, $E22F
        pha
        lda     $E22F
        jsr     L8893
        pla
        beq     L54B7
        pla
        pha
        tax
        lda     buf3,x
        ldx     $1800
        sta     $1801,x
        inc     $1800
L54B7:  pla
        tax
        inx
        jmp     L5485

L54BD:  lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
L54C5:  ldx     $1800
        ldy     #$00
L54CA:  lda     buf3,y
        sta     $1801,x
        iny
        inx
        cpy     buf3len
        bne     L54CA
        lda     $1800
        clc
        adc     buf3len
        sta     $1800
        lda     #$00
        sta     L544A
        lda     #$FF
        ldx     #$03
L54EA:  sta     L5444,x
        dex
        bpl     L54EA
L54F0:  ldx     L544A
L54F3:  lda     $1801,x
        asl     a
        tay
        lda     $DD9F,y
        sta     L0006
        lda     $DDA0,y
        sta     $07
        ldy     #$06
        lda     (L0006),y
        cmp     L5447
        beq     L5510
        bcc     L5532
        jmp     L5547

L5510:  dey
        lda     (L0006),y
        cmp     L5446
        beq     L551D
        bcc     L5532
        jmp     L5547

L551D:  dey
        lda     (L0006),y
        cmp     L5445
        beq     L552A
        bcc     L5532
        jmp     L5547

L552A:  dey
        lda     (L0006),y
        cmp     L5444
        bcs     L5547
L5532:  lda     $1801,x
        stx     L5449
        sta     L5448
        ldy     #$03
L553D:  lda     (L0006),y
        sta     L5441,y
        iny
        cpy     #$07
        bne     L553D
L5547:  inx
        cpx     $1800
        bne     L54F3
        ldx     L544A
        lda     $1801,x
        tay
        lda     L5448
        sta     $1801,x
        ldx     L5449
        tya
        sta     $1801,x
        lda     #$FF
        ldx     #$03
L5565:  sta     L5444,x
        dex
        bpl     L5565
        inc     L544A
        ldx     L544A
        cpx     $1800
        beq     L5579
        jmp     L54F0

L5579:  lda     #$00
        sta     L544A
        jsr     L6D2B
L5581:  jsr     L55F0
L5584:  jsr     L48E6
        lda     $D208
        cmp     #$03
        beq     L5595
        cmp     #$01
        bne     L5584
        jmp     L55D1

L5595:  lda     $D209
        and     #$7F
        cmp     #$0D
        beq     L55D1
        cmp     #$1B
        beq     L55D1
        cmp     #$08
        beq     L55BE
        cmp     #$15
        bne     L5584
        ldx     L544A
        inx
        cpx     $1800
        bne     L55B5
        ldx     #$00
L55B5:  stx     L544A
        jsr     L562C
        jmp     L5581

L55BE:  ldx     L544A
        dex
        bpl     L55C8
        ldx     $1800
        dex
L55C8:  stx     L544A
        jsr     L562C
        jmp     L5581

L55D1:  ldx     L544A
        lda     $1801,x
        sta     $DF22
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        and     #$0F
        sta     $DF20
        lda     #$01
        sta     $DF21
        rts

L55F0:  ldx     L544A
        lda     $1801,x
        sta     $E22F
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        and     #$0F
        sta     $D212
        beq     L5614
        jsr     L56F9
        lda     $E22F
        jsr     L8915
L5614:  DESKTOP_RELAY_CALL $02, $E22F
        lda     $D212
        beq     L562B
        lda     $E22F
        jsr     L8893
        jsr     L4510
L562B:  rts

L562C:  lda     $E22F
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        and     #$0F
        sta     $D212
        beq     L564A
        jsr     L56F9
        lda     $E22F
        jsr     L8915
L564A:  DESKTOP_RELAY_CALL $0B, $E22F
        lda     $D212
        beq     L5661
        lda     $E22F
        jsr     L8893
        jsr     L4510
L5661:  rts

        lda     $DF21
        beq     L566A
        jsr     L6D2B
L566A:  ldx     desktop_winid
        beq     L5676
        dex
        lda     $E6D1,x
        bpl     L5676
        rts

L5676:  lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     buf3len
        bne     L5687
        jmp     L56F0

L5687:  ldx     buf3len
        dex
L568B:  lda     buf3,x
        sta     $DF22,x
        dex
        bpl     L568B
        lda     buf3len
        sta     $DF21
        lda     desktop_winid
        sta     $DF20
        lda     $DF20
        sta     $E22C
        beq     L56AB
        jsr     L56F9
L56AB:  lda     $DF21
        sta     L56F8
        dec     L56F8
L56B4:  ldx     L56F8
        lda     $DF22,x
        sta     $E22B
        jsr     L86E3
        sta     L0006
        stx     $07
        lda     $E22C
        beq     L56CF
        lda     $E22B
        jsr     L8915
L56CF:  DESKTOP_RELAY_CALL $02, $E22B
        lda     $E22C
        beq     L56E3
        lda     $E22B
        jsr     L8893
L56E3:  dec     L56F8
        bpl     L56B4
        lda     $DF20
        beq     L56F0
        jsr     L4510
L56F0:  lda     #$00
        sta     bufnum
        jmp     DESKTOP_COPY_TO_BUF

L56F8:  .byte   0
L56F9:  sta     $D212
        jsr     L4505
        jmp     L6E8E

L5702:  lda     desktop_winid
        bne     L5708
        rts

L5708:  sta     L0800
        ldy     #$01
        ldx     #$00
L570F:  lda     $EC26,x
        beq     L5720
        inx
        cpx     desktop_winid
        beq     L5721
        txa
        dex
        sta     L0800,y
        iny
L5720:  inx
L5721:  cpx     #$08
        bne     L570F
        sty     L578D
        cpy     #$01
        bne     L572D
        rts

L572D:  lda     #$00
        sta     L578C
L5732:  jsr     L48E6
        lda     $D208
        cmp     #$03
        beq     L5743
        cmp     #$01
        bne     L5732
        jmp     L578B

L5743:  lda     $D209
        and     #$7F
        cmp     #$0D
        beq     L578B
        cmp     #$1B
        beq     L578B
        cmp     #$08
        beq     L5772
        cmp     #$15
        bne     L5732
        ldx     L578C
        inx
        cpx     L578D
        bne     L5763
        ldx     #$00
L5763:  stx     L578C
        lda     L0800,x
        sta     $D20E
        jsr     L4459
        jmp     L5732

L5772:  ldx     L578C
        dex
        bpl     L577C
        ldx     L578D
        dex
L577C:  stx     L578C
        lda     L0800,x
        sta     $D20E
        jsr     L4459
        jmp     L5732

L578B:  rts

L578C:  .byte   0
L578D:  .byte   0
L578E:  A2D_RELAY_CALL $22      ; ???
        jmp     L619B

L579A:  A2D_RELAY_CALL $22      ; ???
        jmp     L60DB

L57A6:  jsr     L5803
L57A9:  jsr     L48E6
        lda     $D208
        cmp     #$01
        beq     L57C2
        cmp     #$03
        bne     L57A9
        lda     $D209
        cmp     #$0D
        beq     L57C2
        cmp     #$1B
        bne     L57CB
L57C2:  lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        rts

L57CB:  bit     L585D
        bmi     L57D3
        jmp     L57E7

L57D3:  cmp     #$15
        bne     L57DD
        jsr     L582F
        jmp     L57A9

L57DD:  cmp     #$08
        bne     L57E7
        jsr     L583C
        jmp     L57A9

L57E7:  bit     L585E
        bmi     L57EF
        jmp     L57A9

L57EF:  cmp     #$0A
        bne     L57F9
        jsr     L5846
        jmp     L57A9

L57F9:  cmp     #$0B
        bne     L57A9
        jsr     L5853
        jmp     L57A9

L5803:  lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        ldx     desktop_winid
        dex
        lda     $E6D1,x
        sta     L5B1B
        jsr     L58C3
        sta     L585F
        stx     L5860
        sty     L585D
        jsr     L58E2
        sta     L5861
        stx     L5862
        sty     L585E
        rts

L582F:  lda     L585F
        ldx     L5860
        jsr     L5863
        sta     L585F
        rts

L583C:  lda     L585F
        jsr     L587E
        sta     L585F
        rts

L5846:  lda     L5861
        ldx     L5862
        jsr     L5893
        sta     L5861
        rts

L5853:  lda     L5861
        jsr     L58AE
        sta     L5861
        rts

L585D:  .byte   0
L585E:  .byte   0
L585F:  .byte   0
L5860:  .byte   0
L5861:  .byte   0
L5862:  .byte   0
L5863:  stx     L587D
        cmp     L587D
        beq     L587C
        sta     $D20D
        inc     $D20D
        lda     #$02
        sta     $D208
        jsr     L5C54
        lda     $D20D
L587C:  rts

L587D:  .byte   0
L587E:  beq     L5891
        sta     $D20D
        dec     $D20D
        lda     #$02
        sta     $D208
        jsr     L5C54
        lda     $D20D
L5891:  rts

        .byte   0
L5893:  stx     L58AD
        cmp     L58AD
        beq     L58AC
        sta     $D20D
        inc     $D20D
        lda     #$01
        sta     $D208
        jsr     L5C54
        lda     $D20D
L58AC:  rts

L58AD:  .byte   0
L58AE:  beq     L58C1
        sta     $D20D
        dec     $D20D
        lda     #$01
        sta     $D208
        jsr     L5C54
        lda     $D20D
L58C1:  rts

        .byte   0
L58C3:  lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$06
        lda     (L0006),y
        tax
        iny
        lda     (L0006),y
        pha
        ldy     #$04
        lda     (L0006),y
        and     #$01
        clc
        ror     a
        ror     a
        tay
        pla
        rts

L58E2:  lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$08
        lda     (L0006),y
        tax
        iny
        lda     (L0006),y
        pha
        ldy     #$05
        lda     (L0006),y
        and     #$01
        clc
        ror     a
        ror     a
        tay
        pla
        rts

        lda     #$00
        sta     L599F
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        jsr     L4F50
        jsr     L6D2B
        ldx     buf3len
        dex
L5916:  lda     buf3,x
        cmp     $EBFB
        beq     L5942
        txa
        pha
        lda     buf3,x
        sta     $E22F
        lda     #$00
        sta     buf3,x
        DESKTOP_RELAY_CALL $04, $E22F
        lda     $E22F
        jsr     DESKTOP_FREE_SPACE
        dec     buf3len
        dec     $DD9E
        pla
        tax
L5942:  dex
        bpl     L5916
        ldy     #$00
        sty     L599E
L594A:  ldy     L599E
        inc     buf3len
        inc     $DD9E
        lda     #$00
        sta     $E1A0,y
        lda     $BF32,y
        jsr     L89B6
        cmp     #$57
        bne     L5967
        lda     #$F9
        sta     L599F
L5967:  inc     L599E
        lda     L599E
        cmp     $BF31
        beq     L594A
        bcc     L594A
        ldx     #$00
L5976:  cpx     buf3len
        bne     L5986
        lda     L599F
        beq     L5983
        jsr     DESKTOP_SHOW_ALERT0
L5983:  jmp     DESKTOP_COPY_FROM_BUF

L5986:  txa
        pha
        lda     buf3,x
        cmp     $EBFB
        beq     L5998
        jsr     L86E3
        ldy     #$01
        jsr     DESKTOP_RELAY
L5998:  pla
        tax
        inx
        jmp     L5976

L599E:  .byte   0
L599F:  .byte   0
L59A0:  lda     #$00
        beq     L59AA
L59A4:  lda     #$80
        bne     L59AA
L59A8:  lda     #$C0
L59AA:  sta     L5AD0
        lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        bit     L5AD0
        bpl     L59EA
        bvc     L59D2
        lda     L533F
        ldy     #$0F
L59C1:  cmp     $E1A0,y
        beq     L59C9
        dey
        bpl     L59C1
L59C9:  sty     L5AC6
        sty     $E25B
        jmp     L59F3

L59D2:  ldy     $BF31
        lda     L533F
L59D8:  cmp     $BF32,y
        beq     L59E1
        dey
        bpl     L59D8
        iny
L59E1:  sty     L5AC6
        sty     $E25B
        jmp     L59F3

L59EA:  lda     $E25B
        sec
        sbc     #$03
        sta     $E25B
L59F3:  ldy     $E25B
        lda     $E1A0,y
        bne     L59FE
        jmp     L5A4C

L59FE:  jsr     L86E3
        clc
        adc     #$09
        sta     L0006
        txa
        adc     #$00
        sta     $07
        ldy     #$00
        lda     (L0006),y
        tay
L5A10:  lda     (L0006),y
        sta     $1F00,y
        dey
        bpl     L5A10
        dec     $1F00
        lda     #$2F
        sta     $1F01
        lda     #$00
        ldx     #$1F
        ldy     $1F00
        jsr     L6FB7
        lda     L704B
        beq     L5A4C
L5A2F:  ldx     L704B
        beq     L5A4C
        dex
        lda     L704C,x
        cmp     desktop_winid
        beq     L5A43
        sta     $D20E
        jsr     L4459
L5A43:  jsr     L61DC
        dec     L704B
        jmp     L5A2F

L5A4C:  jsr     L4523
        jsr     L6D2B
        lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     $E25B
        tay
        pha
        lda     $E1A0,y
        sta     $E22F
        beq     L5A7F
        jsr     L8AF4
        dec     $DD9E
        lda     $E22F
        jsr     DESKTOP_FREE_SPACE
        jsr     L4510
        DESKTOP_RELAY_CALL $04, $E22F
L5A7F:  lda     buf3len
        sta     L5AC6
        inc     buf3len
        inc     $DD9E
        pla
        tay
        lda     $BF32,y
        jsr     L89B6
        bit     L5AD0
        bmi     L5AA9
        and     #$FF
        beq     L5AA9
        cmp     #$2F
        beq     L5AA9
        pha
        jsr     DESKTOP_COPY_FROM_BUF
        pla
        jsr     DESKTOP_SHOW_ALERT0
        rts

L5AA9:  lda     buf3len
        cmp     L5AC6
        beq     L5AC0
        ldx     buf3len
        dex
        lda     buf3,x
        jsr     L86E3
        ldy     #$01
        jsr     DESKTOP_RELAY
L5AC0:  jsr     DESKTOP_COPY_FROM_BUF
        jmp     L4523

L5AC6:  .res    10, 0
L5AD0:  .byte   0
        ldx     $E25B
        dex
        txa
        asl     a
        asl     a
        asl     a
        clc
        adc     #$06
        tax
        lda     $E44C,x
        sec
        sbc     #$30
        clc
        adc     #$C0
        sta     L5B19+1
        lda     #$00
        sta     L5B19
L5AEE:  sta     ALTZPOFF
        lda     ROMIN2
        jsr     SETVID
        jsr     SETKBD
        jsr     INIT
        jsr     HOME
        sta     TXTSET
        sta     LOWSCR
        sta     LORES
        sta     MIXCLR
        sta     DHIRESOFF
        sta     CLRALTCHAR
        sta     CLR80VID
        sta     CLR80COL

        L5B19 := *+1
        jmp     $0000           ; self-modified

L5B1B:  .byte   0
L5B1C:  lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        ldx     desktop_winid
        dex
        lda     $E6D1,x
        sta     L5B1B
        ldx     #$03
L5B31:  lda     $EBFD,x
        sta     $D209,x
        dex
        bpl     L5B31
        A2D_RELAY_CALL A2D_QUERY_CLIENT, $D209
        lda     $D20D
        bne     L5B4B
        jmp     L5CB7

L5B4B:  bit     $D2AA
        bmi     L5B53
        jmp     L5C26

L5B53:  cmp     #$03
        bne     L5B58
        rts

L5B58:  cmp     #$01
        bne     L5BC1
        lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$05
        lda     (L0006),y
        and     #$01
        bne     L5B71
        jmp     L5C26

L5B71:  jsr     L5803
        lda     $D20E
        cmp     #$05
        bne     L5B81
        jsr     L5C31
        jmp     L5C26

L5B81:  cmp     #$01
        bne     L5B92
L5B85:  jsr     L5853
        lda     #$01
        jsr     L5C89
        bpl     L5B85
        jmp     L5C26

L5B92:  cmp     #$02
        bne     L5BA3
L5B96:  jsr     L5846
        lda     #$02
        jsr     L5C89
        bpl     L5B96
        jmp     L5C26

L5BA3:  cmp     #$04
        beq     L5BB4
L5BA7:  jsr     L638C
        lda     #$03
        jsr     L5C89
        bpl     L5BA7
        jmp     L5C26

L5BB4:  jsr     L63EC
        lda     #$04
        jsr     L5C89
        bpl     L5BB4
        jmp     L5C26

L5BC1:  lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$04
        lda     (L0006),y
        and     #$01
        bne     L5BD6
        jmp     L5C26

L5BD6:  jsr     L5803
        lda     $D20E
        cmp     #$05
        bne     L5BE6
        jsr     L5C31
        jmp     L5C26

L5BE6:  cmp     #$01
        bne     L5BF7
L5BEA:  jsr     L583C
        lda     #$01
        jsr     L5C89
        bpl     L5BEA
        jmp     L5C26

L5BF7:  cmp     #$02
        bne     L5C08
L5BFB:  jsr     L582F
        lda     #$02
        jsr     L5C89
        bpl     L5BFB
        jmp     L5C26

L5C08:  cmp     #$04
        beq     L5C19
L5C0C:  jsr     L6451
        lda     #$03
        jsr     L5C89
        bpl     L5C0C
        jmp     L5C26

L5C19:  jsr     L64B0
        lda     #$04
        jsr     L5C89
        bpl     L5C19
        jmp     L5C26

L5C26:  jsr     DESKTOP_COPY_FROM_BUF
        lda     #$00
        sta     bufnum
        jmp     DESKTOP_COPY_TO_BUF

L5C31:  lda     $D20D
        sta     $D208
        A2D_RELAY_CALL A2D_DRAG_SCROLL, $D208
        lda     $D20E
        bne     L5C46
        rts

L5C46:  jsr     L5C54
        jsr     DESKTOP_COPY_FROM_BUF
        lda     #$00
        sta     bufnum
        jmp     DESKTOP_COPY_TO_BUF

L5C54:  lda     $D20D
        sta     $D209
        A2D_RELAY_CALL A2D_UPDATE_SCROLL, $D208
        jsr     L6523
        jsr     L84D1
        bit     L5B1B
        bmi     L5C71
        jsr     L6E6E
L5C71:  lda     desktop_winid
        sta     $D212
        jsr     L44F2
        A2D_RELAY_CALL A2D_FILL_RECT, $D21D
        jsr     L4510
        jmp     L6C19

L5C89:  sta     L5CB6
        jsr     L48F0
        lda     $D208
        cmp     #$04
        beq     L5C99
L5C96:  lda     #$FF
        rts

L5C99:  A2D_RELAY_CALL A2D_QUERY_CLIENT, $D209
        lda     $D20D
        beq     L5C96
        cmp     #$03
        beq     L5C96
        lda     $D20E
        cmp     L5CB6
        bne     L5C96
        lda     #$00
        rts

L5CB6:  .byte   0
L5CB7:  bit     L5B1B
        bpl     L5CBF
        jmp     L6D2B

L5CBF:  lda     desktop_winid
        sta     $D20E
        DESKTOP_RELAY_CALL $09, $D209
        lda     $D20D
        bne     L5CDA
        jsr     L5F13
        jmp     L5DEC

L5CD9:  .byte   0
L5CDA:  sta     L5CD9
        ldx     $DF21
        beq     L5CFB
        dex
        lda     L5CD9
L5CE6:  cmp     $DF22,x
        beq     L5CF0
        dex
        bpl     L5CE6
        bmi     L5CFB
L5CF0:  bit     $D2AA
        bmi     L5CF8
        jmp     L5DFC

L5CF8:  jmp     L5D55

L5CFB:  bit     BUTN0
        bpl     L5D08
        lda     $DF20
        cmp     desktop_winid
        beq     L5D0B
L5D08:  jsr     L6D2B
L5D0B:  ldx     $DF21
        lda     L5CD9
        sta     $DF22,x
        inc     $DF21
        lda     desktop_winid
        sta     $DF20
        lda     desktop_winid
        sta     $D212
        jsr     L44F2
        lda     L5CD9
        sta     $E22F
        jsr     L8915
        jsr     L6E8E
        DESKTOP_RELAY_CALL $02, $E22F
        lda     desktop_winid
        sta     $D212
        jsr     L44F2
        lda     L5CD9
        jsr     L8893
        jsr     L4510
        bit     $D2AA
        bmi     L5D55
        jmp     L5DFC

L5D55:  lda     L5CD9
        sta     $EBFC
        DESKTOP_RELAY_CALL $0A, $EBFC
        tax
        lda     $EBFC
        beq     L5DA6
        jsr     L8F00
        cmp     #$FF
        bne     L5D77
        jsr     L5DEC
        jmp     L4523

L5D77:  lda     $EBFC
        cmp     $EBFB
        bne     L5D8E
        lda     desktop_winid
        jsr     L6F0D
        lda     desktop_winid
        jsr     L5E78
        jmp     L4523

L5D8E:  lda     $EBFC
        bmi     L5D99
        jsr     L6A3F
        jmp     L4523

L5D99:  and     #$7F
        pha
        jsr     L6F0D
        pla
        jsr     L5E78
        jmp     L4523

L5DA6:  cpx     #$02
        bne     L5DAD
        jmp     L5DEC

L5DAD:  cpx     #$FF
        beq     L5DF7
        lda     desktop_winid
        sta     $D212
        jsr     L44F2
        jsr     L6E52
        jsr     L6E8E
        ldx     $DF21
        dex
L5DC4:  txa
        pha
        lda     $DF22,x
        sta     $E22E
        DESKTOP_RELAY_CALL $03, $E22E
        pla
        tax
        dex
        bpl     L5DC4
        lda     desktop_winid
        sta     $D212
        jsr     L44F2
        jsr     L6DB1
        jsr     L6E6E
        jsr     L4510
L5DEC:  jsr     DESKTOP_COPY_FROM_BUF
        lda     #$00
        sta     bufnum
        jmp     DESKTOP_COPY_TO_BUF

L5DF7:  ldx     $E256
        txs
        rts

L5DFC:  lda     L5CD9
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        and     #$70
        cmp     #$10
        beq     L5E28
        cmp     #$20
        beq     L5E28
        cmp     #$30
        beq     L5E28
        cmp     #$00
        bne     L5E27
        lda     L5CD9
        jsr     L6A8A
        bmi     L5E27
        jmp     L5DEC

L5E27:  rts

L5E28:  sta     L5E77
        lda     desktop_winid
        jsr     L86FB
        sta     L0006
        stx     $07
        ldy     #$00
        lda     (L0006),y
        tay
L5E3A:  lda     (L0006),y
        sta     $D355,y
        dey
        bpl     L5E3A
        lda     L5CD9
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$09
        lda     (L0006),y
        tax
        clc
        adc     #$09
        tay
        dex
        dey
L5E57:  lda     (L0006),y
        sta     $D344,x
        dey
        dex
        bne     L5E57
        ldy     #$09
        lda     (L0006),y
        tax
        dex
        dex
        stx     $D345
        lda     L5E77
        cmp     #$20
        bcc     L5E74
        lda     L5E77
L5E74:  jmp     L46DE

L5E77:  .byte   0
L5E78:  sta     L5F0A
        jsr     L4523
        jsr     L6D2B
        lda     L5F0A
        cmp     desktop_winid
        beq     L5E8F
        sta     $D20E
        jsr     L4459
L5E8F:  lda     desktop_winid
        sta     $D212
        jsr     L44F2
        jsr     L4904
        A2D_RELAY_CALL A2D_FILL_RECT, $D21D
        ldx     desktop_winid
        dex
        lda     $EC26,x
        pha
        jsr     L7345
        lda     L5F0A
        tax
        dex
        lda     $E6D1,x
        bmi     L5EBC
        jsr     L5302
L5EBC:  lda     desktop_winid
        jsr     L86FB
        sta     L0006
        stx     $07
        ldy     #$00
        lda     (L0006),y
        tay
L5ECB:  lda     (L0006),y
        sta     $E1B0,y
        dey
        bpl     L5ECB
        pla
        jsr     L7054
        jsr     L5106
        jsr     DESKTOP_COPY_FROM_BUF
        lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     desktop_winid
        sta     $D212
        jsr     L4505
        jsr     L78EF
        lda     #$00
        ldx     desktop_winid
        sta     $E6D0,x
        lda     #$01
        sta     $E25B
        jsr     L52DF
        lda     #$00
        sta     bufnum
        jmp     DESKTOP_COPY_TO_BUF

L5F0A:  .byte   0
L5F0B:  .byte   0
        .byte   0
        .byte   0
        .byte   0
L5F0F:  .byte   0
        .byte   0
        .byte   0
        .byte   0
L5F13:  lda     #$06
        sta     L0006
        lda     #$D2
        sta     $07
        jsr     L60D5
        ldx     #$03
L5F20:  lda     $D209,x
        sta     L5F0B,x
        sta     L5F0F,x
        dex
        bpl     L5F20
        jsr     L48F0
        lda     $D208
        cmp     #$04
        beq     L5F3F
        bit     BUTN0
        bmi     L5F3E
        jsr     L6D2B
L5F3E:  rts

L5F3F:  jsr     L6D2B
        lda     desktop_winid
        sta     $D212
        jsr     L4505
        jsr     L6E8E
        ldx     #$03
L5F50:  lda     L5F0B,x
        sta     $E230,x
        lda     L5F0F,x
        sta     $E234,x
        dex
        bpl     L5F50
        jsr     L48FA
        A2D_RELAY_CALL A2D_DRAW_RECT, $E230
L5F6B:  jsr     L48F0
        lda     $D208
        cmp     #$04
        beq     L5FC5
        A2D_RELAY_CALL A2D_DRAW_RECT, $E230
        ldx     #$00
L5F80:  cpx     buf3len
        bne     L5F88
        jmp     L4510

L5F88:  txa
        pha
        lda     buf3,x
        sta     $E22F
        jsr     L8915
        DESKTOP_RELAY_CALL $0D, $E22F
        beq     L5FB9
        DESKTOP_RELAY_CALL $02, $E22F
        ldx     $DF21
        inc     $DF21
        lda     $E22F
        sta     $DF22,x
        lda     desktop_winid
        sta     $DF20
L5FB9:  lda     $E22F
        jsr     L8893
        pla
        tax
        inx
        jmp     L5F80

L5FC5:  jsr     L60D5
        lda     $D209
        sec
        sbc     L60CF
        sta     L60CB
        lda     $D20A
        sbc     L60D0
        sta     L60CC
        lda     $D20B
        sec
        sbc     L60D1
        sta     L60CD
        lda     $D20C
        sbc     L60D2
        sta     L60CE
        lda     L60CC
        bpl     L5FFE
        lda     L60CB
        eor     #$FF
        sta     L60CB
        inc     L60CB
L5FFE:  lda     L60CE
        bpl     L600E
        lda     L60CD
        eor     #$FF
        sta     L60CD
        inc     L60CD
L600E:  lda     L60CB
        cmp     #$05
        bcs     L601F
        lda     L60CD
        cmp     #$05
        bcs     L601F
        jmp     L5F6B

L601F:  A2D_RELAY_CALL A2D_DRAW_RECT, $E230
        ldx     #$03
L602A:  lda     $D209,x
        sta     L60CF,x
        dex
        bpl     L602A
        lda     $D209
        cmp     $E234
        lda     $D20A
        sbc     $E235
        bpl     L6068
        lda     $D209
        cmp     $E230
        lda     $D20A
        sbc     $E231
        bmi     L6054
        bit     L60D3
        bpl     L6068
L6054:  lda     $D209
        sta     $E230
        lda     $D20A
        sta     $E231
        lda     #$80
        sta     L60D3
        jmp     L6079

L6068:  lda     $D209
        sta     $E234
        lda     $D20A
        sta     $E235
        lda     #$00
        sta     L60D3
L6079:  lda     $D20B
        cmp     $E236
        lda     $D20C
        sbc     $E237
        bpl     L60AE
        lda     $D20B
        cmp     $E232
        lda     $D20C
        sbc     $E233
        bmi     L609A
        bit     L60D4
        bpl     L60AE
L609A:  lda     $D20B
        sta     $E232
        lda     $D20C
        sta     $E233
        lda     #$80
        sta     L60D4
        jmp     L60BF

L60AE:  lda     $D20B
        sta     $E236
        lda     $D20C
        sta     $E237
        lda     #$00
        sta     L60D4
L60BF:  A2D_RELAY_CALL A2D_DRAW_RECT, $E230
        jmp     L5F6B

L60CB:  .byte   0
L60CC:  .byte   0
L60CD:  .byte   0
L60CE:  .byte   0
L60CF:  .byte   0
L60D0:  .byte   0
L60D1:  .byte   0
L60D2:  .byte   0
L60D3:  .byte   0
L60D4:  .byte   0
L60D5:  jsr     push_addrs_from_zp
        jmp     L8921

L60DB:  jmp     L60DE

L60DE:  lda     desktop_winid
        sta     $D208
        A2D_RELAY_CALL A2D_QUERY_TOP, desktop_winid
        lda     desktop_winid
        jsr     L8855
        A2D_RELAY_CALL A2D_DRAG_WINDOW, $D208
        lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$16
        lda     (L0006),y
        cmp     #$19
        bcs     L6112
        lda     #$19
        sta     (L0006),y
L6112:  ldy     #$14
        lda     (L0006),y
        sec
        sbc     L8830
        sta     L6197
        iny
        lda     (L0006),y
        sbc     L8831
        sta     L6198
        iny
        lda     (L0006),y
        sec
        sbc     L8832
        sta     L6199
        iny
        lda     (L0006),y
        sbc     L8833
        sta     L619A
        ldx     desktop_winid
        dex
        lda     $E6D1,x
        beq     L6143
        rts

L6143:  lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        ldx     #$00
L614E:  cpx     buf3len
        bne     L6161
        jsr     DESKTOP_COPY_FROM_BUF
        lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        jmp     L6196

L6161:  txa
        pha
        lda     buf3,x
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$03
        lda     (L0006),y
        clc
        adc     L6197
        sta     (L0006),y
        iny
        lda     (L0006),y
        adc     L6198
        sta     (L0006),y
        iny
        lda     (L0006),y
        clc
        adc     L6199
        sta     (L0006),y
        iny
        lda     (L0006),y
        adc     L619A
        sta     (L0006),y
        pla
        tax
        inx
        jmp     L614E

L6196:  rts

L6197:  .byte   0
L6198:  .byte   0
L6199:  .byte   0
L619A:  .byte   0
L619B:  lda     desktop_winid
        sta     $D208
        A2D_RELAY_CALL A2D_DRAG_RESIZE, $D208
        jsr     L4523
        lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        jsr     L6E52
        jsr     L6DB1
        jsr     L6E6E
        lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        jmp     L4510

L61CA:  lda     desktop_winid
        A2D_RELAY_CALL A2D_CLOSE_CLICK, $D2A8
        lda     $D2A8
        bne     L61DC
        rts

L61DC:  lda     desktop_winid
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        jsr     L6D2B
        ldx     desktop_winid
        dex
        lda     $E6D1,x
        bmi     L6215
        lda     $DD9E
        sec
        sbc     buf3len
        sta     $DD9E
        DESKTOP_RELAY_CALL $07, desktop_winid
        ldx     #$00
L6206:  cpx     buf3len
        beq     L6215
        lda     buf3,x
        jsr     DESKTOP_FREE_SPACE
        inx
        jmp     L6206

L6215:  dec     $EC2E
        ldx     #$00
        txa
L621B:  sta     buf3,x
        cpx     buf3len
        beq     L6227
        inx
        jmp     L621B

L6227:  sta     buf3len
        jsr     DESKTOP_COPY_FROM_BUF
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, desktop_winid
        ldx     desktop_winid
        dex
        lda     $EC26,x
        sta     $E22F
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$01
        lda     (L0006),y
        and     #$0F
        beq     L6276
        ldy     #$02
        lda     (L0006),y
        and     #$7F
        sta     (L0006),y
        and     #$0F
        sta     $DF20
        jsr     L8997
        DESKTOP_RELAY_CALL $02, $E22F
        jsr     L4510
        lda     #$01
        sta     $DF21
        lda     $E22F
        sta     $DF22
L6276:  ldx     desktop_winid
        dex
        lda     $EC26,x
        jsr     L7345
        ldx     desktop_winid
        dex
        lda     $EC26,x
        inx
        jsr     L8B5C
        ldx     desktop_winid
        dex
        lda     #$00
        sta     $EC26,x
        sta     $E6D1,x
        A2D_RELAY_CALL A2D_QUERY_TOP, desktop_winid
        lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     #$00
        sta     $E269
        A2D_RELAY_CALL $36, $E267 ; ???
        jsr     L66A2
        jmp     L4523

L62BC:  cmp     #$01
        bcc     L62C2
        bne     L62C5
L62C2:  lda     #$00
        rts

L62C5:  sta     L638B
        stx     L6386
        sty     L638A
        cmp     L6386
        bcc     L62D5
        tya
        rts

L62D5:  lda     #$00
        sta     L6385
        sta     L6389
        clc
        ror     L6386
        ror     L6385
        clc
        ror     L638A
        ror     L6389
        lda     #$00
        sta     L6383
        sta     L6387
        sta     L6384
        sta     L6388
L62F9:  lda     L6384
        cmp     L638B
        beq     L630F
        bcc     L6309
        jsr     L6319
        jmp     L62F9

L6309:  jsr     L634E
        jmp     L62F9

L630F:  lda     L6388
        cmp     #$01
        bcs     L6318
        lda     #$01
L6318:  rts

L6319:  lda     L6383
        sec
        sbc     L6385
        sta     L6383
        lda     L6384
        sbc     L6386
        sta     L6384
        lda     L6387
        sec
        sbc     L6389
        sta     L6387
        lda     L6388
        sbc     L638A
        sta     L6388
        clc
        ror     L6386
        ror     L6385
        clc
        ror     L638A
        ror     L6389
        rts

L634E:  lda     L6383
        clc
        adc     L6385
        sta     L6383
        lda     L6384
        adc     L6386
        sta     L6384
        lda     L6387
        clc
        adc     L6389
        sta     L6387
        lda     L6388
        adc     L638A
        sta     L6388
        clc
        ror     L6386
        ror     L6385
        clc
        ror     L638A
        ror     L6389
        rts

L6383:  .byte   0
L6384:  .byte   0
L6385:  .byte   0
L6386:  .byte   0
L6387:  .byte   0
L6388:  .byte   0
L6389:  .byte   0
L638A:  .byte   0
L638B:  .byte   0
L638C:  jsr     L650F
        sty     L63E9
        jsr     L644C
        sta     L63E8
        lda     $D21F
        sec
        sbc     L63E8
        sta     L63EA
        lda     $D220
        sbc     #$00
        sta     L63EB
        lda     L63EA
        cmp     L7B61
        lda     L63EB
        sbc     L7B62
        bmi     L63C1
        lda     L63EA
        ldx     L63EB
        jmp     L63C7

L63C1:  lda     L7B61
        ldx     L7B62
L63C7:  sta     $D21F
        stx     $D220
        lda     $D21F
        clc
        adc     L63E9
        sta     $D223
        lda     $D220
        adc     #$00
        sta     $D224
        jsr     L653E
        jsr     L6DB1
        jmp     L6556

L63E8:  .byte   0
L63E9:  .byte   0
L63EA:  .byte   0
L63EB:  .byte   0
L63EC:  jsr     L650F
        sty     L6449
        jsr     L644C
        sta     L6448
        lda     $D223
        clc
        adc     L6448
        sta     L644A
        lda     $D224
        adc     #$00
        sta     L644B
        lda     L644A
        cmp     L7B65
        lda     L644B
        sbc     L7B66
        bpl     L6421
        lda     L644A
        ldx     L644B
        jmp     L6427

L6421:  lda     L7B65
        ldx     L7B66
L6427:  sta     $D223
        stx     $D224
        lda     $D223
        sec
        sbc     L6449
        sta     $D21F
        lda     $D224
        sbc     #$00
        sta     $D220
        jsr     L653E
        jsr     L6DB1
        jmp     L6556

L6448:  .byte   0
L6449:  .byte   0
L644A:  .byte   0
L644B:  .byte   0
L644C:  tya
        sec
        sbc     #$0E
        rts

L6451:  jsr     L650F
        sta     L64AC
        stx     L64AD
        lda     $D21D
        sec
        sbc     L64AC
        sta     L64AE
        lda     $D21E
        sbc     L64AD
        sta     L64AF
        lda     L64AE
        cmp     L7B5F
        lda     L64AF
        sbc     L7B60
        bmi     L6484
        lda     L64AE
        ldx     L64AF
        jmp     L648A

L6484:  lda     L7B5F
        ldx     L7B60
L648A:  sta     $D21D
        stx     $D21E
        lda     $D21D
        clc
        adc     L64AC
        sta     $D221
        lda     $D21E
        adc     L64AD
        sta     $D222
        jsr     L653E
        jsr     L6DB1
        jmp     L6556

L64AC:  .byte   0
L64AD:  .byte   0
L64AE:  .byte   0
L64AF:  .byte   0
L64B0:  jsr     L650F
        sta     L650B
        stx     L650C
        lda     $D221
        clc
        adc     L650B
        sta     L650D
        lda     $D222
        adc     L650C
        sta     L650E
        lda     L650D
        cmp     L7B63
        lda     L650E
        sbc     L7B64
        bpl     L64E3
        lda     L650D
        ldx     L650E
        jmp     L64E9

L64E3:  lda     L7B63
        ldx     L7B64
L64E9:  sta     $D221
        stx     $D222
        lda     $D221
        sec
        sbc     L650B
        sta     $D21D
        lda     $D222
        sbc     L650C
        sta     $D21E
        jsr     L653E
        jsr     L6DB1
        jmp     L6556

L650B:  .byte   0
L650C:  .byte   0
L650D:  .byte   0
L650E:  .byte   0
L650F:  bit     L5B1B
        bmi     L6517
        jsr     L6E52
L6517:  jsr     L6523
        jsr     L7B6B
        lda     desktop_winid
        jmp     L7D5D

L6523:  lda     desktop_winid
        jsr     L86EF
        clc
        adc     #$14
        sta     L0006
        txa
        adc     #$00
        sta     $07
        ldy     #$25
L6535:  lda     (L0006),y
        sta     $D215,y
        dey
        bpl     L6535
        rts

L653E:  lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$23
        ldx     #$07
L654C:  lda     $D21D,x
        sta     (L0006),y
        dey
        dex
        bpl     L654C
        rts

L6556:  bit     L5B1B
        bmi     L655E
        jsr     L6E6E
L655E:  A2D_RELAY_CALL A2D_FILL_RECT, $D21D
        jsr     L4510
        jmp     L6C19

L656D:  lda     desktop_winid
        jsr     L7D5D
        sta     L6600
        stx     L6601
        lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$06
        lda     (L0006),y
        tay
        lda     L7B63
        sec
        sbc     L7B5F
        sta     L6602
        lda     L7B64
        sbc     L7B60
        sta     L6603
        lda     L6602
        sec
        sbc     L6600
        sta     L6602
        lda     L6603
        sbc     L6601
        sta     L6603
        lsr     L6603
        ror     L6602
        ldx     L6602
        lda     $D21D
        sec
        sbc     L7B5F
        sta     L6602
        lda     $D21E
        sbc     L7B60
        sta     L6603
        bpl     L65D0
        lda     #$00
        beq     L65EB
L65D0:  lda     $D221
        cmp     L7B63
        lda     $D222
        sbc     L7B64
        bmi     L65E2
        tya
        jmp     L65EE

L65E2:  lsr     L6603
        ror     L6602
        lda     L6602
L65EB:  jsr     L62BC
L65EE:  sta     $D209
        lda     #$02
        sta     $D208
        A2D_RELAY_CALL A2D_UPDATE_SCROLL, $D208
        rts

L6600:  .byte   0
L6601:  .byte   0
L6602:  .byte   0
L6603:  .byte   0
L6604:  lda     desktop_winid
        jsr     L7D5D
        sty     L669F
        lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$08
        lda     (L0006),y
        tay
        lda     L7B65
        sec
        sbc     L7B61
        sta     L66A0
        lda     L7B66
        sbc     L7B62
        sta     L66A1
        lda     L66A0
        sec
        sbc     L669F
        sta     L66A0
        lda     L66A1
        sbc     #$00
        sta     L66A1
        lsr     L66A1
        ror     L66A0
        lsr     L66A1
        ror     L66A0
        ldx     L66A0
        lda     $D21F
        sec
        sbc     L7B61
        sta     L66A0
        lda     $D220
        sbc     L7B62
        sta     L66A1
        bpl     L6669
        lda     #$00
        beq     L668A
L6669:  lda     $D223
        cmp     L7B65
        lda     $D224
        sbc     L7B66
        bmi     L667B
        tya
        jmp     L668D

L667B:  lsr     L66A1
        ror     L66A0
        lsr     L66A1
        ror     L66A0
        lda     L66A0
L668A:  jsr     L62BC
L668D:  sta     $D209
        lda     #$01
        sta     $D208
        A2D_RELAY_CALL A2D_UPDATE_SCROLL, $D208
        rts

L669F:  .byte   0
L66A0:  .byte   0
L66A1:  .byte   0
L66A2:  ldx     desktop_winid
        beq     L66AA
        jmp     L66F2

L66AA:  lda     #$01
        sta     $E26B
        A2D_RELAY_CALL $34, $E26A ; ???
        lda     #$01
        sta     $E26E
        lda     #$02
        sta     $E26C
        lda     #$01
        sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        lda     #$04
        sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        lda     #$05
        sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        lda     #$00
        sta     L4359
        rts

L66F2:  dex
        lda     $E6D1,x
        and     #$0F
        tax
        inx
        stx     $E268
        lda     #$01
        sta     $E269
        A2D_RELAY_CALL $36, $E267 ; ???
        rts

L670C:  lda     #$01
        sta     $E26E
        lda     #$02
        sta     $E26C
        lda     #$03
        jsr     L673A
        lda     #$05
        sta     $E26C
        lda     #$07
        jsr     L673A
        lda     #$08
        jsr     L673A
        lda     #$0A
        jsr     L673A
        lda     #$0B
        jsr     L673A
        lda     #$0D
        jsr     L673A
        rts

L673A:  sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        rts

L6747:  lda     #$00
        sta     $E26E
        lda     #$02
        sta     $E26C
        lda     #$03
        jsr     L6775
        lda     #$05
        sta     $E26C
        lda     #$07
        jsr     L6775
        lda     #$08
        jsr     L6775
        lda     #$0A
        jsr     L6775
        lda     #$0B
        jsr     L6775
        lda     #$0D
        jsr     L6775
        rts

L6775:  sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        rts

L6782:  lda     #$00
        sta     $E26E
        jmp     L678F

L678A:  lda     #$01
        sta     $E26E
L678F:  lda     #$02
        sta     $E26C
        lda     #$0B
        sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        rts

L67A3:  lda     #$01
        sta     $E26E
        jmp     L67B0

L67AB:  lda     #$00
        sta     $E26E
L67B0:  lda     #$03
        sta     $E26C
        lda     #$02
        jsr     L67CA
        lda     #$03
        jsr     L67CA
        lda     #$04
        jsr     L67CA
        lda     #$80
        sta     $D344
        rts

L67CA:  sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        rts

L67D7:  lda     $DF21
        bne     L67DF
        jmp     L681B

L67DF:  tax
        dex
        lda     $D20D
L67E4:  cmp     $DF22,x
        beq     L67EE
        dex
        bpl     L67E4
        bmi     L67F6
L67EE:  bit     $D2AA
        bmi     L6834
        jmp     L6880

L67F6:  bit     BUTN0
        bpl     L6818
        lda     $DF20
        bne     L6818
        DESKTOP_RELAY_CALL $02, $D20D
        ldx     $DF21
        lda     $D20D
        sta     $DF22,x
        inc     $DF21
        jmp     L6834

L6818:  jsr     L6D2B
L681B:  DESKTOP_RELAY_CALL $02, $D20D
        lda     #$01
        sta     $DF21
        lda     $D20D
        sta     $DF22
        lda     #$00
        sta     $DF20
L6834:  bit     $D2AA
        bpl     L6880
        lda     $D20D
        sta     $EBFC
        DESKTOP_RELAY_CALL $0A, $EBFC
        tax
        lda     $EBFC
        beq     L6878
        jsr     L8F00
        cmp     #$FF
        bne     L6858
        jmp     L4523

L6858:  lda     $EBFC
        cmp     $EBFB
        bne     L6863
        jmp     L4523

L6863:  lda     $EBFC
        bpl     L6872
        and     #$7F
        pha
        jsr     L6F0D
        pla
        jmp     L5E78

L6872:  jsr     L6A3F
        jmp     L4523

L6878:  txa
        cmp     #$02
        bne     L688F
        jmp     L4523

L6880:  lda     $D20D
        cmp     $EBFB
        beq     L688E
        jsr     L6A8A
        jsr     DESKTOP_COPY_FROM_BUF
L688E:  rts

L688F:  ldx     $DF21
        dex
L6893:  txa
        pha
        lda     $DF22,x
        sta     $E22D
        DESKTOP_RELAY_CALL $03, $E22D
        pla
        tax
        dex
        bpl     L6893
        rts

L68AA:  jsr     L4510
        bit     BUTN0
        bpl     L68B3
        rts

L68B3:  jsr     L6D2B
        ldx     #$03
L68B8:  lda     $D209,x
        sta     $E230,x
        sta     $E234,x
        dex
        bpl     L68B8
        jsr     L48F0
        lda     $D208
        cmp     #$04
        beq     L68CF
        rts

L68CF:  A2D_RELAY_CALL A2D_SET_PATTERN, $D293
        jsr     L48FA
        A2D_RELAY_CALL A2D_DRAW_RECT, $E230
L68E4:  jsr     L48F0
        lda     $D208
        cmp     #$04
        beq     L6932
        A2D_RELAY_CALL A2D_DRAW_RECT, $E230
        ldx     #$00
L68F9:  cpx     buf3len
        bne     L6904
        lda     #$00
        sta     $DF20
        rts

L6904:  txa
        pha
        lda     buf3,x
        sta     $E22F
        DESKTOP_RELAY_CALL $0D, $E22F
        beq     L692C
        DESKTOP_RELAY_CALL $02, $E22F
        ldx     $DF21
        inc     $DF21
        lda     $E22F
        sta     $DF22,x
L692C:  pla
        tax
        inx
        jmp     L68F9

L6932:  lda     $D209
        sec
        sbc     L6A39
        sta     L6A35
        lda     $D20A
        sbc     L6A3A
        sta     L6A36
        lda     $D20B
        sec
        sbc     L6A3B
        sta     L6A37
        lda     $D20C
        sbc     L6A3C
        sta     L6A38
        lda     L6A36
        bpl     L6968
        lda     L6A35
        eor     #$FF
        sta     L6A35
        inc     L6A35
L6968:  lda     L6A38
        bpl     L6978
        lda     L6A37
        eor     #$FF
        sta     L6A37
        inc     L6A37
L6978:  lda     L6A35
        cmp     #$05
        bcs     L6989
        lda     L6A37
        cmp     #$05
        bcs     L6989
        jmp     L68E4

L6989:  A2D_RELAY_CALL A2D_DRAW_RECT, $E230
        ldx     #$03
L6994:  lda     $D209,x
        sta     L6A39,x
        dex
        bpl     L6994
        lda     $D209
        cmp     $E234
        lda     $D20A
        sbc     $E235
        bpl     L69D2
        lda     $D209
        cmp     $E230
        lda     $D20A
        sbc     $E231
        bmi     L69BE
        bit     L6A3D
        bpl     L69D2
L69BE:  lda     $D209
        sta     $E230
        lda     $D20A
        sta     $E231
        lda     #$80
        sta     L6A3D
        jmp     L69E3

L69D2:  lda     $D209
        sta     $E234
        lda     $D20A
        sta     $E235
        lda     #$00
        sta     L6A3D
L69E3:  lda     $D20B
        cmp     $E236
        lda     $D20C
        sbc     $E237
        bpl     L6A18
        lda     $D20B
        cmp     $E232
        lda     $D20C
        sbc     $E233
        bmi     L6A04
        bit     L6A3E
        bpl     L6A18
L6A04:  lda     $D20B
        sta     $E232
        lda     $D20C
        sta     $E233
        lda     #$80
        sta     L6A3E
        jmp     L6A29

L6A18:  lda     $D20B
        sta     $E236
        lda     $D20C
        sta     $E237
        lda     #$00
        sta     L6A3E
L6A29:  A2D_RELAY_CALL A2D_DRAW_RECT, $E230
        jmp     L68E4

L6A35:  .byte   0
L6A36:  .byte   0
L6A37:  .byte   0
L6A38:  .byte   0
L6A39:  .byte   0
L6A3A:  .byte   0
L6A3B:  .byte   0
L6A3C:  .byte   0
L6A3D:  .byte   0
L6A3E:  .byte   0
L6A3F:  ldx     #$07
L6A41:  cmp     $EC26,x
        beq     L6A80
        dex
        bpl     L6A41
        jsr     L86E3
        clc
        adc     #$09
        sta     L0006
        txa
        adc     #$00
        sta     $07
        ldy     #$00
        lda     (L0006),y
        tay
        dey
L6A5C:  lda     (L0006),y
        sta     $0220,y
        dey
        bpl     L6A5C
        dec     $0220
        lda     #$2F
        sta     $0221
        lda     #$20
        ldx     #$02
        ldy     $0220
        jsr     L6FB7
        lda     #$20
        ldx     #$02
        ldy     $0220
        jmp     L6F4B

L6A80:  inx
        txa
        pha
        jsr     L6F0D
        pla
        jmp     L5E78

L6A8A:  sta     $E6BE
        jsr     DESKTOP_COPY_FROM_BUF
        lda     $E6BE
        ldx     #$07
L6A95:  cmp     $EC26,x
        beq     L6AA0
        dex
        bpl     L6A95
        jmp     L6B1E

L6AA0:  inx
        cpx     desktop_winid
        bne     L6AA7
        rts

L6AA7:  stx     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        lda     $E6BE
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        ora     #$80
        sta     (L0006),y
        ldy     #$02
        lda     (L0006),y
        and     #$0F
        sta     $D212
        beq     L6AD8
        cmp     desktop_winid
        bne     L6AEF
        jsr     L44F2
        lda     $E6BE
        jsr     L8915
L6AD8:  DESKTOP_RELAY_CALL $03, $E6BE
        lda     $D212
        beq     L6AEF
        lda     $E6BE
        jsr     L8893
        jsr     L4510
L6AEF:  lda     $E6BE
        ldx     $E1F1
        dex
L6AF6:  cmp     $E1F2,x
        beq     L6B01
        dex
        bpl     L6AF6
        jsr     L7054
L6B01:  A2D_RELAY_CALL A2D_RAISE_WINDOW, bufnum
        lda     bufnum
        sta     desktop_winid
        jsr     L6C19
        jsr     L40F2
        lda     #$00
        sta     bufnum
        jmp     DESKTOP_COPY_TO_BUF

L6B1E:  lda     $EC2E
        cmp     #$08
        bcc     L6B2F
        lda     #$05
        jsr     L48CC
        ldx     $E256
        txs
        rts

L6B2F:  ldx     #$00
L6B31:  lda     $EC26,x
        beq     L6B3A
        inx
        jmp     L6B31

L6B3A:  lda     $E6BE
        sta     $EC26,x
        inx
        stx     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        inc     $EC2E
        ldx     bufnum
        dex
        lda     #$00
        sta     $E6D1,x
        lda     $EC2E
        cmp     #$02
        bcs     L6B60
        jsr     L6EC5
        jmp     L6B68

L6B60:  lda     #$00
        sta     $E269
        jsr     L6C0F
L6B68:  lda     #$01
        sta     $E268
        sta     $E269
        jsr     L6C0F
        lda     $E6BE
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        ora     #$80
        sta     (L0006),y
        ldy     #$02
        lda     (L0006),y
        and     #$0F
        sta     $D212
        beq     L6BA1
        cmp     desktop_winid
        bne     L6BB8
        jsr     L44F2
        jsr     L6E8E
        lda     $E6BE
        jsr     L8915
L6BA1:  DESKTOP_RELAY_CALL $03, $E6BE
        lda     $D212
        beq     L6BB8
        lda     $E6BE
        jsr     L8893
        jsr     L4510
L6BB8:  jsr     L744B
        lda     bufnum
        jsr     L86EF
        ldy     #$38
        jsr     A2D_RELAY
        lda     desktop_winid
        sta     $D212
        jsr     L44F2
        jsr     L78EF
        jsr     L6E52
        lda     #$00
        sta     L6C0E
L6BDA:  lda     L6C0E
        cmp     buf3len
        beq     L6BF4
        tax
        lda     buf3,x
        jsr     L86E3
        ldy     #$01
        jsr     DESKTOP_RELAY
        inc     L6C0E
        jmp     L6BDA

L6BF4:  lda     bufnum
        sta     desktop_winid
        jsr     L6DB1
        jsr     L6E6E
        jsr     DESKTOP_COPY_FROM_BUF
        lda     #$00
        sta     bufnum
        jsr     DESKTOP_COPY_TO_BUF
        jmp     L4510

L6C0E:  .byte   0
L6C0F:  A2D_RELAY_CALL $36, $E267 ; ???
        rts

L6C19:  ldx     bufnum
        dex
        lda     $E6D1,x
        bmi     L6C25
        jmp     L6CCD

L6C25:  jsr     push_addrs_from_zp
        lda     bufnum
        sta     $D212
        jsr     L44F2
        bit     L4152
        bmi     L6C39
        jsr     L78EF
L6C39:  lda     bufnum
        sta     $D212
        jsr     L4505
L6C42:  bit     L4152
        bmi     L6C4A
        jsr     L6E8E
L6C4A:  ldx     bufnum
        dex
        lda     $EC26,x
        ldx     #$00
L6C53:  cmp     $E1F2,x
        beq     L6C5F
        inx
        cpx     $E1F1
        bne     L6C53
        rts

L6C5F:  txa
        asl     a
        tax
        lda     $E202,x
        sta     $E71D
        sta     L0006
        lda     $E203,x
        sta     $E71E
        sta     $07
        lda     LCBANK2
        lda     LCBANK2
        ldy     #$00
        lda     (L0006),y
        tay
        lda     LCBANK1
        lda     LCBANK1
        tya
        sta     $E71F
        inc     $E71D
        bne     L6C8F
        inc     $E71E
L6C8F:  lda     #$10
        sta     $E6DB
        sta     $E6DF
        sta     $E6E3
        sta     $E6E7
        lda     #$00
        sta     $E6DC
        sta     $E6E0
        sta     $E6E4
        sta     $E6E8
        lda     #$00
        sta     L6CCC
L6CB0:  lda     L6CCC
        cmp     buf3len
        beq     L6CC5
        tax
        lda     buf3,x
        jsr     L813F
        inc     L6CCC
        jmp     L6CB0

L6CC5:  jsr     L4510
        jsr     pop_addrs_to_zp
        rts

L6CCC:  .byte   0
L6CCD:  lda     bufnum
        sta     $D212
        jsr     L44F2
        bit     L4152
        bmi     L6CDE
        jsr     L78EF
L6CDE:  jsr     L6E52
        jsr     L6E8E
        ldx     #$07
L6CE6:  lda     $D21D,x
        sta     $E230,x
        dex
        bpl     L6CE6
        ldx     #$00
        txa
        pha
L6CF3:  cpx     buf3len
        bne     L6D09
        pla
        jsr     L4510
        lda     bufnum
        sta     $D212
        jsr     L44F2
        jsr     L6E6E
        rts

L6D09:  txa
        pha
        lda     buf3,x
        sta     $E22F
        DESKTOP_RELAY_CALL $0D, $E22F
        beq     L6D25
        DESKTOP_RELAY_CALL $03, $E22F
L6D25:  pla
        tax
        inx
        jmp     L6CF3

L6D2B:  lda     $DF21
        bne     L6D31
        rts

L6D31:  lda     #$00
        sta     L6DB0
        lda     $DF20
        sta     $E230
        beq     L6D7D
        cmp     desktop_winid
        beq     L6D4D
        jsr     L8997
        lda     #$00
        sta     $E230
        beq     L6D56
L6D4D:  sta     $D212
        jsr     L44F2
        jsr     L6E8E
L6D56:  lda     L6DB0
        cmp     $DF21
        beq     L6D9B
        tax
        lda     $DF22,x
        sta     $E22F
        jsr     L8915
        DESKTOP_RELAY_CALL $0B, $E22F
        lda     $E22F
        jsr     L8893
        inc     L6DB0
        jmp     L6D56

L6D7D:  lda     L6DB0
        cmp     $DF21
        beq     L6D9B
        tax
        lda     $DF22,x
        sta     $E22F
        DESKTOP_RELAY_CALL $0B, $E22F
        inc     L6DB0
        jmp     L6D7D

L6D9B:  lda     #$00
        ldx     $DF21
        dex
L6DA1:  sta     $DF22,x
        dex
        bpl     L6DA1
        sta     $DF21
        sta     $DF20
        jmp     L4510

L6DB0:  .byte   0
L6DB1:  ldx     desktop_winid
        dex
        lda     $E6D1,x
        bmi     L6DC0
        jsr     L7B6B
        jmp     L6DC9

L6DC0:  jsr     L6E52
        jsr     L7B6B
        jsr     L6E6E
L6DC9:  lda     desktop_winid
        sta     $D212
        jsr     L44F2
        lda     L7B5F
        cmp     $D21D
        lda     L7B60
        sbc     $D21E
        bmi     L6DFE
        lda     $D221
        cmp     L7B63
        lda     $D222
        sbc     L7B64
        bmi     L6DFE
        lda     #$02
        sta     $D208
        lda     #$00
        sta     $D209
        jsr     L6E48
        jmp     L6E0E

L6DFE:  lda     #$02
        sta     $D208
        lda     #$01
        sta     $D209
        jsr     L6E48
        jsr     L656D
L6E0E:  lda     L7B61
        cmp     $D21F
        lda     L7B62
        sbc     $D220
        bmi     L6E38
        lda     $D223
        cmp     L7B65
        lda     $D224
        sbc     L7B66
        bmi     L6E38
        lda     #$01
        sta     $D208
        lda     #$00
        sta     $D209
        jsr     L6E48
        rts

L6E38:  lda     #$01
        sta     $D208
        lda     #$01
        sta     $D209
        jsr     L6E48
        jmp     L6604

L6E48:  A2D_RELAY_CALL $4C, $D208 ; ???
        rts

L6E52:  lda     #$00
        sta     L6E6D
L6E57:  lda     L6E6D
        cmp     buf3len
        beq     L6E6C
        tax
        lda     buf3,x
        jsr     L8915
        inc     L6E6D
        jmp     L6E57

L6E6C:  rts

L6E6D:  .byte   0
L6E6E:  lda     #$00
        sta     L6E89
L6E73:  lda     L6E89
        cmp     buf3len
        beq     L6E88
        tax
        lda     buf3,x
        jsr     L8893
        inc     L6E89
        jmp     L6E73

L6E88:  rts

L6E89:  .byte   0
L6E8A:  lda     #$80
        beq     L6E90
L6E8E:  lda     #$00
L6E90:  sta     L6EC4
        lda     $D217
        clc
        adc     #$0F
        sta     $D217
        lda     $D218
        adc     #$00
        sta     $D218
        lda     $D21F
        clc
        adc     #$0F
        sta     $D21F
        lda     $D220
        adc     #$00
        sta     $D220
        bit     L6EC4
        bmi     L6EC3
        A2D_RELAY_CALL A2D_SET_STATE, $D215
L6EC3:  rts

L6EC4:  .byte   0
L6EC5:  lda     #$00
        sta     $E26B
        A2D_RELAY_CALL $34, $E26A ; ???
        lda     #$00
        sta     $E26E
        lda     #$02
        sta     $E26C
        lda     #$01
        sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        lda     #$04
        sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        lda     #$05
        sta     $E26D
        A2D_RELAY_CALL $35, $E26C ; ???
        lda     #$80
        sta     L4359
        rts

L6F0D:  jsr     L86FB
        sta     L0006
        sta     L6F48
        stx     $07
        stx     L6F49
        ldy     #$00
        lda     (L0006),y
        sta     L6F4A
        iny
L6F22:  iny
        lda     (L0006),y
        cmp     #$2F
        beq     L6F31
        cpy     L6F4A
        beq     L6F32
        jmp     L6F22

L6F31:  dey
L6F32:  sty     L6F4A
        lda     L0006
        ldx     $07
        jsr     L6FB7
        lda     L6F48
        ldx     L6F49
        ldy     L6F4A
        jmp     L6F4B

L6F48:  .byte   0
L6F49:  .byte   0
L6F4A:  .byte   0
L6F4B:  sta     L0006
        stx     $07
        sty     L705D
L6F52:  lda     (L0006),y
        sta     L705D,y
        dey
        bne     L6F52
        jsr     L72EC
        bne     L6F8F
        lda     L704B
        beq     L6F8F
L6F64:  dec     L704B
        bmi     L6F8F
        ldx     L704B
        lda     L704C,x
        sec
        sbc     #$01
        asl     a
        tax
        lda     L70BD
        sta     $EB8B,x
        lda     L70BE
        sta     $EB8C,x
        lda     L70BB
        sta     $EB9B,x
        lda     L70BC
        sta     $EB9C,x
        jmp     L6F64

L6F8F:  rts

L6F90:  sta     $0A
        stx     $0B
        ldy     #$00
        lda     ($0A),y
        tay
L6F99:  lda     ($0A),y
        cmp     #$2F
        beq     L6FA9
        dey
        bpl     L6F99
        ldy     #$01
L6FA4:  dey
        lda     ($0A),y
        tay
        rts

L6FA9:  cpy     #$01
        beq     L6FA4
        dey
        rts

L6FAF:  sta     L0006
        stx     $07
        lda     #$80
        bne     L6FBD
L6FB7:  sta     L0006
        stx     $07
        lda     #$00
L6FBD:  sta     L704A
        bit     L704A
        bpl     L6FCA
        ldy     #$00
        lda     (L0006),y
        tay
L6FCA:  sty     L4F76
L6FCD:  lda     (L0006),y
        sta     L4F76,y
        dey
        bne     L6FCD
        lda     #$76
        ldx     #$4F
        jsr     L87BA
        lda     #$00
        sta     L704B
        sta     L7049
L6FE4:  inc     L7049
        lda     L7049
        cmp     #$09
        bcc     L6FF6
        bit     L704A
        bpl     L6FF5
        lda     #$00
L6FF5:  rts

L6FF6:  jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$0A
        lda     (L0006),y
        beq     L6FE4
        lda     L7049
        jsr     L86FB
        sta     L0006
        stx     $07
        ldy     #$00
        lda     (L0006),y
        tay
        cmp     L4F76
        beq     L7027
        bit     L704A
        bmi     L6FE4
        ldy     L4F76
        iny
        lda     (L0006),y
        cmp     #$2F
        bne     L6FE4
        dey
L7027:  lda     (L0006),y
        cmp     L4F76,y
        bne     L6FE4
        dey
        bne     L7027
        bit     L704A
        bmi     L7045
        ldx     L704B
        lda     L7049
        sta     L704C,x
        inc     L704B
        jmp     L6FE4

L7045:  lda     L7049
        rts

L7049:  .byte   0
L704A:  .byte   0
L704B:  .byte   0
L704C:  .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
L7054:  jmp     L70C5

        .byte   $03,$5D,$70,$00,$08
L705C:  .byte   $00
L705D:  .res    64, 0
        .byte   $00,$04
L709F:  .byte   $00,$00,$0C,$00,$02,$00,$00,$01
L70A7:  .byte   $00,$0A,$5D,$70,$00,$00
L70AD:  .byte   $00
L70AE:  .byte   $00,$00
L70B0:  .byte   $00
L70B1:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00
L70BB:  .byte   $00
L70BC:  .byte   $00
L70BD:  .byte   $00
L70BE:  .byte   $00
L70BF:  .byte   $00
L70C0:  .byte   $00
L70C1:  .byte   $00
L70C2:  .byte   $00
L70C3:  .byte   $00
L70C4:  .byte   $00
L70C5:  sta     L72A7
        jsr     push_addrs_from_zp
        ldx     #$40
L70CD:  lda     $E1B0,x
        sta     L705D,x
        dex
        bpl     L70CD
        jsr     L72AA
        lda     L705C
        sta     L709F
        sta     L70A7
        jsr     L72CE
        jsr     L72E2
        ldx     #$00
L70EA:  lda     $0C23,x
        sta     L70BF,x
        inx
        cpx     #$04
        bne     L70EA
        lda     L485D
        sec
        sbc     L485F
        sta     L72A8
        lda     L485E
        sbc     L4860
        sta     L72A9
        ldx     #$05
L710A:  lsr     L72A9
        ror     L72A8
        dex
        cpx     #$00
        bne     L710A
        lda     L70C2
        bne     L7147
        lda     $DD9E
        clc
        adc     L70C1
        bcs     L7147
        cmp     #$7C
        bcs     L7147
        lda     L72A8
        sec
        sbc     $BF31
        sta     L72A8
        lda     L72A9
        sbc     #$00
        sta     L72A9
        lda     L72A8
        cmp     L70C1
        lda     L72A9
        sbc     L70C2
        bcs     L7169
L7147:  lda     $EC2E
        jsr     L8B19
        dec     $EC2E
        jsr     L4523
        jsr     L72D8
        lda     desktop_winid
        beq     L715F
        lda     #$03
        bne     L7161
L715F:  lda     #$04
L7161:  jsr     L48CC
        ldx     $E256
        txs
        rts

L7169:  lda     L485F
        sta     L0006
        lda     L4860
        sta     $07
        lda     $E1F1
        asl     a
        tax
        lda     L0006
        sta     $E202,x
        lda     $07
        sta     $E203,x
        ldx     $E1F1
        lda     L72A7
        sta     $E1F2,x
        inc     $E1F1
        lda     L70C1
        pha
        lda     LCBANK2
        lda     LCBANK2
        ldy     #$00
        pla
        sta     (L0006),y
        lda     LCBANK1
        lda     LCBANK1
        lda     #$FF
        sta     L70C4
        lda     #$00
        sta     L70C3
        lda     #$04
        sta     $08
        lda     #$0C
        sta     $09
        inc     L0006
        lda     L0006
        bne     L71BD
        inc     $07
L71BD:  inc     L70C4
        lda     L70C4
        cmp     L70C1
        bne     L71CB
        jmp     L7296

L71CB:  inc     L70C3
        lda     L70C3
        cmp     L70C0
        beq     L71E7
        lda     $08
        clc
        adc     L70BF
        sta     $08
        lda     $09
        adc     #$00
        sta     $09
        jmp     L71F7

L71E7:  lda     #$00
        sta     L70C3
        lda     #$04
        sta     $08
        lda     #$0C
        sta     $09
        jsr     L72CE
L71F7:  ldx     #$00
        ldy     #$00
        lda     ($08),y
        and     #$0F
        sta     $1F00,x
        bne     L7223
        inc     L70C3
        lda     L70C3
        cmp     L70C0
        bne     L7212
        jmp     L71E7

L7212:  lda     $08
        clc
        adc     L70BF
        sta     $08
        lda     $09
        adc     #$00
        sta     $09
        jmp     L71F7

L7223:  iny
        inx
L7225:  lda     ($08),y
        sta     $1F00,x
        iny
        inx
        cpx     #$11
        bne     L7225
        ldy     #$13
        lda     ($08),y
        sta     $1F00,x
        inx
        iny
        lda     ($08),y
        sta     $1F00,x
        ldy     #$18
        inx
L7241:  lda     ($08),y
        sta     $1F00,x
        inx
        iny
        cpy     #$1C
        bne     L7241
        ldy     #$21
L724E:  lda     ($08),y
        sta     $1F00,x
        inx
        iny
        cpy     #$25
        bne     L724E
        ldy     #$1E
        lda     ($08),y
        sta     $1F00,x
        inx
        ldy     #$25
        lda     ($08),y
        sta     $1F00,x
        inx
        iny
        lda     ($08),y
        sta     $1F00,x
        lda     LCBANK2
        lda     LCBANK2
        ldx     #$1F
        ldy     #$1F
L7279:  lda     $1F00,x
        sta     (L0006),y
        dex
        dey
        bpl     L7279
        lda     LCBANK1
        lda     LCBANK1
        lda     #$20
        clc
        adc     L0006
        sta     L0006
        bcc     L7293
        inc     $07
L7293:  jmp     L71BD

L7296:  lda     L0006
        sta     L485F
        lda     $07
        sta     L4860
        jsr     L72D8
        jsr     pop_addrs_to_zp
        rts

L72A7:  .byte   0
L72A8:  .byte   0
L72A9:  .byte   0
L72AA:  ldy     #$C8
        lda     #$57
        ldx     #$70
        jsr     L46BA
        beq     L72CD
        jsr     DESKTOP_SHOW_ALERT0
        jsr     L8B1F
        lda     $DF20
        bne     L72C9
        lda     $E6BE
        sta     L533F
        jsr     L59A8
L72C9:  ldx     $E256
        txs
L72CD:  rts

L72CE:  ldy     #$CA
        lda     #$9E
        ldx     #$70
        jsr     L46BA
        rts

L72D8:  ldy     #$CC
        lda     #$A6
        ldx     #$70
        jsr     L46BA
        rts

L72E2:  lda     $0C04
        and     #$F0
        cmp     #$F0
        beq     L72EC
        rts

L72EC:  ldy     #$C4
        lda     #$A8
        ldx     #$70
        jsr     L46BA
        beq     L72F8
        rts

L72F8:  lda     L70AD
        sta     L70BD
        lda     L70AE
        sta     L70BE
        lda     L70AD
        sec
        sbc     L70B0
        sta     L70BB
        lda     L70AE
        sbc     L70B1
        sta     L70BC
        lda     L70BD
        sec
        sbc     L70BB
        sta     L70BD
        lda     L70BE
        sbc     L70BC
        sta     L70BE
        lsr     L70BC
        ror     L70BB
        php
        lsr     L70BE
        ror     L70BD
        plp
        bcc     L7342
        inc     L70BD
        bne     L7342
        inc     L70BE
L7342:  lda     #$00
        rts

L7345:  sta     L7445
        ldx     #$00
L734A:  lda     $E1F2,x
        cmp     L7445
        beq     L7358
        inx
        cpx     #$08
        bne     L734A
        rts

L7358:  stx     L7446
        dex
L735C:  inx
        lda     $E1F3,x
        sta     $E1F2,x
        cpx     $E1F1
        bne     L735C
        dec     $E1F1
        lda     L7446
        cmp     $E1F1
        bne     L7385
        ldx     L7446
        asl     a
        tax
        lda     $E202,x
        sta     L485F
        lda     $E203,x
        sta     L4860
        rts

L7385:  lda     L7446
        asl     a
        tax
        lda     $E202,x
        sta     L0006
        lda     $E203,x
        sta     $07
        inx
        inx
        lda     $E202,x
        sta     $08
        lda     $E203,x
        sta     $09
        ldy     #$00
        jsr     push_addrs_from_zp
L73A5:  lda     LCBANK2
        lda     LCBANK2
        lda     ($08),y
        sta     (L0006),y
        lda     LCBANK1
        lda     LCBANK1
        inc     L0006
        bne     L73BB
        inc     $07
L73BB:  inc     $08
        bne     L73C1
        inc     $09
L73C1:  lda     $09
        cmp     L4860
        bne     L73A5
        lda     $08
        cmp     L485F
        bne     L73A5
        jsr     pop_addrs_to_zp
        lda     $E1F1
        asl     a
        tax
        lda     L485F
        sec
        sbc     $E202,x
        sta     L7447
        lda     L4860
        sbc     $E203,x
        sta     L7448
        inc     L7446
L73ED:  lda     L7446
        cmp     $E1F1
        bne     L73F8
        jmp     L7429

L73F8:  lda     L7446
        asl     a
        tax
        lda     $E204,x
        sec
        sbc     $E202,x
        sta     L7449
        lda     $E205,x
        sbc     $E203,x
        sta     L744A
        lda     $E200,x
        clc
        adc     L7449
        sta     $E202,x
        lda     $E201,x
        adc     L744A
        sta     $E203,x
        inc     L7446
        jmp     L73ED

L7429:  lda     $E1F1
        sec
        sbc     #$01
        asl     a
        tax
        lda     $E202,x
        clc
        adc     L7447
        sta     L485F
        lda     $E203,x
        adc     L7448
        sta     L4860
        rts

L7445:  .byte   0
L7446:  .byte   0
L7447:  .byte   0
L7448:  .byte   0
L7449:  .byte   0
L744A:  .byte   0
L744B:  lda     bufnum
        asl     a
        tax
        lda     $E6BF,x
        sta     $08
        lda     $E6C0,x
        sta     $09
        ldy     #$09
        lda     (L0006),y
        tay
        jsr     push_addrs_from_zp
        lda     L0006
        clc
        adc     #$09
        sta     L0006
        bcc     L746D
        inc     $07
L746D:  tya
        tax
        ldy     #$00
L7471:  lda     (L0006),y
        sta     ($08),y
        iny
        dex
        bne     L7471
        lda     #$20
        sta     ($08),y
        ldy     #$02
        lda     ($08),y
        and     #$DF
        sta     ($08),y
        jsr     pop_addrs_to_zp
        ldy     #$02
        lda     (L0006),y
        and     #$0F
        bne     L74D3
        jsr     push_addrs_from_zp
        lda     bufnum
        jsr     L86FB
        sta     $08
        stx     $09
        lda     L0006
        clc
        adc     #$09
        sta     L0006
        bcc     L74A8
        inc     $07
L74A8:  ldy     #$00
        lda     (L0006),y
        tay
L74AD:  lda     (L0006),y
        sta     ($08),y
        dey
        bpl     L74AD
        ldy     #$00
        lda     ($08),y
        sec
        sbc     #$01
        sta     ($08),y
        ldy     #$01
        lda     #$2F
        sta     ($08),y
        ldy     #$00
        lda     ($08),y
        tay
L74C8:  lda     ($08),y
        sta     $E1B0,y
        dey
        bpl     L74C8
        jmp     L7569

L74D3:  tay
        lda     #$00
        sta     L7620
        jsr     push_addrs_from_zp
        tya
        pha
        jsr     L86FB
        sta     L0006
        stx     $07
        pla
        asl     a
        tax
        lda     $E6BF,x
        sta     $08
        lda     $E6C0,x
        sta     $09
        ldy     #$00
        lda     (L0006),y
        clc
        adc     ($08),y
        cmp     #$43
        bcc     L750D
        lda     #$40
        jsr     DESKTOP_SHOW_ALERT0
        jsr     L8B1F
        dec     $EC2E
        ldx     $E256
        txs
        rts

L750D:  ldy     #$00
        lda     (L0006),y
        tay
L7512:  lda     (L0006),y
        sta     $E1B0,y
        dey
        bpl     L7512
        lda     #$2F
        sta     $E1B1
        inc     $E1B0
        ldx     $E1B0
        sta     $E1B0,x
        lda     $E6BE
        jsr     L86E3
        sta     $08
        stx     $09
        ldx     $E1B0
        ldy     #$09
        lda     ($08),y
        clc
        adc     $E1B0
        sta     $E1B0
        dec     $E1B0
        dec     $E1B0
        ldy     #$0A
L7548:  iny
        inx
        lda     ($08),y
        sta     $E1B0,x
        cpx     $E1B0
        bne     L7548
        lda     bufnum
        jsr     L86FB
        sta     $08
        stx     $09
        ldy     $E1B0
L7561:  lda     $E1B0,y
        sta     ($08),y
        dey
        bpl     L7561
L7569:  lda     $08
        ldx     $09
        jsr     L87BA
        lda     bufnum
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$14
        lda     bufnum
        sec
        sbc     #$01
        asl     a
        asl     a
        asl     a
        asl     a
        pha
        adc     #$05
        sta     (L0006),y
        iny
        lda     #$00
        sta     (L0006),y
        iny
        pla
        lsr     a
        clc
        adc     #$1B
        sta     (L0006),y
        iny
        lda     #$00
        sta     (L0006),y
        lda     #$00
        ldy     #$1F
        ldx     #$03
L75A3:  sta     (L0006),y
        dey
        dex
        bpl     L75A3
        ldy     #$04
        lda     (L0006),y
        and     #$FE
        sta     (L0006),y
        iny
        lda     (L0006),y
        and     #$FE
        sta     (L0006),y
        lda     #$00
        ldy     #$07
        sta     (L0006),y
        ldy     #$09
        sta     (L0006),y
        jsr     pop_addrs_to_zp
        lda     $E6BE
        jsr     L7054
        lda     $E6BE
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        and     #$0F
        beq     L75FA
        tax
        dex
        txa
        asl     a
        tax
        lda     $EB8B,x
        sta     L70BD
        lda     $EB8C,x
        sta     L70BE
        lda     $EB9B,x
        sta     L70BB
        lda     $EB9C,x
        sta     L70BC
L75FA:  ldx     bufnum
        dex
        txa
        asl     a
        tax
        lda     L70BD
        sta     $EB8B,x
        lda     L70BE
        sta     $EB8C,x
        lda     L70BB
        sta     $EB9B,x
        lda     L70BC
        sta     $EB9C,x
        lda     bufnum
        jsr     L7635
        rts

L7620:  .byte   $00
L7621:  .byte   $00
L7622:  .byte   $00
L7623:  .byte   $00
L7624:  .byte   $00
L7625:  .byte   $00
L7626:  .byte   $34
L7627:  .byte   $00,$10,$00
L762A:  .byte   $00
L762B:  .byte   $00
L762C:  .byte   $00
L762D:  .byte   $00
L762E:  .byte   $05
L762F:  .byte   $00
L7630:  .byte   $00
L7631:  .byte   $00
L7632:  .byte   $00
L7633:  .byte   $00
L7634:  .byte   $00
L7635:  pha
        lda     #$00
        beq     L7647
L763A:  pha
        ldx     bufnum
        dex
        lda     $EC26,x
        sta     $E6BE
        lda     #$80
L7647:  sta     L7634
        pla
        sta     L7621
        jsr     push_addrs_from_zp
        ldx     #$03
L7653:  lda     L7626,x
        sta     L762A,x
        dex
        bpl     L7653
        lda     #$00
        sta     L762F
        sta     L7625
        ldx     #$03
L7666:  sta     L7630,x
        dex
        bpl     L7666
        lda     $E6BE
        ldx     $E1F1
        dex
L7673:  cmp     $E1F2,x
        beq     L767C
        dex
        bpl     L7673
        rts

L767C:  txa
        asl     a
        tax
        lda     $E202,x
        sta     L0006
        lda     $E203,x
        sta     $07
        lda     LCBANK2
        lda     LCBANK2
        ldy     #$00
        lda     (L0006),y
        sta     L7764
        lda     LCBANK1
        lda     LCBANK1
        inc     L0006
        lda     L0006
        bne     L76A4
        inc     $07
L76A4:  lda     bufnum
        sta     desktop_winid
L76AA:  lda     L7625
        cmp     L7764
        beq     L76BB
        jsr     L7768
        inc     L7625
        jmp     L76AA

L76BB:  bit     L7634
        bpl     L76C4
        jsr     pop_addrs_to_zp
        rts

L76C4:  jsr     L7B6B
        lda     L7621
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$16
        lda     L7B65
        sec
        sbc     (L0006),y
        sta     L7B65
        lda     L7B66
        sbc     #$00
        sta     L7B66
        lda     L7B63
        cmp     #$AA
        lda     L7B64
        sbc     #$00
        bmi     L7705
        lda     L7B63
        cmp     #$C2
        lda     L7B64
        sbc     #$01
        bpl     L770C
        lda     L7B63
        ldx     L7B64
        jmp     L7710

L7705:  lda     #$AA
        ldx     #$00
        jmp     L7710

L770C:  lda     #$C2
        ldx     #$01
L7710:  ldy     #$20
        sta     (L0006),y
        txa
        iny
        sta     (L0006),y
        lda     L7B65
        cmp     #$32
        lda     L7B66
        sbc     #$00
        bmi     L7739
        lda     L7B65
        cmp     #$6C
        lda     L7B66
        sbc     #$00
        bpl     L7740
        lda     L7B65
        ldx     L7B66
        jmp     L7744

L7739:  lda     #$32
        ldx     #$00
        jmp     L7744

L7740:  lda     #$6C
        ldx     #$00
L7744:  ldy     #$22
        sta     (L0006),y
        txa
        iny
        sta     (L0006),y
        lda     L7767
        ldy     #$06
        sta     (L0006),y
        ldy     #$08
        sta     (L0006),y
        lda     $E6BE
        ldx     L7621
        jsr     L8B60
        jsr     pop_addrs_to_zp
        rts

L7764:  .byte   $00,$00,$00
L7767:  .byte   $14
L7768:  inc     $DD9E
        jsr     DESKTOP_FIND_SPACE
        ldx     buf3len
        inc     buf3len
        sta     buf3,x
        jsr     L86E3
        sta     $08
        stx     $09
        lda     LCBANK2
        lda     LCBANK2
        ldy     #$00
        lda     (L0006),y
        sta     $1800
        iny
        ldx     #$00
L778E:  lda     (L0006),y
        sta     $1802,x
        inx
        iny
        cpx     $1800
        bne     L778E
        inc     $1800
        inc     $1800
        lda     #$20
        sta     $1801
        ldx     $1800
        sta     $1800,x
        ldy     #$10
        lda     (L0006),y
        cmp     #$B3
        beq     L77CC
        cmp     #$FF
        bne     L77DA
        ldy     #$00
        lda     (L0006),y
        tay
        ldx     L77D0
L77BF:  lda     (L0006),y
        cmp     L77D0,x
        bne     L77D8
        dey
        beq     L77D8
        dex
        bne     L77BF
L77CC:  lda     #$01
        bne     L77DA
L77D0:  PASCAL_STRING ".SYSTEM"
L77D8:  lda     #$FF
L77DA:  tay
        lda     LCBANK1
        lda     LCBANK1
        tya
        jsr     L78A1
        lda     #$00
        ldx     #$18
        jsr     L87BA
        ldy     #$09
        ldx     #$00
L77F0:  lda     $1800,x
        sta     ($08),y
        iny
        inx
        cpx     $1800
        bne     L77F0
        lda     $1800,x
        sta     ($08),y
        ldx     #$00
        ldy     #$03
L7805:  lda     L762A,x
        sta     ($08),y
        inx
        iny
        cpx     #$04
        bne     L7805
        lda     buf3len
        cmp     L762E
        beq     L781A
        bcs     L7826
L781A:  lda     L762A
        sta     L7630
        lda     L762B
        sta     L7631
L7826:  lda     L762C
        sta     L7632
        lda     L762D
        sta     L7633
        inc     L762F
        lda     L762F
        cmp     L762E
        bne     L7862
        lda     L762C
        clc
        adc     #$20
        sta     L762C
        lda     L762D
        adc     #$00
        sta     L762D
        lda     L7626
        sta     L762A
        lda     L7627
        sta     L762B
        lda     #$00
        sta     L762F
        jmp     L7870

L7862:  lda     L762A
        clc
        adc     #$50
        sta     L762A
        bcc     L7870
        inc     L762B
L7870:  lda     bufnum
        ora     L7624
        ldy     #$02
        sta     ($08),y
        ldy     #$07
        lda     L7622
        sta     ($08),y
        iny
        lda     L7623
        sta     ($08),y
        ldx     buf3len
        dex
        lda     buf3,x
        jsr     L8893
        lda     L0006
        clc
        adc     #$20
        sta     L0006
        lda     $07
        adc     #$00
        sta     $07
        rts

        .byte   0
        .byte   0
L78A1:  sta     L78EE
        jsr     push_addrs_from_zp
        lda     $FB00
        sta     L0006
        lda     $FB01
        sta     $07
        ldy     #$00
        lda     (L0006),y
        tay
L78B6:  lda     (L0006),y
        cmp     L78EE
        beq     L78C2
        dey
        bpl     L78B6
        ldy     #$01
L78C2:  lda     $FB04
        sta     L0006
        lda     $FB05
        sta     $07
        lda     (L0006),y
        sta     L7624
        dey
        tya
        asl     a
        tay
        lda     $FB02
        sta     L0006
        lda     $FB03
        sta     $07
        lda     (L0006),y
        sta     L7622
        iny
        lda     (L0006),y
        sta     L7623
        jsr     pop_addrs_to_zp
        rts

L78EE:  .byte   0
L78EF:  lda     $D21D
        sta     $EBBE
        clc
        adc     #$05
        sta     $EBBA
        lda     $D21E
        sta     $EBBF
        adc     #$00
        sta     $EBBB
        lda     $D21F
        clc
        adc     #$0C
        sta     $EBC0
        sta     $EBC4
        lda     $D220
        adc     #$00
        sta     $EBC1
        sta     $EBC5
        A2D_RELAY_CALL A2D_SET_POS, $EBBE
        lda     $D221
        sta     $EBC2
        lda     $D222
        sta     $EBC3
        jsr     L48FA
        A2D_RELAY_CALL A2D_DRAW_LINE_ABS, $EBC2
        lda     $EBC0
        clc
        adc     #$02
        sta     $EBC0
        sta     $EBC4
        lda     $EBC1
        adc     #$00
        sta     $EBC1
        sta     $EBC5
        A2D_RELAY_CALL A2D_SET_POS, $EBBE
        A2D_RELAY_CALL A2D_DRAW_LINE_ABS, $EBC2
        lda     $D21F
        clc
        adc     #$0A
        sta     $EBBC
        lda     $D220
        adc     #$00
        sta     $EBBD
        lda     buf3len
        ldx     #$00
        jsr     L7AE0
        lda     buf3len
        cmp     #$02
        bcs     L798A
        dec     $EBB3
L798A:  A2D_RELAY_CALL A2D_SET_POS, $EBBA
        jsr     L7AD7
        lda     #$B3
        ldx     #$EB
        jsr     L8780
        lda     buf3len
        cmp     #$02
        bcs     L79A7
        inc     $EBB3
L79A7:  jsr     L79F7
        ldx     desktop_winid
        dex
        txa
        asl     a
        tax
        lda     $EB8B,x
        tay
        lda     $EB8C,x
        tax
        tya
        jsr     L7AE0
        A2D_RELAY_CALL A2D_SET_POS, $EBEB
        jsr     L7AD7
        lda     #$C6
        ldx     #$EB
        jsr     L8780
        ldx     desktop_winid
        dex
        txa
        asl     a
        tax
        lda     $EB9B,x
        tay
        lda     $EB9C,x
        tax
        tya
        jsr     L7AE0
        A2D_RELAY_CALL A2D_SET_POS, $EBEF
        jsr     L7AD7
        lda     #$D0
        ldx     #$EB
        jsr     L8780
        rts

L79F7:  lda     $D221
        sec
        sbc     $D21D
        sta     L7ADE
        lda     $D222
        sbc     $D21E
        sta     L7ADF
        lda     L7ADE
        sec
        sbc     $EBF3
        sta     L7ADE
        lda     L7ADF
        sbc     $EBF4
        sta     L7ADF
        bpl     L7A22
        jmp     L7A86

L7A22:  lda     L7ADE
        sec
        sbc     $EBF9
        sta     L7ADE
        lda     L7ADF
        sbc     $EBFA
        sta     L7ADF
        bpl     L7A3A
        jmp     L7A86

L7A3A:  lda     $EBE7
        clc
        adc     L7ADE
        sta     $EBEF
        lda     $EBE8
        adc     L7ADF
        sta     $EBF0
        lda     L7ADF
        beq     L7A59
        lda     L7ADE
        cmp     #$18
        bcc     L7A6A
L7A59:  lda     $EBEF
        sec
        sbc     #$0C
        sta     $EBEF
        lda     $EBF0
        sbc     #$00
        sta     $EBF0
L7A6A:  lsr     L7ADF
        ror     L7ADE
        lda     $EBE3
        clc
        adc     L7ADE
        sta     $EBEB
        lda     $EBE4
        adc     L7ADF
        sta     $EBEC
        jmp     L7A9E

L7A86:  lda     $EBE3
        sta     $EBEB
        lda     $EBE4
        sta     $EBEC
        lda     $EBE7
        sta     $EBEF
        lda     $EBE8
        sta     $EBF0
L7A9E:  lda     $EBEB
        clc
        adc     $D21D
        sta     $EBEB
        lda     $EBEC
        adc     $D21E
        sta     $EBEC
        lda     $EBEF
        clc
        adc     $D21D
        sta     $EBEF
        lda     $EBF0
        adc     $D21E
        sta     $EBF0
        lda     $EBBC
        sta     $EBED
        sta     $EBF1
        lda     $EBBD
        sta     $EBEE
        sta     $EBF2
        rts

L7AD7:  lda     #$DC
        ldx     #$EB
        jmp     L8780

L7ADE:  .byte   0
L7ADF:  .byte   0
L7AE0:  sta     L7B5B
        stx     L7B5C
        ldx     #$06
        lda     #$20
L7AEA:  sta     $EBDC,x
        dex
        bne     L7AEA
        lda     #$00
        sta     L7B5E
        ldy     #$00
        ldx     #$00
L7AF9:  lda     #$00
        sta     L7B5D
L7AFE:  lda     L7B5B
        cmp     L7B53,x
        lda     L7B5C
        sbc     L7B54,x
        bpl     L7B31
        lda     L7B5D
        bne     L7B1A
        bit     L7B5E
        bmi     L7B1A
        lda     #$20
        bne     L7B24
L7B1A:  clc
        adc     #$30
        pha
        lda     #$80
        sta     L7B5E
        pla
L7B24:  sta     $EBDE,y
        iny
        inx
        inx
        cpx     #$08
        beq     L7B4A
        jmp     L7AF9

L7B31:  inc     L7B5D
        lda     L7B5B
        sec
        sbc     L7B53,x
        sta     L7B5B
        lda     L7B5C
        sbc     L7B54,x
        sta     L7B5C
        jmp     L7AFE

L7B4A:  lda     L7B5B
        ora     #$30
        sta     $EBDE,y
        rts

L7B53:  .byte   $10
L7B54:  .byte   $27,$E8,$03,$64,$00,$0A,$00
L7B5B:  .byte   0
L7B5C:  .byte   0
L7B5D:  .byte   0
L7B5E:  .byte   0
L7B5F:  .byte   0
L7B60:  .byte   0
L7B61:  .byte   0
L7B62:  .byte   0
L7B63:  .byte   0
L7B64:  .byte   0
L7B65:  .byte   0
L7B66:  .byte   0
L7B67:  .byte   0
L7B68:  .byte   0
L7B69:  .byte   0
L7B6A:  .byte   0
L7B6B:  ldx     #$03
        lda     #$00
L7B6F:  sta     L7B63,x
        dex
        bpl     L7B6F
        sta     L7D5B
        lda     #$FF
        sta     L7B5F
        sta     L7B61
        lda     #$7F
        sta     L7B60
        sta     L7B62
        ldx     bufnum
        dex
        lda     $E6D1,x
        bpl     L7BCB
        lda     buf3len
        bne     L7BA1
L7B96:  lda     #$00
        ldx     #$03
L7B9A:  sta     L7B5F,x
        dex
        bpl     L7B9A
        rts

L7BA1:  clc
        adc     #$02
        ldx     #$00
        stx     L7D5C
        asl     a
        rol     L7D5C
        asl     a
        rol     L7D5C
        asl     a
        rol     L7D5C
        sta     L7B65
        lda     L7D5C
        sta     L7B66
        lda     #$68
        sta     L7B63
        lda     #$01
        sta     L7B64
        jmp     L7B96

L7BCB:  lda     buf3len
        cmp     #$01
        bne     L7BEF
        lda     buf3
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$06
        ldx     #$03
L7BE0:  lda     (L0006),y
        sta     L7B5F,x
        sta     L7B63,x
        dey
        dex
        bpl     L7BE0
        jmp     L7BF7

L7BEF:  lda     L7D5B
        cmp     buf3len
        bne     L7C36
L7BF7:  lda     L7B63
        clc
        adc     #$32
        sta     L7B63
        bcc     L7C05
        inc     L7B64
L7C05:  lda     L7B65
        clc
        adc     #$20
        sta     L7B65
        bcc     L7C13
        inc     L7B66
L7C13:  lda     L7B5F
        sec
        sbc     #$32
        sta     L7B5F
        lda     L7B60
        sbc     #$00
        sta     L7B60
        lda     L7B61
        sec
        sbc     #$0F
        sta     L7B61
        lda     L7B62
        sbc     #$00
        sta     L7B62
        rts

L7C36:  tax
        lda     buf3,x
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        and     #$0F
        cmp     L7D5C
        bne     L7C52
        inc     L7D5B
        jmp     L7BEF

L7C52:  ldy     #$06
        ldx     #$03
L7C56:  lda     (L0006),y
        sta     L7B67,x
        dey
        dex
        bpl     L7C56
        bit     L7B60
        bmi     L7C88
        bit     L7B68
        bmi     L7CCE
        lda     L7B67
        cmp     L7B5F
        lda     L7B68
        sbc     L7B60
        bmi     L7CCE
        lda     L7B67
        cmp     L7B63
        lda     L7B68
        sbc     L7B64
        bpl     L7CBF
        jmp     L7CDA

L7C88:  bit     L7B68
        bmi     L7CA3
        bit     L7B64
        bmi     L7CDA
        lda     L7B67
        cmp     L7B63
        lda     L7B68
        sbc     L7B64
        bmi     L7CDA
        jmp     L7CBF

L7CA3:  lda     L7B67
        cmp     L7B5F
        lda     L7B68
        sbc     L7B60
        bmi     L7CCE
        lda     L7B67
        cmp     L7B63
        lda     L7B68
        sbc     L7B64
        bmi     L7CDA
L7CBF:  lda     L7B67
        sta     L7B63
        lda     L7B68
        sta     L7B64
        jmp     L7CDA

L7CCE:  lda     L7B67
        sta     L7B5F
        lda     L7B68
        sta     L7B60
L7CDA:  bit     L7B62
        bmi     L7D03
        bit     L7B6A
        bmi     L7D49
        lda     L7B69
        cmp     L7B61
        lda     L7B6A
        sbc     L7B62
        bmi     L7D49
        lda     L7B69
        cmp     L7B65
        lda     L7B6A
        sbc     L7B66
        bpl     L7D3A
        jmp     L7D55

L7D03:  bit     L7B6A
        bmi     L7D1E
        bit     L7B66
        bmi     L7D55
        lda     L7B69
        cmp     L7B65
        lda     L7B6A
        sbc     L7B66
        bmi     L7D55
        jmp     L7D3A

L7D1E:  lda     L7B69
        cmp     L7B61
        lda     L7B6A
        sbc     L7B62
        bmi     L7D49
        lda     L7B69
        cmp     L7B65
        lda     L7B6A
        sbc     L7B66
        bmi     L7D55
L7D3A:  lda     L7B69
        sta     L7B65
        lda     L7B6A
        sta     L7B66
        jmp     L7D55

L7D49:  lda     L7B69
        sta     L7B61
        lda     L7B6A
        sta     L7B62
L7D55:  inc     L7D5B
        jmp     L7BEF

L7D5B:  .byte   0
L7D5C:  .byte   0
L7D5D:  jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$23
        ldx     #$07
L7D68:  lda     (L0006),y
        sta     L7D94,x
        dey
        dex
        bpl     L7D68
        lda     L7D98
        sec
        sbc     L7D94
        pha
        lda     L7D99
        sbc     L7D95
        pha
        lda     L7D9A
        sec
        sbc     L7D96
        pha
        lda     L7D9B
        sbc     L7D97
        pla
        tay
        pla
        tax
        pla
        rts

L7D94:  .byte   0
L7D95:  .byte   0
L7D96:  .byte   0
L7D97:  .byte   0
L7D98:  .byte   0
L7D99:  .byte   0
L7D9A:  .byte   0
L7D9B:  .byte   0
L7D9C:  jmp     L7D9F

L7D9F:  ldx     bufnum
        dex
        lda     $EC26,x
        ldx     #$00
L7DA8:  cmp     $E1F2,x
        beq     L7DB4
        inx
        cpx     $E1F1
        bne     L7DA8
        rts

L7DB4:  txa
        asl     a
        tax
        lda     $E202,x
        sta     L0006
        sta     $0801
        lda     $E203,x
        sta     $07
        sta     $0802
        lda     LCBANK2
        lda     LCBANK2
        lda     #$00
        sta     L0800
        tay
        lda     (L0006),y
        sta     $0803
        inc     L0006
        inc     $0801
        bne     L7DE4
        inc     $07
        inc     $0802
L7DE4:  lda     L0800
        cmp     $0803
        beq     L7E0C
        jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        and     #$7F
        sta     (L0006),y
        ldy     #$17
        lda     (L0006),y
        bne     L7E06
        iny
        lda     (L0006),y
        bne     L7E06
        lda     #$01
        sta     (L0006),y
L7E06:  inc     L0800
        jmp     L7DE4

L7E0C:  lda     LCBANK1
        lda     LCBANK1
        ldx     bufnum
        dex
        lda     $E6D1,x
        cmp     #$81
        beq     L7E20
        jmp     L7EC1

L7E20:  lda     LCBANK2
        lda     LCBANK2
        lda     #$5A
        ldx     #$0F
L7E2A:  sta     $0808,x
        dex
        bpl     L7E2A
        lda     #$00
        sta     $0805
        sta     L0800
L7E38:  lda     $0805
        cmp     $0803
        bne     L7E43
        jmp     L80F5

L7E43:  jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        bmi     L7E82
        and     #$0F
        sta     $0804
        ldy     #$01
L7E53:  lda     (L0006),y
        cmp     $0807,y
        beq     L7E5F
        bcs     L7E82
        jmp     L7E67

L7E5F:  iny
        cpy     #$10
        bne     L7E53
        jmp     L7E82

L7E67:  lda     L0800
        sta     $0806
        ldx     #$0F
        lda     #$20
L7E71:  sta     $0808,x
        dex
        bpl     L7E71
        ldy     $0804
L7E7A:  lda     (L0006),y
        sta     $0807,y
        dey
        bne     L7E7A
L7E82:  inc     L0800
        lda     L0800
        cmp     $0803
        beq     L7E90
        jmp     L7E43

L7E90:  inc     $0805
        lda     $0806
        sta     L0800
        jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        ora     #$80
        sta     (L0006),y
        lda     #$5A
        ldx     #$0F
L7EA8:  sta     $0808,x
        dex
        bpl     L7EA8
        ldx     $0805
        dex
        ldy     $0806
        iny
        jsr     L812B
        lda     #$00
        sta     L0800
        jmp     L7E38

L7EC1:  cmp     #$82
        beq     L7EC8
        jmp     L7F58

L7EC8:  lda     LCBANK2
        lda     LCBANK2
        lda     #$00
        sta     $0808
        sta     $0809
        sta     $0805
        sta     L0800
L7EDC:  lda     $0805
        cmp     $0803
        bne     L7EE7
        jmp     L80F5

L7EE7:  jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        bmi     L7F1B
        ldy     #$18
        lda     (L0006),y
        cmp     $0809
        beq     L7EFE
        bcs     L7F08
        jmp     L7F1B

L7EFE:  dey
        lda     (L0006),y
        cmp     $0808
        beq     L7F1B
        bcc     L7F1B
L7F08:  ldy     #$18
        lda     (L0006),y
        sta     $0809
        dey
        lda     (L0006),y
        sta     $0808
        lda     L0800
        sta     $0806
L7F1B:  inc     L0800
        lda     L0800
        cmp     $0803
        beq     L7F29
        jmp     L7EE7

L7F29:  inc     $0805
        lda     $0806
        sta     L0800
        jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        ora     #$80
        sta     (L0006),y
        lda     #$00
        sta     $0808
        sta     $0809
        ldx     $0805
        dex
        ldy     $0806
        iny
        jsr     L812B
        lda     #$00
        sta     L0800
        jmp     L7EDC

L7F58:  cmp     #$83
        beq     L7F5F
        jmp     L801F

L7F5F:  lda     LCBANK2
        lda     LCBANK2
        lda     #$00
        sta     $0808
        sta     $0809
        sta     $0805
        sta     L0800
L7F73:  lda     $0805
        cmp     $0803
        bne     L7F7E
        jmp     L80F5

L7F7E:  jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        bmi     L7FAD
        ldy     #$12
        lda     (L0006),y
        cmp     $0809
        beq     L7F92
        bcs     L7F9C
L7F92:  dey
        lda     (L0006),y
        cmp     $0808
        beq     L7F9C
        bcc     L7FAD
L7F9C:  lda     (L0006),y
        sta     $0808
        iny
        lda     (L0006),y
        sta     $0809
        lda     L0800
        sta     $0806
L7FAD:  inc     L0800
        lda     L0800
        cmp     $0803
        beq     L7FBB
        jmp     L7F7E

L7FBB:  inc     $0805
        lda     $0806
        sta     L0800
        jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        ora     #$80
        sta     (L0006),y
        lda     #$00
        sta     $0808
        sta     $0809
        ldx     $0805
        dex
        ldy     $0806
        iny
        jsr     L812B
        lda     #$00
        sta     L0800
        jmp     L7F73

        lda     LCBANK1
        lda     LCBANK1
        lda     #$54
        sta     $E6D9
        lda     #$00
        sta     $E6DA
        lda     #$CB
        sta     $E6DD
        lda     #$00
        sta     $E6DE
        lda     #$00
        sta     $E6E1
        sta     $E6E2
        lda     #$E7
        sta     $E6E5
        lda     #$00
        sta     $E6E6
        lda     LCBANK2
        lda     LCBANK2
        jmp     L80F5

L801F:  cmp     #$84
        beq     L8024
        rts

L8024:  lda     $FB00
        sta     $08
        lda     $FB01
        sta     $09
        ldy     #$00
        lda     ($08),y
        sta     $0807
        tay
L8036:  lda     ($08),y
        sta     $0807,y
        dey
        bne     L8036
        lda     LCBANK2
        lda     LCBANK2
        lda     #$00
        sta     $0805
        sta     L0800
        lda     #$FF
        sta     $0806
L8051:  lda     $0805
        cmp     $0803
        bne     L805C
        jmp     L80F5

L805C:  jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        bmi     L807E
        ldy     #$10
        lda     (L0006),y
        ldx     $0807
        cpx     #$00
        beq     L8075
        cmp     $0808,x
        bne     L807E
L8075:  lda     L0800
        sta     $0806
        jmp     L809E

L807E:  inc     L0800
        lda     L0800
        cmp     $0803
        beq     L808C
        jmp     L805C

L808C:  lda     $0806
        cmp     #$FF
        bne     L809E
        dec     $0807
        lda     #$00
        sta     L0800
        jmp     L805C

L809E:  inc     $0805
        lda     $0806
        sta     L0800
        jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        ora     #$80
        sta     (L0006),y
        ldx     $0805
        dex
        ldy     $0806
        iny
        jsr     L812B
        lda     #$00
        sta     L0800
        lda     #$FF
        sta     $0806
        jmp     L8051

L80CA:  lda     #$00
        sta     $0804
        lda     L0800
        asl     a
        rol     $0804
        asl     a
        rol     $0804
        asl     a
        rol     $0804
        asl     a
        rol     $0804
        asl     a
        rol     $0804
        clc
        adc     $0801
        sta     L0006
        lda     $0802
        adc     $0804
        sta     $07
        rts

L80F5:  lda     #$00
        sta     L0800
L80FA:  lda     L0800
        cmp     $0803
        beq     L8124
        jsr     L80CA
        ldy     #$00
        lda     (L0006),y
        and     #$7F
        sta     (L0006),y
        ldy     #$17
        lda     (L0006),y
        bne     L811E
        iny
        lda     (L0006),y
        cmp     #$01
        bne     L811E
        lda     #$00
        sta     (L0006),y
L811E:  inc     L0800
        jmp     L80FA

L8124:  lda     LCBANK1
        lda     LCBANK1
        rts

L812B:  lda     LCBANK1
        lda     LCBANK1
        tya
        sta     buf3,x
        lda     LCBANK2
        lda     LCBANK2
        rts

L813C:  .byte   0
        .byte   0
L813E:  php
L813F:  ldy     #$00
        tax
        dex
        txa
        sty     L813C
        asl     a
        rol     L813C
        asl     a
        rol     L813C
        asl     a
        rol     L813C
        asl     a
        rol     L813C
        asl     a
        rol     L813C
        clc
        adc     $E71D
        sta     L0006
        lda     $E71E
        adc     L813C
        sta     $07
        lda     LCBANK2
        lda     LCBANK2
        ldy     #$1F
L8171:  lda     (L0006),y
        sta     $EC43,y
        dey
        bpl     L8171
        lda     LCBANK1
        lda     LCBANK1
        ldx     #$31
        lda     #$20
L8183:  sta     $E6EB,x
        dex
        bpl     L8183
        lda     #$00
        sta     $E6EB
        lda     $E6DF
        clc
        adc     L813E
        sta     $E6DF
        bcc     L819D
        inc     $E6E0
L819D:  lda     $E6E3
        clc
        adc     L813E
        sta     $E6E3
        bcc     L81AC
        inc     $E6E4
L81AC:  lda     $E6E7
        clc
        adc     L813E
        sta     $E6E7
        bcc     L81BB
        inc     $E6E8
L81BB:  lda     $E6DB
        cmp     $D223
        lda     $E6DC
        sbc     $D224
        bmi     L81D9
        lda     $E6DB
        clc
        adc     L813E
        sta     $E6DB
        bcc     L81D8
        inc     $E6DC
L81D8:  rts

L81D9:  lda     $E6DB
        clc
        adc     L813E
        sta     $E6DB
        bcc     L81E8
        inc     $E6DC
L81E8:  lda     $E6DB
        cmp     $D21F
        lda     $E6DC
        sbc     $D220
        bpl     L81F7
        rts

L81F7:  jsr     L821F
        SETPOS_RELAY_CALL $E6D9
        jsr     L8241
        SETPOS_RELAY_CALL $E6DD
        jsr     L8253
        SETPOS_RELAY_CALL $E6E1
        jsr     L830F
        lda     #<$E6E5
        ldx     #>$E6E5
        jmp     SETPOS_RELAY

L821F:  lda     $EC43
        and     #$0F
        sta     $E6EB
        tax
L8228:  lda     $EC43,x
        sta     $E6EC,x
        dex
        bne     L8228
        lda     #$20
        sta     $E6EC
        inc     $E6EB
        lda     #$EB
        ldx     #$E6
        jsr     L87BA
        rts

L8241:  lda     $EC53
        jsr     L8707
        ldx     #$04
L8249:  lda     $DFC5,x
        sta     $E6EB,x
        dex
        bpl     L8249
        rts

L8253:  lda     $EC54
        ldx     $EC55
L8259:  sta     L8272
        stx     L8273
        jmp     L8276

L8262:  .byte   $20
        .byte   "Blocks "
L826A:  .byte   $10             ; ???
L826B:  .byte   $27,$E8
        .byte   $03,$64,$00,$0A,$00
L8272:  .byte   0
L8273:  .byte   0
L8274:  .byte   0
L8275:  .byte   0
L8276:  ldx     #$11
        lda     #$20
L827A:  sta     $E6EB,x
        dex
        bpl     L827A
        lda     #$00
        sta     $E6EB
        sta     L8275
        ldy     #$00
        ldx     #$00
L828C:  lda     #$00
        sta     L8274
L8291:  lda     L8272
        cmp     L826A,x
        lda     L8273
        sbc     L826B,x
        bpl     L82C3
        lda     L8274
        bne     L82AD
        bit     L8275
        bmi     L82AD
        lda     #$20
        bne     L82B6
L82AD:  ora     #$30
        pha
        lda     #$80
        sta     L8275
        pla
L82B6:  sta     $E6ED,y
        iny
        inx
        inx
        cpx     #$08
        beq     L82DC
        jmp     L828C

L82C3:  inc     L8274
        lda     L8272
        sec
        sbc     L826A,x
        sta     L8272
        lda     L8273
L82D3:  sbc     L826B,x
        sta     L8273
        jmp     L8291

L82DC:  lda     L8272
        ora     #$30
        sta     $E6ED,y
        iny
        ldx     #$00
L82E7:  lda     L8262,x
        sta     $E6ED,y
        iny
        inx
        cpx     L8262
        bne     L82E7
        lda     L8274
        bne     L8305
        bit     L8275
        bmi     L8305
        lda     L8272
        cmp     #$02
        bcc     L8309
L8305:  lda     #$0D
        bne     L830B
L8309:  lda     #$0C
L830B:  sta     $E6EB
        rts

L830F:  ldx     #$15
        lda     #$20
L8313:  sta     $E6EB,x
        dex
        bpl     L8313
        lda     #$01
        sta     $E6EB
        lda     #$EB
        sta     $08
        lda     #$E6
        sta     $09
        lda     $EC5A
        ora     $EC5B
        bne     L8334
        sta     L83DC
        jmp     L83A9

L8334:  lda     $EC5B
        and     #$FE
        lsr     a
        sta     L83DB
        lda     $EC5B
        ror     a
        lda     $EC5A
        ror     a
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        sta     L83DC
        lda     $EC5A
        and     #$1F
        sta     L83DD
        jsr     L83A9
        jsr     L835D
        jmp     L83B8

L835D:  lda     #$20
        sta     L83DF
        sta     L83E0
        sta     L83E1
        ldx     #$02
        lda     L83DD
        ora     #$30
        tay
        lda     L83DD
        cmp     #$0A
        bcc     L8386
        inx
        ldy     #$31
        cmp     #$14
        bcc     L8386
        ldy     #$32
        cmp     #$1E
        bcc     L8386
        ldy     #$33
L8386:  stx     L83DE
        sty     L83DF
        cpx     #$02
        beq     L83A2
        tya
        and     #$03
        tay
        lda     L83DD
L8397:  sec
        sbc     #$0A
        dey
        bne     L8397
        ora     #$30
        sta     L83E0
L83A2:  lda     #$DE
        ldx     #$83
        jmp     L84A4

L83A9:  lda     L83DC
        asl     a
        tay
        lda     L83E3,y
        tax
        lda     L83E2,y
        jmp     L84A4

L83B8:  ldx     L8490
L83BB:  lda     L83DB
        sec
        sbc     L8490,x
        bpl     L83C7
        dex
        bne     L83BB
L83C7:  tay
        lda     ascii_digits,x
        sta     year_string_10s
        lda     ascii_digits,y
        sta     year_string_1s
        lda     #$8A
        ldx     #$84
        jmp     L84A4

L83DB:  .byte   $00
L83DC:  .byte   $00
L83DD:  .byte   $00
L83DE:  .byte   $03
L83DF:  .byte   $20
L83E0:  .byte   $20
L83E1:  .byte   $20
L83E2:  .byte   $FC
L83E3:  .byte   $83,$06,$84,$11,$84,$1C,$84,$27
        .byte   $84,$32,$84,$3D,$84,$48,$84,$53
        .byte   $84,$5E,$84,$69,$84,$74,$84,$7F
        .byte   $84
        PASCAL_STRING "no date  "
        PASCAL_STRING "January   "
        PASCAL_STRING "February  "
        PASCAL_STRING "March     "
        PASCAL_STRING "April     "
        PASCAL_STRING "May       "
        PASCAL_STRING "June      "
        PASCAL_STRING "July      "
        PASCAL_STRING "August    "
        PASCAL_STRING "September "
        PASCAL_STRING "October   "
        PASCAL_STRING "November  "
        PASCAL_STRING "December  "
        PASCAL_STRING " 1985"

year_string_10s := *-2          ; 10s digit
year_string_1s  := *-1          ; 1s digit

L8490:  .byte   $09             ; ????
        .byte   $0A,$14,$1E,$28,$32,$3C,$46,$50,$5A

ascii_digits:
        .byte   "0123456789"

L84A4:  sta     L0006
        stx     $07
        ldy     #$00
        lda     ($08),y
        sta     L84D0
        clc
        adc     (L0006),y
        sta     ($08),y
        lda     (L0006),y
        sta     L84CB
        inc     L84D0
        iny
        lda     (L0006),y
        sty     L84CF
        ldy     L84D0
        sta     ($08),y
        ldy     L84CF
        .byte   $C0
L84CB:  .byte   0
        .byte   $90
L84CD:  .byte   $EB
        rts

L84CF:  .byte   0
L84D0:  .byte   0
L84D1:  jsr     push_addrs_from_zp
        bit     L5B1B
        bmi     L84DC
        jsr     L6E52
L84DC:  lda     $D221
        sec
        sbc     $D21D
        sta     L85F8
        lda     $D222
        sbc     $D21E
        sta     L85F9
        lda     $D223
        sec
        sbc     $D21F
        sta     L85FA
        lda     $D224
        sbc     $D220
        sta     L85FB
        lda     $D208
        cmp     #$01
        bne     L850C
        asl     a
        bne     L850E
L850C:  lda     #$00
L850E:  sta     L85F1
        lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        lda     #$06
        clc
        adc     L85F1
        tay
        lda     (L0006),y
        pha
        jsr     L7B6B
        ldx     L85F1
        lda     L7B63,x
        sec
        sbc     L7B5F,x
        sta     L85F2
        lda     L7B64,x
        sbc     L7B60,x
        sta     L85F3
        ldx     L85F1
        lda     L85F2
        sec
        sbc     L85F8,x
        sta     L85F2
        lda     L85F3
        sbc     L85F9,x
        sta     L85F3
        bpl     L8562
        lda     L85F8,x
        sta     L85F2
        lda     L85F9,x
        sta     L85F3
L8562:  lsr     L85F3
        ror     L85F2
        lsr     L85F3
        ror     L85F2
        lda     L85F2
        tay
        pla
        tax
        lda     $D209
        jsr     L62BC
        ldx     #$00
        stx     L85F2
        asl     a
        rol     L85F2
        asl     a
        rol     L85F2
        ldx     L85F1
        clc
        adc     L7B5F,x
        sta     $D21D,x
        lda     L85F2
        adc     L7B60,x
        sta     $D21E,x
        lda     desktop_winid
        jsr     L7D5D
        sta     L85F4
        .byte   $8E
        .byte   $F5
L85A5:  sta     $8C
        inc     $85,x
        lda     L85F1
        beq     L85C3
        lda     $D21F
        clc
        adc     L85F6
        sta     $D223
        lda     $D220
        adc     #$00
        sta     $D224
        jmp     L85D6

L85C3:  lda     $D21D
        clc
        adc     L85F4
        sta     $D221
        lda     $D21E
        adc     L85F5
        sta     $D222
L85D6:  lda     desktop_winid
        jsr     L86EF
        sta     L0006
        stx     $07
        ldy     #$23
        ldx     #$07
L85E4:  lda     $D21D,x
        sta     (L0006),y
        dey
        dex
        bpl     L85E4
        jsr     pop_addrs_to_zp
        rts

L85F1:  .byte   0
L85F2:  .byte   0
L85F3:  .byte   0
L85F4:  .byte   0
L85F5:  .byte   0
L85F6:  .byte   0
        .byte   0
L85F8:  .byte   0
L85F9:  .byte   0
L85FA:  .byte   0
L85FB:  .byte   0
L85FC:  ldx     #$03
L85FE:  lda     $D209,x
        sta     L86A0,x
        sta     $EBFD,x
        dex
        bpl     L85FE
        lda     #$00
        sta     L869F
        lda     $D2AB
        asl     a
        rol     L869F
        sta     L869E
L8619:  dec     L869E
        bne     L8626
        dec     L869F
        lda     L869F
        bne     L8655
L8626:  jsr     L48F0
        jsr     L8658
        bmi     L8655
        lda     #$FF
        sta     L86A6
        lda     $D208
        sta     L86A5
        cmp     #$00
        beq     L8619
        cmp     #$04
        beq     L8619
        cmp     #$02
        bne     L864B
        jsr     L48E6
        jmp     L8619

L864B:  cmp     #$01
        bne     L8655
        jsr     L48E6
        lda     #$00
        rts

L8655:  lda     #$FF
        rts

L8658:  lda     $D209
        sec
        sbc     L86A0
        sta     L86A4
        lda     $D20A
        sbc     L86A1
        bpl     L8674
        lda     L86A4
        cmp     #$F8
        bcs     L867B
L8671:  lda     #$FF
        rts

L8674:  lda     L86A4
        cmp     #$08
        bcs     L8671
L867B:  lda     $D20B
        sec
        sbc     L86A2
        sta     L86A4
        lda     $D20C
        sbc     L86A3
        bpl     L8694
        lda     L86A4
        cmp     #$F9
        bcs     L869B
L8694:  lda     L86A4
        cmp     #$07
        bcs     L8671
L869B:  lda     #$00
        rts

L869E:  .byte   0
L869F:  .byte   0
L86A0:  .byte   0
L86A1:  .byte   0
L86A2:  .byte   0
L86A3:  .byte   0
L86A4:  .byte   0
L86A5:  .byte   0
L86A6:  .byte   0
L86A7:  ldx     #$00
        stx     L86C0
        asl     a
        rol     L86C0
        asl     a
        rol     L86C0
        asl     a
        rol     L86C0
        asl     a
        rol     L86C0
        ldx     L86C0
        rts

L86C0:  .byte   0
L86C1:  ldx     #$00
        stx     L86E2
        asl     a
        rol     L86E2
        asl     a
        rol     L86E2
        asl     a
        rol     L86E2
        asl     a
        rol     L86E2
        asl     a
        rol     L86E2
        asl     a
        rol     L86E2
        ldx     L86E2
        rts

L86E2:  .byte   0
L86E3:  asl     a
        tax
        lda     $DD9F,x
        pha
        lda     $DDA0,x
        tax
        pla
        rts

L86EF:  asl     a
        tax
        lda     $DFA1,x
        pha
        lda     $DFA2,x
        tax
        pla
        rts

L86FB:  asl     a
        tax
        lda     $DFB3,x
        pha
        lda     $DFB4,x
        tax
        pla
        rts

L8707:  sta     L877F
        lda     $FB00
        sta     L0006
        lda     $FB01
        sta     $07
        ldy     #$00
        lda     (L0006),y
        tay
L8719:  lda     (L0006),y
        cmp     L877F
        beq     L8726
        dey
        bne     L8719
        jmp     L8745

L8726:  tya
        asl     a
        asl     a
        tay
        lda     $FB06
        sta     L0006
        lda     $FB07
        sta     $07
        ldx     #$00
L8736:  lda     (L0006),y
        sta     $DFC6,x
        iny
        inx
        cpx     #$04
        bne     L8736
        stx     $DFC5
        rts

L8745:  lda     #$04
        sta     $DFC5
        lda     #$20
        sta     $DFC6
        lda     #$24
        sta     $DFC7
        lda     L877F
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        cmp     #$0A
        bcs     L8764
        clc
        adc     #$30
        bne     L8767
L8764:  clc
        adc     #$37
L8767:  sta     $DFC8
        lda     L877F
        and     #$0F
        cmp     #$0A
        bcs     L8778
        clc
        adc     #$30
        bne     L877B
L8778:  clc
        adc     #$37
L877B:  sta     $DFC9
        rts

L877F:  .byte   0
L8780:  sta     L0006
        stx     $07
        ldy     #$00
        lda     (L0006),y
        beq     L879B
        sta     $08
        inc     L0006
        bne     L8792
        inc     $07
L8792:  A2D_RELAY_CALL A2D_DRAW_TEXT, $0006
L879B:  rts

        sta     L0006
        stx     $07
        ldy     #$00
        lda     (L0006),y
        sta     $08
        inc     L0006
        bne     L87AC
        inc     $07
L87AC:  A2D_RELAY_CALL A2D_MEASURE_TEXT, $0006
        lda     $09
        ldx     $0A
        rts

L87BA:  stx     $0B
        sta     $0A
        ldy     #$00
        lda     ($0A),y
        tay
        bne     L87C6
        rts

L87C6:  dey
        beq     L87CB
        bpl     L87CC
L87CB:  rts

L87CC:  lda     ($0A),y
        and     #$7F
        cmp     #$2F
        beq     L87DC
        cmp     #$20
        beq     L87DC
        cmp     #$2E
        bne     L87E0
L87DC:  dey
        jmp     L87C6

L87E0:  iny
        lda     ($0A),y
        and     #$7F
        cmp     #$41
        bcc     L87F2
        cmp     #$5B
        bcs     L87F2
        clc
        adc     #$20
        sta     ($0A),y
L87F2:  dey
        jmp     L87C6

;;; ==================================================

;;; Pushes two words from $8/$8 to stack
.proc push_addrs_from_zp

        pla                     ; stash return address
        sta     addr
        pla
        sta     addr+1

        ldx     #0              ; copy 4 bytes from $8 to stack
loop:   lda     L0006,x
        pha
        inx
        cpx     #4
        bne     loop

        lda     addr+1           ; restore return address
        pha
        lda     addr
        pha
        rts

addr:   .addr   0
.endproc

;;; ==================================================

;;; Pops two words from stack to $6/$8
.proc pop_addrs_to_zp

        pla                     ; stash return address
        sta     addr
        pla
        sta     addr+1

        ldx     #3              ; copy 4 bytes from stack to $6
loop:   pla
        sta     L0006,x
        dex
        cpx     #$FF            ; why not bpl ???
        bne     loop

        lda     addr+1          ; restore return address to stack
        pha
        lda     addr
        pha
        rts

addr:   .addr   0
.endproc

;;; ==================================================

L8830:  .byte   0
L8831:  .byte   0
L8832:  .byte   0
L8833:  .res    34, 0

L8855:  tay
        jsr     push_addrs_from_zp
        tya
        jsr     L86EF
        sta     L0006
        stx     $07
        ldx     #$00
        ldy     #$14
L8865:  lda     (L0006),y
        sta     L8830,x
        iny
        inx
        cpx     #$24
        bne     L8865
        jsr     pop_addrs_to_zp
        rts

L8874:  tay
        jsr     push_addrs_from_zp
        tya
        jsr     L86EF
        sta     L0006
        stx     $07
        ldx     #$00
        ldy     #$14
L8884:  lda     L8830,x
        sta     (L0006),y
        iny
        inx
        cpx     #$24
        bne     L8884
        jsr     pop_addrs_to_zp
        rts

L8893:  tay
        jsr     push_addrs_from_zp
        tya
        jsr     L86E3
        sta     L0006
        stx     $07
        lda     desktop_winid
        jsr     L86EF
        sta     $08
        stx     $09
        ldy     #$17
        ldx     #$03
L88AD:  lda     ($08),y
        sta     L890D,x
        dey
        dex
        bpl     L88AD
        ldy     #$1F
        ldx     #$03
L88BA:  lda     ($08),y
        sta     L8911,x
        dey
        dex
        bpl     L88BA
        ldy     #$03
        lda     (L0006),y
        clc
        adc     L890D
        sta     (L0006),y
        iny
        lda     (L0006),y
        adc     L890E
        sta     (L0006),y
        iny
        lda     (L0006),y
        clc
        adc     L890F
        sta     (L0006),y
        iny
        lda     (L0006),y
        adc     L8910
        sta     (L0006),y
        ldy     #$03
        lda     (L0006),y
        sec
        sbc     L8911
        sta     (L0006),y
        iny
        lda     (L0006),y
        sbc     L8912
        sta     (L0006),y
        iny
        lda     (L0006),y
        sec
        sbc     L8913
        sta     (L0006),y
        iny
        lda     (L0006),y
        sbc     L8914
        sta     (L0006),y
        jsr     pop_addrs_to_zp
        rts

L890D:  .byte   0
L890E:  .byte   0
L890F:  .byte   0
L8910:  .byte   0
L8911:  .byte   0
L8912:  .byte   0
L8913:  .byte   0
L8914:  .byte   0
L8915:  tay
        jsr     push_addrs_from_zp
        tya
        jsr     L86E3
        sta     L0006
        stx     $07
L8921:  lda     desktop_winid
        jsr     L86EF
        sta     $08
        stx     $09
        ldy     #$17
        ldx     #$03
L892F:  lda     ($08),y
        sta     L898F,x
        dey
        dex
        bpl     L892F
        ldy     #$1F
        ldx     #$03
L893C:  lda     ($08),y
        sta     L8993,x
        dey
        dex
        bpl     L893C
        ldy     #$03
        lda     (L0006),y
        sec
        sbc     L898F
        sta     (L0006),y
        iny
        lda     (L0006),y
        sbc     L8990
        sta     (L0006),y
        iny
        lda     (L0006),y
        sec
        sbc     L8991
        sta     (L0006),y
        iny
        lda     (L0006),y
        sbc     L8992
        sta     (L0006),y
        ldy     #$03
        lda     (L0006),y
        clc
        adc     L8993
        sta     (L0006),y
        iny
        lda     (L0006),y
        adc     L8994
        sta     (L0006),y
        iny
        lda     (L0006),y
        clc
        adc     L8995
        sta     (L0006),y
        iny
        lda     (L0006),y
        adc     L8996
        sta     (L0006),y
        jsr     pop_addrs_to_zp
        rts

L898F:  .byte   0
L8990:  .byte   0
L8991:  .byte   0
L8992:  .byte   0
L8993:  .byte   0
L8994:  .byte   0
L8995:  .byte   0
L8996:  .byte   0
L8997:  lda     #$00
        tax
L899A:  sta     $D265,x
        sta     $D25D,x
        sta     $D269,x
        inx
        cpx     #$04
        bne     L899A
        A2D_RELAY_CALL A2D_SET_STATE, $D25D
        rts

        .byte   $02
L89B3:  .byte   0
        .byte   0
        php
L89B6:  sta     L8AC3
        sty     L8AC4
        and     #$F0
        sta     L89B3
        ldy     #$C5
        lda     #$B2
        ldx     #$89
        jsr     L46BA
        beq     L89DD
L89CC:  pha
        ldy     L8AC4
        lda     #$00
        sta     $E1A0,y
        dec     buf3len
        dec     $DD9E
        pla
        rts

L89DD:  lda     L0800
        and     #$0F
        bne     L89EA
        lda     $0801
        jmp     L89CC

L89EA:  jsr     push_addrs_from_zp
        jsr     DESKTOP_FIND_SPACE
        ldy     L8AC4
        sta     $E1A0,y
        jsr     L86E3
        sta     L0006
        stx     $07
        ldx     #$00
        ldy     #$09
        lda     #$20
L8A03:  sta     (L0006),y
        iny
        inx
        cpx     #$12
        bne     L8A03
        ldy     #$09
        lda     L0800
        and     #$0F
        sta     L0800
        sta     (L0006),y
        lda     #$00
        ldx     #$08
        jsr     L87BA
        ldx     #$00
        ldy     #$0B
L8A22:  lda     $0801,x
        sta     (L0006),y
        iny
        inx
        cpx     L0800
        bne     L8A22
        ldy     #$09
        lda     (L0006),y
        clc
        adc     #$02
        sta     (L0006),y
        lda     L8AC3
        cmp     #$3E
        beq     L8A59
        and     #$0F
        cmp     #$04
        bne     L8A75
        lda     L8AC3
        and     #$70
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        ora     #$C0
        sta     L8A54
        L8A54 := *+2
        lda     $C7FB
        and     #$01
        beq     L8A67
L8A59:  ldy     #$07
        lda     #$CC
        sta     (L0006),y
        iny
        lda     #$A9
        sta     (L0006),y
        jmp     L8A96

L8A67:  ldy     #$07
        lda     #$50
        sta     (L0006),y
        iny
        lda     #$AA
        sta     (L0006),y
        jmp     L8A96

L8A75:  cmp     #$0B
        bne     L8A87
        ldy     #$07
        lda     #$20
        sta     (L0006),y
        iny
        lda     #$AA
        sta     (L0006),y
        jmp     L8A96

L8A87:  cmp     #$00
        bne     L8A67
        ldy     #$07
        lda     #$80
        sta     (L0006),y
        iny
        lda     #$A9
        sta     (L0006),y
L8A96:  ldy     #$02
        lda     #$00
        sta     (L0006),y
        inc     L8AC4
        lda     L8AC4
        asl     a
        asl     a
        tax
        ldy     #$03
L8AA7:  lda     L8AC5,x
        sta     (L0006),y
        inx
        iny
        cpy     #$07
        bne     L8AA7
        ldx     buf3len
        dex
        ldy     #$00
        lda     (L0006),y
        sta     buf3,x
        jsr     pop_addrs_to_zp
        lda     #$00
        rts

L8AC3:  .byte   $00
L8AC4:  .byte   $00
L8AC5:  .byte   $00,$00,$00,$00,$EA,$01,$10,$00
        .byte   $EA,$01,$2D,$00,$EA,$01,$4B,$00
        .byte   $EA,$01,$67,$00,$EA,$01,$83,$00
        .byte   $90,$01,$A0,$00,$36,$01,$A0,$00
        .byte   $DC,$00,$A0,$00,$82,$00,$A0,$00
        .byte   $28,$00,$A0,$00,$01,$24
        pha
L8AF4:  ldx     buf3len
        dex
L8AF8:  cmp     buf3,x
        beq     L8B01
        dex
        bpl     L8AF8
        rts

L8B01:  lda     buf3+1,x
        sta     buf3,x
        inx
        cpx     buf3len
        bne     L8B01
        dec     buf3len
        ldx     buf3len
        lda     #$00
        sta     buf3,x
        rts

L8B19:  jsr     push_addrs_from_zp
        jmp     L8B2E

L8B1F:  lda     $E6BE
        bne     L8B25
        rts

L8B25:  jsr     push_addrs_from_zp
        lda     $E6BE
        jsr     L7345
L8B2E:  lda     $E6BE
        ldx     #$07
L8B33:  cmp     $EC26,x
        beq     L8B3E
        dex
        bpl     L8B33
        jmp     L8B43

L8B3E:  lda     #$00
        sta     $EC26,x
L8B43:  lda     $E6BE
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$02
        lda     (L0006),y
        and     #$7F
        sta     (L0006),y
        jsr     L4244
        jsr     pop_addrs_to_zp
        rts

L8B5C:  ldy     #$80
        bne     L8B62
L8B60:  ldy     #$00
L8B62:  sty     L8D4A
        sta     L8D4B
        stx     L8D4C
        txa
        jsr     L86EF
        sta     L0006
        stx     $07
        lda     #$14
        clc
        adc     #$23
        tay
        ldx     #$23
L8B7B:  lda     (L0006),y
        sta     $D215,x
        dey
        dex
        bpl     L8B7B
        lda     L8D4B
        jsr     L86E3
        sta     L0006
        stx     $07
        ldy     #$03
        lda     (L0006),y
        clc
        adc     #$07
        sta     L0800
        sta     $0804
        iny
        lda     (L0006),y
        adc     #$00
        sta     $0801
        sta     $0805
        iny
        lda     (L0006),y
        clc
        adc     #$07
        sta     $0802
        sta     $0806
        iny
        lda     (L0006),y
        adc     #$00
        sta     $0803
        sta     $0807
        ldy     #$5B
        ldx     #$03
L8BC1:  lda     $D215,x
        sta     L0800,y
        dey
        dex
        bpl     L8BC1
        lda     $D221
        sec
        sbc     $D21D
        sta     L8D54
        lda     $D222
        sbc     $D21E
        sta     L8D55
        lda     $D223
        sec
        sbc     $D21F
        sta     L8D56
        lda     $D224
        sbc     $D220
        sta     L8D57
        lda     $0858
        clc
        adc     L8D54
        sta     $085C
        lda     $0859
        adc     L8D55
        sta     $085D
        lda     $085A
        clc
        adc     L8D56
        sta     $085E
        lda     $085B
        adc     L8D57
        sta     $085F
        lda     #$00
        sta     L8D4E
        sta     L8D4F
        sta     L8D4D
        lda     $0858
        sec
        sbc     L0800
        sta     L8D50
        lda     $0859
        sbc     $0801
        sta     L8D51
        lda     $085A
        sec
        sbc     $0802
        sta     L8D52
        lda     $085B
        sbc     $0803
        sta     L8D53
        bit     L8D51
        bpl     L8C6A
        lda     #$80
        sta     L8D4E
        lda     L8D50
        eor     #$FF
        sta     L8D50
        lda     L8D51
        eor     #$FF
        sta     L8D51
        inc     L8D50
        bne     L8C6A
        inc     L8D51
L8C6A:  bit     L8D53
        bpl     L8C8C
        lda     #$80
        sta     L8D4F
        lda     L8D52
        eor     #$FF
        sta     L8D52
        lda     L8D53
        eor     #$FF
        sta     L8D53
        inc     L8D52
        bne     L8C8C
        inc     L8D53
L8C8C:  lsr     L8D51
        ror     L8D50
        lsr     L8D53
        ror     L8D52
        lsr     L8D55
        ror     L8D54
        lsr     L8D57
        ror     L8D56
        lda     #$0A
        sec
        sbc     L8D4D
        asl     a
        asl     a
        asl     a
        tax
        bit     L8D4E
        bpl     L8CC9
        lda     L0800
        sec
        sbc     L8D50
        sta     L0800,x
        lda     $0801
        sbc     L8D51
        sta     $0801,x
        jmp     L8CDC

L8CC9:  lda     L0800
        clc
        adc     L8D50
        sta     L0800,x
        lda     $0801
        adc     L8D51
        sta     $0801,x
L8CDC:  bit     L8D4F
        bpl     L8CF7
        lda     $0802
        sec
        sbc     L8D52
        sta     $0802,x
        lda     $0803
        sbc     L8D53
        sta     $0803,x
        jmp     L8D0A

L8CF7:  lda     $0802
        clc
        adc     L8D52
        sta     $0802,x
        lda     $0803
        adc     L8D53
        sta     $0803,x
L8D0A:  lda     L0800,x
        clc
        adc     L8D54
        sta     $0804,x
        lda     $0801,x
        adc     L8D55
        sta     $0805,x
        lda     $0802,x
        clc
        adc     L8D56
        sta     $0806,x
        lda     $0803,x
        adc     L8D57
        sta     $0807,x
        inc     L8D4D
        lda     L8D4D
        cmp     #$0A
        beq     L8D3D
        jmp     L8C8C

L8D3D:  bit     L8D4A
        bmi     L8D46
        jsr     L8D58
        rts

L8D46:  jsr     L8DB3
        rts

L8D4A:  .byte   0
L8D4B:  .byte   0
L8D4C:  .byte   0
L8D4D:  .byte   0
L8D4E:  .byte   0
L8D4F:  .byte   0
L8D50:  .byte   0
L8D51:  .byte   0
L8D52:  .byte   0
L8D53:  .byte   0
L8D54:  .byte   0
L8D55:  .byte   0
L8D56:  .byte   0
L8D57:  .byte   0
L8D58:  lda     #$00
        sta     L8DB2
        jsr     L4510
        A2D_RELAY_CALL A2D_SET_PATTERN, $D293
        jsr     L48FA
L8D6C:  lda     L8DB2
        cmp     #$0C
        bcs     L8D89
        asl     a
        asl     a
        asl     a
        clc
        adc     #$07
        tax
        ldy     #$07
L8D7C:  lda     L0800,x
        sta     $E230,y
        dex
        dey
        bpl     L8D7C
        jsr     L8E10
L8D89:  lda     L8DB2
        sec
        sbc     #$02
        bmi     L8DA7
        asl     a
L8D92:  asl     a
        asl     a
        clc
        adc     #$07
        tax
        ldy     #$07
L8D9A:  lda     L0800,x
        sta     $E230,y
        dex
        dey
        bpl     L8D9A
        jsr     L8E10
L8DA7:  inc     L8DB2
        lda     L8DB2
        cmp     #$0E
        bne     L8D6C
        rts

L8DB2:  .byte   0
L8DB3:  lda     #$0B
        sta     L8E0F
        jsr     L4510
        A2D_RELAY_CALL A2D_SET_PATTERN, $D293
        jsr     L48FA
L8DC7:  lda     L8E0F
        bmi     L8DE4
        beq     L8DE4
        asl     a
        asl     a
        asl     a
        clc
        adc     #$07
        tax
        ldy     #$07
L8DD7:  lda     L0800,x
        sta     $E230,y
        dex
        dey
        bpl     L8DD7
        jsr     L8E10
L8DE4:  lda     L8E0F
        clc
        adc     #$02
        cmp     #$0E
        bcs     L8E04
        asl     a
        asl     a
        asl     a
        clc
        adc     #$07
        tax
        ldy     #$07
        lda     L0800,x
        sta     $E230,y
        dex
        dey
        .byte   $10
UNKNOWN_CALL:
        inc     L0020,x
        bpl     L8D92
L8E04:  dec     L8E0F
        lda     L8E0F
        cmp     #$FD
        bne     L8DC7
        rts

L8E0F:  .byte   0
L8E10:  A2D_RELAY_CALL A2D_DRAW_RECT, $E230
        rts

L8E1A:  .byte   $E0
L8E1B:  .byte   $2F
L8E1C:  .byte   $01,$00,$E0,$60,$01,$00,$E0,$74
        .byte   $01,$00,$E0,$84,$01,$00,$E0,$A4
        .byte   $01,$00,$E0,$AC,$01,$00,$E0,$B4
        .byte   $01,$00,$80,$B7,$00,$00,$80,$F7
        .byte   $00,$00
L8E3E:  .byte   $00
L8E3F:  .byte   $02,$00,$14,$00,$10,$00,$20,$00
        .byte   $08,$00,$08,$00,$08,$00,$28,$00
        .byte   $10
L8E50:  .byte   $00
L8E51:  .byte   $08,$00,$08,$00,$90,$00,$50,$00
        .byte   $70,$00,$70,$00,$70,$00,$50,$00
        .byte   $90,$03,$68,$8E,$00,$1C
L8E67:  .byte   $00,$08,$44,$65,$73,$6B,$54,$6F
        .byte   $70,$32,$02
L8E72:  .byte   $00
L8E73:  .byte   $00
L8E74:  .byte   $00
L8E75:  .byte   $00,$04
L8E77:  .byte   $00
L8E78:  .byte   $00
L8E79:  .byte   $00
L8E7A:  .byte   $00
L8E7B:  .byte   $00,$00,$00,$01,$00
L8E80:  .byte   $00
L8E81:  pha
        lda     #$00
        sta     L8E80
        beq     L8E8F
L8E89:  pha
        lda     #$80
        sta     L8E80
L8E8F:  pla
        asl     a
        tay
        asl     a
        tax
        lda     L8E1A,x
        sta     L8E73
        lda     L8E1B,x
        sta     L8E74
        lda     L8E1C,x
        sta     L8E75
        lda     L8E3E,y
        sta     L8E7A
        lda     L8E3F,y
        sta     L8E7B
        lda     L8E50,y
        sta     L8E78
        lda     L8E51,y
        sta     L8E79
L8EBE:  ldy     #$C8
        lda     #$62
        ldx     #$8E
        jsr     L46BA
        beq     L8ED6
        lda     #$00
        ora     L8E80
        jsr     L48CC
        beq     L8EBE
        lda     #$FF
        rts

L8ED6:  lda     L8E67
        sta     L8E77
        sta     L8E72
        ldy     #$CE
        lda     #$71
        ldx     #$8E
        jsr     L46BA
        ldy     #$CA
        lda     #$76
        ldx     #$8E
        jsr     L46BA
        ldy     #$CC
        lda     #$7E
        ldx     #$8E
        jsr     L46BA
        rts

        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
L8F00:  jmp     L8FC5

        jmp     L97E3

        jmp     L97E3

L8F09:  jmp     L92E7

L8F0C:  jmp     L8F9B

L8F0F:  jmp     L8FA1

L8F12:  jmp     L9571

L8F15:  jmp     L9213

L8F18:  jmp     L8F2A

L8F1B:  jmp     L8F5B

        jmp     L97E3

        jmp     L97E3

L8F24:  jmp     L8F7E

L8F27:  jmp     L8FB8

L8F2A:  lda     #$00
        sta     L9189
        tsx
        stx     L9188
        jsr     LA248
        jsr     L993E
        jsr     LA271
        jsr     L9968
L8F3F:  lda     #$FF
        sta     $E05B
        lda     #$00
        sta     $E05C
        jsr     L9A0D
        jsr     L917F
L8F4F:  jsr     L91E8
        lda     #$00
        rts

        jsr     L91D5
        jmp     L8F4F

L8F5B:  lda     #$00
        sta     L9189
        tsx
        stx     L9188
        jsr     LA248
        lda     #$00
        jsr     L9E7E
        jsr     LA271
        jsr     L9182
        jsr     L9EBF
        jsr     L9EDB
        jsr     L917F
        jmp     L8F4F

L8F7E:  lda     #$80
        sta     L918C
        lda     #$C0
        sta     L9189
        tsx
        stx     L9188
        jsr     LA248
        jsr     L9984
        jsr     LA271
        jsr     L99BC
        jmp     L8F3F

L8F9B:  jsr     L8FDD
        jmp     L8F4F

L8FA1:  jsr     L8FE1
        jmp     L8F4F

L8FA7:  asl     a
        tay
        lda     $DD9F,y
        sta     L0006
        lda     $DDA0,y
        sta     $07
        ldy     #$02
        lda     (L0006),y
        rts

L8FB8:  lda     #$00
        sta     L918C
        lda     #$C0
        sta     L9189
        jmp     L8FEB

L8FC5:  lda     $EBFC
        cmp     #$01
        bne     L8FD0
        lda     #$80
        bne     L8FD2
L8FD0:  lda     #$00
L8FD2:  sta     L918A
        lda     #$00
        sta     L9189
        jmp     L8FEB

L8FDD:  lda     #$00
        beq     L8FE3
L8FE1:  lda     #$80
L8FE3:  sta     L918B
        lda     #$80
        sta     L9189
L8FEB:  tsx
        stx     L9188
        lda     #$00
        sta     $E05C
        jsr     L91D5
        lda     L9189
        beq     L8FFF
        jmp     L908C

L8FFF:  .byte   $2C
L9000:  txa
        sta     ($10),y
        ora     $20AD
        .byte   $DF             ; ???
        beq     L900C
        jmp     L908C

L900C:  pla
        pla
        jmp     L4012

        lda     $EBFC
        bpl     L9032
        and     #$7F
        asl     a
        tax
        lda     $DFB3,x
        sta     $08
        lda     $DFB4,x
        sta     $09
        lda     #$7B
        sta     L0006
        lda     #$91
        sta     $07
        jsr     L91A0
        jmp     L9076

L9032:  jsr     L8FA7
        and     #$0F
        beq     L9051
        asl     a
        tax
        lda     $DFB3,x
        sta     $08
        lda     $DFB4,x
        sta     $09
        lda     $EBFC
        jsr     L918E
        jsr     L91A0
        jmp     L9076

L9051:  lda     $EBFC
        jsr     L918E
        ldy     #$01
        lda     #$2F
        sta     (L0006),y
        dey
        lda     (L0006),y
        sta     L906D
        sta     $E00A,y
L9066:  iny
        lda     (L0006),y
        sta     $E00A,y
        .byte   $C0
L906D:  .byte   0
        bne     L9066
        ldy     #$01
        lda     #$20
        sta     (L0006),y
L9076:  ldy     #$FF
L9078:  iny
        lda     $E00A,y
        sta     $DFC9,y
        cpy     $E00A
        bne     L9078
        lda     $DFC9
        beq     L908C
        dec     $DFC9
L908C:  lda     #$00
        sta     L97E4
        jsr     LA248
        bit     L9189
        bvs     L90B4
        bmi     L90AE
        bit     L918A
        bmi     L90A6
        jsr     L993E
        jmp     L90DE

L90A6:  lda     #$06
        jsr     L9E7E
        jmp     L90DE

L90AE:  jsr     LA059
        jmp     L90DE

L90B4:  jsr     LA1E4
        jmp     L90DE

L90BA:  bit     L9189
        bvs     L90D8
        bmi     L90D2
        bit     L918A
        bmi     L90CC
        jsr     L9968
        jmp     L90DE

L90CC:  jsr     L9EBF
        jmp     L90DE

L90D2:  jsr     LA0DF
        jmp     L90DE

L90D8:  jsr     LA241
        jmp     L90DE

L90DE:  jsr     L91F5
        lda     $DF21
        bne     L90E9
        jmp     L9168

L90E9:  ldx     #$00
        stx     L917A
L90EE:  jsr     L91F5
        ldx     L917A
        lda     $DF22,x
        cmp     #$01
        beq     L9140
        jsr     L918E
        jsr     L91A0
        lda     #$0A
        sta     L0006
        lda     #$E0
        sta     $07
        ldy     #$00
        lda     (L0006),y
        beq     L9114
        sec
        sbc     #$01
        sta     (L0006),y
L9114:  lda     L97E4
        beq     L913D
        bit     L9189
        bmi     L912F
        bit     L918A
        bmi     L9129
        jsr     L9A01
        jmp     L9140

L9129:  jsr     L9EDB
        jmp     L9140

L912F:  bvs     L9137
        jsr     LA114
        jmp     L9140

L9137:  jsr     LA271
        jmp     L9140

L913D:  jsr     LA271
L9140:  inc     L917A
        ldx     L917A
        cpx     $DF21
        bne     L90EE
        lda     L97E4
        bne     L9168
        inc     L97E4
        bit     L9189
        bmi     L915D
        bit     L918A
        bpl     L9165
L915D:  jsr     L9182
        bit     L9189
        bvs     L9168
L9165:  jmp     L90BA

L9168:  jsr     L917F
        lda     $EBFC
        jsr     L918E
        ldy     #$01
        lda     #$20
        sta     (L0006),y
        lda     #$00
        rts

L917A:  .byte   0
        .byte   0

        ;; Dynamically constructed jump table???
        L917D := *+1
L917C:  jmp     $0000
        L9180 := *+1
L917F:  jmp     $0000
        L9183 := *+1
L9182:  jmp     $0000
        L9186 := *+1
L9185:  jmp     $0000

L9188:  .byte   0
L9189:  .byte   0
L918A:  .byte   0
L918B:  .byte   0
L918C:  .byte   0
L918D:  .byte   0
L918E:  asl     a
        tay
        lda     $DD9F,y
        clc
        adc     #$09
        sta     L0006
        lda     $DDA0,y
        adc     #$00
        sta     $07
        rts

L91A0:  ldx     #$00
        ldy     #$00
        lda     ($08),y
        beq     L91B6
        sta     L91B3
L91AB:  iny
        inx
        lda     ($08),y
        sta     $E00A,x
        .byte   $C0
L91B3:  .byte   0
        bne     L91AB
L91B6:  inx
        lda     #$2F
        sta     $E00A,x
        ldy     #$00
        lda     (L0006),y
        beq     L91D1
        sta     L91CE
        iny
L91C6:  iny
        inx
        lda     (L0006),y
        sta     $E00A,x
        .byte   $C0
L91CE:  .byte   0
        bne     L91C6
L91D1:  stx     $E00A
        rts

L91D5:  ldy     #$03
        lda     #$39
        ldx     #$D2
        jsr     L4003
        ldy     #$04
        lda     #$39
        ldx     #$D2
        jsr     L4003
        rts

L91E8:  jsr     L4015
        ldy     #$0C
        lda     #$00
        ldx     #$00
        jsr     L4018
        rts

L91F5:  lda     #$11
        sta     $08
        lda     #$92
        sta     $09
        lda     $DF20
        beq     L9210
        asl     a
        tax
        lda     $DFB3,x
        sta     $08
        lda     $DFB4,x
        sta     $09
        lda     #$00
L9210:  rts

        .byte   0
        .byte   0
L9213:  lda     $DF21
        bne     L9219
        rts

L9219:  ldx     $DF21
        stx     L0800
        dex
L9220:  lda     $DF22,x
        sta     $0801,x
        dex
        bpl     L9220
        jsr     L401E
        ldx     #$00
        stx     L924A
L9231:  ldx     L924A
        lda     $0801,x
        cmp     #$01
        beq     L923E
        jsr     L924B
L923E:  inc     L924A
        ldx     L924A
        cpx     L0800
        bne     L9231
        rts

L924A:  .byte   0
L924B:  sta     L9254
        ldy     #$00
L9250:  lda     $E1A0,y
        .byte   $C9
L9254:  .byte   0
        beq     L9260
        cpy     $BF31
        beq     L925F
        iny
        bne     L9250
L925F:  rts

L9260:  lda     $BF32,y
        sta     L92C7
        ldx     #$11
        lda     L92C7
        and     #$80
        beq     L9271
        ldx     #$21
L9271:  stx     L9284
        lda     L92C7
        and     #$70
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     L9284
        sta     L9284
        L9284 := *+1
        lda     $BF00
        sta     L0006+1
        lda     #$00
        sta     L0006
        ldy     #$07
        .byte   $B1
L928F:  asl     $D0
        cmp     $FBA0
        lda     (L0006),y
        and     #$7F
        bne     L925F
        ldy     #$FF
        lda     (L0006),y
        clc
        adc     #$03
        sta     L0006
        lda     L92C7
        pha
        rol     a
        pla
        php
        and     #$20
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        plp
        adc     #$01
        sta     L92C1
        jsr     L92BD
        .byte   $04
        .addr   L92C0
        rts
L92BD:  jmp     (L0006)

L92C0:  .byte   $03
L92C1:  .byte   $00,$C5,$92,$04,$00,$00
L92C7:  .byte   $00,$00,$0A,$20,$02
L92CC:  .byte   $00
L92CD:  .byte   $00
L92CE:  .byte   $00
L92CF:  .byte   $00,$00
L92D1:  .byte   $00
L92D2:  .byte   $00
L92D3:  .byte   $00
L92D4:  .byte   $00,$00,$00
L92D7:  .byte   $00
L92D8:  .byte   $00,$00,$00,$00,$00,$03
L92DE:  .byte   $00,$00,$08,$0A,$00
L92E3:  .byte   $00
L92E4:  .byte   $00
L92E5:  .byte   $00
L92E6:  .byte   $00
L92E7:  lda     $DF21
        bne     L92ED
        rts

L92ED:  lda     #$00
        sta     L92E6
        jsr     L91D5
L92F5:  ldx     L92E6
        cpx     $DF21
        bne     L9300
        jmp     L9534

L9300:  lda     $DF20
        beq     L9331
        asl     a
        tax
        lda     $DFB3,x
        sta     $08
        lda     $DFB4,x
        sta     $09
        ldx     L92E6
        lda     $DF22,x
        jsr     L918E
        jsr     L91A0
        ldy     #$00
L931F:  lda     $E00A,y
        sta     $0220,y
        iny
        cpy     $0220
        bne     L931F
        dec     $0220
        jmp     L9356

L9331:  ldx     L92E6
        lda     $DF22,x
        cmp     #$01
        bne     L933E
        jmp     L952E

L933E:  jsr     L918E
        ldy     #$00
L9343:  lda     (L0006),y
        sta     $0220,y
        iny
        cpy     $0220
        bne     L9343
        dec     $0220
        lda     #$2F
        sta     $0221
L9356:  ldy     #$C4
        lda     #$C9
        ldx     #$92
        jsr     L4021
        beq     L9366
        jsr     LA49B
        beq     L9356
L9366:  lda     $DF20
        beq     L9387
        lda     #$80
        sta     L92E3
        lda     L92E6
        clc
        adc     #$01
        cmp     $DF21
        beq     L9381
        inc     L92E3
        inc     L92E3
L9381:  jsr     L953F
        jmp     L93DB

L9387:  lda     #$81
        sta     L92E3
        lda     L92E6
        clc
        adc     #$01
        cmp     $DF21
        beq     L939D
        inc     L92E3
        inc     L92E3
L939D:  jsr     L953F
        lda     #$00
        sta     L942E
        ldx     L92E6
        lda     $DF22,x
        ldy     #$0F
L93AD:  cmp     $E1A0,y
        beq     L93B8
        dey
        bpl     L93AD
        jmp     L93DB

L93B8:  lda     $BF32,y
        sta     L92DE
        ldy     #$80
        lda     #$DD
        ldx     #$92
        jsr     L4021
        bne     L93DB
        ldy     #$81
        lda     #$DD
        ldx     #$92
        jsr     L4021
        cmp     #$2B
        bne     L93DB
        lda     #$80
        sta     L942E
L93DB:  ldx     L92E6
        lda     $DF22,x
        jsr     L918E
        lda     #$01
        sta     L92E3
        lda     L0006
        sta     L92E4
        lda     $07
        sta     L92E5
        jsr     L953F
        lda     #$02
        sta     L92E3
        lda     $DF20
        bne     L9413
        bit     L942E
        bmi     L940C
        lda     #$00
        sta     L92E4
        beq     L9428
L940C:  lda     #$01
        sta     L92E4
        bne     L9428
L9413:  lda     L92CC
        and     #$C3
        cmp     #$C3
        beq     L9423
        lda     #$01
        sta     L92E4
        bne     L9428
L9423:  lda     #$00
        sta     L92E4
L9428:  jsr     L953F
        jmp     L942F

L942E:  .byte   0
L942F:  lda     #$03
        sta     L92E3
        lda     #$00
        sta     $0220
        lda     $DF20
        bne     L9472
        lda     L92CE
        sec
        sbc     L92D1
        pha
        lda     L92CF
        sbc     L92D2
        tax
        pla
        jsr     L4006
        jsr     L9549
        ldx     #$00
L9456:  lda     $E6EB,x
        cmp     #$42
        beq     L9460
        inx
        bne     L9456
L9460:  stx     $0220
        lda     #$2F
        sta     $0220,x
        dex
L9469:  lda     $E6EB,x
        sta     $0220,x
        dex
        bne     L9469
L9472:  lda     $DF20
        bne     L9480
        lda     L92CE
        ldx     L92CF
        jmp     L9486

L9480:  lda     L92D1
        ldx     L92D2
L9486:  jsr     L4006
        jsr     L9549
        ldx     $0220
        ldy     #$00
L9491:  lda     $E6EC,y
        sta     $0221,x
        inx
        iny
        cpy     $E6EB
        bne     L9491
        tya
        clc
        adc     $0220
        sta     $0220
        ldx     $0220
L94A9:  lda     $0220,x
        sta     $DFC9,x
        dex
        bpl     L94A9
        lda     #$C9
        sta     L92E4
        lda     #$DF
        sta     L92E5
        jsr     L953F
        lda     #$04
        sta     L92E3
        lda     L92D7
        sta     $EC5A
        lda     L92D8
        sta     $EC5B
        jsr     L4009
        lda     #$EB
        sta     L92E4
        lda     #$E6
        sta     L92E5
        jsr     L953F
        lda     #$05
        sta     L92E3
        lda     L92D3
        sta     $EC5A
        lda     L92D4
        sta     $EC5B
        jsr     L4009
        lda     #$EB
        sta     L92E4
        lda     #$E6
        sta     L92E5
        jsr     L953F
        lda     #$06
        sta     L92E3
        lda     $DF20
        bne     L9519
        ldx     L953A
L950E:  lda     L953A,x
        sta     $DFC5,x
        dex
        bpl     L950E
        bmi     L951F
L9519:  lda     L92CD
        jsr     L402D
L951F:  lda     #$C5
        sta     L92E4
        lda     #$DF
        sta     L92E5
        jsr     L953F
        bne     L9534
L952E:  inc     L92E6
        jmp     L92F5

L9534:  lda     #$00
        sta     $DFC9
        rts

L953A:  PASCAL_STRING " VOL"
L953F:  ldy     #$06
        lda     #$E3
        ldx     #$92
        jsr     LA500
        rts

L9549:  ldx     #$00
L954B:  lda     $E6EC,x
        cmp     #$20
        bne     L9555
        inx
        bne     L954B
L9555:  ldy     #$00
        dex
L9558:  lda     $E6EC,x
        sta     $E6EC,y
        iny
        inx
        cpx     $E6EB
        bne     L9558
        sty     $E6EB
        rts

        .byte   $02
        jsr     RAMRDOFF
        .byte   $1F
L956E:  .byte   0
        .byte   0
L9570:  .byte   $1F
L9571:  lda     #$00
        sta     L9706
L9576:  lda     L9706
        cmp     $DF21
        bne     L9581
        lda     #$00
        rts

L9581:  ldx     L9706
        lda     $DF22,x
        cmp     #$01
        bne     L9591
        inc     L9706
        jmp     L9576

L9591:  lda     $DF20
        beq     L95C2
        asl     a
        tax
        lda     $DFB3,x
        sta     $08
        lda     $DFB4,x
        sta     $09
        ldx     L9706
        lda     $DF22,x
        jsr     L918E
        jsr     L91A0
        ldy     #$00
L95B0:  lda     $E00A,y
        sta     $0220,y
        iny
        cpy     $0220
        bne     L95B0
        dec     $0220
        jmp     L95E0

L95C2:  ldx     L9706
        lda     $DF22,x
        jsr     L918E
        ldy     #$00
L95CD:  lda     (L0006),y
        sta     $0220,y
        iny
        cpy     $0220
        bne     L95CD
        dec     $0220
        lda     #$2F
        sta     $0221
L95E0:  ldx     L9706
        lda     $DF22,x
        jsr     L918E
        ldy     #$00
        lda     (L0006),y
        tay
L95EE:  lda     (L0006),y
        sta     $1F12,y
        dey
        bpl     L95EE
        ldy     #$00
        lda     (L0006),y
        tay
        dey
        sec
        sbc     #$02
        sta     $1F00
L9602:  lda     (L0006),y
        sta     $1EFF,y
        dey
        cpy     #$01
        bne     L9602
        lda     #$00
        jsr     L96F8
L9611:  lda     #$80
        jsr     L96F8
        beq     L962F
L9618:  ldx     L9706
        lda     $DF22,x
        jsr     L918E
        ldy     $1F12
L9624:  lda     $1F12,y
        sta     (L0006),y
        dey
        bpl     L9624
        lda     #$FF
        rts

L962F:  sty     $08
        sty     L9707
        stx     $09
        stx     L9708
        lda     $DF20
        beq     L964D
        asl     a
        tax
        lda     $DFB3,x
        sta     L0006
        lda     $DFB4,x
        sta     $07
        jmp     L9655

L964D:  lda     #$05
        sta     L0006
        lda     #$97
        sta     $07
L9655:  ldy     #$00
        lda     (L0006),y
        tay
L965A:  lda     (L0006),y
        sta     $1FC0,y
        dey
        bpl     L965A
        inc     $1FC0
        ldx     $1FC0
        lda     #$2F
        sta     $1FC0,x
        ldy     #$00
        lda     ($08),y
        sta     L9709
L9674:  inx
        iny
        lda     ($08),y
        sta     $1FC0,x
        cpy     L9709
        bne     L9674
        stx     $1FC0
        ldy     #$C2
        lda     #$69
        ldx     #$95
        jsr     L4021
        beq     L969E
        jsr     L4030
        bne     L9696
        jmp     L9611

L9696:  lda     #$40
        jsr     L96F8
        jmp     L9618

L969E:  lda     #$40
        jsr     L96F8
        ldx     L9706
        lda     $DF22,x
        sta     $E22B
        ldy     #$0E
        lda     #$2B
        ldx     #$E2
        jsr     L4018
        lda     L9707
        sta     $08
        lda     L9708
        sta     $09
        ldx     L9706
        lda     $DF22,x
        jsr     L918E
        ldy     #$00
        lda     ($08),y
        clc
        adc     #$02
        sta     (L0006),y
        lda     ($08),y
        tay
        inc     L0006
        bne     L96DA
        inc     $07
L96DA:  lda     ($08),y
        sta     (L0006),y
        dey
        bne     L96DA
        dec     L0006
        lda     L0006
        cmp     #$FF
        bne     L96EB
        dec     $07
L96EB:  lda     (L0006),y
        tay
        lda     #$20
        sta     (L0006),y
        inc     L9706
        jmp     L9576

L96F8:  sta     L956E
        ldy     #$09
        lda     #$6E
        ldx     #$95
        jsr     LA500
        rts

        .byte   $00
L9706:  .byte   $00
L9707:  .byte   $00
L9708:  .byte   $00
L9709:  .byte   $00,$03,$20,$02,$00,$08
L970F:  .byte   $00,$04
L9711:  .byte   $00,$18,$97,$04,$00,$00,$00,$00
        .byte   $00,$00,$00,$01
L971D:  .byte   $00,$04
L971F:  .byte   $00,$AD,$97,$27,$00,$00,$00,$04
L9727:  .byte   $00,$2E,$97,$05,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $01
L9738:  .byte   $00,$01
L973A:  .byte   $00,$01,$20,$02,$03,$20,$02,$00
        .byte   $0D
L9743:  .byte   $00,$03,$C0,$1F,$00,$11
L9749:  .byte   $00,$04
L974B:  .byte   $00,$00,$15
L974E:  .byte   $C0
L974F:  .byte   $0A
L9750:  .byte   $00
L9751:  .byte   $00,$04
L9753:  .byte   $00,$00,$15
L9756:  .byte   $C0
L9757:  .byte   $0A,$00,$00
L975A:  .byte   $07,$C0,$1F,$C3,$00,$00,$00,$00
        .byte   $00,$00,$00,$00
L9766:  .byte   $07,$C0,$1F
L9769:  .byte   $00,$00,$00,$00
L976D:  .byte   $00,$00,$00,$00,$00,$00,$00
L9774:  .byte   $0A,$20,$02
L9777:  .byte   $00
L9778:  .byte   $00,$00,$00
L977B:  .byte   $00
L977C:  .byte   $00
L977D:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00
L9787:  .byte   $0A,$C0,$1F
L978A:  .byte   $00,$00
L978C:  .byte   $00
L978D:  .byte   $00,$00
L978F:  .byte   $00
L9790:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$02
L979B:  .byte   $00,$00,$00,$00,$02
L97A0:  .byte   $00
L97A1:  .byte   $00
L97A2:  .byte   $00
L97A3:  .byte   $00,$02
L97A5:  .byte   $00
L97A6:  .byte   $00
L97A7:  .byte   $00
L97A8:  .byte   $00,$02,$00,$00,$08
L97AD:  .byte   $00
L97AE:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00
L97BD:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
L97DD:  .byte   $36,$9B
L97DF:  .byte   $33,$9B
L97E1:  .byte   $E3,$97
L97E3:  .byte   $60
L97E4:  .byte   $00
L97E5:  ldx     $E10C
        lda     $E061
        sta     $E062,x
        inx
        stx     $E10C
        rts

L97F3:  ldx     $E10C
        dex
        lda     $E062,x
        sta     $E061
        stx     $E10C
        rts

L9801:  lda     #$00
        sta     $E05F
        sta     $E10D
L9809:  ldy     #$C8
        lda     #$0A
        ldx     #$97
        jsr     L4021
        beq     L981E
        ldx     #$80
        jsr     L4033
        beq     L9809
        jmp     LA39F

L981E:  lda     L970F
        sta     $E060
        sta     L9711
L9827:  ldy     #$CA
        lda     #$10
        ldx     #$97
        jsr     L4021
        beq     L983C
        ldx     #$80
        jsr     L4033
        beq     L9827
        jmp     LA39F

L983C:  jmp     L985B

L983F:  lda     $E060
        sta     L971D
L9845:  ldy     #$CC
        lda     #$1C
        ldx     #$97
        jsr     L4021
        beq     L985A
        ldx     #$80
        jsr     L4033
        beq     L9845
        jmp     LA39F

L985A:  rts

L985B:  inc     $E05F
        lda     $E060
        sta     L971F
L9864:  ldy     #$CA
        lda     #$1E
        ldx     #$97
        jsr     L4021
        beq     L987D
        cmp     #$4C
        beq     L989F
        ldx     #$80
        jsr     L4033
        beq     L9864
        jmp     LA39F

L987D:  inc     $E10D
        lda     $E10D
        cmp     $E05E
        bcc     L989C
        lda     #$00
        sta     $E10D
        lda     $E060
        sta     L9727
        ldy     #$CA
        lda     #$26
        ldx     #$97
        jsr     L4021
L989C:  lda     #$00
        rts

L989F:  lda     #$FF
        rts

L98A2:  lda     $E05F
        sta     $E061
        jsr     L983F
        jsr     L97E5
        jsr     LA2FD
        jmp     L9801

L98B4:  jsr     L983F
        jsr     L992A
        jsr     LA322
        jsr     L97F3
        jsr     L9801
        jsr     L98C9
        jmp     L9927

L98C9:  lda     $E05F
        cmp     $E061
        beq     L98D7
        jsr     L985B
        jmp     L98C9

L98D7:  rts

L98D8:  lda     #$00
        sta     $E05D
        jsr     L9801
L98E0:  jsr     L985B
        bne     L9912
        lda     L97AD
        beq     L98E0
        lda     L97AD
        sta     L992D
        and     #$0F
        sta     L97AD
        lda     #$00
        sta     L9923
        jsr     L9924
        lda     L9923
        bne     L98E0
        lda     L97BD
        cmp     #$0F
        bne     L98E0
        jsr     L98A2
        inc     $E05D
        jmp     L98E0

L9912:  lda     $E05D
        beq     L9920
        jsr     L98B4
        dec     $E05D
        jmp     L98E0

L9920:  jmp     L983F

L9923:  .byte   0
L9924:  jmp     (L97DD)

L9927:  jmp     (L97DF)

L992A:  jmp     (L97E1)

L992D:  .byte   $00,$00,$00,$00
L9931:  .byte   $36,$9B,$33,$9B,$E3,$97
L9937:  .byte   $00
L9938:  .byte   $00
L9939:  .byte   $00
        jsr     RAMRDOFF
        .byte   $1F
L993E:  lda     #$00
        sta     L9937
        lda     #$5A
        sta     L917D
        lda     #$99
        sta     L917D+1
        lda     #$7C
        sta     L9180
        lda     #$99
        sta     L9180+1
        jmp     L9BBF

        sta     L9938
        stx     L9939
        lda     #$01
        sta     L9937
        jmp     L9BBF

L9968:  ldy     #$05
L996A:  lda     L9931,y
        sta     L97DD,y
        dey
        bpl     L996A
        lda     #$00
        sta     LA425
        sta     L918D
        rts

        lda     #$05
        sta     L9937
        jmp     L9BBF

L9984:  lda     #$00
        sta     L9937
        lda     #$A7
        sta     L917D
        lda     #$99
        sta     L917D+1
        lda     #$DC
        sta     L9180
        lda     #$99
        sta     L9180+1
        ldy     #$0A
        lda     #$37
        ldx     #$99
        jsr     LA500
        rts

        sta     L9938
        stx     L9939
        lda     #$01
        sta     L9937
        ldy     #$0A
        lda     #$37
        ldx     #$99
        jsr     LA500
        rts

L99BC:  lda     #$80
        sta     L918D
        ldy     #$05
L99C3:  lda     L9931,y
        sta     L97DD,y
        dey
        bpl     L99C3
        lda     #$00
        sta     LA425
        lda     #$EB
        sta     L9186
        lda     #$99
        sta     L9186+1
        rts

        lda     #$03
        sta     L9937
        ldy     #$0A
        lda     #$37
        ldx     #$99
        jsr     LA500
        rts

        lda     #$04
        sta     L9937
        ldy     #$0A
        lda     #$37
        ldx     #$99
        jsr     LA500
        cmp     #$02
        bne     L99FE
        rts

L99FE:  jmp     LA39F

L9A01:  lda     #$80
        sta     $E05B
        lda     #$00
        sta     $E05C
        beq     L9A0F
L9A0D:  lda     #$FF
L9A0F:  sta     L9B31
        lda     #$02
        sta     L9937
        jsr     LA379
        bit     L9189
        bvc     L9A22
        jsr     L9BC9
L9A22:  bit     $E05B
        bpl     L9A70
        bvs     L9A50
        lda     L9B31
        bne     L9A36
        lda     $DF20
        bne     L9A36
        jmp     L9B28

L9A36:  ldx     $1FC0
        ldy     L9B32
        dey
L9A3D:  iny
        inx
        lda     $0220,y
        sta     $1FC0,x
        cpy     $0220
        bne     L9A3D
        stx     $1FC0
        jmp     L9A70

L9A50:  ldx     $1FC0
        lda     #$2F
        sta     $1FC1,x
        inc     $1FC0
        ldy     #$00
        ldx     $1FC0
L9A60:  iny
        inx
        lda     $E04B,y
        sta     $1FC0,x
        cpy     $E04B
        bne     L9A60
        stx     $1FC0
L9A70:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        beq     L9A81
        jsr     LA49B
        jmp     L9A70

L9A81:  lda     L977B
        cmp     #$0F
        beq     L9A90
        cmp     #$0D
        beq     L9A90
        lda     #$00
        beq     L9A95
L9A90:  jsr     LA2F1
        lda     #$FF
L9A95:  sta     L9B30
        jsr     LA40A
        lda     LA2EE
        bne     L9AA8
        lda     LA2ED
        bne     L9AA8
        jmp     LA39F

L9AA8:  ldy     #$07
L9AAA:  lda     L9774,y
        sta     L9766,y
        dey
        cpy     #$02
        bne     L9AAA
        lda     #$C3
        sta     L9769
        lda     $E05B
        beq     L9B23
        jsr     L9C01
        bcs     L9B2C
        ldy     #$11
        ldx     #$0B
L9AC8:  lda     L9774,y
        sta     L9766,x
        dex
        dey
        cpy     #$0D
        bne     L9AC8
        lda     L976D
        cmp     #$0F
        bne     L9AE0
        lda     #$0D
        sta     L976D
L9AE0:  ldy     #$C0
        lda     #$66
        ldx     #$97
        jsr     L4021
        beq     L9B23
        cmp     #$47
        bne     L9B1D
        bit     L918D
        bmi     L9B14
        lda     #$03
        sta     L9937
        jsr     L9BBF
        pha
        lda     #$02
        sta     L9937
        pla
        cmp     #$02
        beq     L9B14
        cmp     #$03
        beq     L9B2C
        cmp     #$04
        bne     L9B1A
        lda     #$80
        sta     L918D
L9B14:  jsr     LA426
        jmp     L9B23

L9B1A:  jmp     LA39F

L9B1D:  jsr     LA49B
        jmp     L9AE0

L9B23:  lda     L9B30
        beq     L9B2D
L9B28:  jmp     L98D8

        .byte   0
L9B2C:  rts

L9B2D:  jmp     L9CDA

L9B30:  .byte   0
L9B31:  .byte   0
L9B32:  .byte   0
        jmp     LA360

        jsr     LA3D1
        beq     L9B3E
        jmp     LA39F

L9B3E:  lda     L97BD
        cmp     #$0F
        bne     L9B88
        jsr     LA2FD
L9B48:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        beq     L9B59
        jsr     LA49B
        jmp     L9B48

L9B59:  jsr     LA33B
        jsr     LA40A
        jsr     LA2F1
        lda     LA2EE
        bne     L9B6F
        lda     LA2ED
        bne     L9B6F
        jmp     LA39F

L9B6F:  jsr     L9E19
        bcs     L9B7A
        jsr     LA322
        jmp     L9BBE

L9B7A:  jsr     LA360
        jsr     LA322
        lda     #$FF
        sta     L9923
        jmp     L9BBE

L9B88:  jsr     LA33B
        jsr     LA2FD
        jsr     LA40A
L9B91:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        beq     L9BA2
        jsr     LA49B
        jmp     L9B91

L9BA2:  jsr     L9C01
        bcc     L9BAA
        jmp     LA39F

L9BAA:  jsr     LA322
        jsr     L9E19
        bcs     L9BBB
        jsr     LA2FD
        jsr     L9CDA
        jsr     LA322
L9BBB:  jsr     LA360
L9BBE:  rts

L9BBF:  ldy     #$01
        lda     #$37
        ldx     #$99
        jsr     LA500
        rts

L9BC9:  ldy     #$C4
        lda     #$87
        ldx     #$97
        jsr     L4021
        beq     L9BDA
        jsr     LA497
        jmp     L9BC9

L9BDA:  lda     L978C
        sec
        sbc     L978F
        sta     L9BFF
        lda     L978D
        sbc     L9790
        sta     L9C00
        lda     L9BFF
        cmp     LA2EF
        lda     L9C00
        sbc     LA2F0
        bcs     L9BFE
        jmp     L9185

L9BFE:  rts

L9BFF:  .byte   0
L9C00:  .byte   0
L9C01:  jsr     L9C1A
        bcc     L9C19
        lda     #$04
        sta     L9937
        jsr     L9BBF
        beq     L9C13
        jmp     LA39F

L9C13:  lda     #$03
        sta     L9937
        sec
L9C19:  rts

L9C1A:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        beq     L9C2B
        jsr     LA49B
        jmp     L9C1A

L9C2B:  lda     #$00
        sta     L9CD8
        sta     L9CD9
L9C33:  ldy     #$C4
        lda     #$87
        ldx     #$97
        jsr     L4021
        beq     L9C48
        cmp     #$46
        beq     L9C54
        jsr     LA497
        jmp     L9C33

L9C48:  lda     L978F
        sta     L9CD8
        lda     L9790
        sta     L9CD9
L9C54:  lda     $1FC0
        sta     L9CD6
        ldy     #$01
L9C5C:  iny
        cpy     $1FC0
        bcs     L9CCC
        lda     $1FC0,y
        cmp     #$2F
        bne     L9C5C
        tya
        sta     $1FC0
        sta     L9CD7
L9C70:  ldy     #$C4
        lda     #$87
        ldx     #$97
        jsr     L4021
        beq     L9C95
        pha
        lda     L9CD6
        sta     $1FC0
        pla
        jsr     LA497
        jmp     L9C70

        lda     L9CD7
        sta     $1FC0
        jmp     L9C70

        jmp     LA39F

L9C95:  lda     L978C
        sec
        sbc     L978F
        sta     L9CD4
        lda     L978D
        sbc     L9790
        sta     L9CD5
        lda     L9CD4
        clc
        adc     L9CD8
        sta     L9CD4
        lda     L9CD5
        adc     L9CD9
        sta     L9CD5
        lda     L9CD4
        cmp     L977C
        lda     L9CD5
        sbc     L977D
        bcs     L9CCC
        sec
        bcs     L9CCD
L9CCC:  clc
L9CCD:  lda     L9CD6
        sta     $1FC0
        rts

L9CD4:  .byte   0
L9CD5:  .byte   0
L9CD6:  .byte   0
L9CD7:  .byte   0
L9CD8:  .byte   0
L9CD9:  .byte   0
L9CDA:  jsr     LA2F1
        lda     #$00
        sta     L9E17
        sta     L9E18
        sta     L97A1
        sta     L97A2
        sta     L97A3
        sta     L97A6
        sta     L97A7
        sta     L97A8
        jsr     L9D62
        jsr     L9D74
        jsr     L9D81
        beq     L9D09
        lda     #$FF
        sta     L9E17
        bne     L9D0C
L9D09:  jsr     L9D9C
L9D0C:  jsr     L9DA9
        bit     L9E17
        bpl     L9D28
        jsr     L9E0D
L9D17:  jsr     L9D81
        bne     L9D17
        jsr     L9D9C
        ldy     #$CE
        lda     #$A4
        ldx     #$97
        jsr     L4021
L9D28:  bit     L9E18
        bmi     L9D51
        jsr     L9DE8
        bit     L9E17
        bpl     L9D0C
        jsr     L9E03
        jsr     L9D62
        jsr     L9D74
        ldy     #$CE
        lda     #$9F
        ldx     #$97
        jsr     L4021
        beq     L9D0C
        lda     #$FF
        sta     L9E18
        jmp     L9D0C

L9D51:  jsr     L9E03
        bit     L9E17
        bmi     L9D5C
        jsr     L9E0D
L9D5C:  jsr     LA46D
        jmp     LA479

L9D62:  ldy     #$C8
        lda     #$3E
        ldx     #$97
        jsr     L4021
        beq     L9D73
        jsr     LA49B
        jmp     L9D62

L9D73:  rts

L9D74:  lda     L9743
        sta     L974B
        sta     L9738
        sta     L97A0
        rts

L9D81:  ldy     #$C8
        lda     #$44
        ldx     #$97
        jsr     L4021
        beq     L9D9B
        cmp     #$45
        beq     L9D96
        jsr     LA497
        jmp     L9D81

L9D96:  jsr     LA497
        lda     #$45
L9D9B:  rts

L9D9C:  lda     L9749
        sta     L9753
        sta     L973A
        sta     L97A5
        rts

L9DA9:  lda     #$C0
        sta     L974E
        lda     #$0A
        sta     L974F
L9DB3:  ldy     #$CA
        lda     #$4A
        ldx     #$97
        jsr     L4021
        beq     L9DC8
        cmp     #$4C
        beq     L9DD9
        jsr     LA49B
        jmp     L9DB3

L9DC8:  lda     L9750
        sta     L9756
        lda     L9751
        sta     L9757
        ora     L9750
        bne     L9DDE
L9DD9:  lda     #$FF
        sta     L9E18
L9DDE:  ldy     #$CF
        lda     #$9F
        ldx     #$97
        jsr     L4021
        rts

L9DE8:  ldy     #$CB
        lda     #$52
        ldx     #$97
        jsr     L4021
        beq     L9DF9
        jsr     LA497
        jmp     L9DE8

L9DF9:  ldy     #$CF
        lda     #$A4
        ldx     #$97
        jsr     L4021
        rts

L9E03:  ldy     #$CC
        lda     #$39
        ldx     #$97
        jsr     L4021
        rts

L9E0D:  ldy     #$CC
        lda     #$37
        ldx     #$97
        jsr     L4021
        rts

L9E17:  .byte   0
L9E18:  .byte   0
L9E19:  ldx     #$07
L9E1B:  lda     L9774,x
        sta     L975A,x
        dex
        cpx     #$03
        bne     L9E1B
L9E26:  ldy     #$C0
        lda     #$5A
        ldx     #$97
        jsr     L4021
        beq     L9E6F
        cmp     #$47
        bne     L9E69
        bit     L918D
        bmi     L9E60
        lda     #$03
        sta     L9937
        ldy     #$01
        lda     #$37
        ldx     #$99
        jsr     LA500
        pha
        lda     #$02
        sta     L9937
        pla
        cmp     #$02
        beq     L9E60
        cmp     #$03
        beq     L9E71
        cmp     #$04
        bne     L9E66
        lda     #$80
        sta     L918D
L9E60:  jsr     LA426
        jmp     L9E6F

L9E66:  jmp     LA39F

L9E69:  jsr     LA497
        jmp     L9E26

L9E6F:  clc
        rts

L9E71:  sec
        rts

L9E73:  .byte   $94,$9F,$E3,$97,$2E,$A0
L9E79:  .byte   0
L9E7A:  .byte   0
L9E7B:  .byte   0
        .byte   $20
        .byte   $02
L9E7E:  sta     L9E79
        lda     #$B1
        sta     L9183
        lda     #$9E
        sta     L9183+1
        lda     #$A3
        sta     L917D
        lda     #$9E
        sta     L917D+1
        jsr     LA044
        lda     #$D3
        sta     L9180
        lda     #$9E
        sta     L9180+1
        rts

        sta     L9E7A
        stx     L9E7B
        lda     #$01
        sta     L9E79
        jmp     LA044

        lda     #$02
        sta     L9E79
        jsr     LA044
        beq     L9EBE
        jmp     LA39F

L9EBE:  rts

L9EBF:  ldy     #$05
L9EC1:  lda     L9E73,y
        sta     L97DD,y
        dey
        bpl     L9EC1
        lda     #$00
        sta     LA425
        sta     L918D
        rts

        lda     #$05
        sta     L9E79
        jmp     LA044

L9EDB:  lda     #$03
        sta     L9E79
        jsr     LA379
L9EE3:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        beq     L9EF4
        jsr     LA49B
        jmp     L9EE3

L9EF4:  lda     L977B
        sta     L9F1D
        cmp     #$0D
        beq     L9F02
        lda     #$00
        beq     L9F04
L9F02:  lda     #$FF
L9F04:  sta     L9F1C
        beq     L9F1E
        jsr     L98D8
        lda     L9F1D
        cmp     #$0D
        bne     L9F18
        lda     #$FF
        sta     L9F1D
L9F18:  jmp     L9F1E

        rts

L9F1C:  .byte   0
L9F1D:  .byte   0
L9F1E:  bit     $E05C
        bmi     L9F26
        jsr     LA3EF
L9F26:  jsr     LA2F1
L9F29:  ldy     #$C1
        lda     #$3B
        ldx     #$97
        jsr     L4021
        beq     L9F8D
        cmp     #$4E
        bne     L9F8E
        bit     L918D
        bmi     L9F62
        lda     #$04
        sta     L9E79
        jsr     LA044
        pha
        lda     #$03
        sta     L9E79
        pla
        cmp     #$03
        beq     L9F8D
        cmp     #$02
        beq     L9F62
        cmp     #$04
        bne     L9F5F
        lda     #$80
        sta     L918D
        bne     L9F62
L9F5F:  jmp     LA39F

L9F62:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        lda     L9777
        and     #$80
        bne     L9F8D
        lda     #$C3
        sta     L9777
        lda     #$07
        sta     L9774
        ldy     #$C3
        lda     #$74
        ldx     #$97
        jsr     L4021
        lda     #$0A
        sta     L9774
        jmp     L9F29

L9F8D:  rts

L9F8E:  jsr     LA49B
        jmp     L9F29

        jsr     LA3D1
        beq     L9F9C
        jmp     LA39F

L9F9C:  jsr     LA2FD
        bit     $E05C
        bmi     L9FA7
        jsr     LA3EF
L9FA7:  jsr     LA2F1
L9FAA:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        beq     L9FBB
        jsr     LA49B
        jmp     L9FAA

L9FBB:  lda     L977B
        cmp     #$0D
        beq     LA022
L9FC2:  ldy     #$C1
        lda     #$3B
        ldx     #$97
        jsr     L4021
        beq     LA022
        cmp     #$4E
        bne     LA01C
        bit     L918D
        bmi     LA001
        lda     #$04
        sta     L9E79
        ldy     #$02
        lda     #$79
        ldx     #$9E
        jsr     LA500
        pha
        lda     #$03
        sta     L9E79
        pla
        cmp     #$03
        beq     LA022
        cmp     #$02
L9FF1:  beq     LA001
        cmp     #$04
        bne     L9FFE
        lda     #$80
        sta     L918D
        bne     LA001
L9FFE:  jmp     LA39F

LA001:  lda     #$C3
        sta     L9777
        lda     #$07
        sta     L9774
        ldy     #$C3
        lda     #$74
        ldx     #$97
        jsr     L4021
        lda     #$0A
        sta     L9774
        jmp     L9FC2

LA01C:  jsr     LA49B
        jmp     L9FC2

LA022:  jmp     LA322

        jsr     LA322
        lda     #$FF
        sta     L9923
        rts

LA02E:  ldy     #$C1
        lda     #$3B
        ldx     #$97
        jsr     L4021
        beq     LA043
        cmp     #$4E
        beq     LA043
        jsr     LA49B
        jmp     LA02E

LA043:  rts

LA044:  ldy     #$02
        lda     #$79
        ldx     #$9E
        jsr     LA500
        rts

LA04E:  .byte   $70,$A1,$E3,$97,$E3,$97
LA054:  .byte   0
LA055:  .byte   0
LA056:  .byte   0
        .byte   $20
        .byte   $02
LA059:  lda     #$00
        sta     LA054
        bit     L918B
        bpl     LA085
        lda     #$D1
        sta     L9183
        lda     #$A0
        sta     L9183+1
        lda     #$B5
        sta     L917D
        lda     #$A0
        sta     L917D+1
        jsr     LA10A
        lda     #$F8
        sta     L9180
        lda     #$A0
        sta     L9180+1
        rts

LA085:  lda     #$C3
        sta     L9183
        lda     #$A0
        sta     L9183+1
        lda     #$A7
        sta     L917D
        lda     #$A0
        sta     L917D+1
        jsr     LA100
        lda     #$F0
        sta     L9180
        lda     #$A0
        sta     L9180+1
        rts

        sta     LA055
        stx     LA056
        lda     #$01
        sta     LA054
        jmp     LA100

        sta     LA055
        stx     LA056
        lda     #$01
        sta     LA054
        jmp     LA10A

        lda     #$02
        sta     LA054
        jsr     LA100
        beq     LA0D0
        jmp     LA39F

LA0D0:  rts

        lda     #$02
        sta     LA054
        jsr     LA10A
        beq     LA0DE
        jmp     LA39F

LA0DE:  rts

LA0DF:  lda     #$00
        sta     LA425
        ldy     #$05
LA0E6:  lda     LA04E,y
        sta     L97DD,y
        dey
        bpl     LA0E6
        rts

        lda     #$04
        sta     LA054
        jmp     LA100

        lda     #$04
        sta     LA054
        jmp     LA10A

LA100:  ldy     #$07
        lda     #$54
        ldx     #$A0
        jsr     LA500
        rts

LA10A:  ldy     #$08
        lda     #$54
        ldx     #$A0
        jsr     LA500
        rts

LA114:  lda     #$03
        sta     LA054
        jsr     LA379
        ldx     $1FC0
        ldy     L9B32
        dey
LA123:  iny
        inx
        lda     $0220,y
        sta     $1FC0,x
        cpy     $0220
        bne     LA123
        stx     $1FC0
LA133:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        beq     LA144
        jsr     LA49B
        jmp     LA133

LA144:  lda     L977B
        sta     LA169
        cmp     #$0F
        beq     LA156
        cmp     #$0D
        beq     LA156
        lda     #$00
        beq     LA158
LA156:  lda     #$FF
LA158:  sta     LA168
        beq     LA16A
        jsr     L98D8
        lda     LA169
        cmp     #$0F
        bne     LA16A
        rts

LA168:  .byte   0
LA169:  .byte   0
LA16A:  jsr     LA173
        jmp     LA2FD

        jsr     LA2FD
LA173:  jsr     LA1C3
        jsr     LA2F1
LA179:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        beq     LA18A
        jsr     LA49B
        jmp     LA179

LA18A:  lda     L977B
        cmp     #$0F
        beq     LA1C0
        cmp     #$0D
        beq     LA1C0
        bit     L918B
        bpl     LA19E
        lda     #$C3
        bne     LA1A0
LA19E:  lda     #$21
LA1A0:  sta     L9777
LA1A3:  lda     #$07
        sta     L9774
        ldy     #$C3
        lda     #$74
        ldx     #$97
        jsr     L4021
        pha
        lda     #$0A
        sta     L9774
        pla
        beq     LA1C0
        jsr     LA49B
        jmp     LA1A3

LA1C0:  jmp     LA322

LA1C3:  lda     LA2ED
        sec
        sbc     #$01
        sta     LA055
        lda     LA2EE
        sbc     #$00
        sta     LA056
        bit     L918B
        bpl     LA1DC
        jmp     LA10A

LA1DC:  jmp     LA100

LA1DF:  .byte   0
        sbc     $EFA2
        .byte   $A2
LA1E4:  lda     #$00
        sta     LA1DF
        lda     #$20
        sta     L9183
        lda     #$A2
        sta     L9183+1
        lda     #$11
        sta     L917D
        lda     #$A2
        sta     L917D+1
        ldy     #$0B
        lda     #$DF
        ldx     #$A1
        jsr     LA500
        lda     #$33
        sta     L9180
        lda     #$A2
        sta     L9180+1
        rts

        lda     #$01
        sta     LA1DF
        ldy     #$0B
        lda     #$DF
        ldx     #$A1
        jsr     LA500
LA21F:  rts

        lda     #$02
        sta     LA1DF
        ldy     #$0B
        lda     #$DF
        ldx     #$A1
        jsr     LA500
        beq     LA21F
        jmp     LA39F

        lda     #$03
        sta     LA1DF
        ldy     #$0B
        lda     #$DF
        ldx     #$A1
        jsr     LA500
LA241:  rts

LA242:  .byte   $AE,$A2,$E3,$97,$E3,$97
LA248:  lda     #$00
        sta     LA425
        ldy     #$05
LA24F:  lda     LA242,y
        sta     L97DD,y
        dey
        bpl     LA24F
        lda     #$00
        sta     LA2ED
        sta     LA2EE
        sta     LA2EF
        sta     LA2F0
        ldy     #$17
        lda     #$00
LA26A:  sta     $BF58,y
        dey
        bpl     LA26A
        rts

LA271:  jsr     LA379
LA274:  ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        beq     LA285
        jsr     LA49B
        jmp     LA274

LA285:  lda     L977B
        sta     LA2AA
        cmp     #$0F
        beq     LA297
        cmp     #$0D
        beq     LA297
        lda     #$00
        beq     LA299
LA297:  lda     #$FF
LA299:  sta     LA2A9
        beq     LA2AB
        jsr     L98D8
        lda     LA2AA
        cmp     #$0F
        bne     LA2AB
        rts

LA2A9:  .byte   0
LA2AA:  .byte   0
LA2AB:  jmp     LA2AE

LA2AE:  bit     L9189
        bvc     LA2D4
        jsr     LA2FD
        ldy     #$C4
        lda     #$74
        ldx     #$97
        jsr     L4021
        bne     LA2D4
        lda     LA2EF
        clc
        adc     L977C
        sta     LA2EF
        lda     LA2F0
        adc     L977D
        sta     LA2F0
LA2D4:  inc     LA2ED
        bne     LA2DC
        inc     LA2EE
LA2DC:  bit     L9189
        bvc     LA2E4
        jsr     LA322
LA2E4:  lda     LA2ED
        ldx     LA2EE
        jmp     L917C

LA2ED:  .byte   0
LA2EE:  .byte   0
LA2EF:  .byte   0
LA2F0:  .byte   0
LA2F1:  lda     LA2ED
        bne     LA2F9
        dec     LA2EE
LA2F9:  dec     LA2ED
        rts

LA2FD:  lda     L97AD
        bne     LA303
        rts

LA303:  ldx     #$00
        ldy     $0220
        lda     #$2F
        sta     $0221,y
        iny
LA30E:  cpx     L97AD
        bcs     LA31E
        lda     L97AE,x
        sta     $0221,y
        inx
        iny
        jmp     LA30E

LA31E:  sty     $0220
        rts

LA322:  ldx     $0220
        bne     LA328
        rts

LA328:  lda     $0220,x
        cmp     #$2F
        beq     LA336
        dex
        bne     LA328
        stx     $0220
        rts

LA336:  dex
        stx     $0220
        rts

LA33B:  lda     L97AD
        bne     LA341
        rts

LA341:  ldx     #$00
        ldy     $1FC0
        lda     #$2F
        sta     $1FC1,y
        iny
LA34C:  cpx     L97AD
        bcs     LA35C
        lda     L97AE,x
        sta     $1FC1,y
        inx
        iny
        jmp     LA34C

LA35C:  sty     $1FC0
        rts

LA360:  ldx     $1FC0
        bne     LA366
        rts

LA366:  lda     $1FC0,x
        cmp     #$2F
        beq     LA374
        dex
        bne     LA366
        stx     $1FC0
        rts

LA374:  dex
        stx     $1FC0
        rts

LA379:  ldy     #$00
        sty     L9B32
        dey
LA37F:  iny
        lda     $E00A,y
        cmp     #$2F
        bne     LA38A
        sty     L9B32
LA38A:  sta     $0220,y
        cpy     $E00A
        bne     LA37F
        ldy     $DFC9
LA395:  lda     $DFC9,y
        sta     $1FC0,y
        dey
        bpl     LA395
        rts

LA39F:  jsr     L917F
        jmp     LA3A7

        ora     (L0000,x)
LA3A7:  ldy     #$CC
        lda     #$A5
        ldx     #$A3
        jsr     L4021
        lda     $DF20
        beq     LA3CA
        sta     $D212
        ldy     #$3C
        lda     #$12
        ldx     #$D2
        jsr     L4003
        ldy     #$04
        lda     #$15
        ldx     #$D2
        jsr     L4003
LA3CA:  ldx     L9188
        txs
        lda     #$FF
        rts

LA3D1:  ldy     #$2A
        lda     #$08
        ldx     #$D2
        jsr     L4003
        lda     $D208
        cmp     #$03
        bne     LA3EC
        lda     $D209
        cmp     #$1B
        bne     LA3EC
        lda     #$FF
        bne     LA3EE
LA3EC:  lda     #$00
LA3EE:  rts

LA3EF:  lda     LA2ED
        sec
        sbc     #$01
        sta     L9E7A
        lda     LA2EE
        sbc     #$00
        sta     L9E7B
        ldy     #$02
        lda     #$79
        ldx     #$9E
        jsr     LA500
        rts

LA40A:  lda     LA2ED
        sec
        sbc     #$01
        sta     L9938
        lda     LA2EE
        sbc     #$00
        sta     L9939
        ldy     #$01
        lda     #$37
        ldx     #$99
        jsr     LA500
        rts

LA425:  .byte   0
LA426:  jsr     LA46D
        lda     #$C3
        sta     L978A
        jsr     LA479
        lda     L9778
        cmp     #$0F
        beq     LA46C
        ldy     #$C8
        lda     #$44
        ldx     #$97
        jsr     L4021
        beq     LA449
        jsr     LA497
        jmp     LA426

LA449:  lda     L9749
        sta     L979B
        sta     L973A
LA452:  ldy     #$D0
        lda     #$9A
        ldx     #$97
        jsr     L4021
        beq     LA463
        jsr     LA497
        jmp     LA452

LA463:  ldy     #$CC
        lda     #$39
        ldx     #$97
        jsr     L4021
LA46C:  rts

LA46D:  ldx     #$0A
LA46F:  lda     L9777,x
        sta     L978A,x
        dex
        bpl     LA46F
        rts

LA479:  lda     #$07
        sta     L9787
        ldy     #$C3
        lda     #$87
        ldx     #$97
        jsr     L4021
        pha
        lda     #$0A
        sta     L9787
        pla
        beq     LA496
        jsr     LA497
        jmp     LA479

LA496:  rts

LA497:  ldx     #$80
        bne     LA49D
LA49B:  ldx     #$00
LA49D:  stx     LA4C5
        cmp     #$45
        beq     LA4AE
        cmp     #$44
        beq     LA4AE
        jsr     L4030
        bne     LA4C2
        rts

LA4AE:  bit     LA4C5
        bpl     LA4B8
        lda     #$FD
        jmp     LA4BA

LA4B8:  lda     #$FC
LA4BA:  jsr     L4030
        bne     LA4C2
        jmp     LA4C6

LA4C2:  jmp     LA39F

LA4C5:  .byte   0
LA4C6:  ldy     #$C5
        lda     #$A9
        ldx     #$97
        jsr     L4021
        rts

        .res    48, 0
LA500:  jmp     LA520

LA503:  .addr   $A89C,$A957,$ACD4,$AE34,$A898,$A898,$AF28,$B02C,$B14A,$B268,$AAE1,$ABFA,$B325
LA51D:  .byte   $00
LA51E:  .byte   $00,$00
LA520:  sta     LA51D
        stx     LA51E
        tya
        asl     a
        tax
        lda     LA503,x
        sta     LA565
        lda     LA503+1,x
        sta     LA565+1
        lda     #$00
        sta     $D8EB
        sta     $D8EC
        sta     $D8F0
        sta     $D8F1
        sta     $D8F2
        sta     $D8E8
        sta     $D8F5
        sta     $D8ED
        sta     LB3E6
        lda     #$14
        sta     $D8E9
        lda     #$98
        sta     LA89A
        lda     #$A8
        sta     LA89A+1
        jsr     LB403

        LA565 := *+1
        jmp     $0000           ; self-modified
LA567:  lda     $D8E8
        beq     LA579
        dec     $D8E9
        bne     LA579
        jsr     LB8F5
        lda     #$14
        sta     $D8E9
LA579:  A2D_RELAY_CALL A2D_GET_INPUT, $D208
        lda     $D208
        cmp     #$01
        bne     LA58C
        jmp     LA5EE

LA58C:  cmp     #$03
        bne     LA593
        jmp     LA6FD

LA593:  lda     $D8E8
        beq     LA567
        A2D_RELAY_CALL A2D_QUERY_TARGET, $D209
        lda     $D20D
        bne     LA5A9
        jmp     LA567

LA5A9:  lda     $D20E
        cmp     $D57D
        beq     LA5B4
        jmp     LA567

LA5B4:  lda     $D57D
        jsr     LB7B9
        lda     $D57D
        sta     $D208
        A2D_RELAY_CALL A2D_MAP_COORDS, $D208
        A2D_RELAY_CALL A2D_SET_POS, $D20D
LA5D2:  A2D_RELAY_CALL A2D_TEST_BOX, $D6AB
        cmp     #$80
        bne     LA5E5
        jsr     LB3D8
        jmp     LA5E8

LA5E5:  jsr     LB3CA
LA5E8:  jsr     LBEB1
        jmp     LA567

LA5EE:  A2D_RELAY_CALL A2D_QUERY_TARGET, $D209
        lda     $D20D
        bne     LA5FF
        lda     #$FF
        rts

LA5FF:  cmp     #$02
        bne     LA606
        jmp     LA609

LA606:  lda     #$FF
        rts

LA609:  lda     $D20E
        cmp     $D57D
        beq     LA614
        lda     #$FF
        rts

LA614:  lda     $D57D
        jsr     LB7B9
        lda     $D57D
        sta     $D208
        A2D_RELAY_CALL A2D_MAP_COORDS, $D208
        A2D_RELAY_CALL A2D_SET_POS, $D20D
        bit     $D8E7
        bvc     LA63A
        jmp     LA65E

LA63A:  A2D_RELAY_CALL A2D_TEST_BOX, $AE20
        cmp     #$80
        beq     LA64A
        jmp     LA6C1

LA64A:  jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE20
        jsr     LB7CF
        bmi     LA65D
        lda     #$00
LA65D:  rts

LA65E:  A2D_RELAY_CALL A2D_TEST_BOX, $AE28
        cmp     #$80
        bne     LA67F
        jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE28
        jsr     LB7D9
        bmi     LA67E
        lda     #$02
LA67E:  rts

LA67F:  A2D_RELAY_CALL A2D_TEST_BOX, $AE30
        cmp     #$80
        bne     LA6A0
        jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE30
        jsr     LB7DE
        bmi     LA69F
        lda     #$03
LA69F:  rts

LA6A0:  A2D_RELAY_CALL A2D_TEST_BOX, $AE38
        cmp     #$80
        bne     LA6C1
        jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE38
        jsr     LB7E3
        bmi     LA6C0
        lda     #$04
LA6C0:  rts

LA6C1:  bit     $D8E7
        bpl     LA6C9
        lda     #$FF
        rts

LA6C9:  A2D_RELAY_CALL A2D_TEST_BOX, $AE10
        cmp     #$80
        beq     LA6D9
        jmp     LA6ED

LA6D9:  jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE10
        jsr     LB7D4
        bmi     LA6EC
        lda     #$01
LA6EC:  rts

LA6ED:  bit     $D8E8
        bmi     LA6F7
        lda     #$FF
        jmp     LA899

LA6F7:  jsr     LB9B8
        lda     #$FF
        rts

LA6FD:  lda     $D20A
        cmp     #$02
        bne     LA71A
        lda     $D209
        and     #$7F
        cmp     #$08
        bne     LA710
        jmp     LA815

LA710:  cmp     #$15
        bne     LA717
        jmp     LA820

LA717:  lda     #$FF
        rts

LA71A:  lda     $D209
        and     #$7F
        cmp     #$08
        bne     LA72E
        bit     $D8ED
        bpl     LA72B
        jmp     L0CB8

LA72B:  jmp     LA82B

LA72E:  cmp     #$15
        bne     LA73D
        bit     $D8ED
        bpl     LA73A
        jmp     L0CD7

LA73A:  jmp     LA83E

LA73D:  cmp     #$0D
        bne     LA749
        bit     $D8E7
        bvs     LA717
        jmp     LA851

LA749:  cmp     #$1B
        bne     LA755
        bit     $D8E7
        bmi     LA717
        jmp     LA86F

LA755:  cmp     #$7F
        bne     LA75C
        jmp     LA88D

LA75C:  cmp     #$0B
        bne     LA76B
        bit     $D8ED
        bmi     LA768
        jmp     LA717

LA768:  jmp     L0D14

LA76B:  cmp     #$0A
        bne     LA77A
        bit     $D8ED
        bmi     LA777
        jmp     LA717

LA777:  jmp     L0CF9

LA77A:  bit     $D8E7
        bvc     LA79B
        cmp     #$59
        beq     LA7E8
        cmp     #$79
        beq     LA7E8
        cmp     #$4E
        beq     LA7F7
        cmp     #$6E
        beq     LA7F7
        cmp     #$41
        beq     LA806
        cmp     #$61
        beq     LA806
        cmp     #$0D
        beq     LA7E8
LA79B:  bit     $D8F5
        bmi     LA7C8
        cmp     #$2E
        beq     LA7D8
        cmp     #$30
        bcs     LA7AB
        jmp     LA717

LA7AB:  cmp     #$7B
        bcc     LA7B2
        jmp     LA717

LA7B2:  cmp     #$3A
        bcc     LA7D8
        cmp     #$41
        bcs     LA7BD
        jmp     LA717

LA7BD:  cmp     #$5B
        bcc     LA7DD
        cmp     #$61
        bcs     LA7DD
        jmp     LA717

LA7C8:  cmp     #$20
        bcs     LA7CF
        jmp     LA717

LA7CF:  cmp     #$7E
        beq     LA7DD
        bcc     LA7DD
        jmp     LA717

LA7D8:  ldx     $D443
        beq     LA7E5
LA7DD:  ldx     $D8E8
        beq     LA7E5
        jsr     LBB0B
LA7E5:  lda     #$FF
        rts

LA7E8:  jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE28
        lda     #$02
        rts

LA7F7:  jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE30
        lda     #$03
        rts

LA806:  jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE38
        lda     #$04
        rts

LA815:  lda     $D8E8
        beq     LA81D
        jsr     LBC5E
LA81D:  lda     #$FF
        rts

LA820:  lda     $D8E8
        beq     LA828
        jsr     LBCC9
LA828:  lda     #$FF
        rts

LA82B:  lda     $D8E8
        beq     LA83B
        bit     $D8ED
        bpl     LA838
        jmp     L0CD7

LA838:  jsr     LBBA4
LA83B:  lda     #$FF
        rts

LA83E:  lda     $D8E8
        beq     LA84E
        bit     $D8ED
        bpl     LA84B
        jmp     L0CB8

LA84B:  jsr     LBC03
LA84E:  lda     #$FF
        rts

LA851:  lda     $D57D
        jsr     LB7B9
        jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE20
        A2D_RELAY_CALL A2D_FILL_RECT, $AE20
        lda     #$00
        rts

LA86F:  lda     $D57D
        jsr     LB7B9
        jsr     LB43B
        A2D_RELAY_CALL A2D_FILL_RECT, $AE10
        A2D_RELAY_CALL A2D_FILL_RECT, $AE10
        lda     #$01
        rts

LA88D:  lda     $D8E8
        beq     LA895
        jsr     LBB63
LA895:  lda     #$FF
        rts

        rts

        LA89A := *+1
LA899:  jmp     $0000

LA89C:  A2D_RELAY_CALL A2D_CREATE_WINDOW, $D62B
        lda     $D62B
        jsr     LB7B9
        jsr     LB43B
        A2D_RELAY_CALL A2D_DRAW_RECT, $AEDD
        A2D_RELAY_CALL A2D_DRAW_RECT, $AEE5
        lda     #$ED
        ldx     #$AE
        jsr     LB723
        lda     #$FE
        ldx     #$AE
        ldy     #$81
        jsr     LB590
        lda     #$22
        ldx     #$AF
        ldy     #$82
        jsr     LB590
        lda     #$46
        ldx     #$AF
        ldy     #$83
        jsr     LB590
        lda     #$5A
        ldx     #$AF
        ldy     #$05
        jsr     LB590
        lda     #$93
        ldx     #$AF
        ldy     #$86
        jsr     LB590
        lda     #$B4
        ldx     #$AF
        ldy     #$07
        jsr     LB590
        lda     #$EE
        ldx     #$AF
        ldy     #$09
        jsr     LB590
        lda     #$36
        sta     $D6C3
        lda     #$01
        sta     $D6C4
        lda     #$00
        ldx     #$B0
        ldy     #$09
        jsr     LB590
        lda     #$28
        sta     $D6C3
        lda     #$00
        sta     $D6C4
LA923:  A2D_RELAY_CALL A2D_GET_INPUT, $D208
        lda     $D208
        cmp     #$01
        beq     LA947
        cmp     #$03
        bne     LA923
        lda     $D209
        and     #$7F
        cmp     #$1B
        beq     LA947
        cmp     #$0D
        bne     LA923
        jmp     LA947

LA947:  A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D62B
        jsr     LBEB1
        jsr     LB3CA
        rts

        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        cmp     #$01
        bne     LA965
        jmp     LA9B5

LA965:  cmp     #$02
        bne     LA96C
        jmp     LA9E6

LA96C:  cmp     #$03
        bne     LA973
        jmp     LAA6A

LA973:  cmp     #$04
        bne     LA97A
        jmp     LAA9C

LA97A:  cmp     #$05
        bne     LA981
        jmp     LAA5A

LA981:  lda     #$00
        sta     $D8E8
        jsr     LB53A
        lda     #$0C
        ldx     #$B0
        jsr     LB723
        lda     #$15
        ldx     #$B0
        ldy     #$01
        jsr     LB590
        lda     #$22
        ldx     #$B0
        ldy     #$02
        jsr     LB590
        lda     #$28
        ldx     #$B0
        ldy     #$03
        jsr     LB590
        lda     #$2D
        ldx     #$B0
        ldy     #$04
        jsr     LB590
        rts

LA9B5:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        A2D_RELAY_CALL A2D_SET_POS, $B0B6
        lda     #$01
        ldx     #$D9
        jsr     LB708
        lda     #$FB
        ldx     #$D8
        jsr     LB708
        rts

LA9E6:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        jsr     LBE8D
        jsr     LBE9A
        jsr     LB3BF
        ldy     #$03
        lda     (L0006),y
        tax
        iny
        lda     (L0006),y
        sta     $07
        stx     L0006
        jsr     LBE63
        A2D_RELAY_CALL A2D_SET_POS, $AE7E
        lda     #$02
        ldx     #$D4
        jsr     LB708
        jsr     LB3BF
        ldy     #$05
        lda     (L0006),y
        tax
        iny
        lda     (L0006),y
        sta     $07
        stx     L0006
        jsr     LBE78
        A2D_RELAY_CALL A2D_SET_POS, $AE82
        lda     #$43
        ldx     #$D4
        LAA48 := *+2            ; ???
        jsr     $B708
        ldy     #$0E
        lda     #$BA
        ldx     #$B0
        jsr     A2D_RELAY
        lda     #$01
        ldx     #$D9
        jsr     LB708
        rts

LAA5A:  jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB403
        rts

LAA6A:  jsr     LAACE
        lda     $D57D
        jsr     LB7B9
        lda     #$47
        ldx     #$B0
        ldy     #$06
        jsr     LB590
        jsr     LB64E
LAA7F:  jsr     LA567
        bmi     LAA7F
        pha
        jsr     LB687
        A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        A2D_RELAY_CALL A2D_FILL_RECT, $AE76
        pla
        rts

LAA9C:  jsr     LAACE
        lda     $D57D
        jsr     LB7B9
        lda     #$80
        ldx     #$B0
        ldy     #$06
        jsr     LB590
        jsr     LB6AF
LAAB1:  jsr     LA567
        bmi     LAAB1
        pha
        jsr     LB6D0
        A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        A2D_RELAY_CALL A2D_FILL_RECT, $AE76
        pla
        rts

LAACE:  sta     ALTZPOFF
        sta     ROMIN2
        jsr     BELL1
        sta     ALTZPON
        lda     LCBANK1
        lda     LCBANK1
        rts

        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        cmp     #$01
        bne     LAAEF
        jmp     LAB38

LAAEF:  cmp     #$02
        bne     LAAF6
        jmp     LAB69

LAAF6:  cmp     #$03
        bne     LAAFD
        jmp     LABB8

LAAFD:  cmp     #$04
        bne     LAB04
        jmp     LABC8

LAB04:  lda     #$00
        sta     $D8E8
        jsr     LB53A
        lda     #$73
        ldx     #$B4
        jsr     LB723
        lda     #$15
        ldx     #$B0
        ldy     #$01
        jsr     LB590
        lda     #$22
        ldx     #$B0
        ldy     #$02
        jsr     LB590
        lda     #$28
        ldx     #$B0
        ldy     #$03
        jsr     LB590
        lda     #$2D
        ldx     #$B0
        ldy     #$04
        jsr     LB590
        rts

LAB38:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        A2D_RELAY_CALL A2D_SET_POS, $B0B6
        lda     #$01
        ldx     #$D9
        jsr     LB708
        lda     #$FB
        ldx     #$D8
        jsr     LB708
        rts

LAB69:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        jsr     LBE8D
        jsr     LB3BF
        ldy     #$03
        lda     (L0006),y
        tax
        iny
        lda     (L0006),y
        sta     $07
        stx     L0006
        jsr     LBE63
        A2D_RELAY_CALL A2D_SET_POS, $AE7E
        lda     #$02
        ldx     #$D4
        jsr     LB708
        A2D_RELAY_CALL A2D_SET_POS, $B0BA
        lda     #$01
        ldx     #$D9
        jsr     LB708
        rts

LABB8:  jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB403
        rts

LABC8:  jsr     LAACE
        lda     $D57D
        jsr     LB7B9
        lda     #$80
        ldx     #$B4
        ldy     #$06
        jsr     LB590
        jsr     LB6E6
LABDD:  jsr     LA567
        bmi     LABDD
        pha
        jsr     LB6FB
        A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        A2D_RELAY_CALL A2D_FILL_RECT, $AE76
        pla
        rts

        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        cmp     #$01
        bne     LAC08
        jmp     LAC3D

LAC08:  cmp     #$02
        bne     LAC0F
        jmp     LACAE

LAC0F:  cmp     #$03
        bne     LAC16
        jmp     LAC9E

LAC16:  jsr     LB53A
        lda     #$3A
        ldx     #$B4
        jsr     LB723
        lda     #$47
        ldx     #$B4
        ldy     #$01
        jsr     LB590
        ldy     #$01
        jsr     LB01F
        lda     #$57
        ldx     #$B4
        ldy     #$02
        jsr     LB590
        ldy     #$02
        jsr     LB01F
        rts

LAC3D:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        tax
        iny
        lda     (L0006),y
        sta     $07
        stx     L0006
        ldy     #$00
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        lda     #$A5
        sta     $D6C3
        ldy     #$01
        lda     #$01
        ldx     #$D9
        jsr     LB590
        jsr     LB3BF
        ldy     #$03
        lda     (L0006),y
        tax
        iny
        lda     (L0006),y
        sta     $07
        stx     L0006
        ldy     #$00
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDDF
        lda     #$A5
        sta     $D6C3
        ldy     #$02
        lda     #$01
        ldx     #$D9
        jsr     LB590
        rts

LAC9E:  jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB403
        rts

LACAE:  lda     $D57D
        jsr     LB7B9
        jsr     LB6E6
LACB7:  jsr     LA567
        bmi     LACB7
        A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        A2D_RELAY_CALL A2D_FILL_RECT, $AE6E
        jsr     LB6FB
        lda     #$00
        rts

        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        cmp     #$01
        bne     LACE2
        jmp     LAD2A

LACE2:  cmp     #$02
        bne     LACE9
        jmp     LADBB

LACE9:  cmp     #$03
        bne     LACF0
        jmp     LAD6C

LACF0:  cmp     #$04
        bne     LACF7
        jmp     LAE05

LACF7:  cmp     #$05
        bne     LACFE
        jmp     LADF5

LACFE:  sta     LAD1F
        lda     #$00
        sta     $D8E8
        jsr     LB53A
        lda     #$BE
        ldx     #$B0
        jsr     LB723
        lda     LAD1F
        beq     LAD20
        lda     #$DD
        ldx     #$B0
        ldy     #$04
        jsr     LB590
        rts

LAD1F:  .byte   0
LAD20:  lda     #$C9
        ldx     #$B0
        ldy     #$04
        jsr     LB590
        rts

LAD2A:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        lda     LAD1F
LAD46:  bne     LAD54
        A2D_RELAY_CALL A2D_SET_POS, $B16A
        jmp     LAD5D

LAD54:  A2D_RELAY_CALL A2D_SET_POS, $B172
LAD5D:  lda     #$01
        ldx     #$D9
        jsr     LB708
        lda     #$FB
        ldx     #$D8
        jsr     LB708
        rts

LAD6C:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        jsr     LBE8D
        jsr     LB3BF
        ldy     #$03
        lda     (L0006),y
        tax
        iny
        lda     (L0006),y
        sta     $07
        stx     L0006
        jsr     LBE63
        A2D_RELAY_CALL A2D_SET_POS, $AE7E
        lda     #$02
        ldx     #$D4
        jsr     LB708
        A2D_RELAY_CALL A2D_SET_POS, $B16E
        lda     #$01
        ldx     #$D9
        jsr     LB708
        rts

LADBB:  lda     $D57D
        jsr     LB7B9
        jsr     LB6AF
LADC4:  jsr     LA567
        bmi     LADC4
        bne     LADF4
        A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        A2D_RELAY_CALL A2D_FILL_RECT, $AE6E
        jsr     LB6D0
        ldy     #$02
        lda     #$0E
        ldx     #$B1
        jsr     LB590
        ldy     #$04
        lda     #$14
        ldx     #$B1
        jsr     LB590
        lda     #$00
LADF4:  rts

LADF5:  jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB403
        rts

LAE05:  lda     $D57D
        jsr     LB7B9
        lda     #$33
        ldx     #$B1
        ldy     #$06
        jsr     LB590
        jsr     LB64E
LAE17:  jsr     LA567
        bmi     LAE17
        pha
        jsr     LB687
        A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        A2D_RELAY_CALL A2D_FILL_RECT, $AE76
        pla
        rts

        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        cmp     #$80
        bne     LAE42
        jmp     LAE70

LAE42:  cmp     #$40
        bne     LAE49
        jmp     LAF16

LAE49:  lda     #$80
        sta     $D8E8
        jsr     LBD69
        lda     #$00
        jsr     LB509
        lda     $D57D
        jsr     LB7B9
        lda     #$76
        ldx     #$B1
        jsr     LB723
        jsr     LB43B
        A2D_RELAY_CALL A2D_DRAW_RECT, $D6AB
        rts

LAE70:  lda     #$80
        sta     $D8E8
        lda     #$00
        sta     $D8E7
        jsr     LBD75
        jsr     LB3BF
        ldy     #$01
        lda     (L0006),y
        sta     $08
        iny
        lda     (L0006),y
        sta     $09
        ldy     #$00
        lda     ($08),y
        tay
LAE90:  lda     ($08),y
        sta     $D402,y
        dey
        bpl     LAE90
        lda     $D57D
        jsr     LB7B9
        ldy     #$02
        lda     #$85
        ldx     #$B1
        jsr     LB590
        lda     #$37
        sta     $D6C3
        ldy     #$02
        lda     #$02
        ldx     #$D4
        jsr     LB590
        lda     #$28
        sta     $D6C3
        ldy     #$04
        lda     #$89
        ldx     #$B1
        jsr     LB590
        jsr     LB961
LAEC6:  jsr     LA567
        bmi     LAEC6
        bne     LAF16
        lda     $D443
        beq     LAEC6
        cmp     #$10
        bcc     LAEE1
LAED6:  lda     #$FB
        jsr     L4030
        jsr     LB961
        jmp     LAEC6

LAEE1:  lda     $D402
        clc
        adc     $D443
        clc
        adc     #$01
        cmp     #$41
        bcs     LAED6
        inc     $D402
        ldx     $D402
        lda     #$2F
        sta     $D402,x
        ldx     $D402
        ldy     #$00
LAEFF:  inx
        iny
        lda     $D443,y
        sta     $D402,x
        cpy     $D443
        bne     LAEFF
        stx     $D402
        ldy     #$02
        ldx     #$D4
        lda     #$00
        rts

LAF16:  jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB403
        lda     #$01
        rts

        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        bmi     LAF34
        jmp     LAFB9

LAF34:  lda     #$00
        sta     $D8E8
        lda     (L0006),y
        lsr     a
        lsr     a
        ror     a
        eor     #$80
        jsr     LB509
        lda     $D57D
        jsr     LB7B9
        lda     #$C6
        ldx     #$B1
        jsr     LB723
        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        and     #$7F
        lsr     a
        ror     a
        sta     LB01D
        ldy     #$01
        lda     #$D3
        ldx     #$B1
        jsr     LB590
        bit     LB01D
        bmi     LAF78
        ldy     #$02
        lda     #$D8
        ldx     #$B1
        jsr     LB590
        jmp     LAF81

LAF78:  ldy     #$02
        lda     #$09
        ldx     #$B2
        jsr     LB590
LAF81:  bit     LB01D
        bpl     LAF92
        ldy     #$03
        lda     #$19
        ldx     #$B2
        jsr     LB590
        jmp     LAF9B

LAF92:  ldy     #$03
        lda     #$DF
        ldx     #$B1
        jsr     LB590
LAF9B:  ldy     #$04
        lda     #$E4
        ldx     #$B1
        jsr     LB590
        ldy     #$05
        lda     #$F2
        ldx     #$B1
        jsr     LB590
        ldy     #$06
        lda     #$04
        ldx     #$B2
        jsr     LB590
        jmp     LBEB1

LAFB9:  lda     $D57D
        jsr     LB7B9
        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        sta     LB01E
        tay
        jsr     LB01F
        lda     #$A5
        sta     $D6C3
        jsr     LB3BF
        lda     LB01E
        cmp     #$02
        bne     LAFF0
        ldy     #$01
        lda     (L0006),y
        beq     LAFE9
        lda     #$A8
        ldx     #$AE
        jmp     LAFF8

LAFE9:  lda     #$AD
        ldx     #$AE
        jmp     LAFF8

LAFF0:  ldy     #$02
        lda     (L0006),y
        tax
        dey
        lda     (L0006),y
LAFF8:  ldy     LB01E
        jsr     LB590
        lda     LB01E
        cmp     #$06
        beq     LB006
        rts

LB006:  jsr     LA567
        bmi     LB006
        pha
        jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB3CA
        pla
        rts

LB01D:  .byte   0
LB01E:  .byte   0
LB01F:  lda     #$A0
        sta     $D6C3
        lda     #$2A
        ldx     #$B2
        jsr     LB590
        rts

        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        cmp     #$01
        bne     LB03A
        jmp     LB068

LB03A:  cmp     #$02
        bne     LB041
        jmp     LB0F1

LB041:  cmp     #$03
        bne     LB048
        jmp     LB0A2

LB048:  cmp     #$04
        bne     LB04F
        jmp     LB13A

LB04F:  lda     #$00
        sta     $D8E8
        jsr     LB53A
        lda     #$00
        ldx     #$B4
        jsr     LB723
        ldy     #$04
        lda     #$09
        ldx     #$B4
        jsr     LB590
        rts

LB068:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        A2D_RELAY_CALL A2D_SET_POS, $B231
        lda     #$01
        ldx     #$D9
        jsr     LB708
        A2D_RELAY_CALL A2D_SET_POS, $B239
        lda     #$FB
        ldx     #$D8
        jsr     LB708
        rts

LB0A2:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        jsr     LBE8D
        jsr     LB3BF
        ldy     #$03
        lda     (L0006),y
        tax
        iny
        lda     (L0006),y
        sta     $07
        stx     L0006
        jsr     LBE63
        A2D_RELAY_CALL A2D_SET_POS, $AE7E
        lda     #$02
        ldx     #$D4
        jsr     LB708
        A2D_RELAY_CALL A2D_SET_POS, $B241
        lda     #$01
        ldx     #$D9
        jsr     LB708
        rts

LB0F1:  lda     $D57D
        jsr     LB7B9
        jsr     LB6AF
LB0FA:  jsr     LA567
        bmi     LB0FA
        bne     LB139
        A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        A2D_RELAY_CALL A2D_FILL_RECT, $AE6E
        A2D_RELAY_CALL A2D_FILL_RECT, $AE20
        A2D_RELAY_CALL A2D_FILL_RECT, $AE10
        ldy     #$02
        lda     #$0E
        ldx     #$B1
        jsr     LB590
        ldy     #$04
        lda     #$1B
        ldx     #$B4
        jsr     LB590
        lda     #$00
LB139:  rts

LB13A:  jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB403
        rts

        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        cmp     #$01
        bne     LB158
        jmp     LB186

LB158:  cmp     #$02
        bne     LB15F
        jmp     LB20F

LB15F:  cmp     #$03
        bne     LB166
        jmp     LB1C0

LB166:  cmp     #$04
        bne     LB16D
        jmp     LB258

LB16D:  lda     #$00
        sta     $D8E8
        jsr     LB53A
        lda     #$C0
        ldx     #$B3
        jsr     LB723
        ldy     #$04
        lda     #$CB
        ldx     #$B3
        jsr     LB590
        rts

LB186:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        A2D_RELAY_CALL A2D_SET_POS, $B22D
        lda     #$01
        ldx     #$D9
        jsr     LB708
        A2D_RELAY_CALL A2D_SET_POS, $B235
        lda     #$FB
        ldx     #$D8
        jsr     LB708
        rts

LB1C0:  ldy     #$01
        lda     (L0006),y
        sta     $D909
        iny
        lda     (L0006),y
        sta     $D90A
        jsr     LBDC4
        jsr     LBDDF
        lda     $D57D
        jsr     LB7B9
        jsr     LBE8D
        jsr     LB3BF
        ldy     #$03
        lda     (L0006),y
        tax
        iny
        lda     (L0006),y
        sta     $07
        stx     L0006
        jsr     LBE63
        A2D_RELAY_CALL A2D_SET_POS, $AE7E
        lda     #$02
        ldx     #$D4
        jsr     LB708
        A2D_RELAY_CALL A2D_SET_POS, $B23D
        lda     #$01
        ldx     #$D9
        jsr     LB708
        rts

LB20F:  lda     $D57D
        jsr     LB7B9
        jsr     LB6AF
LB218:  jsr     LA567
        bmi     LB218
        bne     LB257
        A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        A2D_RELAY_CALL A2D_FILL_RECT, $AE6E
        A2D_RELAY_CALL A2D_FILL_RECT, $AE20
        A2D_RELAY_CALL A2D_FILL_RECT, $AE10
        ldy     #$02
        lda     #$0E
        ldx     #$B1
        jsr     LB590
        ldy     #$04
        lda     #$DF
        ldx     #$B3
        jsr     LB590
        lda     #$00
LB257:  rts

LB258:  jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB403
        rts

        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        cmp     #$80
        bne     LB276
        jmp     LB2ED

LB276:  cmp     #$40
        bne     LB27D
        jmp     LB313

LB27D:  jsr     LBD75
        jsr     LB3BF
        lda     #$80
        sta     $D8E8
        jsr     LBD69
        lda     #$00
        jsr     LB509
        lda     $D57D
        jsr     LB7B9
        lda     #$A0
        ldx     #$B1
        jsr     LB723
        jsr     LB43B
        A2D_RELAY_CALL A2D_DRAW_RECT, $D6AB
        ldy     #$02
        lda     #$B3
        ldx     #$B1
        jsr     LB590
        lda     #$55
        sta     $D6C3
        jsr     LB3BF
        ldy     #$01
        lda     (L0006),y
        sta     $08
        iny
        lda     (L0006),y
        sta     $09
        ldy     #$00
        lda     ($08),y
        tay
LB2CA:  lda     ($08),y
        sta     $D8D7,y
        dey
        bpl     LB2CA
        ldy     #$02
        lda     #$D7
        ldx     #$D8
        jsr     LB590
        ldy     #$04
        lda     #$BC
        ldx     #$B1
        jsr     LB590
        lda     #$00
        sta     $D443
        jsr     LB961
        rts

LB2ED:  lda     #$00
        sta     $D8E7
        lda     #$80
        sta     $D8E8
        lda     $D57D
        jsr     LB7B9
LB2FD:  jsr     LA567
        bmi     LB2FD
        bne     LB313
        lda     $D443
        beq     LB2FD
        jsr     LBCC9
        ldy     #$43
        ldx     #$D4
        lda     #$00
        rts

LB313:  jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB403
        lda     #$01
        rts

        A2D_RELAY_CALL A2D_HIDE_CURSOR
        jsr     LB55F
        lda     $D57D
        jsr     LB7B9
        lda     #$B3
        ldx     #$B4
        jsr     LB723
        A2D_RELAY_CALL A2D_SHOW_CURSOR
        jsr     LB3BF
        ldy     #$00
        lda     (L0006),y
        pha
        bmi     LB357
        tax
        lda     LB39C,x
        bne     LB361
LB357:  pla
        and     #$7F
        pha
        jsr     LB6E6
        jmp     LB364

LB361:  jsr     LB6AF
LB364:  pla
        pha
        asl     a
        asl     a
        tay
        lda     LB3A4,y
        tax
        lda     LB3A3,y
        ldy     #$03
        jsr     LB590
        pla
        asl     a
        asl     a
        tay
        lda     LB3A6,y
        tax
        lda     LB3A5,y
        ldy     #$04
        jsr     LB590
LB385:  jsr     LA567
        bmi     LB385
        pha
        jsr     LBEB1
        A2D_RELAY_CALL A2D_DESTROY_WINDOW, $D57D
        jsr     LB403
        pla
        rts

LB39C:  .byte   $80,$00,$00,$80,$00,$00,$80
LB3A3:  .byte   $BD
LB3A4:  .byte   $B4
LB3A5:  .byte   $B1
LB3A6:  .byte   $B4,$DC,$B4,$10,$B5,$DC,$B4,$10
        .byte   $B5,$30,$B5,$B1,$B4,$30,$B5,$B1
        .byte   $B4,$69,$B5,$B1,$B4,$9A,$B5,$C4
        .byte   $B5
LB3BF:  lda     $A51D
        sta     L0006
        lda     $A51E
        sta     L0006+1
        rts
LB3CA:  bit     LB3E6
        bpl     LB3D7
        jsr     LB403
        lda     #$00
        sta     LB3E6
LB3D7:  rts

LB3D8:  bit     LB3E6
        bmi     LB3E5
        jsr     LB41F
        lda     #$80
        sta     LB3E6
LB3E5:  rts

LB3E6:  .byte   0
        A2D_RELAY_CALL A2D_HIDE_CURSOR
        A2D_RELAY_CALL A2D_SET_CURSOR, $D311 ; watch
        A2D_RELAY_CALL A2D_SHOW_CURSOR
        rts

LB403:  A2D_RELAY_CALL A2D_HIDE_CURSOR
        A2D_RELAY_CALL A2D_SET_CURSOR, $D2AD ; pointer
        A2D_RELAY_CALL A2D_SHOW_CURSOR
        rts

LB41F:  A2D_RELAY_CALL A2D_HIDE_CURSOR
        A2D_RELAY_CALL A2D_SET_CURSOR, $D2DF ; insertion point
        A2D_RELAY_CALL A2D_SHOW_CURSOR
        rts

LB43B:  A2D_RELAY_CALL A2D_SET_FILL_MODE, $D202
        rts

        ldx     #$03
LB447:  lda     $D209,x
        sta     LB502,x
        dex
        bpl     LB447
        lda     #$00
        sta     LB501
        lda     $D2AB
        asl     a
        sta     LB500
        rol     LB501
LB45F:  dec     LB500
        lda     LB500
        cmp     #$FF
        bne     LB46C
        dec     LB501
LB46C:  lda     LB501
        bne     LB476
        lda     LB500
        beq     LB4B7
LB476:  A2D_RELAY_CALL $2C, $D208 ; ???
        jsr     LB4BA
        bmi     LB4B7
        lda     #$FF
        sta     LB508
        lda     $D208
        sta     LB507
        cmp     #$00
        beq     LB45F
        cmp     #$04
        beq     LB45F
        cmp     #$02
        bne     LB4A7
        A2D_RELAY_CALL A2D_GET_INPUT, $D208
        jmp     LB45F

LB4A7:  cmp     #$01
        bne     LB4B7
        A2D_RELAY_CALL A2D_GET_INPUT, $D208
        lda     #$00
        rts

LB4B7:  lda     #$FF
        rts

LB4BA:  lda     $D209
        sec
        sbc     LB502
        sta     LB506
        lda     $D20A
        sbc     LB503
        bpl     LB4D6
        lda     LB506
        cmp     #$FB
        bcs     LB4DD
LB4D3:  lda     #$FF
        rts

LB4D6:  lda     LB506
        cmp     #$05
        bcs     LB4D3
LB4DD:  lda     $D20B
        sec
        sbc     LB504
        sta     LB506
        lda     $D20C
        sbc     LB505
        bpl     LB4F6
        lda     LB506
        cmp     #$FC
        bcs     LB4FD
LB4F6:  lda     LB506
        cmp     #$04
        bcs     LB4D3
LB4FD:  lda     #$00
        rts

LB500:  .byte   0
LB501:  .byte   0
LB502:  .byte   0
LB503:  .byte   0
LB504:  .byte   0
LB505:  .byte   0
LB506:  .byte   0
LB507:  .byte   0
LB508:  .byte   0
LB509:  sta     $D8E7
        jsr     LB53A
        bit     $D8E7
        bvc     LB51A
        jsr     LB64E
        jmp     LB526

LB51A:  A2D_RELAY_CALL A2D_DRAW_RECT, $AE20
        jsr     LB5F9
LB526:  bit     $D8E7
        bmi     LB537
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE10
        jsr     LB60A
LB537:  jmp     LBEB1

LB53A:  A2D_RELAY_CALL A2D_CREATE_WINDOW, $D57D
        lda     $D57D
        jsr     LB7B9
        jsr     LB43B
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE00
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE08
        rts

LB55F:  A2D_RELAY_CALL A2D_CREATE_WINDOW, $D57D
        lda     $D57D
        jsr     LB7B9
        jsr     LBEA7
        A2D_RELAY_CALL A2D_DRAW_BITMAP, $D56D
        jsr     LB43B
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE00
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE08
        rts

LB590:  stx     $07
        sta     L0006
        tya
        bmi     LB59A
        jmp     LB5CC

LB59A:  tya
        pha
        lda     L0006
        clc
        adc     #$01
        sta     $08
        lda     $07
        adc     #$00
        sta     $09
        jsr     LBD7B
        sta     $0A
        A2D_RELAY_CALL A2D_MEASURE_TEXT, $0008
        lsr     $0C
        ror     $0B
        lda     #$C8
        sec
        sbc     $0B
        sta     $D6C3
        lda     #$00
        sbc     $0C
        sta     $D6C4
        pla
        tay
LB5CC:  dey
        tya
        asl     a
        asl     a
        asl     a
        clc
        adc     $D6C1
        sta     $D6C5
        lda     $D6C2
        adc     #$00
        sta     $D6C6
        A2D_RELAY_CALL A2D_SET_POS, $D6C3
        lda     L0006
        ldx     $07
        jsr     LB708
        ldx     $D6C3
        lda     #$28
        sta     $D6C3
        rts

LB5F9:  A2D_RELAY_CALL A2D_SET_POS, $AE50
        lda     #$40
        ldx     #$AE
        jsr     LB708
        rts

LB60A:  A2D_RELAY_CALL A2D_SET_POS, $AE54
        lda     #$96
        ldx     #$AE
        jsr     LB708
        rts

LB61B:  A2D_RELAY_CALL A2D_SET_POS, $AE58
        lda     #$A8
        ldx     #$AE
        jsr     LB708
        rts

LB62C:  A2D_RELAY_CALL A2D_SET_POS, $AE5C
        lda     #$AD
        ldx     #$AE
        jsr     LB708
        rts

LB63D:  A2D_RELAY_CALL A2D_SET_POS, $AE60
        lda     #$B1
        ldx     #$AE
        jsr     LB708
        rts

LB64E:  jsr     LB43B
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE28
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE30
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE38
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE10
        jsr     LB61B
        jsr     LB62C
        jsr     LB63D
        jsr     LB60A
        lda     #$40
        sta     $D8E7
        rts

LB687:  jsr     LBEA7
        A2D_RELAY_CALL A2D_FILL_RECT, $AE28
        A2D_RELAY_CALL A2D_FILL_RECT, $AE30
        A2D_RELAY_CALL A2D_FILL_RECT, $AE38
        A2D_RELAY_CALL A2D_FILL_RECT, $AE10
        rts

LB6AF:  jsr     LB43B
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE20
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE10
        jsr     LB5F9
        jsr     LB60A
        lda     #$00
        sta     $D8E7
        rts

LB6D0:  jsr     LBEA7
        A2D_RELAY_CALL A2D_FILL_RECT, $AE20
        A2D_RELAY_CALL A2D_FILL_RECT, $AE10
        rts

LB6E6:  jsr     LB43B
        A2D_RELAY_CALL A2D_DRAW_RECT, $AE20
        jsr     LB5F9
        lda     #$80
        sta     $D8E7
        rts

LB6FB:  jsr     LBEA7
        A2D_RELAY_CALL A2D_FILL_RECT, $AE20
        rts

LB708:  sta     L0006
        stx     $07
        jsr     LBD7B
        beq     LB722
        sta     $08
        inc     L0006
        bne     LB719
        inc     $07
LB719:  A2D_RELAY_CALL A2D_DRAW_TEXT, $0006
LB722:  rts

LB723:  sta     L0006
        stx     $07
        jsr     LBD7B
        sta     $08
        inc     L0006
        bne     LB732
        inc     $07
LB732:  A2D_RELAY_CALL A2D_MEASURE_TEXT, $0006
        lsr     $0A
        ror     $09
        lda     #$01
        sta     LB76B
        lda     #$90
        lsr     LB76B
        ror     a
        sec
        sbc     $09
        sta     $D6B7
        lda     LB76B
        sbc     $0A
        sta     $D6B8
        A2D_RELAY_CALL A2D_SET_POS, $D6B7
        A2D_RELAY_CALL A2D_DRAW_TEXT, $0006
        rts

LB76B:  .byte   0
        sta     L0006
        stx     $07
        A2D_RELAY_CALL A2D_SET_POS, $D6BB
        lda     L0006
        ldx     $07
        jsr     LB708
        rts

LB781:  stx     $0B
        sta     $0A
        ldy     #$00
        lda     ($0A),y
        tay
        bne     LB78D
        rts

LB78D:  dey
        beq     LB792
        bpl     LB793
LB792:  rts

LB793:  lda     ($0A),y
        and     #$7F
        cmp     #$2F
        beq     LB79F
        cmp     #$2E
        bne     LB7A3
LB79F:  dey
        jmp     LB78D

LB7A3:  iny
        lda     ($0A),y
        and     #$7F
        cmp     #$41
        bcc     LB7B5
        cmp     #$5B
        bcs     LB7B5
        clc
        adc     #$20
        sta     ($0A),y
LB7B5:  dey
        jmp     LB78D

LB7B9:  sta     $D212
        A2D_RELAY_CALL A2D_QUERY_STATE, $D212
        ldy     #$04
        lda     #$15
        LB7CA := *+1
        ldx     #$D2
        jsr     A2D_RELAY
        rts
LB7CF:  lda     #$00
        jmp     LB7E8

LB7D4:  lda     #$01
        jmp     LB7E8

LB7D9:  lda     #$02
        jmp     LB7E8

LB7DE:  lda     #$03
        jmp     LB7E8

LB7E3:  lda     #$04
        jmp     LB7E8

LB7E8:  pha
        asl     a
        asl     a
        tax
        lda     LB808,x
        sta     LB886
        lda     LB809,x
        sta     LB887
        lda     LB80A,x
        sta     LB888
        lda     LB80B,x
        sta     LB889
        pla
        jmp     LB88A

LB808:  .byte   $1C
LB809:  .byte   $B8
LB80A:  .byte   $4E
LB80B:  .byte   $B8,$26,$B8,$58,$B8,$30,$B8,$62,$B8
        .byte   $3A,$B8,$6C,$B8,$44,$B8,$76,$B8

        A2D_RELAY_CALL A2D_TEST_BOX, $AE20
        rts

        A2D_RELAY_CALL A2D_TEST_BOX, $AE10
        rts

        A2D_RELAY_CALL A2D_TEST_BOX, $AE28
        rts

        A2D_RELAY_CALL A2D_TEST_BOX, $AE30
        rts

        A2D_RELAY_CALL A2D_TEST_BOX, $AE38
        rts

        A2D_RELAY_CALL A2D_FILL_RECT, $AE20
        rts

        A2D_RELAY_CALL A2D_FILL_RECT, $AE10
        rts

        A2D_RELAY_CALL A2D_FILL_RECT, $AE28
        rts

        A2D_RELAY_CALL A2D_FILL_RECT, $AE30
        rts

        A2D_RELAY_CALL A2D_FILL_RECT, $AE38
        rts

LB880:  jmp     (LB886)

LB883:  jmp     (LB888)

LB886:  .byte   0
LB887:  .byte   0
LB888:  .byte   0
LB889:  .byte   0
LB88A:  sta     LB8F3
        lda     #$00
        sta     LB8F2
LB892:  A2D_RELAY_CALL A2D_GET_INPUT, $D208
        lda     $D208
        cmp     #$02
        beq     LB8E3
        lda     $D57D
        sta     $D208
        A2D_RELAY_CALL A2D_MAP_COORDS, $D208
        A2D_RELAY_CALL A2D_SET_POS, $D20D
        jsr     LB880
        cmp     #$80
        beq     LB8C9
        lda     LB8F2
        beq     LB8D1
        jmp     LB892

LB8C9:  lda     LB8F2
        bne     LB8D1
        jmp     LB892

LB8D1:  jsr     LB43B
        jsr     LB883
        lda     LB8F2
        clc
        adc     #$80
        sta     LB8F2
        jmp     LB892

LB8E3:  lda     LB8F2
        beq     LB8EB
        lda     #$FF
        rts

LB8EB:  jsr     LB883
        lda     LB8F3
        rts

LB8F2:  .byte   0
LB8F3:  .byte   0
        rts

LB8F5:  jsr     LBD3B
        sta     L0006
        stx     $07
        lda     $D6B5
        sta     $08
        lda     $D6B6
        sta     $09
        A2D_RELAY_CALL A2D_SET_POS, $0006
        A2D_RELAY_CALL A2D_SET_BOX, $D6C7
        bit     $D8EB
        bpl     LB92D
        A2D_RELAY_CALL A2D_SET_TEXT_MASK, $AE6C
        lda     #$00
        sta     $D8EB
        beq     LB93B
LB92D:  A2D_RELAY_CALL A2D_SET_TEXT_MASK, $AE6D
        lda     #$FF
        sta     $D8EB
LB93B:  lda     #$EF
        sta     L0006
        lda     #$D8
        sta     $07
        lda     $D8EE
        sta     $08
        A2D_RELAY_CALL A2D_DRAW_TEXT, $0006
        A2D_RELAY_CALL A2D_SET_TEXT_MASK, $AE6D
        lda     $D57D
        jsr     LB7B9
        rts

LB961:  lda     $D443
        beq     LB9B7
        lda     $D57D
        jsr     LB7B9
        jsr     LBEA7
        A2D_RELAY_CALL A2D_FILL_RECT, $D6AB
        A2D_RELAY_CALL A2D_SET_FILL_MODE, $D202
        A2D_RELAY_CALL A2D_DRAW_RECT, $D6AB
        A2D_RELAY_CALL A2D_SET_POS, $D6B3
        A2D_RELAY_CALL A2D_SET_BOX, $D6C7
        lda     #$43
        ldx     #$D4
        jsr     LB708
        lda     #$84
        ldx     #$D4
        jsr     LB708
        lda     #$F8
        ldx     #$D8
        jsr     LB708
        lda     $D57D
        jsr     LB7B9
LB9B7:  rts

LB9B8:  A2D_RELAY_CALL A2D_MAP_COORDS, $D208
        A2D_RELAY_CALL A2D_SET_POS, $D20D
        A2D_RELAY_CALL A2D_TEST_BOX, $D6AB
        cmp     #$80
        beq     LB9D8
        rts

LB9D8:  jsr     LBD3B
        sta     L0006
        stx     $07
        lda     $D20D
        cmp     L0006
        lda     $D20E
        sbc     $07
        bcs     LB9EE
        jmp     LBA83

LB9EE:  jsr     LBD3B
        sta     LBB09
        stx     LBB0A
        ldx     $D484
        inx
        lda     #$20
        sta     $D484,x
        inc     $D484
        lda     #$84
        sta     L0006
        lda     #$D4
        sta     $07
        lda     $D484
        sta     $08
LBA10:  A2D_RELAY_CALL A2D_MEASURE_TEXT, $0006
        lda     $09
        clc
        adc     LBB09
        sta     $09
        lda     $0A
        adc     LBB0A
        sta     $0A
        lda     $09
        cmp     $D20D
        lda     $0A
        sbc     $D20E
        bcc     LBA42
        dec     $08
        lda     $08
        cmp     #$01
        bne     LBA10
        dec     $D484
        jmp     LBB05

LBA42:  lda     $08
        cmp     $D484
        bcc     LBA4F
        dec     $D484
        jmp     LBCC9

LBA4F:  ldx     #$02
        ldy     $D443
        iny
LBA55:  lda     $D484,x
        sta     $D443,y
        cpx     $08
        beq     LBA64
        iny
        inx
        jmp     LBA55

LBA64:  sty     $D443
        ldy     #$02
        ldx     $08
        inx
LBA6C:  lda     $D484,x
        sta     $D484,y
        cpx     $D484
        beq     LBA7C
        iny
        inx
        jmp     LBA6C

LBA7C:  dey
        sty     $D484
        jmp     LBB05

LBA83:  lda     #$43
        sta     L0006
        lda     #$D4
        sta     $07
        lda     $D443
        sta     $08
LBA90:  A2D_RELAY_CALL A2D_MEASURE_TEXT, $0006
        lda     $09
        clc
        adc     $D6B3
        sta     $09
        lda     $0A
        adc     $D6B4
        sta     $0A
        .byte   $A5
LBAA9:  ora     #$CD
        ora     LA5D2
        asl     a
        sbc     $D20E
        bcc     LBABF
        dec     $08
        lda     $08
        cmp     #$01
        bcs     LBA90
        jmp     LBC5E

LBABF:  inc     $08
        ldy     #$00
        ldx     $08
LBAC5:  cpx     $D443
        beq     LBAD5
        inx
        iny
        lda     $D443,x
        sta     $D3C2,y
        jmp     LBAC5

LBAD5:  iny
        sty     $D3C1
        ldx     #$01
        ldy     $D3C1
LBADE:  cpx     $D484
        beq     LBAEE
        inx
        iny
        lda     $D484,x
        sta     $D3C1,y
        jmp     LBADE

LBAEE:  sty     $D3C1
        lda     $D8EF
        sta     $D3C2
LBAF7:  lda     $D3C1,y
        sta     $D484,y
        dey
        bpl     LBAF7
        lda     $08
        sta     $D443
LBB05:  jsr     LB961
        rts

LBB09:  .byte   0
LBB0A:  .byte   0
LBB0B:  sta     LBB62
        lda     $D443
        clc
        adc     $D484
        cmp     #$10
        bcc     LBB1A
        rts

LBB1A:  lda     LBB62
        ldx     $D443
        inx
        sta     $D443,x
        sta     $D8F7
        jsr     LBD3B
        inc     $D443
        sta     L0006
        stx     $07
        lda     $D6B5
        sta     $08
        lda     $D6B6
        sta     $09
        A2D_RELAY_CALL A2D_SET_POS, $0006
        A2D_RELAY_CALL A2D_SET_BOX, $D6C7
        lda     #$F6
        ldx     #$D8
        jsr     LB708
        lda     #$84
        ldx     #$D4
        jsr     LB708
        lda     $D57D
        jsr     LB7B9
        rts

LBB62:  .byte   0
LBB63:  lda     $D443
        bne     LBB69
        rts

LBB69:  dec     $D443
        jsr     LBD3B
        sta     L0006
        stx     $07
        lda     $D6B5
        sta     $08
        lda     $D6B6
        sta     $09
        A2D_RELAY_CALL A2D_SET_POS, $0006
        A2D_RELAY_CALL A2D_SET_BOX, $D6C7
        lda     #$84
        ldx     #$D4
        jsr     LB708
        lda     #$F8
        ldx     #$D8
        jsr     LB708
        lda     $D57D
        jsr     LB7B9
        rts

LBBA4:  lda     $D443
        bne     LBBAA
        rts

LBBAA:  ldx     $D484
        cpx     #$01
        beq     LBBBC
LBBB1:  lda     $D484,x
        sta     $D485,x
        dex
        cpx     #$01
        bne     LBBB1
LBBBC:  ldx     $D443
        lda     $D443,x
        sta     $D486
        dec     $D443
        inc     $D484
        jsr     LBD3B
        sta     L0006
        stx     $07
        lda     $D6B5
        sta     $08
        lda     $D6B6
        sta     $09
        A2D_RELAY_CALL A2D_SET_POS, $0006
        A2D_RELAY_CALL A2D_SET_BOX, $D6C7
        lda     #$84
        ldx     #$D4
        jsr     LB708
        lda     #$F8
        ldx     #$D8
        jsr     LB708
        lda     $D57D
        jsr     LB7B9
        rts

LBC03:  lda     $D484
        cmp     #$02
        bcs     LBC0B
        rts

LBC0B:  ldx     $D443
        inx
        lda     $D486
        sta     $D443,x
        inc     $D443
        ldx     $D484
        cpx     #$03
        bcc     LBC2D
        ldx     #$02
LBC21:  lda     $D485,x
        sta     $D484,x
        inx
        cpx     $D484
        bne     LBC21
LBC2D:  dec     $D484
        A2D_RELAY_CALL A2D_SET_POS, $D6B3
        A2D_RELAY_CALL A2D_SET_BOX, $D6C7
        lda     #$43
        ldx     #$D4
        jsr     LB708
        lda     #$84
        ldx     #$D4
        jsr     LB708
        lda     #$F8
        ldx     #$D8
        jsr     LB708
        lda     $D57D
        jsr     LB7B9
        rts

LBC5E:  lda     $D443
        bne     LBC64
        rts

LBC64:  ldx     $D484
        cpx     #$01
        beq     LBC79
LBC6B:  lda     $D484,x
        sta     $D3C0,x
        dex
        cpx     #$01
        bne     LBC6B
        ldx     $D484
LBC79:  dex
        stx     $D3C1
        ldx     $D443
LBC80:  lda     $D443,x
        sta     $D485,x
        dex
        bne     LBC80
        lda     $D8EF
        sta     $D485
        inc     $D443
        lda     $D443
        sta     $D484
        lda     $D443
        clc
        adc     $D3C1
        tay
        pha
        ldx     $D3C1
        beq     LBCB3
LBCA6:  lda     $D3C1,x
        sta     $D484,y
        dex
        dey
        cpy     $D484
        bne     LBCA6
LBCB3:  pla
        sta     $D484
        lda     #$00
        sta     $D443
        A2D_RELAY_CALL A2D_SET_POS, $D6B3
        jsr     LB961
        rts

LBCC9:  lda     $D484
        cmp     #$02
        bcs     LBCD1
        rts

LBCD1:  ldx     $D484
        dex
        txa
        clc
        adc     $D443
        pha
        tay
        ldx     $D484
LBCDF:  lda     $D484,x
        sta     $D443,y
        dex
        dey
        cpy     $D443
        bne     LBCDF
        pla
        sta     $D443
        lda     #$01
        sta     $D484
        A2D_RELAY_CALL A2D_SET_POS, $D6B3
        jsr     LB961
        rts

        sta     L0006
        stx     $07
        ldy     #$00
        lda     (L0006),y
        tay
        clc
        adc     $D443
        pha
        tax
LBD11:  lda     (L0006),y
        sta     $D443,x
        dey
        dex
        cpx     $D443
        bne     LBD11
        pla
        sta     $D443
        rts

LBD22:  ldx     $D443
        cpx     #$00
        beq     LBD33
        dec     $D443
        lda     $D443,x
        cmp     #$2F
        bne     LBD22
LBD33:  rts

        jsr     LBD22
        jsr     LB961
        rts

LBD3B:  lda     #$44
        sta     L0006
        lda     #$D4
        sta     $07
        lda     $D443
        sta     $08
        bne     LBD51
        lda     $D6B3
        ldx     $D6B4
        rts

LBD51:  A2D_RELAY_CALL A2D_MEASURE_TEXT, $0006
        lda     $09
        clc
        adc     $D6B3
        tay
        lda     $0A
        adc     $D6B4
        tax
        tya
        rts

LBD69:  lda     #$01
        sta     $D484
        lda     $D8EF
        sta     $D485
        rts

LBD75:  lda     #$00
        sta     $D443
        rts

LBD7B:  ldx     #$11
LBD7D:  lda     L0020,x
        sta     LBDB0,x
        dex
        bpl     LBD7D
        ldx     #$11
LBD87:  lda     LBD9F,x
        sta     L0020,x
        dex
        bpl     LBD87
        jsr     L0020
        pha
        ldx     #$11
LBD95:  lda     LBDB0,x
        sta     L0020,x
        dex
        bpl     LBD95
        pla
        rts

LBD9F:  sta     RAMRDON
        sta     RAMWRTON
        ldy     #$00
        lda     (L0006),y
        sta     RAMRDOFF
        sta     RAMWRTOFF
        rts

LBDB0:  .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
LBDC4:  ldx     $D8FB
        lda     $D90A
        bne     LBDD9
        lda     $D909
        cmp     #$02
        bcs     LBDD9
        lda     #$20
        sta     $D8FB,x
        rts

LBDD9:  lda     #$73
        sta     $D8FB,x
        rts

LBDDF:  lda     $D909
        sta     LBE5F
        lda     $D90A
        sta     LBE60
        ldx     #$07
        lda     #$20
LBDEF:  sta     $D901,x
        dex
        bne     LBDEF
        lda     #$00
        sta     LBE62
        ldy     #$00
        ldx     #$00
LBDFE:  lda     #$00
        sta     LBE61
LBE03:  lda     LBE5F
        cmp     LBE57,x
        lda     LBE60
        sbc     LBE58,x
        bpl     LBE35
        lda     LBE61
        bne     LBE1F
        bit     LBE62
        bmi     LBE1F
        lda     #$20
        bne     LBE28
LBE1F:  ora     #$30
        pha
        lda     #$80
        sta     LBE62
        pla
LBE28:  sta     $D903,y
        iny
        inx
        inx
        cpx     #$08
        beq     LBE4E
        jmp     LBDFE

LBE35:  inc     LBE61
        lda     LBE5F
        sec
        sbc     LBE57,x
        sta     LBE5F
        lda     LBE60
        sbc     LBE58,x
        sta     LBE60
        jmp     LBE03

LBE4E:  lda     LBE5F
        ora     #$30
        sta     $D903,y
        rts

LBE57:  .byte   $10
LBE58:  .byte   $27,$E8,$03,$64,$00,$0A
        .byte   0
LBE5F:  .byte   0
LBE60:  .byte   0
LBE61:  .byte   0
LBE62:  .byte   0
LBE63:  ldy     #$00
        lda     (L0006),y
        tay
LBE68:  lda     (L0006),y
        sta     $D402,y
        dey
        bpl     LBE68
        lda     #$02
        ldx     #$D4
        jsr     LB781
        rts

LBE78:  ldy     #$00
        lda     (L0006),y
        tay
LBE7D:  lda     (L0006),y
        sta     $D443,y
        dey
        bpl     LBE7D
        lda     #$43
        ldx     #$D4
        jsr     LB781
        rts

LBE8D:  jsr     LBEA7
        A2D_RELAY_CALL A2D_FILL_RECT, $AE86
        rts

LBE9A:  jsr     LBEA7
        A2D_RELAY_CALL A2D_FILL_RECT, $AE8E
        rts

LBEA7:  A2D_RELAY_CALL A2D_SET_FILL_MODE, $D200
        rts

LBEB1:  A2D_RELAY_CALL A2D_QUERY_SCREEN, $D239
        A2D_RELAY_CALL A2D_SET_STATE, $D239
        rts

        .res    60, 0
.endproc ; desktop_main
        desktop_main_pop_addrs_to_zp := desktop_main::pop_addrs_to_zp
        desktop_main_push_addrs_from_zp := desktop_main::push_addrs_from_zp