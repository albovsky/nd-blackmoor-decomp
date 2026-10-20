# FUN_00456c87
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456c87
# extent:       0x00456c87-0x00456c97 (16 code bytes)
# span:         0x00456c87-0x00456c97 (code 16, tables 0, padding 0)
# sha256:       7b31418b1e7cb26aa3faaaaedf383cae253c6053f0fa6439fa63b24a0d31c75f
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_bballpuzzle_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/456c87.c.txt, not original source) refers to the data labelled s_CBballPuzzle_0052cda0
# name-note:    Returns the MFC runtime class record for CBballPuzzle, shown by the class-name string label.
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

.org 0x00456c87 - 0x401000
.globl FUN_00456c87
FUN_00456c87:
    # block 0x00456c87: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00456c87
    {load} mov ebp, esp                          # 00456c88
    push ecx                                     # 00456c8a
    mov dword ptr [ebp - local_4], ecx           # 00456c8b
    mov eax, 0x52cda0                            # 00456c8e
    {load} mov esp, ebp                          # 00456c93
    pop ebp                                      # 00456c95
    ret                                          # 00456c96

