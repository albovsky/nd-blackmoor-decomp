# FUN_00488d5a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00488d5a
# extent:       0x00488d5a-0x00488d6a (16 code bytes)
# span:         0x00488d5a-0x00488d6a (code 16, tables 0, padding 0)
# sha256:       b7876689b620f31338af0ca2ef7f923d7fe3f3730747ffa5b29ea2308db88d1b
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_overlay_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/488d5a.c.txt, not original source) refers to the data labelled s_COverlay_0052d818
# name-note:    Returns the MFC runtime class record for COverlay, shown by the class-name string label.
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

.org 0x00488d5a - 0x401000
.globl FUN_00488d5a
FUN_00488d5a:
    # block 0x00488d5a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00488d5a
    {load} mov ebp, esp                          # 00488d5b
    push ecx                                     # 00488d5d
    mov dword ptr [ebp - local_4], ecx           # 00488d5e
    mov eax, 0x52d818                            # 00488d61
    {load} mov esp, ebp                          # 00488d66
    pop ebp                                      # 00488d68
    ret                                          # 00488d69

