# FUN_0041de29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041de29
# extent:       0x0041de29-0x0041df05 (220 code bytes)
# span:         0x0041de29-0x0041df05 (code 220, tables 0, padding 0)
# sha256:       f563de65c8929cb81c04e5315fc10bba8bfbbde2df69c0d2ed6ffa0a2f8dadaf
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041de29
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_6, field_1e, field_68e; [ecx + n] field_1e, field_694; [edx + n] field_1c
# callees:      calls FUN_0051dc6c, FUN_004c2e5b
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_clear_cache (function ledger class candidate_port; also phase0, phase2; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 60 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_6, 0x6  # offset +0x6
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_68e, 0x68e  # offset +0x68e
.equ field_694, 0x694  # offset +0x694

# --- external targets -----------------------------------------------
.set FUN_004c2e5b, .text + (0x004c2e5b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041de29 - 0x401000
.globl FUN_0041de29
FUN_0041de29:
    # block 0x0041de29: entry, 10 instruction(s), ends with forward jump to 0x0041de5e
    push ebp                                     # 0041de29
    {load} mov ebp, esp                          # 0041de2a
    sub esp, 0x10                                # 0041de2c
    mov dword ptr [ebp - local_10], ecx          # 0041de2f
    mov eax, dword ptr [ebp - local_10]          # 0041de32
    mov word ptr [eax + field_68e], 0x0          # 0041de35
    mov ecx, dword ptr [ebp - local_10]          # 0041de3e
    mov word ptr [ecx + field_694], 0xffff       # 0041de41
    mov word ptr [ebp - local_8], 0x0            # 0041de4a
    jmp.d8 L_0041de5e                            # 0041de50
L_0041de52:
    # block 0x0041de52: entered by jmp at 0x0041defc, 3 instruction(s), falls into the block at 0x0041de5e
    mov dx, word ptr [ebp - local_8]             # 0041de52
    add dx, 0x1                                  # 0041de56
    mov word ptr [ebp - local_8], dx             # 0041de5a
L_0041de5e:
    # block 0x0041de5e: entered by jmp at 0x0041de50, 3 instruction(s), ends with jge to 0x0041df01 (forward)
    movsx eax, word ptr [ebp - local_8]          # 0041de5e
    cmp eax, 0x4b                                # 0041de62
    jge.d32 L_0041df01                           # 0041de65
    # block 0x0041de6b: entered by fall-through of jge at 0x0041de65, 9 instruction(s), ends with je to 0x0041debc (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0041de6b
    imul ecx, ecx, 0x16                          # 0041de6f
    mov edx, dword ptr [ebp - local_10]          # 0041de72
    mov word ptr [edx + ecx + field_1c], 0xffff  # 0041de75
    movsx eax, word ptr [ebp - local_8]          # 0041de7c
    imul eax, eax, 0x16                          # 0041de80
    mov ecx, dword ptr [ebp - local_10]          # 0041de83
    cmp dword ptr [ecx + eax + field_1e], 0x0    # 0041de86
    je.d8 L_0041debc                             # 0041de8b
    # block 0x0041de8d: entered by fall-through of je at 0x0041de8b, 13 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0041debc
    movsx edx, word ptr [ebp - local_8]          # 0041de8d
    imul edx, edx, 0x16                          # 0041de91
    mov eax, dword ptr [ebp - local_10]          # 0041de94
    mov ecx, dword ptr [eax + edx + field_1e]    # 0041de97
    mov dword ptr [ebp - local_c], ecx           # 0041de9b
    mov edx, dword ptr [ebp - local_c]           # 0041de9e
    push edx                                     # 0041dea1
    call FUN_0051dc6c                            # 0041dea2
    add esp, 0x4                                 # 0041dea7
    movsx eax, word ptr [ebp - local_8]          # 0041deaa
    imul eax, eax, 0x16                          # 0041deae
    mov ecx, dword ptr [ebp - local_10]          # 0041deb1
    mov dword ptr [ecx + eax + field_1e], 0x0    # 0041deb4
L_0041debc:
    # block 0x0041debc: entered by je at 0x0041de8b, 2 instruction(s), ends with forward jump to 0x0041ded0
    mov word ptr [ebp - local_4], 0x0            # 0041debc
    jmp.d8 L_0041ded0                            # 0041dec2
L_0041dec4:
    # block 0x0041dec4: entered by jmp at 0x0041defa, 3 instruction(s), falls into the block at 0x0041ded0
    mov dx, word ptr [ebp - local_4]             # 0041dec4
    add dx, 0x1                                  # 0041dec8
    mov word ptr [ebp - local_4], dx             # 0041decc
L_0041ded0:
    # block 0x0041ded0: entered by jmp at 0x0041dec2, 3 instruction(s), ends with jge to 0x0041defc (forward)
    movsx eax, word ptr [ebp - local_4]          # 0041ded0
    cmp eax, 0x4                                 # 0041ded4
    jge.d8 L_0041defc                            # 0041ded7
    # block 0x0041ded9: entered by fall-through of jge at 0x0041ded7, 10 instruction(s), calls FUN_004c2e5b, ends with backward jump to 0x0041dec4
    movsx ecx, word ptr [ebp - local_8]          # 0041ded9
    imul ecx, ecx, 0x16                          # 0041dedd
    mov edx, dword ptr [ebp - local_10]          # 0041dee0
    lea eax, [edx + ecx + field_1c]              # 0041dee3
    movsx ecx, word ptr [ebp - local_4]          # 0041dee7
    mov edx, dword ptr [eax + 4*ecx + field_6]   # 0041deeb
    push edx                                     # 0041deef
    mov ecx, 0x5cf659                            # 0041def0
    call FUN_004c2e5b                            # 0041def5
    jmp.d8 L_0041dec4                            # 0041defa
L_0041defc:
    # block 0x0041defc: entered by jge at 0x0041ded7, 1 instruction(s), ends with backward jump to 0x0041de52
    jmp.d32 L_0041de52                           # 0041defc
L_0041df01:
    # block 0x0041df01: entered by jge at 0x0041de65, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0041df01
    pop ebp                                      # 0041df03
    ret                                          # 0041df04

