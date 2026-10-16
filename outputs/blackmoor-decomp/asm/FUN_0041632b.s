# FUN_0041632b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041632b
# extent:       0x0041632b-0x004163b4 (137 code bytes)
# span:         0x0041632b-0x004163b4 (code 137, tables 0, padding 0)
# sha256:       bfae2ec37823ceff388af32a715b28491b58964704c64f4f3359c664eab127bf
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041632b
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_17a, field_17e; [ecx + n] field_17a, field_182; [edx + n] field_17e, field_184
# callees:      calls FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:avf_player_stop (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_182, 0x182  # offset +0x182
.equ field_184, 0x184  # offset +0x184

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0041632b - 0x401000
.globl FUN_0041632b
FUN_0041632b:
    # block 0x0041632b: entry, 7 instruction(s), ends with je to 0x00416365 (forward)
    push ebp                                     # 0041632b
    {load} mov ebp, esp                          # 0041632c
    sub esp, 0xc                                 # 0041632e
    mov dword ptr [ebp - local_c], ecx           # 00416331
    mov eax, dword ptr [ebp + arg_8]             # 00416334
    cmp dword ptr [eax + field_17a], 0x0         # 00416337
    je.d8 L_00416365                             # 0041633e
    # block 0x00416340: entered by fall-through of je at 0x0041633e, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00416365
    mov ecx, dword ptr [ebp + arg_8]             # 00416340
    mov edx, dword ptr [ecx + field_17a]         # 00416343
    mov dword ptr [ebp - local_4], edx           # 00416349
    mov eax, dword ptr [ebp - local_4]           # 0041634c
    push eax                                     # 0041634f
    call FUN_0051dc6c                            # 00416350
    add esp, 0x4                                 # 00416355
    mov ecx, dword ptr [ebp + arg_8]             # 00416358
    mov dword ptr [ecx + field_17a], 0x0         # 0041635b
L_00416365:
    # block 0x00416365: entered by je at 0x0041633e, 3 instruction(s), ends with je to 0x00416396 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00416365
    cmp dword ptr [edx + field_17e], 0x0         # 00416368
    je.d8 L_00416396                             # 0041636f
    # block 0x00416371: entered by fall-through of je at 0x0041636f, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00416396
    mov eax, dword ptr [ebp + arg_8]             # 00416371
    mov ecx, dword ptr [eax + field_17e]         # 00416374
    mov dword ptr [ebp - local_8], ecx           # 0041637a
    mov edx, dword ptr [ebp - local_8]           # 0041637d
    push edx                                     # 00416380
    call FUN_0051dc6c                            # 00416381
    add esp, 0x4                                 # 00416386
    mov eax, dword ptr [ebp + arg_8]             # 00416389
    mov dword ptr [eax + field_17e], 0x0         # 0041638c
L_00416396:
    # block 0x00416396: entered by je at 0x0041636f, 7 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp + arg_8]             # 00416396
    mov word ptr [ecx + field_182], 0x0          # 00416399
    mov edx, dword ptr [ebp + arg_8]             # 004163a2
    mov word ptr [edx + field_184], 0x0          # 004163a5
    {load} mov esp, ebp                          # 004163ae
    pop ebp                                      # 004163b0
    ret 0x4                                      # 004163b1

