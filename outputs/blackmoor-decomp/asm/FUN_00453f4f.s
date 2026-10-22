# FUN_00453f4f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00453f4f
# extent:       0x00453f4f-0x00454065 (278 code bytes)
# span:         0x00453f4f-0x00454065 (code 278, tables 0, padding 0)
# sha256:       500438a4bdcfdb20e275ee231b6f59b59fefeb93e7e11ee212b062a9dd314edb
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00453f4f
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_c, field_40, field_ac, field_2a0, field_2a4; [ecx + n] field_20, field_54, field_58, field_e5, field_2a0, field_2a4
# callees:      calls FUN_004c51a5, FUN_004c5b3a, KERNEL32.dll!GetTickCount, FUN_004541cf
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m453f4f_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 80 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_20, 0x20  # offset +0x20
.equ field_40, 0x40  # offset +0x40
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_ac, 0xac  # offset +0xac
.equ field_e5, 0xe5  # offset +0xe5
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2a4, 0x2a4  # offset +0x2a4

# --- external targets -----------------------------------------------
.set FUN_004541cf, .text + (0x004541cf - 0x401000)
.set FUN_004c51a5, .text + (0x004c51a5 - 0x401000)
.set FUN_004c5b3a, .text + (0x004c5b3a - 0x401000)

.org 0x00453f4f - 0x401000
.globl FUN_00453f4f
FUN_00453f4f:
    # block 0x00453f4f: entry, 8 instruction(s), ends with jl to 0x00453f69 (forward)
    push ebp                                     # 00453f4f
    {load} mov ebp, esp                          # 00453f50
    push ecx                                     # 00453f52
    mov dword ptr [ebp - local_4], ecx           # 00453f53
    mov eax, dword ptr [ebp - local_4]           # 00453f56
    mov ecx, dword ptr [ebp + arg_8]             # 00453f59
    cmp ecx, dword ptr [eax + field_ac]          # 00453f5c
    jl.d8 L_00453f69                             # 00453f62
    # block 0x00453f64: entered by fall-through of jl at 0x00453f62, 1 instruction(s), ends with forward jump to 0x0045405f
    jmp.d32 L_0045405f                           # 00453f64
L_00453f69:
    # block 0x00453f69: entered by jl at 0x00453f62, 6 instruction(s), ends with je to 0x00453f84 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00453f69
    imul edx, edx, 0x5c                          # 00453f6c
    mov eax, dword ptr [ebp - local_4]           # 00453f6f
    mov ecx, dword ptr [eax + field_2a0]         # 00453f72
    cmp dword ptr [ecx + edx + field_58], 0x1    # 00453f78
    je.d8 L_00453f84                             # 00453f7d
    # block 0x00453f7f: entered by fall-through of je at 0x00453f7d, 1 instruction(s), ends with forward jump to 0x0045405f
    jmp.d32 L_0045405f                           # 00453f7f
L_00453f84:
    # block 0x00453f84: entered by je at 0x00453f7d, 61 instruction(s), calls FUN_004c51a5, FUN_004c5b3a, KERNEL32.dll!GetTickCount, FUN_004541cf, falls into the block at 0x0045405f
    push 0x549d80                                # 00453f84
    mov edx, dword ptr [ebp + arg_8]             # 00453f89
    imul edx, edx, 0x5c                          # 00453f8c
    mov eax, dword ptr [ebp - local_4]           # 00453f8f
    mov ecx, dword ptr [eax + field_2a0]         # 00453f92
    {load} add ecx, edx                          # 00453f98
    push ecx                                     # 00453f9a
    mov edx, dword ptr [ebp + arg_8]             # 00453f9b
    imul edx, edx, 0x5c                          # 00453f9e
    mov eax, dword ptr [ebp - local_4]           # 00453fa1
    mov ecx, dword ptr [eax + field_2a0]         # 00453fa4
    lea edx, [ecx + edx + field_20]              # 00453faa
    push edx                                     # 00453fae
    mov eax, dword ptr [ebp - local_4]           # 00453faf
    mov ecx, dword ptr [eax + field_2a4]         # 00453fb2
    push ecx                                     # 00453fb8
    mov edx, dword ptr [0x5d15e3]                # 00453fb9
    push edx                                     # 00453fbf
    mov ecx, 0x5cf659                            # 00453fc0
    call FUN_004c51a5                            # 00453fc5
    push 0x549db0                                # 00453fca
    mov eax, dword ptr [ebp + arg_8]             # 00453fcf
    imul eax, eax, 0x5c                          # 00453fd2
    mov ecx, dword ptr [ebp - local_4]           # 00453fd5
    mov edx, dword ptr [ecx + field_2a0]         # 00453fd8
    {load} add edx, eax                          # 00453fde
    push edx                                     # 00453fe0
    mov eax, dword ptr [ebp - local_4]           # 00453fe1
    mov ecx, dword ptr [eax + field_8]           # 00453fe4
    mov edx, dword ptr [ebp + arg_8]             # 00453fe7
    imul edx, edx, 0x5c                          # 00453fea
    mov eax, dword ptr [ebp - local_4]           # 00453fed
    mov eax, dword ptr [eax + field_2a0]         # 00453ff0
    mov edx, dword ptr [eax + edx + field_40]    # 00453ff6
    shl edx, 0x4                                 # 00453ffa
    lea eax, [ecx + edx + field_e5]              # 00453ffd
    push eax                                     # 00454004
    mov ecx, dword ptr [ebp - local_4]           # 00454005
    mov edx, dword ptr [ecx + field_2a4]         # 00454008
    push edx                                     # 0045400e
    mov eax, dword ptr [ebp - local_4]           # 0045400f
    mov ecx, dword ptr [eax + field_c]           # 00454012
    push ecx                                     # 00454015
    mov ecx, 0x5cf659                            # 00454016
    call FUN_004c5b3a                            # 0045401b
    mov edx, dword ptr [ebp + arg_8]             # 00454020
    imul edx, edx, 0x5c                          # 00454023
    mov eax, dword ptr [ebp - local_4]           # 00454026
    mov ecx, dword ptr [eax + field_2a0]         # 00454029
    mov dword ptr [ecx + edx + field_58], 0x2    # 0045402f
    call dword ptr [0x52a23c]                    # 00454037
    add eax, 0x7d                                # 0045403d
    mov edx, dword ptr [ebp + arg_8]             # 00454040
    imul edx, edx, 0x5c                          # 00454043
    mov ecx, dword ptr [ebp - local_4]           # 00454046
    mov ecx, dword ptr [ecx + field_2a0]         # 00454049
    mov dword ptr [ecx + edx + field_54], eax    # 0045404f
    mov edx, dword ptr [ebp + arg_8]             # 00454053
    push edx                                     # 00454056
    mov ecx, dword ptr [ebp - local_4]           # 00454057
    call FUN_004541cf                            # 0045405a
L_0045405f:
    # block 0x0045405f: entered by jmp at 0x00453f64; jmp at 0x00453f7f, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0045405f
    pop ebp                                      # 00454061
    ret 0x4                                      # 00454062

