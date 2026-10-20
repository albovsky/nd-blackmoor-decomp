# FUN_004a7bfa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7bfa
# extent:       0x004a7bfa-0x004a7c0a (16 code bytes)
# span:         0x004a7bfa-0x004a7c0a (code 16, tables 0, padding 0)
# sha256:       c35a7c5c119681bb6f55f6a1ece788043bb97216e3b92f32430d339c32fd2ac4
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sort_puzzle_runtime_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a7bfa.c.txt, not original source) refers to the data labelled s_CSortPuzzle_0052ddb8
# name-note:    Returns the pointer to the CSortPuzzle MFC runtime-class record; the string label CSortPuzzle names the class.
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

.org 0x004a7bfa - 0x401000
.globl FUN_004a7bfa
FUN_004a7bfa:
    # block 0x004a7bfa: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004a7bfa
    {load} mov ebp, esp                          # 004a7bfb
    push ecx                                     # 004a7bfd
    mov dword ptr [ebp - local_4], ecx           # 004a7bfe
    mov eax, 0x52ddb8                            # 004a7c01
    {load} mov esp, ebp                          # 004a7c06
    pop ebp                                      # 004a7c08
    ret                                          # 004a7c09

