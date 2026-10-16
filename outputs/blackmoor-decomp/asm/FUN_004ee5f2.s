# FUN_004ee5f2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee5f2
# extent:       0x004ee5f2-0x004ee602 (16 code bytes)
# span:         0x004ee5f2-0x004ee602 (code 16, tables 0, padding 0)
# sha256:       e283c83a9c059045f82ecb57d4b465ad2026db6f5d838be595e3620edbddc9c0
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee5f2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004ee5f2 - 0x401000
.globl FUN_004ee5f2
FUN_004ee5f2:
    # block 0x004ee5f2: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004ee5f2
    {load} mov ebp, esp                          # 004ee5f3
    push ecx                                     # 004ee5f5
    mov dword ptr [ebp - local_4], ecx           # 004ee5f6
    mov eax, dword ptr [0x63aa10]                # 004ee5f9
    {load} mov esp, ebp                          # 004ee5fe
    pop ebp                                      # 004ee600
    ret                                          # 004ee601

