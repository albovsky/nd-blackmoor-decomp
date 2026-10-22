# FUN_0044b1b4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044b1b4
# extent:       0x0044b1b4-0x0044b26a (182 code bytes)
# span:         0x0044b1b4-0x0044b26a (code 182, tables 0, padding 0)
# sha256:       7fd6e5bddf0d82ed85a2a9db70609b4cefc02fd3821cd42137091b116a59529d
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44b1b4_lifted
# naming:       native port src/original_methods_fl40.c:m44b1b4_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 56/56 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_4, field_8; [edx + n] field_4, field_8
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44b1b4_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 56 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0044b1b4 - 0x401000
.globl FUN_0044b1b4
FUN_0044b1b4:
    # block 0x0044b1b4: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x0044b216 (forward)
    push ebp                                     # 0044b1b4
    {load} mov ebp, esp                          # 0044b1b5
    sub esp, 0x8                                 # 0044b1b7
    mov dword ptr [ebp - local_8], ecx           # 0044b1ba
    push 0xa                                     # 0044b1bd
    call FUN_0051dc43                            # 0044b1bf
    add esp, 0x4                                 # 0044b1c4
    mov dword ptr [ebp - local_4], eax           # 0044b1c7
    mov eax, dword ptr [ebp + arg_8]             # 0044b1ca
    mov ecx, dword ptr [ebp - local_4]           # 0044b1cd
    mov dword ptr [eax], ecx                     # 0044b1d0
    cmp dword ptr [ebp - local_4], 0x0           # 0044b1d2
    jne.d8 L_0044b216                            # 0044b1d6
    # block 0x0044b1d8: entered by fall-through of jne at 0x0044b1d6, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0044b216
    movsx edx, word ptr [0x5c39e3]               # 0044b1d8
    push edx                                     # 0044b1df
    mov eax, dword ptr [0x5bb57b]                # 0044b1e0
    push eax                                     # 0044b1e5
    push 0x548fb0                                # 0044b1e6
    push 0x63888b                                # 0044b1eb
    call FUN_0050ca3e                            # 0044b1f0
    add esp, 0x10                                # 0044b1f5
    push 0x63888b                                # 0044b1f8
    push 0x548fdc                                # 0044b1fd
    mov ecx, 0x583979                            # 0044b202
    call FUN_0042639d                            # 0044b207
    mov ecx, 0x5cf659                            # 0044b20c
    call FUN_004c97b4                            # 0044b211
L_0044b216:
    # block 0x0044b216: entered by jne at 0x0044b1d6, 23 instruction(s), ends with je to 0x0044b264 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0044b216
    mov edx, dword ptr [ecx]                     # 0044b219
    mov eax, dword ptr [ebp + arg_8]             # 0044b21b
    mov ecx, dword ptr [eax]                     # 0044b21e
    mov eax, dword ptr [edx]                     # 0044b220
    mov dword ptr [ecx], eax                     # 0044b222
    mov eax, dword ptr [edx + field_4]           # 0044b224
    mov dword ptr [ecx + field_4], eax           # 0044b227
    mov dx, word ptr [edx + field_8]             # 0044b22a
    mov word ptr [ecx + field_8], dx             # 0044b22e
    mov eax, dword ptr [ebp + arg_10]            # 0044b232
    mov ecx, dword ptr [eax]                     # 0044b235
    add ecx, 0xa                                 # 0044b237
    mov edx, dword ptr [ebp + arg_10]            # 0044b23a
    mov dword ptr [edx], ecx                     # 0044b23d
    mov eax, dword ptr [ebp + arg_c]             # 0044b23f
    mov ecx, dword ptr [eax]                     # 0044b242
    add ecx, 0xa                                 # 0044b244
    mov edx, dword ptr [ebp + arg_c]             # 0044b247
    mov dword ptr [edx], ecx                     # 0044b24a
    movsx eax, word ptr [0x63a4cd]               # 0044b24c
    test eax, eax                                # 0044b253
    je.d8 L_0044b264                             # 0044b255
    # block 0x0044b257: entered by fall-through of je at 0x0044b255, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044b264
    push 0x548ff8                                # 0044b257
    call FUN_0044a2b7                            # 0044b25c
    add esp, 0x4                                 # 0044b261
L_0044b264:
    # block 0x0044b264: entered by je at 0x0044b255, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0044b264
    pop ebp                                      # 0044b266
    ret 0xc                                      # 0044b267

