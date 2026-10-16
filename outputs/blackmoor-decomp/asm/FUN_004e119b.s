# FUN_004e119b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e119b
# extent:       0x004e119b-0x004e11ed (82 code bytes)
# span:         0x004e119b-0x004e11ed (code 82, tables 0, padding 0)
# sha256:       c250553bd28a2d539f37b0dd22e33eb5f485e66a4c0044a0be880ed98dae9832
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e119b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_f2e; [ecx + n] field_f2e; [edx + n] field_74f
# callees:      calls FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_74f, 0x74f  # offset +0x74f
.equ field_f2e, 0xf2e  # offset +0xf2e

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004e119b - 0x401000
.globl FUN_004e119b
FUN_004e119b:
    # block 0x004e119b: entry, 7 instruction(s), ends with je to 0x004e11e9 (forward)
    push ebp                                     # 004e119b
    {load} mov ebp, esp                          # 004e119c
    push ecx                                     # 004e119e
    mov dword ptr [ebp - local_4], ecx           # 004e119f
    mov eax, dword ptr [ebp - local_4]           # 004e11a2
    cmp dword ptr [eax + field_f2e], 0x0         # 004e11a5
    je.d8 L_004e11e9                             # 004e11ac
    # block 0x004e11ae: entered by fall-through of je at 0x004e11ac, 16 instruction(s), calls FUN_004c5377, falls into the block at 0x004e11e9
    mov ecx, dword ptr [ebp - local_4]           # 004e11ae
    mov dword ptr [ecx + field_f2e], 0x0         # 004e11b1
    push 0x55be74                                # 004e11bb
    mov edx, dword ptr [ebp - local_4]           # 004e11c0
    add edx, 0x45                                # 004e11c3
    push edx                                     # 004e11c6
    mov eax, dword ptr [ebp - local_4]           # 004e11c7
    add eax, 0x45                                # 004e11ca
    push eax                                     # 004e11cd
    mov ecx, dword ptr [0x5cf665]                # 004e11ce
    push ecx                                     # 004e11d4
    mov edx, dword ptr [ebp - local_4]           # 004e11d5
    mov eax, dword ptr [edx + field_74f]         # 004e11d8
    push eax                                     # 004e11de
    mov ecx, 0x5cf659                            # 004e11df
    call FUN_004c5377                            # 004e11e4
L_004e11e9:
    # block 0x004e11e9: entered by je at 0x004e11ac, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e11e9
    pop ebp                                      # 004e11eb
    ret                                          # 004e11ec

