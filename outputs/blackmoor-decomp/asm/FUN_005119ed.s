# FUN_005119ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005119ed
# extent:       0x005119ed-0x00511a08 (27 code bytes)
# span:         0x005119ed-0x00511a08 (code 27, tables 0, padding 0)
# sha256:       bb23b24aa1565f7aeea37813d38f7596e28492fcf4649dc311def39cfa95deaa
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005119ed
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_18, field_1c; [esp + n] stk_8
# callees:      calls FUN_0050c992
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050c992, .text + (0x0050c992 - 0x401000)

.org 0x005119ed - 0x401000
.globl FUN_005119ed
FUN_005119ed:
    # block 0x005119ed: entry, 11 instruction(s), calls FUN_0050c992, ends with ret 0x4
    push ebp                                     # 005119ed
    mov ecx, dword ptr [esp + stk_8]             # 005119ee
    mov ebp, dword ptr [ecx]                     # 005119f2
    mov eax, dword ptr [ecx + field_1c]          # 005119f4
    push eax                                     # 005119f7
    mov eax, dword ptr [ecx + field_18]          # 005119f8
    push eax                                     # 005119fb
    call FUN_0050c992                            # 005119fc
    add esp, 0x8                                 # 00511a01
    pop ebp                                      # 00511a04
    ret 0x4                                      # 00511a05

