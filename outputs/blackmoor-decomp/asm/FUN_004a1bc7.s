# FUN_004a1bc7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1bc7
# extent:       0x004a1bc7-0x004a1bd7 (16 code bytes)
# span:         0x004a1bc7-0x004a1bd7 (code 16, tables 0, padding 0)
# sha256:       c9017cb007709ea8b935efe8bf7bc7707e5dfbe913cdf0f62cac76482a0d3360
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_riddlepuzzle_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a1bc7.c.txt, not original source) refers to the data labelled s_CRiddlePuzzle_0052dc20
# name-note:    Returns the MFC runtime class record for CRiddlePuzzle, shown by the class-name string label.
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

.org 0x004a1bc7 - 0x401000
.globl FUN_004a1bc7
FUN_004a1bc7:
    # block 0x004a1bc7: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004a1bc7
    {load} mov ebp, esp                          # 004a1bc8
    push ecx                                     # 004a1bca
    mov dword ptr [ebp - local_4], ecx           # 004a1bcb
    mov eax, 0x52dc20                            # 004a1bce
    {load} mov esp, ebp                          # 004a1bd3
    pop ebp                                      # 004a1bd5
    ret                                          # 004a1bd6

