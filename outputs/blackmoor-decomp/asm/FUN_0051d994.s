# FUN_0051d994
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d994
# extent:       0x0051d994-0x0051d9a9 (21 code bytes)
# span:         0x0051d994-0x0051d9a9 (code 21, tables 0, padding 0)
# sha256:       eb39ec15bd9fc64f0db99dfeb6c79c0bffb12e885533d3064e7edb9d744be592
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d994
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [edx + n] field_90
# callees:      calls FUN_00525371; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0051d9a9
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051d994 - 0x401000
.globl FUN_0051d994
FUN_0051d994:
    # block 0x0051d994: entry, 7 instruction(s), calls FUN_00525371, indirect dword ptr [edx + 0x90], ends with ret
    call FUN_00525371                            # 0051d994
    mov eax, dword ptr [eax + field_4]           # 0051d999
    push -0x1                                    # 0051d99c
    {load} mov ecx, eax                          # 0051d99e
    mov edx, dword ptr [eax]                     # 0051d9a0
    call dword ptr [edx + field_90]              # 0051d9a2
    ret                                          # 0051d9a8

