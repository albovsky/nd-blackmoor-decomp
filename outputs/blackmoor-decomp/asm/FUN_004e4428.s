# FUN_004e4428
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e4428
# extent:       0x004e4428-0x004e444d (37 code bytes)
# span:         0x004e4428-0x004e444d (code 37, tables 0, padding 0)
# sha256:       e780f24526a8ce55c052f096f00109b1125169a3a42e5e188a7b3ced5ac222f7
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e4428
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004e4428 - 0x401000
.globl FUN_004e4428
FUN_004e4428:
    # block 0x004e4428: entry, 17 instruction(s), ends with ret 0x8
    push ebp                                     # 004e4428
    {load} mov ebp, esp                          # 004e4429
    push ecx                                     # 004e442b
    push esi                                     # 004e442c
    push edi                                     # 004e442d
    mov dword ptr [ebp - local_4], ecx           # 004e442e
    mov ecx, 0x43b                               # 004e4431
    mov esi, dword ptr [ebp + arg_8]             # 004e4436
    mov edi, dword ptr [ebp - local_4]           # 004e4439
    add edi, 0x54df                              # 004e443c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e4442
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e4444
    pop edi                                      # 004e4445
    pop esi                                      # 004e4446
    {load} mov esp, ebp                          # 004e4447
    pop ebp                                      # 004e4449
    ret 0x8                                      # 004e444a

