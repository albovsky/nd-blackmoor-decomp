# FUN_0041be0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041be0a
# extent:       0x0041be0a-0x0041be1a (16 code bytes)
# span:         0x0041be0a-0x0041be1a (code 16, tables 0, padding 0)
# sha256:       1b60912e8e331a0ce874ba54abe098824a5bec435d6202609d7afad0594e1b51
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_conversation_class_getter
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/41be0a.c.txt, not original source) refers to the data labelled s_CConversation_0052c5f0
# name-note:    Returns the MFC runtime class record for CConversation, shown by the class-name string label.
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

.org 0x0041be0a - 0x401000
.globl FUN_0041be0a
FUN_0041be0a:
    # block 0x0041be0a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0041be0a
    {load} mov ebp, esp                          # 0041be0b
    push ecx                                     # 0041be0d
    mov dword ptr [ebp - local_4], ecx           # 0041be0e
    mov eax, 0x52c5f0                            # 0041be11
    {load} mov esp, ebp                          # 0041be16
    pop ebp                                      # 0041be18
    ret                                          # 0041be19

