# FUN_0050ccec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ccec
# extent:       0x0050ccec-0x0050cd43 (87 code bytes)
# span:         0x0050ccec-0x0050cd43 (code 87, tables 0, padding 0)
# sha256:       53b7e5ee6949702167c7a48450a7ef59bf371ac1968fe4705b1b4247c7bb319b
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ccec
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_18
# fields:       [eax + n] field_10
# callees:      calls FUN_005118b3, FUN_00511f30, FUN_00511ea7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_18, 0x18  # offset -0x18
.equ arg_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_005118b3, .text + (0x005118b3 - 0x401000)
.set FUN_00511ea7, .text + (0x00511ea7 - 0x401000)
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)

.org 0x0050ccec - 0x401000
.globl FUN_0050ccec
FUN_0050ccec:
    # block 0x0050ccec: entry, 5 instruction(s), falls into the block at 0x0050ccf6
    push ebp                                     # 0050ccec
    {load} mov ebp, esp                          # 0050cced
    sub esp, 0x18                                # 0050ccef
    push esi                                     # 0050ccf2
    mov esi, dword ptr [ebp + arg_8]             # 0050ccf3
L_0050ccf6:
    # block 0x0050ccf6: entered by jmp at 0x0050cd22, 2 instruction(s), ends with jle to 0x0050cd0e (forward)
    cmp dword ptr [0x56840c], 0x1                # 0050ccf6
    jle.d8 L_0050cd0e                            # 0050ccfd
    # block 0x0050ccff: entered by fall-through of jle at 0x0050ccfd, 7 instruction(s), calls FUN_005118b3, ends with forward jump to 0x0050cd1d
    movzx eax, byte ptr [esi]                    # 0050ccff
    push 0x8                                     # 0050cd02
    push eax                                     # 0050cd04
    call FUN_005118b3                            # 0050cd05
    pop ecx                                      # 0050cd0a
    pop ecx                                      # 0050cd0b
    jmp.d8 L_0050cd1d                            # 0050cd0c
L_0050cd0e:
    # block 0x0050cd0e: entered by jle at 0x0050ccfd, 4 instruction(s), falls into the block at 0x0050cd1d
    movzx eax, byte ptr [esi]                    # 0050cd0e
    mov ecx, dword ptr [0x568200]                # 0050cd11
    mov al, byte ptr [ecx + 2*eax]               # 0050cd17
    and eax, 0x8                                 # 0050cd1a
L_0050cd1d:
    # block 0x0050cd1d: entered by jmp at 0x0050cd0c, 2 instruction(s), ends with je to 0x0050cd24 (forward)
    test eax, eax                                # 0050cd1d
    je.d8 L_0050cd24                             # 0050cd1f
    # block 0x0050cd21: entered by fall-through of je at 0x0050cd1f, 2 instruction(s), ends with backward jump to 0x0050ccf6
    inc esi                                      # 0050cd21
    jmp.d8 L_0050ccf6                            # 0050cd22
L_0050cd24:
    # block 0x0050cd24: entered by je at 0x0050cd1f, 15 instruction(s), calls FUN_00511f30, FUN_00511ea7, ends with ret
    push 0x0                                     # 0050cd24
    push 0x0                                     # 0050cd26
    push esi                                     # 0050cd28
    call FUN_00511f30                            # 0050cd29
    pop ecx                                      # 0050cd2e
    push eax                                     # 0050cd2f
    lea eax, [ebp - local_18]                    # 0050cd30
    push esi                                     # 0050cd33
    push eax                                     # 0050cd34
    call FUN_00511ea7                            # 0050cd35
    fld qword ptr [eax + field_10]               # 0050cd3a
    add esp, 0x14                                # 0050cd3d
    pop esi                                      # 0050cd40
    leave                                        # 0050cd41
    ret                                          # 0050cd42

