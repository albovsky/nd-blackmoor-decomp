# FUN_0046f907
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046f907
# extent:       0x0046f907-0x0046f986 (127 code bytes)
# span:         0x0046f907-0x0046f986 (code 127, tables 0, padding 0)
# sha256:       877b06e8a541d67ce91819c15050df569ff103702f65c117a7f00f7957b95f3d
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46f907_lifted
# naming:       native port src/original_methods_fl40.c:m46f907_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 7 seeds; oracle: 42/42 instructions executed, 6/6 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_85
# callees:      calls FUN_004f6334, FUN_004fb2e3, FUN_00448d11
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m46f907_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 42 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_85, 0x85  # offset +0x85

# --- external targets -----------------------------------------------
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0046f907 - 0x401000
.globl FUN_0046f907
FUN_0046f907:
    # block 0x0046f907: entry, 13 instruction(s), ends with je to 0x0046f95c (forward)
    push ebp                                     # 0046f907
    {load} mov ebp, esp                          # 0046f908
    sub esp, 0x8                                 # 0046f90a
    push esi                                     # 0046f90d
    push edi                                     # 0046f90e
    mov dword ptr [ebp - local_8], ecx           # 0046f90f
    mov edi, 0x54c180                            # 0046f912
    mov esi, dword ptr [ebp + arg_8]             # 0046f917
    add esi, 0x64                                # 0046f91a
    mov ecx, 0x9                                 # 0046f91d
    {load} xor eax, eax                          # 0046f922
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046f924
    je.d8 L_0046f95c                             # 0046f926
    # block 0x0046f928: entered by fall-through of je at 0x0046f926, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0046f95c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0046f928
    movsx edx, word ptr [ecx + field_85]         # 0046f92b
    mov dword ptr [ebp - local_4], edx           # 0046f932
    mov eax, dword ptr [ebp - local_4]           # 0046f935
    push eax                                     # 0046f938
    mov ecx, 0x5cf1eb                            # 0046f939
    call FUN_004f6334                            # 0046f93e
    test eax, eax                                # 0046f943
    jne.d8 L_0046f95c                            # 0046f945
    # block 0x0046f947: entered by fall-through of jne at 0x0046f945, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0046f95c
    mov ecx, dword ptr [ebp + arg_8]             # 0046f947
    mov dx, word ptr [ecx + field_85]            # 0046f94a
    push edx                                     # 0046f951
    mov ecx, 0x5c3a67                            # 0046f952
    call FUN_004fb2e3                            # 0046f957
L_0046f95c:
    # block 0x0046f95c: entered by je at 0x0046f926; jne at 0x0046f945, 2 instruction(s), ends with je to 0x0046f97e (forward)
    cmp dword ptr [0x5bb202], 0x0                # 0046f95c
    je.d8 L_0046f97e                             # 0046f963
    # block 0x0046f965: entered by fall-through of je at 0x0046f963, 8 instruction(s), calls FUN_00448d11, falls into the block at 0x0046f97e
    push 0x0                                     # 0046f965
    push -0x1                                    # 0046f967
    mov eax, dword ptr [ebp + arg_8]             # 0046f969
    push eax                                     # 0046f96c
    mov ecx, dword ptr [0x5d03b3]                # 0046f96d
    push ecx                                     # 0046f973
    mov ecx, 0x619a05                            # 0046f974
    call FUN_00448d11                            # 0046f979
L_0046f97e:
    # block 0x0046f97e: entered by je at 0x0046f963, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0046f97e
    pop esi                                      # 0046f97f
    {load} mov esp, ebp                          # 0046f980
    pop ebp                                      # 0046f982
    ret 0x4                                      # 0046f983

