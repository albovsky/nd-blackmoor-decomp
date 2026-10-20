# FUN_00446f67
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446f67
# extent:       0x00446f67-0x00446f77 (16 code bytes)
# span:         0x00446f67-0x00446f77 (code 16, tables 0, padding 0)
# sha256:       04f5fd6c21ce243092198cf23dbad0c35cdae7128a3df5f1ef83df5e9db608b3
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_specialeffect_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/446f67.c.txt, not original source) refers to the data labelled s_CSpecialEffect_0052ca20
# name-note:    Returns the MFC runtime class record for CSpecialEffect, shown by the class-name string label.
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

.org 0x00446f67 - 0x401000
.globl FUN_00446f67
FUN_00446f67:
    # block 0x00446f67: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00446f67
    {load} mov ebp, esp                          # 00446f68
    push ecx                                     # 00446f6a
    mov dword ptr [ebp - local_4], ecx           # 00446f6b
    mov eax, 0x52ca20                            # 00446f6e
    {load} mov esp, ebp                          # 00446f73
    pop ebp                                      # 00446f75
    ret                                          # 00446f76

