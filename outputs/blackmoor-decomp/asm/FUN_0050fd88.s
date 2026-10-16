# FUN_0050fd88
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050fd88
# extent:       0x0050fd88-0x0050fd95 (13 code bytes)
# span:         0x0050fd88-0x0050fd98 (code 13, tables 0, padding 3)
# sha256:       6fc6569f4c3f3f3c39183d51cd12050ca513fa5a0ca46ec42fad7b575ba0e4a5
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050fa90 (+0x2f8)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050fd88
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8; [edi + n] field_3; [esi + n] field_3
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050fd98
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_3, 0x3  # offset +0x3
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050fd88 - 0x401000
.globl FUN_0050fd88
FUN_0050fd88:
    # block 0x0050fd88: entry, 7 instruction(s), ends with ret
    mov al, byte ptr [esi + field_3]             # 0050fd88
    mov byte ptr [edi + field_3], al             # 0050fd8b
    mov eax, dword ptr [ebp + field_8]           # 0050fd8e
    pop esi                                      # 0050fd91
    pop edi                                      # 0050fd92
    leave                                        # 0050fd93
    ret                                          # 0050fd94

# --- data items (not part of the function) -------------------------
.org 0x0050fd95 - 0x401000
PAD_0050fd95:  # 3 byte(s) of alignment instructions
    {disp8} lea ecx, [ecx]

