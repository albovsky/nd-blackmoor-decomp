# FUN_004ebd2e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ebd2e
# extent:       0x004ebd2e-0x004ebd53 (37 code bytes)
# span:         0x004ebd2e-0x004ebd53 (code 37, tables 0, padding 0)
# sha256:       53c368e6660b2ac8fba1c4e83d05f743d49c73a4a449a0408372bdf7478cd93e
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ebd2e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_ca4
# callees:      calls FUN_004edf96
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_ca4, 0xca4  # offset +0xca4

# --- external targets -----------------------------------------------
.set FUN_004edf96, .text + (0x004edf96 - 0x401000)

.org 0x004ebd2e - 0x401000
.globl FUN_004ebd2e
FUN_004ebd2e:
    # block 0x004ebd2e: entry, 14 instruction(s), calls FUN_004edf96, ends with ret 0x4
    push ebp                                     # 004ebd2e
    {load} mov ebp, esp                          # 004ebd2f
    push ecx                                     # 004ebd31
    mov dword ptr [ebp - local_4], ecx           # 004ebd32
    mov eax, dword ptr [ebp - local_4]           # 004ebd35
    mov ecx, dword ptr [ebp + arg_8]             # 004ebd38
    mov dword ptr [eax + field_ca4], ecx         # 004ebd3b
    mov edx, dword ptr [ebp + arg_8]             # 004ebd41
    push edx                                     # 004ebd44
    mov ecx, dword ptr [ebp - local_4]           # 004ebd45
    call FUN_004edf96                            # 004ebd48
    {load} mov esp, ebp                          # 004ebd4d
    pop ebp                                      # 004ebd4f
    ret 0x4                                      # 004ebd50

