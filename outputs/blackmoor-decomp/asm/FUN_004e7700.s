# FUN_004e7700
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7700
# extent:       0x004e7700-0x004e7728 (40 code bytes)
# span:         0x004e7700-0x004e7728 (code 40, tables 0, padding 0)
# sha256:       4e22cb3f47e65711b7ce9125e0f5f25a949c8fd1b2aaaf0dd8eb58a294121c25
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7700
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004edcb1, FUN_004ee6c7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004edcb1, .text + (0x004edcb1 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)

.org 0x004e7700 - 0x401000
.globl FUN_004e7700
FUN_004e7700:
    # block 0x004e7700: entry, 16 instruction(s), calls FUN_004edcb1, FUN_004ee6c7, ends with ret
    push ebp                                     # 004e7700
    {load} mov ebp, esp                          # 004e7701
    push ecx                                     # 004e7703
    mov dword ptr [ebp - local_4], ecx           # 004e7704
    push 0x1                                     # 004e7707
    mov eax, dword ptr [ebp - local_4]           # 004e7709
    add eax, 0x691                               # 004e770c
    push eax                                     # 004e7711
    mov ecx, dword ptr [ebp - local_4]           # 004e7712
    call FUN_004edcb1                            # 004e7715
    push 0x1                                     # 004e771a
    mov ecx, dword ptr [ebp - local_4]           # 004e771c
    call FUN_004ee6c7                            # 004e771f
    {load} mov esp, ebp                          # 004e7724
    pop ebp                                      # 004e7726
    ret                                          # 004e7727

