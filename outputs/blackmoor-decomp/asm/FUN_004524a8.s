# FUN_004524a8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004524a8
# extent:       0x004524a8-0x00452576 (206 code bytes)
# span:         0x004524a8-0x00452576 (code 206, tables 0, padding 0)
# sha256:       380977b834bf232cf0b92a8b40cb7aa5804b804318c1146bdae73782c1fb2e69
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004524a8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_270, field_2a8, field_510; [ecx + n] field_270, field_510; [edx + n] field_510
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4524a8_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 55 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_270, 0x270  # offset +0x270
.equ field_2a8, 0x2a8  # offset +0x2a8
.equ field_510, 0x510  # offset +0x510

# --- external targets -----------------------------------------------

.org 0x004524a8 - 0x401000
.globl FUN_004524a8
FUN_004524a8:
    # block 0x004524a8: entry, 8 instruction(s), ends with forward jump to 0x004524dc
    push ebp                                     # 004524a8
    {load} mov ebp, esp                          # 004524a9
    sub esp, 0x8                                 # 004524ab
    mov dword ptr [ebp - local_8], ecx           # 004524ae
    mov dword ptr [ebp - local_4], 0x0           # 004524b1
    mov eax, dword ptr [ebp - local_8]           # 004524b8
    mov dword ptr [eax + field_510], 0x0         # 004524bb
    jmp.d8 L_004524dc                            # 004524c5
L_004524c7:
    # block 0x004524c7: entered by jmp at 0x00452507, 5 instruction(s), falls into the block at 0x004524dc
    mov ecx, dword ptr [ebp - local_8]           # 004524c7
    mov edx, dword ptr [ecx + field_510]         # 004524ca
    add edx, 0x1                                 # 004524d0
    mov eax, dword ptr [ebp - local_8]           # 004524d3
    mov dword ptr [eax + field_510], edx         # 004524d6
L_004524dc:
    # block 0x004524dc: entered by jmp at 0x004524c5, 3 instruction(s), ends with jge to 0x00452509 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004524dc
    cmp dword ptr [ecx + field_510], 0x6         # 004524df
    jge.d8 L_00452509                            # 004524e6
    # block 0x004524e8: entered by fall-through of jge at 0x004524e6, 5 instruction(s), ends with je to 0x00452507 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004524e8
    mov eax, dword ptr [edx + field_510]         # 004524eb
    mov ecx, dword ptr [ebp - local_8]           # 004524f1
    cmp dword ptr [ecx + 4*eax + field_270], 0x0 # 004524f4
    je.d8 L_00452507                             # 004524fc
    # block 0x004524fe: entered by fall-through of je at 0x004524fc, 3 instruction(s), falls into the block at 0x00452507
    mov edx, dword ptr [ebp - local_4]           # 004524fe
    add edx, 0x1                                 # 00452501
    mov dword ptr [ebp - local_4], edx           # 00452504
L_00452507:
    # block 0x00452507: entered by je at 0x004524fc, 1 instruction(s), ends with backward jump to 0x004524c7
    jmp.d8 L_004524c7                            # 00452507
L_00452509:
    # block 0x00452509: entered by jge at 0x004524e6, 4 instruction(s), ends with jl to 0x0045251c (forward)
    mov eax, dword ptr [ebp - local_8]           # 00452509
    mov ecx, dword ptr [ebp - local_4]           # 0045250c
    cmp ecx, dword ptr [eax + field_2a8]         # 0045250f
    jl.d8 L_0045251c                             # 00452515
    # block 0x00452517: entered by fall-through of jl at 0x00452515, 2 instruction(s), ends with forward jump to 0x00452572
    or eax, -0x1                                 # 00452517
    jmp.d8 L_00452572                            # 0045251a
L_0045251c:
    # block 0x0045251c: entered by jl at 0x00452515, 3 instruction(s), ends with forward jump to 0x00452540
    mov edx, dword ptr [ebp - local_8]           # 0045251c
    mov dword ptr [edx + field_510], 0x0         # 0045251f
    jmp.d8 L_00452540                            # 00452529
L_0045252b:
    # block 0x0045252b: entered by jmp at 0x0045256d, 5 instruction(s), falls into the block at 0x00452540
    mov eax, dword ptr [ebp - local_8]           # 0045252b
    mov ecx, dword ptr [eax + field_510]         # 0045252e
    add ecx, 0x1                                 # 00452534
    mov edx, dword ptr [ebp - local_8]           # 00452537
    mov dword ptr [edx + field_510], ecx         # 0045253a
L_00452540:
    # block 0x00452540: entered by jmp at 0x00452529, 3 instruction(s), ends with jge to 0x0045256f (forward)
    mov eax, dword ptr [ebp - local_8]           # 00452540
    cmp dword ptr [eax + field_510], 0x6         # 00452543
    jge.d8 L_0045256f                            # 0045254a
    # block 0x0045254c: entered by fall-through of jge at 0x0045254a, 5 instruction(s), ends with jne to 0x0045256d (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0045254c
    mov edx, dword ptr [ecx + field_510]         # 0045254f
    mov eax, dword ptr [ebp - local_8]           # 00452555
    cmp dword ptr [eax + 4*edx + field_270], 0x0 # 00452558
    jne.d8 L_0045256d                            # 00452560
    # block 0x00452562: entered by fall-through of jne at 0x00452560, 3 instruction(s), ends with forward jump to 0x00452572
    mov ecx, dword ptr [ebp - local_8]           # 00452562
    mov eax, dword ptr [ecx + field_510]         # 00452565
    jmp.d8 L_00452572                            # 0045256b
L_0045256d:
    # block 0x0045256d: entered by jne at 0x00452560, 1 instruction(s), ends with backward jump to 0x0045252b
    jmp.d8 L_0045252b                            # 0045256d
L_0045256f:
    # block 0x0045256f: entered by jge at 0x0045254a, 1 instruction(s), falls into the block at 0x00452572
    or eax, -0x1                                 # 0045256f
L_00452572:
    # block 0x00452572: entered by jmp at 0x0045251a; jmp at 0x0045256b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00452572
    pop ebp                                      # 00452574
    ret                                          # 00452575

