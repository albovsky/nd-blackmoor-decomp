# FUN_00404aba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404aba
# extent:       0x00404aba-0x00404aca (16 code bytes)
# span:         0x00404aba-0x00404aca (code 16, tables 0, padding 0)
# sha256:       bee39f6587d19312340cd3ac66ec817be42eade8b6067203bb67fc8b1dbc17d6
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_invproppage_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/404aba.c.txt, not original source) refers to the data labelled s_CInvPropPage_0052b358
# name-note:    Returns the MFC runtime class record for CInvPropPage, shown by the class-name string label.
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

.org 0x00404aba - 0x401000
.globl FUN_00404aba
FUN_00404aba:
    # block 0x00404aba: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00404aba
    {load} mov ebp, esp                          # 00404abb
    push ecx                                     # 00404abd
    mov dword ptr [ebp - local_4], ecx           # 00404abe
    mov eax, 0x52b358                            # 00404ac1
    {load} mov esp, ebp                          # 00404ac6
    pop ebp                                      # 00404ac8
    ret                                          # 00404ac9

