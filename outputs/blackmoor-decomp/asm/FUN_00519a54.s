# FUN_00519a54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519a54
# extent:       0x00519a54-0x00519a5a (6 code bytes)
# span:         0x00519a54-0x00519a60 (code 6, tables 0, padding 6)
# sha256:       6ce812a28b520086457f66f15b20482c4fc5fd3c507537d7a8b06a7eb6545dc9
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005199bd (+0x97)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519a54
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump WINSPOOL.DRV!OpenPrinterA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00519a54 - 0x401000
.globl FUN_00519a54
FUN_00519a54:
    # block 0x00519a54: entry, 1 instruction(s), ends with indirect jump dword ptr [0x52a4f8]
    jmp dword ptr [0x52a4f8]                     # 00519a54

# --- data items (not part of the function) -------------------------
.org 0x00519a5a - 0x401000
PAD_00519a5a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

