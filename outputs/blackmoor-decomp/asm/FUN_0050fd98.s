# FUN_0050fd98
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050fd98
# extent:       0x0050fd98-0x0050fdab (19 code bytes)
# span:         0x0050fd98-0x0050fdac (code 19, tables 0, padding 1)
# sha256:       3fa76665ef8b98ba18fe7cb121cd403af211faa9ce9733fbfd2b8ba98a7a2e7f
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050fa90 (+0x308)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050fd98
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8; [edi + n] field_2, field_3; [esi + n] field_2, field_3
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050fdac
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050fd98 - 0x401000
.globl FUN_0050fd98
FUN_0050fd98:
    # block 0x0050fd98: entry, 9 instruction(s), ends with ret
    mov al, byte ptr [esi + field_3]             # 0050fd98
    mov byte ptr [edi + field_3], al             # 0050fd9b
    mov al, byte ptr [esi + field_2]             # 0050fd9e
    mov byte ptr [edi + field_2], al             # 0050fda1
    mov eax, dword ptr [ebp + field_8]           # 0050fda4
    pop esi                                      # 0050fda7
    pop edi                                      # 0050fda8
    leave                                        # 0050fda9
    ret                                          # 0050fdaa

# --- data items (not part of the function) -------------------------
.org 0x0050fdab - 0x401000
PAD_0050fdab:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

