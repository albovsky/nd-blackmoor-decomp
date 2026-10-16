# FUN_004be44d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be44d
# extent:       0x004be44d-0x004be48a (61 code bytes)
# span:         0x004be44d-0x004be48a (code 61, tables 0, padding 0)
# sha256:       e3e48d8140380f8279e5c7149bfa45a853e27f77225ec8838f8019684377b374
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004be44d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_39f
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_39f, 0x39f  # offset +0x39f

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004be44d - 0x401000
.globl FUN_004be44d
FUN_004be44d:
    # block 0x004be44d: entry, 13 instruction(s), ends with je to 0x004be484 (forward)
    push ebp                                     # 004be44d
    {load} mov ebp, esp                          # 004be44e
    push ecx                                     # 004be450
    push esi                                     # 004be451
    push edi                                     # 004be452
    mov dword ptr [ebp - local_4], ecx           # 004be453
    mov edi, 0x552164                            # 004be456
    mov esi, dword ptr [ebp - local_4]           # 004be45b
    add esi, 0x37e                               # 004be45e
    mov ecx, 0x9                                 # 004be464
    {load} xor eax, eax                          # 004be469
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004be46b
    je.d8 L_004be484                             # 004be46d
    # block 0x004be46f: entered by fall-through of je at 0x004be46d, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004be484
    mov ecx, dword ptr [ebp - local_4]           # 004be46f
    mov dx, word ptr [ecx + field_39f]           # 004be472
    push edx                                     # 004be479
    mov ecx, 0x5c3a67                            # 004be47a
    call FUN_004fb2e3                            # 004be47f
L_004be484:
    # block 0x004be484: entered by je at 0x004be46d, 5 instruction(s), ends with ret
    pop edi                                      # 004be484
    pop esi                                      # 004be485
    {load} mov esp, ebp                          # 004be486
    pop ebp                                      # 004be488
    ret                                          # 004be489

