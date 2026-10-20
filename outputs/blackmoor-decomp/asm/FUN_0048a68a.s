# FUN_0048a68a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a68a
# extent:       0x0048a68a-0x0048a69a (16 code bytes)
# span:         0x0048a68a-0x0048a69a (code 16, tables 0, padding 0)
# sha256:       043100dd55e6f1f0c0ec7c6a34e01f5228726f431c9124dd62df0c86c08dc0a8
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_overridelockpuzzle_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/48a68a.c.txt, not original source) refers to the data labelled s_COverrideLockPuzzle_0052d8a0
# name-note:    Returns the MFC runtime class record for COverrideLockPuzzle, shown by the class-name string label.
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

.org 0x0048a68a - 0x401000
.globl FUN_0048a68a
FUN_0048a68a:
    # block 0x0048a68a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048a68a
    {load} mov ebp, esp                          # 0048a68b
    push ecx                                     # 0048a68d
    mov dword ptr [ebp - local_4], ecx           # 0048a68e
    mov eax, 0x52d8a0                            # 0048a691
    {load} mov esp, ebp                          # 0048a696
    pop ebp                                      # 0048a698
    ret                                          # 0048a699

