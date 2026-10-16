# FUN_004ffb90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ffb90
# extent:       0x004ffb90-0x004ffc0a (122 code bytes)
# span:         0x004ffb90-0x004ffc10 (code 122, tables 0, padding 6)
# sha256:       5df9175c4a31d30588e85fb52a2eab01732d31d6f1c0075626c2d1d2791a36b0
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ffb90
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [esi + n] field_8, field_20; [esp + n] stk_4, stk_8, stk_10, stk_20
# callees:      calls FUN_0050bc50, FUN_0050be60
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0050bc50, .text + (0x0050bc50 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)

.org 0x004ffb90 - 0x401000
.globl FUN_004ffb90
FUN_004ffb90:
    # block 0x004ffb90: entry, 19 instruction(s), calls FUN_0050bc50, FUN_0050be60, ends with je to 0x004ffbcd (forward)
    mov eax, dword ptr [esp + stk_4]             # 004ffb90
    sub esp, 0x14                                # 004ffb94
    push esi                                     # 004ffb97
    mov esi, dword ptr [eax + field_1c]          # 004ffb98
    mov eax, dword ptr [esp + stk_20]            # 004ffb9b
    mov ecx, dword ptr [eax + field_4]           # 004ffb9f
    mov edx, dword ptr [eax]                     # 004ffba2
    push ecx                                     # 004ffba4
    lea eax, [esp + stk_8]                       # 004ffba5
    push edx                                     # 004ffba9
    push eax                                     # 004ffbaa
    call FUN_0050bc50                            # 004ffbab
    lea ecx, [esp + stk_10]                      # 004ffbb0
    push 0x1                                     # 004ffbb4
    push ecx                                     # 004ffbb6
    call FUN_0050be60                            # 004ffbb7
    add esp, 0x14                                # 004ffbbc
    test eax, eax                                # 004ffbbf
    je.d8 L_004ffbcd                             # 004ffbc1
    # block 0x004ffbc3: entered by fall-through of je at 0x004ffbc1, 4 instruction(s), ends with ret
    mov eax, 0xffffff79                          # 004ffbc3
    pop esi                                      # 004ffbc8
    add esp, 0x14                                # 004ffbc9
    ret                                          # 004ffbcc
L_004ffbcd:
    # block 0x004ffbcd: entered by je at 0x004ffbc1, 4 instruction(s), ends with jle to 0x004ffbdf (forward)
    mov eax, dword ptr [esi + field_8]           # 004ffbcd
    {load} xor ecx, ecx                          # 004ffbd0
    cmp eax, 0x1                                 # 004ffbd2
    jle.d8 L_004ffbdf                            # 004ffbd5
L_004ffbd7:
    # block 0x004ffbd7: entered by jg at 0x004ffbdd; fall-through of jle at 0x004ffbd5, 4 instruction(s), ends with jg to 0x004ffbd7 (backward)
    sar eax                                      # 004ffbd7
    inc ecx                                      # 004ffbd9
    cmp eax, 0x1                                 # 004ffbda
    jg.d8 L_004ffbd7                             # 004ffbdd
L_004ffbdf:
    # block 0x004ffbdf: entered by jle at 0x004ffbd5; fall-through of jg at 0x004ffbdd, 7 instruction(s), calls FUN_0050be60, ends with jne to 0x004ffbfc (forward)
    lea edx, [esp + stk_4]                       # 004ffbdf
    push ecx                                     # 004ffbe3
    push edx                                     # 004ffbe4
    call FUN_0050be60                            # 004ffbe5
    add esp, 0x8                                 # 004ffbea
    cmp eax, -0x1                                # 004ffbed
    jne.d8 L_004ffbfc                            # 004ffbf0
    # block 0x004ffbf2: entered by fall-through of jne at 0x004ffbf0, 4 instruction(s), ends with ret
    mov eax, 0xffffff78                          # 004ffbf2
    pop esi                                      # 004ffbf7
    add esp, 0x14                                # 004ffbf8
    ret                                          # 004ffbfb
L_004ffbfc:
    # block 0x004ffbfc: entered by jne at 0x004ffbf0, 6 instruction(s), ends with ret
    mov eax, dword ptr [esi + 4*eax + field_20]  # 004ffbfc
    mov ecx, dword ptr [eax]                     # 004ffc00
    mov eax, dword ptr [esi + 4*ecx]             # 004ffc02
    pop esi                                      # 004ffc05
    add esp, 0x14                                # 004ffc06
    ret                                          # 004ffc09

# --- data items (not part of the function) -------------------------
.org 0x004ffc0a - 0x401000
PAD_004ffc0a:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90

