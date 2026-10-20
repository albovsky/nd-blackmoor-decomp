# FUN_0047d477
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d477
# extent:       0x0047d477-0x0047d487 (16 code bytes)
# span:         0x0047d477-0x0047d487 (code 16, tables 0, padding 0)
# sha256:       ac47cebcf09ec17c3482b957776c449ca2fde4d44588545d6a70554ed76020d0
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_mouselightpuzzle_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/47d477.c.txt, not original source) refers to the data labelled s_CMouselightPuzzle_0052d570
# name-note:    Returns the MFC runtime class record for CMouselightPuzzle, shown by the class-name string label.
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

.org 0x0047d477 - 0x401000
.globl FUN_0047d477
FUN_0047d477:
    # block 0x0047d477: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0047d477
    {load} mov ebp, esp                          # 0047d478
    push ecx                                     # 0047d47a
    mov dword ptr [ebp - local_4], ecx           # 0047d47b
    mov eax, 0x52d570                            # 0047d47e
    {load} mov esp, ebp                          # 0047d483
    pop ebp                                      # 0047d485
    ret                                          # 0047d486

