# FUN_0050bd80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050bd80
# extent:       0x0050bd80-0x0050be27 (167 code bytes)
# span:         0x0050bd80-0x0050be30 (code 167, tables 0, padding 9)
# sha256:       d80a83ebe494723bf0ba45c75d4df0a4126fb7301ae584461e13ca17b1944d41
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050bd80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ecx + n] field_4, field_c, field_10; [esi + n] field_1, field_2, field_3, field_4; [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 72 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050bd80 - 0x401000
.globl FUN_0050bd80
FUN_0050bd80:
    # block 0x0050bd80: entry, 14 instruction(s), ends with jl to 0x0050bdb6 (forward)
    mov ecx, dword ptr [esp + stk_4]             # 0050bd80
    mov edx, dword ptr [esp + stk_8]             # 0050bd84
    push ebx                                     # 0050bd88
    push ebp                                     # 0050bd89
    mov eax, dword ptr [ecx]                     # 0050bd8a
    mov ebp, dword ptr [4*edx + 0x56777c]        # 0050bd8c
    push esi                                     # 0050bd93
    mov esi, dword ptr [ecx + field_10]          # 0050bd94
    push edi                                     # 0050bd97
    mov edi, dword ptr [ecx + field_4]           # 0050bd98
    lea ebx, [eax + field_4]                     # 0050bd9b
    {load} add edx, edi                          # 0050bd9e
    {load} cmp ebx, esi                          # 0050bda0
    jl.d8 L_0050bdb6                             # 0050bda2
    # block 0x0050bda4: entered by fall-through of jl at 0x0050bda2, 4 instruction(s), ends with jle to 0x0050bdb6 (forward)
    lea eax, [edx + 8*eax]                       # 0050bda4
    shl esi, 0x3                                 # 0050bda7
    {load} cmp eax, esi                          # 0050bdaa
    jle.d8 L_0050bdb6                            # 0050bdac
    # block 0x0050bdae: entered by fall-through of jle at 0x0050bdac, 6 instruction(s), ends with ret
    pop edi                                      # 0050bdae
    pop esi                                      # 0050bdaf
    pop ebp                                      # 0050bdb0
    or eax, -0x1                                 # 0050bdb1
    pop ebx                                      # 0050bdb4
    ret                                          # 0050bdb5
L_0050bdb6:
    # block 0x0050bdb6: entered by jl at 0x0050bda2; jle at 0x0050bdac, 7 instruction(s), ends with jle to 0x0050be20 (forward)
    mov esi, dword ptr [ecx + field_c]           # 0050bdb6
    mov cl, byte ptr [ecx + field_4]             # 0050bdb9
    {load} xor eax, eax                          # 0050bdbc
    mov al, byte ptr [esi]                       # 0050bdbe
    shr eax, cl                                  # 0050bdc0
    cmp edx, 0x8                                 # 0050bdc2
    jle.d8 L_0050be20                            # 0050bdc5
    # block 0x0050bdc7: entered by fall-through of jle at 0x0050bdc5, 9 instruction(s), ends with jle to 0x0050be20 (forward)
    {load} xor ecx, ecx                          # 0050bdc7
    mov cl, byte ptr [esi + field_1]             # 0050bdc9
    {load} mov ebx, ecx                          # 0050bdcc
    mov ecx, 0x8                                 # 0050bdce
    {load} sub ecx, edi                          # 0050bdd3
    shl ebx, cl                                  # 0050bdd5
    {load} or eax, ebx                           # 0050bdd7
    cmp edx, 0x10                                # 0050bdd9
    jle.d8 L_0050be20                            # 0050bddc
    # block 0x0050bdde: entered by fall-through of jle at 0x0050bddc, 9 instruction(s), ends with jle to 0x0050be20 (forward)
    {load} xor ecx, ecx                          # 0050bdde
    mov cl, byte ptr [esi + field_2]             # 0050bde0
    {load} mov ebx, ecx                          # 0050bde3
    mov ecx, 0x10                                # 0050bde5
    {load} sub ecx, edi                          # 0050bdea
    shl ebx, cl                                  # 0050bdec
    {load} or eax, ebx                           # 0050bdee
    cmp edx, 0x18                                # 0050bdf0
    jle.d8 L_0050be20                            # 0050bdf3
    # block 0x0050bdf5: entered by fall-through of jle at 0x0050bdf3, 9 instruction(s), ends with jle to 0x0050be20 (forward)
    {load} xor ecx, ecx                          # 0050bdf5
    mov cl, byte ptr [esi + field_3]             # 0050bdf7
    {load} mov ebx, ecx                          # 0050bdfa
    mov ecx, 0x18                                # 0050bdfc
    {load} sub ecx, edi                          # 0050be01
    shl ebx, cl                                  # 0050be03
    {load} or eax, ebx                           # 0050be05
    cmp edx, 0x20                                # 0050be07
    jle.d8 L_0050be20                            # 0050be0a
    # block 0x0050be0c: entered by fall-through of jle at 0x0050be0a, 2 instruction(s), ends with je to 0x0050be20 (forward)
    test edi, edi                                # 0050be0c
    je.d8 L_0050be20                             # 0050be0e
    # block 0x0050be10: entered by fall-through of je at 0x0050be0e, 6 instruction(s), falls into the block at 0x0050be20
    {load} xor edx, edx                          # 0050be10
    mov ecx, 0x20                                # 0050be12
    mov dl, byte ptr [esi + field_4]             # 0050be17
    {load} sub ecx, edi                          # 0050be1a
    shl edx, cl                                  # 0050be1c
    {load} or eax, edx                           # 0050be1e
L_0050be20:
    # block 0x0050be20: entered by jle at 0x0050bdc5; jle at 0x0050bddc; jle at 0x0050bdf3; jle at 0x0050be0a; more, 6 instruction(s), ends with ret
    pop edi                                      # 0050be20
    {load} and eax, ebp                          # 0050be21
    pop esi                                      # 0050be23
    pop ebp                                      # 0050be24
    pop ebx                                      # 0050be25
    ret                                          # 0050be26

# --- data items (not part of the function) -------------------------
.org 0x0050be27 - 0x401000
PAD_0050be27:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

