# FUN_0051f929
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f929
# extent:       0x0051f929-0x0051f96d (68 code bytes)
# span:         0x0051f929-0x0051f96d (code 68, tables 0, padding 0)
# sha256:       49f085668a9f81aa0dda07065ed803f0f8f1eb7f8f4360e895078ca61cdaff5b
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f929
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_20, field_24, field_28, field_2c, field_30, field_34, field_38
# callees:      none direct; 7 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------

.org 0x0051f929 - 0x401000
.globl FUN_0051f929
FUN_0051f929:
    # block 0x0051f929: entry, 29 instruction(s), calls indirect edi, ends with ret
    push esi                                     # 0051f929
    push edi                                     # 0051f92a
    mov edi, dword ptr [0x52a310]                # 0051f92b
    {load} mov esi, ecx                          # 0051f931
    push 0xf                                     # 0051f933
    call edi                                     # 0051f935
    push 0x10                                    # 0051f937
    mov dword ptr [esi + field_28], eax          # 0051f939
    call edi                                     # 0051f93c
    push 0x14                                    # 0051f93e
    mov dword ptr [esi + field_2c], eax          # 0051f940
    call edi                                     # 0051f943
    push 0x12                                    # 0051f945
    mov dword ptr [esi + field_30], eax          # 0051f947
    call edi                                     # 0051f94a
    push 0x6                                     # 0051f94c
    mov dword ptr [esi + field_34], eax          # 0051f94e
    call edi                                     # 0051f951
    mov edi, dword ptr [0x52a3c0]                # 0051f953
    push 0xf                                     # 0051f959
    mov dword ptr [esi + field_38], eax          # 0051f95b
    call edi                                     # 0051f95e
    push 0x6                                     # 0051f960
    mov dword ptr [esi + field_24], eax          # 0051f962
    call edi                                     # 0051f965
    mov dword ptr [esi + field_20], eax          # 0051f967
    pop edi                                      # 0051f96a
    pop esi                                      # 0051f96b
    ret                                          # 0051f96c

