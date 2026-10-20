# FUN_004cc917
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cc917
# extent:       0x004cc917-0x004cc927 (16 code bytes)
# span:         0x004cc917-0x004cc927 (code 16, tables 0, padding 0)
# sha256:       3af77a59e949dcd4040d801dc66f2021380d67bbf717c2f84df690970a7b2651
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_matrix_runtime_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4cc917.c.txt, not original source) refers to the data labelled s_CMatrix_0052e240
# name-note:    Returns the pointer to the CMatrix MFC runtime-class record; the string label CMatrix names the class.
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

.org 0x004cc917 - 0x401000
.globl FUN_004cc917
FUN_004cc917:
    # block 0x004cc917: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004cc917
    {load} mov ebp, esp                          # 004cc918
    push ecx                                     # 004cc91a
    mov dword ptr [ebp - local_4], ecx           # 004cc91b
    mov eax, 0x52e240                            # 004cc91e
    {load} mov esp, ebp                          # 004cc923
    pop ebp                                      # 004cc925
    ret                                          # 004cc926

