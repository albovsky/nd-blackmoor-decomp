# FUN_004ada56
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ada56
# extent:       0x004ada56-0x004ada9f (73 code bytes)
# span:         0x004ada56-0x004ada9f (code 73, tables 0, padding 0)
# sha256:       395e1489e42bd68dc0b892176d81639dd13545423bb2636a9bb11da70a4223cb
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ada56
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c17; [ecx + n] field_255
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_255, 0x255  # offset +0x255
.equ field_c17, 0xc17  # offset +0xc17

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004ada56 - 0x401000
.globl FUN_004ada56
FUN_004ada56:
    # block 0x004ada56: entry, 14 instruction(s), ends with je to 0x004ada99 (forward)
    push ebp                                     # 004ada56
    {load} mov ebp, esp                          # 004ada57
    push ecx                                     # 004ada59
    push esi                                     # 004ada5a
    push edi                                     # 004ada5b
    mov dword ptr [ebp - local_4], ecx           # 004ada5c
    mov edi, 0x5511e0                            # 004ada5f
    mov eax, dword ptr [ebp - local_4]           # 004ada64
    mov esi, dword ptr [eax + field_c17]         # 004ada67
    add esi, 0x234                               # 004ada6d
    mov ecx, 0x9                                 # 004ada73
    {load} xor edx, edx                          # 004ada78
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ada7a
    je.d8 L_004ada99                             # 004ada7c
    # block 0x004ada7e: entered by fall-through of je at 0x004ada7c, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004ada99
    mov eax, dword ptr [ebp - local_4]           # 004ada7e
    mov ecx, dword ptr [eax + field_c17]         # 004ada81
    mov dx, word ptr [ecx + field_255]           # 004ada87
    push edx                                     # 004ada8e
    mov ecx, 0x5c3a67                            # 004ada8f
    call FUN_004fb2e3                            # 004ada94
L_004ada99:
    # block 0x004ada99: entered by je at 0x004ada7c, 5 instruction(s), ends with ret
    pop edi                                      # 004ada99
    pop esi                                      # 004ada9a
    {load} mov esp, ebp                          # 004ada9b
    pop ebp                                      # 004ada9d
    ret                                          # 004ada9e

