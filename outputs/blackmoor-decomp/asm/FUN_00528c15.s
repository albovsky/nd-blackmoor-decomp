# FUN_00528c15
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528c15
# extent:       0x00528c15-0x00528c1f (10 code bytes)
# span:         0x00528c15-0x00528c20 (code 10, tables 0, padding 1)
# sha256:       3d31c04e3ef8a3d26325668c2b81c0248fb8822e78e7b1b20beea21672c5e9fa
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528c0c (+0x9)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         eh_handler_stub_of_00524945
# naming:       function-xrefs.json eh_stubs entry (container 0x00528c0c); a structural fact about the bytes
# name-note:    The compiler's exception handler stub (loads the FuncInfo at 0x00533b40 and jumps to the shared handler) of the function at 0x00524945
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump FUN_0050c6c6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name states a structural role that function-xrefs.json records about the bytes; it is not read from this code and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c6c6, .text + (0x0050c6c6 - 0x401000)

.org 0x00528c15 - 0x401000
.globl FUN_00528c15
FUN_00528c15:
    # block 0x00528c15: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x533b40                            # 00528c15
    jmp.d32 FUN_0050c6c6                         # 00528c1a

# --- data items (not part of the function) -------------------------
.org 0x00528c1f - 0x401000
PAD_00528c1f:  # 1 byte(s) of int3 padding
    .fill 1, 1, 0xcc

