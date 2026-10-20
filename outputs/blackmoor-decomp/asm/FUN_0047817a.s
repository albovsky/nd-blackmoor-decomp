# FUN_0047817a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047817a
# extent:       0x0047817a-0x0047818a (16 code bytes)
# span:         0x0047817a-0x0047818a (code 16, tables 0, padding 0)
# sha256:       e4f25c6293420ad13324839ebe349f8469bbf887a1ff727344bb62aaa31cf671
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_mazechasepuzzle_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/47817a.c.txt, not original source) refers to the data labelled s_CMazeChasePuzzle_0052d4e0
# name-note:    Returns the MFC runtime class record for CMazeChasePuzzle, shown by the class-name string label.
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

.org 0x0047817a - 0x401000
.globl FUN_0047817a
FUN_0047817a:
    # block 0x0047817a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0047817a
    {load} mov ebp, esp                          # 0047817b
    push ecx                                     # 0047817d
    mov dword ptr [ebp - local_4], ecx           # 0047817e
    mov eax, 0x52d4e0                            # 00478181
    {load} mov esp, ebp                          # 00478186
    pop ebp                                      # 00478188
    ret                                          # 00478189

