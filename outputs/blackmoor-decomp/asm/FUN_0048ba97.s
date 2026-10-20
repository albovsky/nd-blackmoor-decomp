# FUN_0048ba97
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ba97
# extent:       0x0048ba97-0x0048baa7 (16 code bytes)
# span:         0x0048ba97-0x0048baa7 (code 16, tables 0, padding 0)
# sha256:       ed9e2f182dc784bb61c37991046d4aad9f5ffcb99084080a477b66a2a1de7c40
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_peepholepuzzle_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/48ba97.c.txt, not original source) refers to the data labelled s_CPeepholePuzzle_0052d928
# name-note:    Returns the MFC runtime class record for CPeepholePuzzle, shown by the class-name string label.
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

.org 0x0048ba97 - 0x401000
.globl FUN_0048ba97
FUN_0048ba97:
    # block 0x0048ba97: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048ba97
    {load} mov ebp, esp                          # 0048ba98
    push ecx                                     # 0048ba9a
    mov dword ptr [ebp - local_4], ecx           # 0048ba9b
    mov eax, 0x52d928                            # 0048ba9e
    {load} mov esp, ebp                          # 0048baa3
    pop ebp                                      # 0048baa5
    ret                                          # 0048baa6

