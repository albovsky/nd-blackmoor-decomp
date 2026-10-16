# FUN_0050bc80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050bc80
# extent:       0x0050bc80-0x0050bd74 (244 code bytes)
# span:         0x0050bc80-0x0050bd80 (code 244, tables 0, padding 12)
# sha256:       1a79a8a2e6d639bcd19ef678f8e2153309dc454d6d195c49e9cf8038dfc6489e
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050bc80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ecx + n] field_1, field_2, field_3; [edx + n] field_4; [esi + n] field_4, field_8, field_c, field_10; [esp + n] stk_10, stk_18, stk_1c
# callees:      calls FUN_0050ebca
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 94 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050ebca, .text + (0x0050ebca - 0x401000)

.org 0x0050bc80 - 0x401000
.globl FUN_0050bc80
FUN_0050bc80:
    # block 0x0050bc80: entry, 10 instruction(s), ends with jl to 0x0050bcbc (forward)
    push ebx                                     # 0050bc80
    push ebp                                     # 0050bc81
    push esi                                     # 0050bc82
    mov esi, dword ptr [esp + stk_10]            # 0050bc83
    push edi                                     # 0050bc87
    mov ecx, dword ptr [esi]                     # 0050bc88
    mov eax, dword ptr [esi + field_10]          # 0050bc8a
    add ecx, 0x4                                 # 0050bc8d
    {load} cmp ecx, eax                          # 0050bc90
    jl.d8 L_0050bcbc                             # 0050bc92
    # block 0x0050bc94: entered by fall-through of jl at 0x0050bc92, 13 instruction(s), calls FUN_0050ebca, falls into the block at 0x0050bcbc
    mov edx, dword ptr [esi + field_8]           # 0050bc94
    add eax, 0x100                               # 0050bc97
    push eax                                     # 0050bc9c
    push edx                                     # 0050bc9d
    call FUN_0050ebca                            # 0050bc9e
    mov edi, dword ptr [esi + field_10]          # 0050bca3
    mov ecx, dword ptr [esi]                     # 0050bca6
    add esp, 0x8                                 # 0050bca8
    add edi, 0x100                               # 0050bcab
    {load} add ecx, eax                          # 0050bcb1
    mov dword ptr [esi + field_8], eax           # 0050bcb3
    mov dword ptr [esi + field_10], edi          # 0050bcb6
    mov dword ptr [esi + field_c], ecx           # 0050bcb9
L_0050bcbc:
    # block 0x0050bcbc: entered by jl at 0x0050bc92, 15 instruction(s), ends with jl to 0x0050bd50 (forward)
    mov edi, dword ptr [esp + stk_1c]            # 0050bcbc
    mov eax, dword ptr [esp + stk_18]            # 0050bcc0
    mov ebp, dword ptr [esi + field_4]           # 0050bcc4
    mov edx, dword ptr [4*edi + 0x56777c]        # 0050bcc7
    {load} mov ecx, ebp                          # 0050bcce
    {load} and eax, edx                          # 0050bcd0
    mov edx, dword ptr [esi + field_c]           # 0050bcd2
    {load} mov bl, al                            # 0050bcd5
    {load} add edi, ebp                          # 0050bcd7
    shl bl, cl                                   # 0050bcd9
    mov cl, byte ptr [edx]                       # 0050bcdb
    {load} or cl, bl                             # 0050bcdd
    cmp edi, 0x8                                 # 0050bcdf
    mov byte ptr [edx], cl                       # 0050bce2
    jl.d8 L_0050bd50                             # 0050bce4
    # block 0x0050bce6: entered by fall-through of jl at 0x0050bce4, 9 instruction(s), ends with jl to 0x0050bd50 (forward)
    mov ebp, dword ptr [esi + field_4]           # 0050bce6
    mov ecx, 0x8                                 # 0050bce9
    {load} sub ecx, ebp                          # 0050bcee
    {load} mov edx, eax                          # 0050bcf0
    shr edx, cl                                  # 0050bcf2
    mov ecx, dword ptr [esi + field_c]           # 0050bcf4
    cmp edi, 0x10                                # 0050bcf7
    mov byte ptr [ecx + field_1], dl             # 0050bcfa
    jl.d8 L_0050bd50                             # 0050bcfd
    # block 0x0050bcff: entered by fall-through of jl at 0x0050bcfd, 9 instruction(s), ends with jl to 0x0050bd50 (forward)
    mov ebp, dword ptr [esi + field_4]           # 0050bcff
    mov ecx, 0x10                                # 0050bd02
    {load} sub ecx, ebp                          # 0050bd07
    {load} mov edx, eax                          # 0050bd09
    shr edx, cl                                  # 0050bd0b
    mov ecx, dword ptr [esi + field_c]           # 0050bd0d
    cmp edi, 0x18                                # 0050bd10
    mov byte ptr [ecx + field_2], dl             # 0050bd13
    jl.d8 L_0050bd50                             # 0050bd16
    # block 0x0050bd18: entered by fall-through of jl at 0x0050bd16, 9 instruction(s), ends with jl to 0x0050bd50 (forward)
    mov ebp, dword ptr [esi + field_4]           # 0050bd18
    mov ecx, 0x18                                # 0050bd1b
    {load} sub ecx, ebp                          # 0050bd20
    {load} mov edx, eax                          # 0050bd22
    shr edx, cl                                  # 0050bd24
    mov ecx, dword ptr [esi + field_c]           # 0050bd26
    cmp edi, 0x20                                # 0050bd29
    mov byte ptr [ecx + field_3], dl             # 0050bd2c
    jl.d8 L_0050bd50                             # 0050bd2f
    # block 0x0050bd31: entered by fall-through of jl at 0x0050bd2f, 3 instruction(s), ends with je to 0x0050bd49 (forward)
    mov edx, dword ptr [esi + field_4]           # 0050bd31
    test edx, edx                                # 0050bd34
    je.d8 L_0050bd49                             # 0050bd36
    # block 0x0050bd38: entered by fall-through of je at 0x0050bd36, 6 instruction(s), ends with forward jump to 0x0050bd50
    mov ecx, 0x20                                # 0050bd38
    {load} sub ecx, edx                          # 0050bd3d
    mov edx, dword ptr [esi + field_c]           # 0050bd3f
    shr eax, cl                                  # 0050bd42
    mov byte ptr [edx + field_4], al             # 0050bd44
    jmp.d8 L_0050bd50                            # 0050bd47
L_0050bd49:
    # block 0x0050bd49: entered by je at 0x0050bd36, 2 instruction(s), falls into the block at 0x0050bd50
    mov eax, dword ptr [esi + field_c]           # 0050bd49
    mov byte ptr [eax + field_4], 0x0            # 0050bd4c
L_0050bd50:
    # block 0x0050bd50: entered by jl at 0x0050bce4; jl at 0x0050bcfd; jl at 0x0050bd16; jl at 0x0050bd2f; jmp at 0x0050bd47, 18 instruction(s), ends with ret
    {load} mov eax, edi                          # 0050bd50
    mov ecx, dword ptr [esi + field_c]           # 0050bd52
    cdq                                          # 0050bd55
    and edx, 0x7                                 # 0050bd56
    and edi, 0x7                                 # 0050bd59
    {load} add eax, edx                          # 0050bd5c
    mov edx, dword ptr [esi]                     # 0050bd5e
    sar eax, 0x3                                 # 0050bd60
    {load} add edx, eax                          # 0050bd63
    {load} add ecx, eax                          # 0050bd65
    mov dword ptr [esi + field_4], edi           # 0050bd67
    mov dword ptr [esi], edx                     # 0050bd6a
    mov dword ptr [esi + field_c], ecx           # 0050bd6c
    pop edi                                      # 0050bd6f
    pop esi                                      # 0050bd70
    pop ebp                                      # 0050bd71
    pop ebx                                      # 0050bd72
    ret                                          # 0050bd73

# --- data items (not part of the function) -------------------------
.org 0x0050bd74 - 0x401000
PAD_0050bd74:  # 12 byte(s) of nop padding
    .fill 12, 1, 0x90

