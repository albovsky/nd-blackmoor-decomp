# FUN_0050fd80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050fd80
# extent:       0x0050fd80-0x0050fd87 (7 code bytes)
# span:         0x0050fd80-0x0050fd88 (code 7, tables 0, padding 1)
# sha256:       42af23f2392dc1efe1fd06612d07b84d932d0880aee40478b800b90322e3b5d0
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050fa90 (+0x2f0)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050fd80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050fd88
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050fd80 - 0x401000
.globl FUN_0050fd80
FUN_0050fd80:
    # block 0x0050fd80: entry, 5 instruction(s), ends with ret
    mov eax, dword ptr [ebp + field_8]           # 0050fd80
    pop esi                                      # 0050fd83
    pop edi                                      # 0050fd84
    leave                                        # 0050fd85
    ret                                          # 0050fd86

# --- data items (not part of the function) -------------------------
.org 0x0050fd87 - 0x401000
PAD_0050fd87:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

