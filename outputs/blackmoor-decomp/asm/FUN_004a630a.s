# FUN_004a630a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a630a
# extent:       0x004a630a-0x004a631a (16 code bytes)
# span:         0x004a630a-0x004a631a (code 16, tables 0, padding 0)
# sha256:       afaf887ba21832a6c91d5dc4719425f567094354e6f9986b44d29d92d629d336
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_safedialpuzzle_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a630a.c.txt, not original source) refers to the data labelled s_CSafeDialPuzzle_0052dd30
# name-note:    Returns the MFC runtime class record for CSafeDialPuzzle, shown by the class-name string label.
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

.org 0x004a630a - 0x401000
.globl FUN_004a630a
FUN_004a630a:
    # block 0x004a630a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004a630a
    {load} mov ebp, esp                          # 004a630b
    push ecx                                     # 004a630d
    mov dword ptr [ebp - local_4], ecx           # 004a630e
    mov eax, 0x52dd30                            # 004a6311
    {load} mov esp, ebp                          # 004a6316
    pop ebp                                      # 004a6318
    ret                                          # 004a6319

