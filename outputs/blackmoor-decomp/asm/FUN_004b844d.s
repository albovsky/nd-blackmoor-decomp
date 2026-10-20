# FUN_004b844d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b844d
# extent:       0x004b844d-0x004b8520 (211 code bytes)
# span:         0x004b844d-0x004b8520 (code 211, tables 0, padding 0)
# sha256:       87601d720680d616aa12e82603d5c6a2dc622fe6ee454cbee278c30405cd214b
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         score_update
# naming:       native port src/action_family_f5_runtime.c:score_update (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with score_update (float scale, __ftol low word, time-up). 53-bit x87 emulation is verified only by the oracle; native uses host double arithmetic.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_8, field_10, field_45c, field_54e, field_552, field_632; [ecx + n] field_45a, field_552; [edx + n] field_8, field_54e, field_556
# callees:      calls FUN_0050ce04, FUN_0044655e
# track-n:      outputs/blackmoor-decomp/src/action_family_f5_runtime.c:score_update (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 59 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ field_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_45a, 0x45a  # offset +0x45a
.equ field_45c, 0x45c  # offset +0x45c
.equ field_54e, 0x54e  # offset +0x54e
.equ field_552, 0x552  # offset +0x552
.equ field_556, 0x556  # offset +0x556
.equ field_632, 0x632  # offset +0x632

# --- external targets -----------------------------------------------
.set FUN_0044655e, .text + (0x0044655e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004b844d - 0x401000
.globl FUN_004b844d
FUN_004b844d:
    # block 0x004b844d: entry, 12 instruction(s), ends with jle to 0x004b84d8 (forward)
    push ebp                                     # 004b844d
    {load} mov ebp, esp                          # 004b844e
    sub esp, 0x24                                # 004b8450
    mov dword ptr [ebp - local_c], ecx           # 004b8453
    mov eax, dword ptr [ebp - local_c]           # 004b8456
    mov eax, dword ptr [eax + field_632]         # 004b8459
    {load} xor edx, edx                          # 004b845f
    mov ecx, 0x3e8                               # 004b8461
    div ecx                                      # 004b8466
    mov dword ptr [ebp - local_4], eax           # 004b8468
    cmp dword ptr [ebp - local_4], 0x0           # 004b846b
    jle.d8 L_004b84d8                            # 004b846f
    # block 0x004b8471: entered by fall-through of jle at 0x004b846f, 3 instruction(s), ends with je to 0x004b84d8 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b8471
    cmp dword ptr [edx + field_54e], 0x0         # 004b8474
    je.d8 L_004b84d8                             # 004b847b
    # block 0x004b847d: entered by fall-through of je at 0x004b847b, 24 instruction(s), calls FUN_0050ce04, falls into the block at 0x004b84d8
    mov eax, dword ptr [ebp - local_c]           # 004b847d
    mov ecx, dword ptr [eax + field_54e]         # 004b8480
    mov dword ptr [ebp - local_14], ecx          # 004b8486
    mov dword ptr [ebp - local_10], 0x0          # 004b8489
    fild qword ptr [ebp - local_14]              # 004b8490
    fstp dword ptr [ebp - local_18]              # 004b8493
    mov edx, dword ptr [ebp - local_c]           # 004b8496
    mov eax, dword ptr [edx + field_8]           # 004b8499
    movsx ecx, word ptr [eax + field_45c]        # 004b849c
    mov dword ptr [ebp - local_1c], ecx          # 004b84a3
    fild dword ptr [ebp - local_1c]              # 004b84a6
    fstp dword ptr [ebp - local_20]              # 004b84a9
    fild dword ptr [ebp - local_4]               # 004b84ac
    fstp dword ptr [ebp - local_24]              # 004b84af
    fld dword ptr [ebp - local_20]               # 004b84b2
    fmul dword ptr [ebp - local_24]              # 004b84b5
    fdivr dword ptr [ebp - local_18]             # 004b84b8
    fmul dword ptr [0x52e1fc]                    # 004b84bb
    fstp dword ptr [ebp - local_8]               # 004b84c1
    fld dword ptr [ebp - local_8]                # 004b84c4
    call FUN_0050ce04                            # 004b84c7
    movsx edx, ax                                # 004b84cc
    mov eax, dword ptr [ebp - local_c]           # 004b84cf
    mov dword ptr [eax + field_552], edx         # 004b84d2
L_004b84d8:
    # block 0x004b84d8: entered by jle at 0x004b846f; je at 0x004b847b, 5 instruction(s), ends with je to 0x004b8500 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b84d8
    mov edx, dword ptr [ebp - local_c]           # 004b84db
    mov eax, dword ptr [ecx + field_552]         # 004b84de
    cmp eax, dword ptr [edx + field_556]         # 004b84e4
    je.d8 L_004b8500                             # 004b84ea
    # block 0x004b84ec: entered by fall-through of je at 0x004b84ea, 5 instruction(s), calls FUN_0044655e, falls into the block at 0x004b8500
    mov ecx, dword ptr [ebp - local_c]           # 004b84ec
    mov edx, dword ptr [ecx + field_552]         # 004b84ef
    push edx                                     # 004b84f5
    mov ecx, 0x638603                            # 004b84f6
    call FUN_0044655e                            # 004b84fb
L_004b8500:
    # block 0x004b8500: entered by je at 0x004b84ea, 5 instruction(s), ends with jl to 0x004b851c (forward)
    mov eax, dword ptr [ebp - local_c]           # 004b8500
    mov ecx, dword ptr [eax + field_8]           # 004b8503
    movsx edx, word ptr [ecx + field_45a]        # 004b8506
    cmp dword ptr [ebp - local_4], edx           # 004b850d
    jl.d8 L_004b851c                             # 004b8510
    # block 0x004b8512: entered by fall-through of jl at 0x004b8510, 2 instruction(s), falls into the block at 0x004b851c
    mov eax, dword ptr [ebp - local_c]           # 004b8512
    mov dword ptr [eax + field_10], 0x1          # 004b8515
L_004b851c:
    # block 0x004b851c: entered by jl at 0x004b8510, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b851c
    pop ebp                                      # 004b851e
    ret                                          # 004b851f

