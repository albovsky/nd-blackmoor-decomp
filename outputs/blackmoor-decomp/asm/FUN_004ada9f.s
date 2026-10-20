# FUN_004ada9f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ada9f
# extent:       0x004ada9f-0x004adae8 (73 code bytes)
# span:         0x004ada9f-0x004adae8 (code 73, tables 0, padding 0)
# sha256:       88e29d792b116b571643883e0a2a09947bd9d588aa56e35ab602c4396955aaca
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ada9f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c17; [ecx + n] field_286
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_286, 0x286  # offset +0x286
.equ field_c17, 0xc17  # offset +0xc17

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004ada9f - 0x401000
.globl FUN_004ada9f
FUN_004ada9f:
    # block 0x004ada9f: entry, 14 instruction(s), ends with je to 0x004adae2 (forward)
    push ebp                                     # 004ada9f
    {load} mov ebp, esp                          # 004adaa0
    push ecx                                     # 004adaa2
    push esi                                     # 004adaa3
    push edi                                     # 004adaa4
    mov dword ptr [ebp - local_4], ecx           # 004adaa5
    mov edi, 0x5511ec                            # 004adaa8
    mov eax, dword ptr [ebp - local_4]           # 004adaad
    mov esi, dword ptr [eax + field_c17]         # 004adab0
    add esi, 0x265                               # 004adab6
    mov ecx, 0x9                                 # 004adabc
    {load} xor edx, edx                          # 004adac1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004adac3
    je.d8 L_004adae2                             # 004adac5
    # block 0x004adac7: entered by fall-through of je at 0x004adac5, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004adae2
    mov eax, dword ptr [ebp - local_4]           # 004adac7
    mov ecx, dword ptr [eax + field_c17]         # 004adaca
    mov dx, word ptr [ecx + field_286]           # 004adad0
    push edx                                     # 004adad7
    mov ecx, 0x5c3a67                            # 004adad8
    call FUN_004fb2e3                            # 004adadd
L_004adae2:
    # block 0x004adae2: entered by je at 0x004adac5, 5 instruction(s), ends with ret
    pop edi                                      # 004adae2
    pop esi                                      # 004adae3
    {load} mov esp, ebp                          # 004adae4
    pop ebp                                      # 004adae6
    ret                                          # 004adae7

