# FUN_0048bb86
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048bb86
# extent:       0x0048bb86-0x0048bc38 (178 code bytes)
# span:         0x0048bb86-0x0048bc38 (code 178, tables 0, padding 0)
# sha256:       ef85d7e0a7c773651e6453c2292fcb1ad8d105335367e51b32825d9314448b92
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48bb86_release
# naming:       native port src/original_methods_fl20a.c:m48bb86_release (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m48bb86_release. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 178 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_22, field_2e, field_30, field_45; [ecx + n] field_1e, field_30; [edx + n] field_1e, field_2e, field_45
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0048bb17
# track-n:      outputs/blackmoor-decomp/src/action_family_d8_runtime.h:d8_cleanup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 61 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_2e, 0x2e  # offset +0x2e
.equ field_30, 0x30  # offset +0x30
.equ field_45, 0x45  # offset +0x45

# --- external targets -----------------------------------------------
.set FUN_0048bb17, .text + (0x0048bb17 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0048bb86 - 0x401000
.globl FUN_0048bb86
FUN_0048bb86:
    # block 0x0048bb86: entry, 9 instruction(s), ends with je to 0x0048bbac (forward)
    push ebp                                     # 0048bb86
    {load} mov ebp, esp                          # 0048bb87
    push ecx                                     # 0048bb89
    mov dword ptr [ebp - local_4], ecx           # 0048bb8a
    mov eax, dword ptr [ebp - local_4]           # 0048bb8d
    mov ecx, dword ptr [ebp - local_4]           # 0048bb90
    mov edx, dword ptr [eax + field_22]          # 0048bb93
    cmp edx, dword ptr [ecx + field_1e]          # 0048bb96
    je.d8 L_0048bbac                             # 0048bb99
    # block 0x0048bb9b: entered by fall-through of je at 0x0048bb99, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0048bbac
    mov eax, dword ptr [ebp - local_4]           # 0048bb9b
    add eax, 0x22                                # 0048bb9e
    push eax                                     # 0048bba1
    mov ecx, 0x5cf659                            # 0048bba2
    call FUN_004c2dfb                            # 0048bba7
L_0048bbac:
    # block 0x0048bbac: entered by je at 0x0048bb99, 3 instruction(s), ends with je to 0x0048bbd4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048bbac
    cmp dword ptr [ecx + field_1e], 0x0          # 0048bbaf
    je.d8 L_0048bbd4                             # 0048bbb3
    # block 0x0048bbb5: entered by fall-through of je at 0x0048bbb3, 5 instruction(s), ends with jne to 0x0048bbd4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048bbb5
    {load} xor eax, eax                          # 0048bbb8
    mov al, byte ptr [edx + field_45]            # 0048bbba
    test eax, eax                                # 0048bbbd
    jne.d8 L_0048bbd4                            # 0048bbbf
    # block 0x0048bbc1: entered by fall-through of jne at 0x0048bbbf, 6 instruction(s), calls FUN_004c2dfb, ends with forward jump to 0x0048bbf4
    mov ecx, dword ptr [ebp - local_4]           # 0048bbc1
    add ecx, 0x1e                                # 0048bbc4
    push ecx                                     # 0048bbc7
    mov ecx, 0x5cf659                            # 0048bbc8
    call FUN_004c2dfb                            # 0048bbcd
    jmp.d8 L_0048bbf4                            # 0048bbd2
L_0048bbd4:
    # block 0x0048bbd4: entered by je at 0x0048bbb3; jne at 0x0048bbbf, 3 instruction(s), ends with je to 0x0048bbf4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048bbd4
    cmp dword ptr [edx + field_1e], 0x0          # 0048bbd7
    je.d8 L_0048bbf4                             # 0048bbdb
    # block 0x0048bbdd: entered by fall-through of je at 0x0048bbdb, 5 instruction(s), ends with jne to 0x0048bbf4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048bbdd
    {load} xor ecx, ecx                          # 0048bbe0
    mov cl, byte ptr [eax + field_45]            # 0048bbe2
    cmp ecx, 0x1                                 # 0048bbe5
    jne.d8 L_0048bbf4                            # 0048bbe8
    # block 0x0048bbea: entered by fall-through of jne at 0x0048bbe8, 2 instruction(s), falls into the block at 0x0048bbf4
    mov edx, dword ptr [ebp - local_4]           # 0048bbea
    mov dword ptr [edx + field_1e], 0x0          # 0048bbed
L_0048bbf4:
    # block 0x0048bbf4: entered by jmp at 0x0048bbd2; je at 0x0048bbdb; jne at 0x0048bbe8, 4 instruction(s), ends with je to 0x0048bc10 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048bbf4
    movsx ecx, word ptr [eax + field_2e]         # 0048bbf7
    cmp ecx, -0x1                                # 0048bbfb
    je.d8 L_0048bc10                             # 0048bbfe
    # block 0x0048bc00: entered by fall-through of je at 0x0048bbfe, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0048bc10
    mov edx, dword ptr [ebp - local_4]           # 0048bc00
    mov ax, word ptr [edx + field_2e]            # 0048bc03
    push eax                                     # 0048bc07
    call FUN_004d3992                            # 0048bc08
    add esp, 0x4                                 # 0048bc0d
L_0048bc10:
    # block 0x0048bc10: entered by je at 0x0048bbfe, 4 instruction(s), ends with je to 0x0048bc2c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048bc10
    movsx edx, word ptr [ecx + field_30]         # 0048bc13
    cmp edx, -0x1                                # 0048bc17
    je.d8 L_0048bc2c                             # 0048bc1a
    # block 0x0048bc1c: entered by fall-through of je at 0x0048bc1a, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0048bc2c
    mov eax, dword ptr [ebp - local_4]           # 0048bc1c
    mov cx, word ptr [eax + field_30]            # 0048bc1f
    push ecx                                     # 0048bc23
    call FUN_004d3992                            # 0048bc24
    add esp, 0x4                                 # 0048bc29
L_0048bc2c:
    # block 0x0048bc2c: entered by je at 0x0048bc1a, 5 instruction(s), calls FUN_0048bb17, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0048bc2c
    call FUN_0048bb17                            # 0048bc2f
    {load} mov esp, ebp                          # 0048bc34
    pop ebp                                      # 0048bc36
    ret                                          # 0048bc37

