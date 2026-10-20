# FUN_004de413
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de413
# extent:       0x004de413-0x004de440 (45 code bytes)
# span:         0x004de413-0x004de440 (code 45, tables 0, padding 0)
# sha256:       7b7c577f94ba16cac3522c616468659baf66536c0a909bac3ff3d3acb4ee67dd
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de413
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_991; [ecx + n] field_991
# callees:      calls FUN_004ee517
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004ee517, .text + (0x004ee517 - 0x401000)

.org 0x004de413 - 0x401000
.globl FUN_004de413
FUN_004de413:
    # block 0x004de413: entry, 7 instruction(s), ends with je to 0x004de432 (forward)
    push ebp                                     # 004de413
    {load} mov ebp, esp                          # 004de414
    push ecx                                     # 004de416
    mov dword ptr [ebp - local_4], ecx           # 004de417
    mov eax, dword ptr [ebp - local_4]           # 004de41a
    cmp dword ptr [eax + field_991], 0x0         # 004de41d
    je.d8 L_004de432                             # 004de424
    # block 0x004de426: entered by fall-through of je at 0x004de424, 3 instruction(s), ends with jne to 0x004de434 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004de426
    cmp dword ptr [ecx + field_991], 0x1         # 004de429
    jne.d8 L_004de434                            # 004de430
L_004de432:
    # block 0x004de432: entered by je at 0x004de424; fall-through of jne at 0x004de430, 1 instruction(s), ends with forward jump to 0x004de43c
    jmp.d8 L_004de43c                            # 004de432
L_004de434:
    # block 0x004de434: entered by jne at 0x004de430, 2 instruction(s), calls FUN_004ee517, falls into the block at 0x004de43c
    mov ecx, dword ptr [ebp - local_4]           # 004de434
    call FUN_004ee517                            # 004de437
L_004de43c:
    # block 0x004de43c: entered by jmp at 0x004de432, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004de43c
    pop ebp                                      # 004de43e
    ret                                          # 004de43f

