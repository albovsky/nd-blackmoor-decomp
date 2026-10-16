# FUN_00513cf5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513cf5
# extent:       0x00513cf5-0x00513dac (183 code bytes)
# span:         0x00513cf5-0x00513dac (code 183, tables 0, padding 0)
# sha256:       cf2e5c52b8c9540f7a60ea8b9a16168906c90774c158e913bac7156a080fd808
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513ccb (+0x2a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513cf5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_00513bd7, FUN_00513bc0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 63 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         unreachable_code_entry:0x00513d09
# note:         unreachable_code_entry:0x00513d5a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00513bc0, .text + (0x00513bc0 - 0x401000)
.set FUN_00513bd7, .text + (0x00513bd7 - 0x401000)

.org 0x00513cf5 - 0x401000
.globl FUN_00513cf5
FUN_00513cf5:
    # block 0x00513cf5: entry, 6 instruction(s), ends with forward jump to 0x00513d1d
    sub esp, 0x8                                 # 00513cf5
    fst qword ptr [esp]                          # 00513cf8
    mov eax, dword ptr [esp + stk_4]             # 00513cfb
    add esp, 0x8                                 # 00513cff
    and eax, 0x7ff00000                          # 00513d02
    jmp.d8 L_00513d1d                            # 00513d07
    # block 0x00513d09: entered by follows jmp at 0x00513d07, 6 instruction(s), ends with je to 0x00513d5a (forward)
    sub esp, 0x8                                 # 00513d09
    fst qword ptr [esp]                          # 00513d0c
    mov eax, dword ptr [esp + stk_4]             # 00513d0f
    add esp, 0x8                                 # 00513d13
    and eax, 0x7ff00000                          # 00513d16
    je.d8 L_00513d5a                             # 00513d1b
L_00513d1d:
    # block 0x00513d1d: entered by jmp at 0x00513d07; fall-through of je at 0x00513d1b, 2 instruction(s), ends with je to 0x00513d83 (forward)
    cmp eax, 0x7ff00000                          # 00513d1d
    je.d8 L_00513d83                             # 00513d22
    # block 0x00513d24: entered by fall-through of je at 0x00513d22, 3 instruction(s), ends with je to 0x00513d58 (forward)
    mov ax, word ptr [esp]                       # 00513d24
    .insn 0x66, 0x3d, 0x027f{:u16}               # 00513d28
    je.d8 L_00513d58                             # 00513d2c
    # block 0x00513d2e: entered by fall-through of je at 0x00513d2c, 2 instruction(s), ends with jne to 0x00513d55 (forward)
    and ax, 0x20                                 # 00513d2e
    jne.d8 L_00513d55                            # 00513d32
    # block 0x00513d34: entered by fall-through of jne at 0x00513d32, 4 instruction(s), ends with je to 0x00513d55 (forward)
    wait                                         # 00513d34
    fnstsw ax                                    # 00513d35
    and ax, 0x20                                 # 00513d37
    je.d8 L_00513d55                             # 00513d3b
    # block 0x00513d3d: entered by fall-through of je at 0x00513d3b, 1 instruction(s), falls into the block at 0x00513d42
    mov eax, 0x8                                 # 00513d3d
L_00513d42:
    # block 0x00513d42: entered by jae at 0x00513d79; jmp at 0x00513d81; jbe at 0x00513da2; jmp at 0x00513daa, 2 instruction(s), ends with je to 0x00513d4e (forward)
    cmp edx, 0x1d                                # 00513d42
    je.d8 L_00513d4e                             # 00513d45
    # block 0x00513d47: entered by fall-through of je at 0x00513d45, 3 instruction(s), calls FUN_00513bd7, ends with ret
    call FUN_00513bd7                            # 00513d47
    pop edx                                      # 00513d4c
    ret                                          # 00513d4d
L_00513d4e:
    # block 0x00513d4e: entered by je at 0x00513d45, 3 instruction(s), calls FUN_00513bc0, ends with ret
    call FUN_00513bc0                            # 00513d4e
    pop edx                                      # 00513d53
    ret                                          # 00513d54
L_00513d55:
    # block 0x00513d55: entered by jne at 0x00513d32; je at 0x00513d3b, 1 instruction(s), falls into the block at 0x00513d58
    fldcw word ptr [esp]                         # 00513d55
L_00513d58:
    # block 0x00513d58: entered by je at 0x00513d2c, 2 instruction(s), ends with ret
    pop edx                                      # 00513d58
    ret                                          # 00513d59
L_00513d5a:
    # block 0x00513d5a: entered by je at 0x00513d1b, 12 instruction(s), ends with jae to 0x00513d42 (backward)
    fld qword ptr [0x53056c]                     # 00513d5a
    fxch st(1)                                   # 00513d60
    fscale                                       # 00513d62
    fstp st(1)                                   # 00513d64
    fld st(0)                                    # 00513d66
    fabs                                         # 00513d68
    fcomp qword ptr [0x53055c]                   # 00513d6a
    wait                                         # 00513d70
    fnstsw ax                                    # 00513d71
    sahf                                         # 00513d73
    mov eax, 0x4                                 # 00513d74
    jae.d8 L_00513d42                            # 00513d79
    # block 0x00513d7b: entered by fall-through of jae at 0x00513d79, 2 instruction(s), ends with backward jump to 0x00513d42
    fmul qword ptr [0x53057c]                    # 00513d7b
    jmp.d8 L_00513d42                            # 00513d81
L_00513d83:
    # block 0x00513d83: entered by je at 0x00513d22, 12 instruction(s), ends with jbe to 0x00513d42 (backward)
    fld qword ptr [0x530564]                     # 00513d83
    fxch st(1)                                   # 00513d89
    fscale                                       # 00513d8b
    fstp st(1)                                   # 00513d8d
    fld st(0)                                    # 00513d8f
    fabs                                         # 00513d91
    fcomp qword ptr [0x530554]                   # 00513d93
    wait                                         # 00513d99
    fnstsw ax                                    # 00513d9a
    sahf                                         # 00513d9c
    mov eax, 0x3                                 # 00513d9d
    jbe.d8 L_00513d42                            # 00513da2
    # block 0x00513da4: entered by fall-through of jbe at 0x00513da2, 2 instruction(s), ends with backward jump to 0x00513d42
    fmul qword ptr [0x530574]                    # 00513da4
    jmp.d8 L_00513d42                            # 00513daa

