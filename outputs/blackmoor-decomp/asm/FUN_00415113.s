# FUN_00415113
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00415113
# extent:       0x00415113-0x00415176 (99 code bytes)
# span:         0x00415113-0x00415176 (code 99, tables 0, padding 0)
# sha256:       df46e7174e5ceab8fcdaac9d27255c1e01aae7bc76e353639fbafd02aaffb062
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m415113_lifted
# naming:       native port src/original_methods_fl40.c:m415113_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 5 seeds; oracle: 29/29 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_3d
# callees:      calls FUN_0051dc43, FUN_00415011, FUN_0042639d, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m415113_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_3d, 0x3d  # offset +0x3d

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00415113 - 0x401000
.globl FUN_00415113
FUN_00415113:
    # block 0x00415113: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00415170 (forward)
    push ebp                                     # 00415113
    {load} mov ebp, esp                          # 00415114
    sub esp, 0x8                                 # 00415116
    mov dword ptr [ebp - local_8], ecx           # 00415119
    mov eax, dword ptr [ebp + arg_8]             # 0041511c
    mov ecx, dword ptr [eax + field_3d]          # 0041511f
    push ecx                                     # 00415122
    call FUN_0051dc43                            # 00415123
    add esp, 0x4                                 # 00415128
    mov dword ptr [ebp - local_4], eax           # 0041512b
    mov edx, dword ptr [ebp + arg_c]             # 0041512e
    mov eax, dword ptr [ebp - local_4]           # 00415131
    mov dword ptr [edx], eax                     # 00415134
    cmp dword ptr [ebp - local_4], 0x0           # 00415136
    jne.d8 L_00415170                            # 0041513a
    # block 0x0041513c: entered by fall-through of jne at 0x0041513a, 11 instruction(s), calls FUN_00415011, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00415170
    mov ecx, dword ptr [ebp + arg_8]             # 0041513c
    push ecx                                     # 0041513f
    mov ecx, dword ptr [ebp - local_8]           # 00415140
    call FUN_00415011                            # 00415143
    push 0x541a58                                # 00415148
    push 0x541a8c                                # 0041514d
    mov ecx, 0x583979                            # 00415152
    call FUN_0042639d                            # 00415157
    mov dword ptr [0x63a58a], 0x4                # 0041515c
    mov ecx, 0x5cf659                            # 00415166
    call FUN_004c97b4                            # 0041516b
L_00415170:
    # block 0x00415170: entered by jne at 0x0041513a, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00415170
    pop ebp                                      # 00415172
    ret 0x8                                      # 00415173

