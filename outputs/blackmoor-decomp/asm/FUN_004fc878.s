# FUN_004fc878
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fc878
# extent:       0x004fc878-0x004fc909 (145 code bytes)
# span:         0x004fc878-0x004fc909 (code 145, tables 0, padding 0)
# sha256:       bfb3f1ddaa0d13aabe1898c6694f9e48c98cf9930c2b3e76d4297d96417b8cb9
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fc878_activate_record
# naming:       native port src/original_methods_fl31b.c:m4fc878_activate_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Optional trace calls, then when the state word of record index*0x5bb is 1 calls 0x4f61e7 and sets it to 2; 38/38 instructions, 4/4 directions. See tasks/fl31b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_132; [ecx + n] field_132
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004f61e7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31b.c:m4fc878_activate_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_132, 0x132  # offset +0x132

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f61e7, .text + (0x004f61e7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004fc878 - 0x401000
.globl FUN_004fc878
FUN_004fc878:
    # block 0x004fc878: entry, 7 instruction(s), ends with je to 0x004fc8b3 (forward)
    push ebp                                     # 004fc878
    {load} mov ebp, esp                          # 004fc879
    push ecx                                     # 004fc87b
    mov dword ptr [ebp - local_4], ecx           # 004fc87c
    movsx eax, word ptr [0x63a4cd]               # 004fc87f
    test eax, eax                                # 004fc886
    je.d8 L_004fc8b3                             # 004fc888
    # block 0x004fc88a: entered by fall-through of je at 0x004fc888, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fc8b3
    mov ecx, dword ptr [ebp + arg_8]             # 004fc88a
    and ecx, 0xffff                              # 004fc88d
    push ecx                                     # 004fc893
    push 0x560940                                # 004fc894
    push 0x63888b                                # 004fc899
    call FUN_0050ca3e                            # 004fc89e
    add esp, 0xc                                 # 004fc8a3
    push 0x63888b                                # 004fc8a6
    call FUN_0044a2b7                            # 004fc8ab
    add esp, 0x4                                 # 004fc8b0
L_004fc8b3:
    # block 0x004fc8b3: entered by je at 0x004fc888, 8 instruction(s), ends with jne to 0x004fc903 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004fc8b3
    and edx, 0xffff                              # 004fc8b6
    imul edx, edx, 0x5bb                         # 004fc8bc
    mov eax, dword ptr [ebp - local_4]           # 004fc8c2
    {load} xor ecx, ecx                          # 004fc8c5
    mov cx, word ptr [eax + edx + field_132]     # 004fc8c7
    cmp ecx, 0x1                                 # 004fc8cf
    jne.d8 L_004fc903                            # 004fc8d2
    # block 0x004fc8d4: entered by fall-through of jne at 0x004fc8d2, 10 instruction(s), calls FUN_004f61e7, falls into the block at 0x004fc903
    mov edx, dword ptr [ebp + arg_8]             # 004fc8d4
    and edx, 0xffff                              # 004fc8d7
    push edx                                     # 004fc8dd
    mov ecx, 0x5cf1eb                            # 004fc8de
    call FUN_004f61e7                            # 004fc8e3
    mov eax, dword ptr [ebp + arg_8]             # 004fc8e8
    and eax, 0xffff                              # 004fc8eb
    imul eax, eax, 0x5bb                         # 004fc8f0
    mov ecx, dword ptr [ebp - local_4]           # 004fc8f6
    mov word ptr [ecx + eax + field_132], 0x2    # 004fc8f9
L_004fc903:
    # block 0x004fc903: entered by jne at 0x004fc8d2, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004fc903
    pop ebp                                      # 004fc905
    ret 0x4                                      # 004fc906

