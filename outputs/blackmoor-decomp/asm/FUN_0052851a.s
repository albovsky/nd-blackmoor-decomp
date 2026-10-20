# FUN_0052851a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052851a
# extent:       0x0052851a-0x00528524 (10 code bytes)
# span:         0x0052851a-0x00528524 (code 10, tables 0, padding 0)
# sha256:       f148877d5fe5497607ec57c1238b34b410ba4a2878b11b66023e2c2b74ae3a95
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00528510 (+0xa)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         eh_handler_stub_of_00490480
# naming:       function-xrefs.json eh_stubs entry (container 0x00528510); a structural fact about the bytes
# name-note:    The compiler's exception handler stub (loads the FuncInfo at 0x00532fb0 and jumps to the shared handler) of the function at 0x00490480
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

.org 0x0052851a - 0x401000
.globl FUN_0052851a
FUN_0052851a:
    # block 0x0052851a: entry, 2 instruction(s), ends with backward jump to 0x0050c6c6
    mov eax, 0x532fb0                            # 0052851a
    jmp.d32 FUN_0050c6c6                         # 0052851f

