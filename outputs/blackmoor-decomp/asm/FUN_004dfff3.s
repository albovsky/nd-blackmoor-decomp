# FUN_004dfff3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dfff3
# extent:       0x004dfff3-0x004e01b3 (448 code bytes)
# span:         0x004dfff3-0x004e01b3 (code 448, tables 0, padding 0)
# sha256:       fe316a1eba8defe38485af6c5d4531c625151d44a4fd0c3571e2c5495750c431
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dfff3
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [ecx + n] field_f1, field_f5, field_119, field_3a9; [edi + n] field_e9, field_ed; [edx + n] field_e9, field_f1, field_11b, field_3af, field_3b3, field_3b7, field_3bb; [esi + n] field_f5
# callees:      calls FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 116 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_e9, 0xe9  # offset +0xe9
.equ field_ed, 0xed  # offset +0xed
.equ field_f1, 0xf1  # offset +0xf1
.equ field_f5, 0xf5  # offset +0xf5
.equ field_119, 0x119  # offset +0x119
.equ field_11b, 0x11b  # offset +0x11b
.equ field_3a9, 0x3a9  # offset +0x3a9
.equ field_3af, 0x3af  # offset +0x3af
.equ field_3b3, 0x3b3  # offset +0x3b3
.equ field_3b7, 0x3b7  # offset +0x3b7
.equ field_3bb, 0x3bb  # offset +0x3bb

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004dfff3 - 0x401000
.globl FUN_004dfff3
FUN_004dfff3:
    # block 0x004dfff3: entry, 8 instruction(s), ends with forward jump to 0x004e0012
    push ebp                                     # 004dfff3
    {load} mov ebp, esp                          # 004dfff4
    sub esp, 0x28                                # 004dfff6
    push esi                                     # 004dfff9
    push edi                                     # 004dfffa
    mov dword ptr [ebp - local_10], ecx          # 004dfffb
    mov word ptr [ebp - local_8], 0x0            # 004dfffe
    jmp.d8 L_004e0012                            # 004e0004
L_004e0006:
    # block 0x004e0006: entered by jmp at 0x004e01a8, 3 instruction(s), falls into the block at 0x004e0012
    mov ax, word ptr [ebp - local_8]             # 004e0006
    .insn 0x66, 0x05, 0x0001{:u16}               # 004e000a
    mov word ptr [ebp - local_8], ax             # 004e000e
L_004e0012:
    # block 0x004e0012: entered by jmp at 0x004e0004, 3 instruction(s), ends with jge to 0x004e01ad (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e0012
    cmp ecx, 0x3                                 # 004e0016
    jge.d32 L_004e01ad                           # 004e0019
    # block 0x004e001f: entered by fall-through of jge at 0x004e0019, 97 instruction(s), calls FUN_0050ce04, ends with backward jump to 0x004e0006
    movsx edx, word ptr [ebp - local_8]          # 004e001f
    movsx eax, word ptr [ebp - local_8]          # 004e0023
    mov ecx, dword ptr [ebp - local_10]          # 004e0027
    movsx eax, word ptr [ecx + 2*eax + field_3a9] # 004e002a
    mov dword ptr [ebp - local_14], eax          # 004e0032
    fild dword ptr [ebp - local_14]              # 004e0035
    fstp dword ptr [ebp - local_18]              # 004e0038
    fld dword ptr [ebp - local_18]               # 004e003b
    fmul dword ptr [4*edx + 0x5cf1cb]            # 004e003e
    call FUN_0050ce04                            # 004e0045
    mov word ptr [ebp - local_c], ax             # 004e004a
    movsx ecx, word ptr [ebp - local_8]          # 004e004e
    imul ecx, ecx, 0x6                           # 004e0052
    mov edx, dword ptr [ebp - local_10]          # 004e0055
    movsx eax, word ptr [edx + ecx + field_11b]  # 004e0058
    movsx ecx, word ptr [ebp - local_c]          # 004e0060
    {load} add eax, ecx                          # 004e0064
    mov word ptr [ebp - local_4], ax             # 004e0066
    movsx esi, word ptr [ebp - local_4]          # 004e006a
    movsx edx, word ptr [ebp - local_8]          # 004e006e
    shl edx, 0x4                                 # 004e0072
    movsx eax, word ptr [ebp - local_8]          # 004e0075
    shl eax, 0x4                                 # 004e0079
    mov ecx, dword ptr [ebp - local_10]          # 004e007c
    mov edi, dword ptr [ebp - local_10]          # 004e007f
    mov edx, dword ptr [ecx + edx + field_f1]    # 004e0082
    sub edx, dword ptr [edi + eax + field_e9]    # 004e0089
    mov dword ptr [ebp - local_1c], edx          # 004e0090
    fild dword ptr [ebp - local_1c]              # 004e0093
    fstp dword ptr [ebp - local_20]              # 004e0096
    fld dword ptr [ebp - local_20]               # 004e0099
    fdiv qword ptr [0x52c678]                    # 004e009c
    call FUN_0050ce04                            # 004e00a2
    movsx eax, ax                                # 004e00a7
    {load} sub esi, eax                          # 004e00aa
    movsx ecx, word ptr [ebp - local_8]          # 004e00ac
    shl ecx, 0x4                                 # 004e00b0
    mov edx, dword ptr [ebp - local_10]          # 004e00b3
    mov dword ptr [edx + ecx + field_3af], esi   # 004e00b6
    movsx eax, word ptr [ebp - local_8]          # 004e00bd
    shl eax, 0x4                                 # 004e00c1
    movsx ecx, word ptr [ebp - local_8]          # 004e00c4
    shl ecx, 0x4                                 # 004e00c8
    mov edx, dword ptr [ebp - local_10]          # 004e00cb
    mov eax, dword ptr [edx + eax + field_3af]   # 004e00ce
    mov edx, dword ptr [ebp - local_10]          # 004e00d5
    add eax, dword ptr [edx + ecx + field_f1]    # 004e00d8
    movsx ecx, word ptr [ebp - local_8]          # 004e00df
    shl ecx, 0x4                                 # 004e00e3
    mov edx, dword ptr [ebp - local_10]          # 004e00e6
    sub eax, dword ptr [edx + ecx + field_e9]    # 004e00e9
    movsx ecx, word ptr [ebp - local_8]          # 004e00f0
    shl ecx, 0x4                                 # 004e00f4
    mov edx, dword ptr [ebp - local_10]          # 004e00f7
    mov dword ptr [edx + ecx + field_3b7], eax   # 004e00fa
    movsx eax, word ptr [ebp - local_8]          # 004e0101
    imul eax, eax, 0x6                           # 004e0105
    mov ecx, dword ptr [ebp - local_10]          # 004e0108
    movsx esi, word ptr [ecx + eax + field_119]  # 004e010b
    movsx edx, word ptr [ebp - local_8]          # 004e0113
    shl edx, 0x4                                 # 004e0117
    movsx eax, word ptr [ebp - local_8]          # 004e011a
    shl eax, 0x4                                 # 004e011e
    mov ecx, dword ptr [ebp - local_10]          # 004e0121
    mov edi, dword ptr [ebp - local_10]          # 004e0124
    mov edx, dword ptr [ecx + edx + field_f5]    # 004e0127
    sub edx, dword ptr [edi + eax + field_ed]    # 004e012e
    mov dword ptr [ebp - local_24], edx          # 004e0135
    fild dword ptr [ebp - local_24]              # 004e0138
    fstp dword ptr [ebp - local_28]              # 004e013b
    fld dword ptr [ebp - local_28]               # 004e013e
    fdiv qword ptr [0x52c678]                    # 004e0141
    call FUN_0050ce04                            # 004e0147
    movsx eax, ax                                # 004e014c
    {load} sub esi, eax                          # 004e014f
    movsx ecx, word ptr [ebp - local_8]          # 004e0151
    shl ecx, 0x4                                 # 004e0155
    mov edx, dword ptr [ebp - local_10]          # 004e0158
    mov dword ptr [edx + ecx + field_3b3], esi   # 004e015b
    movsx eax, word ptr [ebp - local_8]          # 004e0162
    shl eax, 0x4                                 # 004e0166
    movsx ecx, word ptr [ebp - local_8]          # 004e0169
    shl ecx, 0x4                                 # 004e016d
    movsx edx, word ptr [ebp - local_8]          # 004e0170
    shl edx, 0x4                                 # 004e0174
    mov esi, dword ptr [ebp - local_10]          # 004e0177
    mov edi, dword ptr [ebp - local_10]          # 004e017a
    mov ecx, dword ptr [esi + ecx + field_f5]    # 004e017d
    sub ecx, dword ptr [edi + edx + field_ed]    # 004e0184
    mov edx, dword ptr [ebp - local_10]          # 004e018b
    mov eax, dword ptr [edx + eax + field_3b3]   # 004e018e
    {load} add eax, ecx                          # 004e0195
    movsx ecx, word ptr [ebp - local_8]          # 004e0197
    shl ecx, 0x4                                 # 004e019b
    mov edx, dword ptr [ebp - local_10]          # 004e019e
    mov dword ptr [edx + ecx + field_3bb], eax   # 004e01a1
    jmp.d32 L_004e0006                           # 004e01a8
L_004e01ad:
    # block 0x004e01ad: entered by jge at 0x004e0019, 5 instruction(s), ends with ret
    pop edi                                      # 004e01ad
    pop esi                                      # 004e01ae
    {load} mov esp, ebp                          # 004e01af
    pop ebp                                      # 004e01b1
    ret                                          # 004e01b2

