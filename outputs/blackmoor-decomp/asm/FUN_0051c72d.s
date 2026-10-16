# FUN_0051c72d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c72d
# extent:       0x0051c72d-0x0051c74f (34 code bytes)
# span:         0x0051c72d-0x0051c74f (code 34, tables 0, padding 0)
# sha256:       11cc8cb133e69b6a351c1159dfc895fb77cdaace4da80aff3a0b287174e0723c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051c618 (+0x115)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c72d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_df; [esp + n] stk_4
# callees:      calls FUN_0052513f, FUN_0051b4cb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_df, 0xdf  # offset +0xdf

# --- external targets -----------------------------------------------
.set FUN_0051b4cb, .text + (0x0051b4cb - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)

.org 0x0051c72d - 0x401000
.globl FUN_0051c72d
FUN_0051c72d:
    # block 0x0051c72d: entry, 2 instruction(s), ends with jne to 0x0051c74a (forward)
    cmp word ptr [esp + stk_4], 0x0              # 0051c72d
    jne.d8 L_0051c74a                            # 0051c733
    # block 0x0051c735: entered by fall-through of jne at 0x0051c733, 3 instruction(s), calls FUN_0052513f, ends with jne to 0x0051c74a (forward)
    call FUN_0052513f                            # 0051c735
    test byte ptr [eax + field_df], 0x40         # 0051c73a
    jne.d8 L_0051c74a                            # 0051c741
    # block 0x0051c743: entered by fall-through of jne at 0x0051c741, 2 instruction(s), calls FUN_0051b4cb, falls into the block at 0x0051c74a
    push 0x1                                     # 0051c743
    call FUN_0051b4cb                            # 0051c745
L_0051c74a:
    # block 0x0051c74a: entered by jne at 0x0051c733; jne at 0x0051c741, 2 instruction(s), ends with ret 0x8
    {load} xor eax, eax                          # 0051c74a
    ret 0x8                                      # 0051c74c

