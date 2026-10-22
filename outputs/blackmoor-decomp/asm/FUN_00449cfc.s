# FUN_00449cfc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449cfc
# extent:       0x00449cfc-0x00449d37 (59 code bytes)
# span:         0x00449cfc-0x00449d37 (code 59, tables 0, padding 0)
# sha256:       c0c8270dbf71e4e3db208b4800765d7e3f3f434aa089db51766fc962dfb17898
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00449cfc
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_28, field_36
# callees:      calls KERNEL32.dll!SetThreadPriority
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m449cfc_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_28, 0x28  # offset +0x28
.equ field_36, 0x36  # offset +0x36

# --- external targets -----------------------------------------------

.org 0x00449cfc - 0x401000
.globl FUN_00449cfc
FUN_00449cfc:
    # block 0x00449cfc: entry, 16 instruction(s), calls KERNEL32.dll!SetThreadPriority, ends with je to 0x00449d2f (forward)
    push ebp                                     # 00449cfc
    {load} mov ebp, esp                          # 00449cfd
    sub esp, 0xc                                 # 00449cff
    mov dword ptr [ebp - local_c], ecx           # 00449d02
    mov eax, dword ptr [ebp - local_c]           # 00449d05
    mov ecx, dword ptr [eax + field_36]          # 00449d08
    mov dword ptr [ebp - local_8], ecx           # 00449d0b
    mov edx, dword ptr [ebp + arg_8]             # 00449d0e
    push edx                                     # 00449d11
    mov eax, dword ptr [ebp - local_8]           # 00449d12
    mov ecx, dword ptr [eax + field_28]          # 00449d15
    push ecx                                     # 00449d18
    call dword ptr [0x52a2ac]                    # 00449d19
    mov dword ptr [ebp - local_4], eax           # 00449d1f
    cmp dword ptr [ebp - local_4], 0x0           # 00449d22
    je.d8 L_00449d2f                             # 00449d26
    # block 0x00449d28: entered by fall-through of je at 0x00449d26, 2 instruction(s), ends with forward jump to 0x00449d31
    mov eax, 0x1                                 # 00449d28
    jmp.d8 L_00449d31                            # 00449d2d
L_00449d2f:
    # block 0x00449d2f: entered by je at 0x00449d26, 1 instruction(s), falls into the block at 0x00449d31
    {load} xor eax, eax                          # 00449d2f
L_00449d31:
    # block 0x00449d31: entered by jmp at 0x00449d2d, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00449d31
    pop ebp                                      # 00449d33
    ret 0x4                                      # 00449d34

