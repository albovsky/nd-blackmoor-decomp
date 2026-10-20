# FUN_004ab327
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab327
# extent:       0x004ab327-0x004ab337 (16 code bytes)
# span:         0x004ab327-0x004ab337 (code 16, tables 0, padding 0)
# sha256:       91a841bb0f8f6586d7dacfebe9f3015602234bef0543f6633d0384dfcc3d8b3d
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_spigot_puzzle_runtime_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4ab327.c.txt, not original source) refers to the data labelled s_CSpigotPuzzle_0052dec8
# name-note:    Returns the pointer to the CSpigotPuzzle MFC runtime-class record; the string label CSpigotPuzzle names the class.
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

.org 0x004ab327 - 0x401000
.globl FUN_004ab327
FUN_004ab327:
    # block 0x004ab327: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004ab327
    {load} mov ebp, esp                          # 004ab328
    push ecx                                     # 004ab32a
    mov dword ptr [ebp - local_4], ecx           # 004ab32b
    mov eax, 0x52dec8                            # 004ab32e
    {load} mov esp, ebp                          # 004ab333
    pop ebp                                      # 004ab335
    ret                                          # 004ab336

