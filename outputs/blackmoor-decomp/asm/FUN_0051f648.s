# FUN_0051f648
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f648
# extent:       0x0051f648-0x0051f69d (85 code bytes)
# span:         0x0051f648-0x0051f69d (code 85, tables 0, padding 0)
# sha256:       4904fda8ff369040adb702bc6ebfd8d990cc6a004b4935b00a09458cd8c98a0c
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f648
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_204
# fields:       [eax + n] field_c
# callees:      calls FUN_0052139c, FUN_005213d4; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_204, 0x204  # offset -0x204
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0052139c, .text + (0x0052139c - 0x401000)
.set FUN_005213d4, .text + (0x005213d4 - 0x401000)

.org 0x0051f648 - 0x401000
.globl FUN_0051f648
FUN_0051f648:
    # block 0x0051f648: entry, 12 instruction(s), calls indirect dword ptr [eax + 0xc], ends with je to 0x0051f67e (forward)
    push ebp                                     # 0051f648
    {load} mov ebp, esp                          # 0051f649
    sub esp, 0x204                               # 0051f64b
    mov eax, dword ptr [ecx]                     # 0051f651
    lea edx, [ebp - local_4]                     # 0051f653
    push edx                                     # 0051f656
    lea edx, [ebp - local_204]                   # 0051f657
    push 0x200                                   # 0051f65d
    push edx                                     # 0051f662
    call dword ptr [eax + field_c]               # 0051f663
    test eax, eax                                # 0051f666
    je.d8 L_0051f67e                             # 0051f668
    # block 0x0051f66a: entered by fall-through of je at 0x0051f668, 6 instruction(s), calls FUN_0052139c, ends with forward jump to 0x0051f699
    push dword ptr [ebp - local_4]               # 0051f66a
    lea eax, [ebp - local_204]                   # 0051f66d
    push dword ptr [ebp + arg_8]                 # 0051f673
    push eax                                     # 0051f676
    call FUN_0052139c                            # 0051f677
    jmp.d8 L_0051f699                            # 0051f67c
L_0051f67e:
    # block 0x0051f67e: entered by je at 0x0051f668, 2 instruction(s), ends with jne to 0x0051f68b (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 0051f67e
    jne.d8 L_0051f68b                            # 0051f682
    # block 0x0051f684: entered by fall-through of jne at 0x0051f682, 1 instruction(s), falls into the block at 0x0051f68b
    mov dword ptr [ebp + arg_c], 0xf020          # 0051f684
L_0051f68b:
    # block 0x0051f68b: entered by jne at 0x0051f682, 4 instruction(s), calls FUN_005213d4, falls into the block at 0x0051f699
    push dword ptr [ebp - local_4]               # 0051f68b
    push dword ptr [ebp + arg_8]                 # 0051f68e
    push dword ptr [ebp + arg_c]                 # 0051f691
    call FUN_005213d4                            # 0051f694
L_0051f699:
    # block 0x0051f699: entered by jmp at 0x0051f67c, 2 instruction(s), ends with ret 0x8
    leave                                        # 0051f699
    ret 0x8                                      # 0051f69a

