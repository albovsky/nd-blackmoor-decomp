# FUN_0043eb1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043eb1a
# extent:       0x0043eb1a-0x0043eb2a (16 code bytes)
# span:         0x0043eb1a-0x0043eb2a (code 16, tables 0, padding 0)
# sha256:       4600648dea79a048651f850af07d624bdfd3ee23156d6e4ac91ca60ddab61c70
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_mainframe_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/43eb1a.c.txt, not original source) refers to the data labelled s_CMainFrame_0052c7c0
# name-note:    Returns the MFC runtime class record for CMainFrame, shown by the class-name string label.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0043eb1a - 0x401000
.globl FUN_0043eb1a
FUN_0043eb1a:
    # block 0x0043eb1a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0043eb1a
    {load} mov ebp, esp                          # 0043eb1b
    push ecx                                     # 0043eb1d
    mov dword ptr [ebp - local_4], ecx           # 0043eb1e
    mov eax, 0x52c7c0                            # 0043eb21
    {load} mov esp, ebp                          # 0043eb26
    pop ebp                                      # 0043eb28
    ret                                          # 0043eb29

