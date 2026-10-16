# FUN_0050f048
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f048
# extent:       0x0050f048-0x0050f055 (13 code bytes)
# span:         0x0050f048-0x0050f058 (code 13, tables 0, padding 3)
# sha256:       6fc6569f4c3f3f3c39183d51cd12050ca513fa5a0ca46ec42fad7b575ba0e4a5
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050ed50 (+0x2f8)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f048
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8; [edi + n] field_3; [esi + n] field_3
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050f058
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_3, 0x3  # offset +0x3
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050f048 - 0x401000
.globl FUN_0050f048
FUN_0050f048:
    # block 0x0050f048: entry, 7 instruction(s), ends with ret
    mov al, byte ptr [esi + field_3]             # 0050f048
    mov byte ptr [edi + field_3], al             # 0050f04b
    mov eax, dword ptr [ebp + field_8]           # 0050f04e
    pop esi                                      # 0050f051
    pop edi                                      # 0050f052
    leave                                        # 0050f053
    ret                                          # 0050f054

# --- data items (not part of the function) -------------------------
.org 0x0050f055 - 0x401000
PAD_0050f055:  # 3 byte(s) of alignment instructions
    {disp8} lea ecx, [ecx]

