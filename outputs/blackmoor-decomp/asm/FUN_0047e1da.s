# FUN_0047e1da
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e1da
# extent:       0x0047e1da-0x0047e1ea (16 code bytes)
# span:         0x0047e1da-0x0047e1ea (code 16, tables 0, padding 0)
# sha256:       05f6cc0068e12457acb7860b3da1368878e0ad77b169775bb3b132aab4adb1d7
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_multibuildpuzzle_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/47e1da.c.txt, not original source) refers to the data labelled s_CMultibuildPuzzle_0052d5f8
# name-note:    Returns the MFC runtime class record for CMultibuildPuzzle, shown by the class-name string label.
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

.org 0x0047e1da - 0x401000
.globl FUN_0047e1da
FUN_0047e1da:
    # block 0x0047e1da: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0047e1da
    {load} mov ebp, esp                          # 0047e1db
    push ecx                                     # 0047e1dd
    mov dword ptr [ebp - local_4], ecx           # 0047e1de
    mov eax, 0x52d5f8                            # 0047e1e1
    {load} mov esp, ebp                          # 0047e1e6
    pop ebp                                      # 0047e1e8
    ret                                          # 0047e1e9

