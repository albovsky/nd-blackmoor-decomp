# FUN_0050be60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050be60
# extent:       0x0050be60-0x0050bf2d (205 code bytes)
# span:         0x0050be60-0x0050bf30 (code 205, tables 0, padding 3)
# sha256:       ca4fe39dd152cfd89c8d10e052473ea162a37b1196401b9b765944d7bdca6351
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050be60
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1, field_2, field_3, field_4; [ebx + n] field_4, field_c, field_10; [esp + n] stk_8, stk_14, stk_18
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 84 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x0050be60 - 0x401000
.globl FUN_0050be60
FUN_0050be60:
    # block 0x0050be60: entry, 15 instruction(s), ends with jl to 0x0050be95 (forward)
    push ebx                                     # 0050be60
    mov ebx, dword ptr [esp + stk_8]             # 0050be61
    push ebp                                     # 0050be65
    push esi                                     # 0050be66
    mov esi, dword ptr [esp + stk_14]            # 0050be67
    mov ebp, dword ptr [ebx + field_4]           # 0050be6b
    mov ecx, dword ptr [ebx + field_10]          # 0050be6e
    push edi                                     # 0050be71
    mov eax, dword ptr [4*esi + 0x56777c]        # 0050be72
    {load} add esi, ebp                          # 0050be79
    mov dword ptr [esp + stk_18], eax            # 0050be7b
    mov eax, dword ptr [ebx]                     # 0050be7f
    lea edx, [eax + field_4]                     # 0050be81
    {load} cmp edx, ecx                          # 0050be84
    jl.d8 L_0050be95                             # 0050be86
    # block 0x0050be88: entered by fall-through of jl at 0x0050be86, 5 instruction(s), ends with jg to 0x0050bf07 (forward)
    lea eax, [esi + 8*eax]                       # 0050be88
    or edi, -0x1                                 # 0050be8b
    shl ecx, 0x3                                 # 0050be8e
    {load} cmp eax, ecx                          # 0050be91
    jg.d8 L_0050bf07                             # 0050be93
L_0050be95:
    # block 0x0050be95: entered by jl at 0x0050be86; fall-through of jg at 0x0050be93, 8 instruction(s), ends with jle to 0x0050bf03 (forward)
    mov eax, dword ptr [ebx + field_c]           # 0050be95
    mov cl, byte ptr [ebx + field_4]             # 0050be98
    {load} xor edx, edx                          # 0050be9b
    mov dl, byte ptr [eax]                       # 0050be9d
    {load} mov edi, edx                          # 0050be9f
    shr edi, cl                                  # 0050bea1
    cmp esi, 0x8                                 # 0050bea3
    jle.d8 L_0050bf03                            # 0050bea6
    # block 0x0050bea8: entered by fall-through of jle at 0x0050bea6, 9 instruction(s), ends with jle to 0x0050bf03 (forward)
    {load} xor ecx, ecx                          # 0050bea8
    mov cl, byte ptr [eax + field_1]             # 0050beaa
    {load} mov edx, ecx                          # 0050bead
    mov ecx, 0x8                                 # 0050beaf
    {load} sub ecx, ebp                          # 0050beb4
    shl edx, cl                                  # 0050beb6
    {load} or edi, edx                           # 0050beb8
    cmp esi, 0x10                                # 0050beba
    jle.d8 L_0050bf03                            # 0050bebd
    # block 0x0050bebf: entered by fall-through of jle at 0x0050bebd, 9 instruction(s), ends with jle to 0x0050bf03 (forward)
    {load} xor ecx, ecx                          # 0050bebf
    mov cl, byte ptr [eax + field_2]             # 0050bec1
    {load} mov edx, ecx                          # 0050bec4
    mov ecx, 0x10                                # 0050bec6
    {load} sub ecx, ebp                          # 0050becb
    shl edx, cl                                  # 0050becd
    {load} or edi, edx                           # 0050becf
    cmp esi, 0x18                                # 0050bed1
    jle.d8 L_0050bf03                            # 0050bed4
    # block 0x0050bed6: entered by fall-through of jle at 0x0050bed4, 9 instruction(s), ends with jle to 0x0050bf03 (forward)
    {load} xor ecx, ecx                          # 0050bed6
    mov cl, byte ptr [eax + field_3]             # 0050bed8
    {load} mov edx, ecx                          # 0050bedb
    mov ecx, 0x18                                # 0050bedd
    {load} sub ecx, ebp                          # 0050bee2
    shl edx, cl                                  # 0050bee4
    {load} or edi, edx                           # 0050bee6
    cmp esi, 0x20                                # 0050bee8
    jle.d8 L_0050bf03                            # 0050beeb
    # block 0x0050beed: entered by fall-through of jle at 0x0050beeb, 2 instruction(s), ends with je to 0x0050bf03 (forward)
    test ebp, ebp                                # 0050beed
    je.d8 L_0050bf03                             # 0050beef
    # block 0x0050bef1: entered by fall-through of je at 0x0050beef, 7 instruction(s), falls into the block at 0x0050bf03
    {load} xor ecx, ecx                          # 0050bef1
    mov cl, byte ptr [eax + field_4]             # 0050bef3
    {load} mov edx, ecx                          # 0050bef6
    mov ecx, 0x20                                # 0050bef8
    {load} sub ecx, ebp                          # 0050befd
    shl edx, cl                                  # 0050beff
    {load} or edi, edx                           # 0050bf01
L_0050bf03:
    # block 0x0050bf03: entered by jle at 0x0050bea6; jle at 0x0050bebd; jle at 0x0050bed4; jle at 0x0050beeb; more, 1 instruction(s), falls into the block at 0x0050bf07
    and edi, dword ptr [esp + stk_18]            # 0050bf03
L_0050bf07:
    # block 0x0050bf07: entered by jg at 0x0050be93, 19 instruction(s), ends with ret
    {load} mov eax, esi                          # 0050bf07
    mov ecx, dword ptr [ebx + field_c]           # 0050bf09
    cdq                                          # 0050bf0c
    and edx, 0x7                                 # 0050bf0d
    and esi, 0x7                                 # 0050bf10
    {load} add eax, edx                          # 0050bf13
    mov dword ptr [ebx + field_4], esi           # 0050bf15
    sar eax, 0x3                                 # 0050bf18
    {load} add ecx, eax                          # 0050bf1b
    mov dword ptr [ebx + field_c], ecx           # 0050bf1d
    mov ecx, dword ptr [ebx]                     # 0050bf20
    {load} add eax, ecx                          # 0050bf22
    mov dword ptr [ebx], eax                     # 0050bf24
    {load} mov eax, edi                          # 0050bf26
    pop edi                                      # 0050bf28
    pop esi                                      # 0050bf29
    pop ebp                                      # 0050bf2a
    pop ebx                                      # 0050bf2b
    ret                                          # 0050bf2c

# --- data items (not part of the function) -------------------------
.org 0x0050bf2d - 0x401000
PAD_0050bf2d:  # 3 byte(s) of nop padding
    .fill 3, 1, 0x90

