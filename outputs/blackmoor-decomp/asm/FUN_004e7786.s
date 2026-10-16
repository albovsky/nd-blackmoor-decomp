# FUN_004e7786
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7786
# extent:       0x004e7786-0x004e779f (25 code bytes)
# span:         0x004e7786-0x004e779f (code 25, tables 0, padding 0)
# sha256:       037e4fc9f01e2cd100472faa3c17e0a1cb9a4e669e251b1441db60cf10a85bb9
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7786
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004edfaf
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004edfaf, .text + (0x004edfaf - 0x401000)

.org 0x004e7786 - 0x401000
.globl FUN_004e7786
FUN_004e7786:
    # block 0x004e7786: entry, 11 instruction(s), calls FUN_004edfaf, ends with ret 0x4
    push ebp                                     # 004e7786
    {load} mov ebp, esp                          # 004e7787
    push ecx                                     # 004e7789
    mov dword ptr [ebp - local_4], ecx           # 004e778a
    mov eax, dword ptr [ebp + arg_8]             # 004e778d
    push eax                                     # 004e7790
    mov ecx, dword ptr [ebp - local_4]           # 004e7791
    call FUN_004edfaf                            # 004e7794
    {load} mov esp, ebp                          # 004e7799
    pop ebp                                      # 004e779b
    ret 0x4                                      # 004e779c

