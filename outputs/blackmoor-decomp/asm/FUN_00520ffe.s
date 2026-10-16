# FUN_00520ffe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520ffe
# extent:       0x00520ffe-0x00521014 (22 code bytes)
# span:         0x00520ffe-0x00521014 (code 22, tables 0, padding 0)
# sha256:       9fc8d0668c3156c5ab5f64f3af651fd349db6fd4b64257fba0a836297cd0d4cc
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520ffe
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4
# callees:      calls FUN_00520fd4, GDI32.dll!DeleteObject
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00520fd4, .text + (0x00520fd4 - 0x401000)

.org 0x00520ffe - 0x401000
.globl FUN_00520ffe
FUN_00520ffe:
    # block 0x00520ffe: entry, 2 instruction(s), ends with jne to 0x00521007 (forward)
    cmp dword ptr [ecx + field_4], 0x0           # 00520ffe
    jne.d8 L_00521007                            # 00521002
    # block 0x00521004: entered by fall-through of jne at 0x00521002, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00521004
    ret                                          # 00521006
L_00521007:
    # block 0x00521007: entered by jne at 0x00521002, 4 instruction(s), calls FUN_00520fd4, GDI32.dll!DeleteObject, ends with ret
    call FUN_00520fd4                            # 00521007
    push eax                                     # 0052100c
    call dword ptr [0x52a090]                    # 0052100d
    ret                                          # 00521013

