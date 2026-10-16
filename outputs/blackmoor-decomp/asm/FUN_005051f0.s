# FUN_005051f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005051f0
# extent:       0x005051f0-0x0050525e (110 code bytes)
# span:         0x005051f0-0x00505260 (code 110, tables 0, padding 2)
# sha256:       5cf4b73dee35c7790853c0d3ce8e89869181f885947d449de21e4d4dfdc0f5e6
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005051f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_minus_4; [esp + n] stk_8, stk_c, stk_10
# callees:      calls FUN_0050e97e, FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 40 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x005051f0 - 0x401000
.globl FUN_005051f0
FUN_005051f0:
    # block 0x005051f0: entry, 9 instruction(s), calls FUN_0050e97e, ends with je to 0x00505215 (forward)
    push esi                                     # 005051f0
    mov esi, dword ptr [esp + stk_c]             # 005051f1
    push 0x4                                     # 005051f5
    push esi                                     # 005051f7
    call FUN_0050e97e                            # 005051f8
    mov ecx, dword ptr [esp + stk_10]            # 005051fd
    add esp, 0x8                                 # 00505201
    test ecx, ecx                                # 00505204
    je.d8 L_00505215                             # 00505206
    # block 0x00505208: entered by fall-through of je at 0x00505206, 6 instruction(s), calls FUN_0050e936, ends with ret
    push eax                                     # 00505208
    call FUN_0050e936                            # 00505209
    add esp, 0x4                                 # 0050520e
    {load} xor eax, eax                          # 00505211
    pop esi                                      # 00505213
    ret                                          # 00505214
L_00505215:
    # block 0x00505215: entered by je at 0x00505206, 4 instruction(s), ends with jle to 0x0050525c (forward)
    {load} xor ecx, ecx                          # 00505215
    test esi, esi                                # 00505217
    mov dword ptr [esp + stk_8], ecx             # 00505219
    jle.d8 L_0050525c                            # 0050521d
    # block 0x0050521f: entered by fall-through of jle at 0x0050521d, 2 instruction(s), falls into the block at 0x00505225
    fild dword ptr [esp + stk_c]                 # 0050521f
    {load} mov edx, eax                          # 00505223
L_00505225:
    # block 0x00505225: entered by jl at 0x00505258, 16 instruction(s), ends with jl to 0x00505225 (backward)
    fild dword ptr [esp + stk_8]                 # 00505225
    inc ecx                                      # 00505229
    add edx, 0x4                                 # 0050522a
    {load} cmp ecx, esi                          # 0050522d
    mov dword ptr [esp + stk_8], ecx             # 0050522f
    fadd dword ptr [0x52cd14]                    # 00505233
    fdiv st, st(1)                               # 00505239
    fmul dword ptr [0x52e624]                    # 0050523b
    fmul qword ptr [0x52cac0]                    # 00505241
    fsin                                         # 00505247
    fld st(0)                                    # 00505249
    fmulp st(1), st                              # 0050524b
    fmul dword ptr [0x52e620]                    # 0050524d
    fsin                                         # 00505253
    fstp dword ptr [edx - field_minus_4]         # 00505255
    jl.d8 L_00505225                             # 00505258
    # block 0x0050525a: entered by fall-through of jl at 0x00505258, 1 instruction(s), falls into the block at 0x0050525c
    fstp st(0)                                   # 0050525a
L_0050525c:
    # block 0x0050525c: entered by jle at 0x0050521d, 2 instruction(s), ends with ret
    pop esi                                      # 0050525c
    ret                                          # 0050525d

# --- data items (not part of the function) -------------------------
.org 0x0050525e - 0x401000
PAD_0050525e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

