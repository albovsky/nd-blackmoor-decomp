# FUN_005273b7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005273b7
# extent:       0x005273b7-0x005273c1 (10 code bytes)
# span:         0x005273b7-0x005273d0 (code 10, tables 0, padding 15)
# sha256:       028e8848dba0ae823f588339acb1c794d0bce0b1ac801f346fe8e321fa972b7e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005273ac (+0xb)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         eh_handler_stub_of_00420c17
# naming:       function-xrefs.json eh_stubs entry (container 0x005273ac); a structural fact about the bytes
# name-note:    The compiler's exception handler stub (loads the FuncInfo at 0x00531e30 and jumps to the shared handler) of the function at 0x00420c17
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

.org 0x005273b7 - 0x401000
.globl FUN_005273b7
FUN_005273b7:
    # block 0x005273b7: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x531e30                            # 005273b7
    jmp.d32 FUN_0050c6c6                         # 005273bc

# --- data items (not part of the function) -------------------------
.org 0x005273c1 - 0x401000
PAD_005273c1:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

