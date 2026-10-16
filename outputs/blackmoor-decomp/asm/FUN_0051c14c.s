# FUN_0051c14c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c14c
# extent:       0x0051c14c-0x0051c174 (40 code bytes)
# span:         0x0051c14c-0x0051c174 (code 40, tables 0, padding 0)
# sha256:       719f583e7b06173972720e25d9d108ec05bd45e368b8284a35921fdf4f21ef81
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c14c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c
# callees:      calls FUN_0051c107, FUN_0051abe4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051c107, .text + (0x0051c107 - 0x401000)

.org 0x0051c14c - 0x401000
.globl FUN_0051c14c
FUN_0051c14c:
    # block 0x0051c14c: entry, 2 instruction(s), ends with je to 0x0051c157 (forward)
    test ecx, ecx                                # 0051c14c
    je.d8 L_0051c157                             # 0051c14e
    # block 0x0051c150: entered by fall-through of je at 0x0051c14e, 3 instruction(s), ends with jne to 0x0051c15a (forward)
    mov eax, dword ptr [ecx + field_1c]          # 0051c150
    test eax, eax                                # 0051c153
    jne.d8 L_0051c15a                            # 0051c155
L_0051c157:
    # block 0x0051c157: entered by je at 0x0051c14e; fall-through of jne at 0x0051c155, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051c157
    ret                                          # 0051c159
L_0051c15a:
    # block 0x0051c15a: entered by jne at 0x0051c155, 3 instruction(s), falls into the block at 0x0051c15e
    push esi                                     # 0051c15a
    {load} mov esi, eax                          # 0051c15b
    push esi                                     # 0051c15d
L_0051c15e:
    # block 0x0051c15e: entered by jmp at 0x0051c16a, 3 instruction(s), calls FUN_0051c107, ends with je to 0x0051c16c (forward)
    call FUN_0051c107                            # 0051c15e
    test eax, eax                                # 0051c163
    je.d8 L_0051c16c                             # 0051c165
    # block 0x0051c167: entered by fall-through of je at 0x0051c165, 3 instruction(s), ends with backward jump to 0x0051c15e
    {load} mov esi, eax                          # 0051c167
    push eax                                     # 0051c169
    jmp.d8 L_0051c15e                            # 0051c16a
L_0051c16c:
    # block 0x0051c16c: entered by je at 0x0051c165, 4 instruction(s), calls FUN_0051abe4, ends with ret
    push esi                                     # 0051c16c
    call FUN_0051abe4                            # 0051c16d
    pop esi                                      # 0051c172
    ret                                          # 0051c173

