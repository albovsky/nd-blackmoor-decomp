# FUN_00519a3c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519a3c
# extent:       0x00519a3c-0x00519a42 (6 code bytes)
# span:         0x00519a3c-0x00519a42 (code 6, tables 0, padding 0)
# sha256:       427449d339cd2fd909c969f964a5261080df47bae82ca77f44bbfd025d25404e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005199bd (+0x7f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         import_thunk_comdlg32_PrintDlgA
# naming:       function-xrefs.json thunks entry (kind import, container 0x005199bd); a structural fact about the bytes
# name-note:    A 6-byte indirect jump through the import address table slot of comdlg32.dll!PrintDlgA
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls tail jump comdlg32.dll!PrintDlgA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name states a structural role that function-xrefs.json records about the bytes; it is not read from this code and not a recovered name
# note:         further_unindexed_code_at:0x00519a42
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00519a3c - 0x401000
.globl FUN_00519a3c
FUN_00519a3c:
    # block 0x00519a3c: entry, 1 instruction(s), ends with indirect jump dword ptr [0x52a540]
    jmp dword ptr [0x52a540]                     # 00519a3c

