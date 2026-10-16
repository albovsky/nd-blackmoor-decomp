# FUN_0046b707
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b707
# extent:       0x0046b707-0x0046b73e (55 code bytes)
# span:         0x0046b707-0x0046b73e (code 55, tables 0, padding 0)
# sha256:       006118e644cb0e02680530c300ae80d5f7fde5b79f0063258d75616c34b870ac
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046b707
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_4a48; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_4a48, 0x4a48  # offset +0x4a48

# --- external targets -----------------------------------------------

.org 0x0046b707 - 0x401000
.globl FUN_0046b707
FUN_0046b707:
    # block 0x0046b707: entry, 7 instruction(s), ends with je to 0x0046b73a (forward)
    push ebp                                     # 0046b707
    {load} mov ebp, esp                          # 0046b708
    push ecx                                     # 0046b70a
    mov dword ptr [ebp - local_4], ecx           # 0046b70b
    mov eax, dword ptr [ebp - local_4]           # 0046b70e
    cmp dword ptr [eax + field_4a48], 0x0        # 0046b711
    je.d8 L_0046b73a                             # 0046b718
    # block 0x0046b71a: entered by fall-through of je at 0x0046b718, 4 instruction(s), ends with je to 0x0046b73a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046b71a
    movsx edx, word ptr [ecx + field_1c]         # 0046b71d
    cmp edx, -0x1                                # 0046b721
    je.d8 L_0046b73a                             # 0046b724
    # block 0x0046b726: entered by fall-through of je at 0x0046b724, 4 instruction(s), falls into the block at 0x0046b73a
    mov eax, dword ptr [ebp - local_4]           # 0046b726
    movsx ecx, word ptr [eax + field_1c]         # 0046b729
    imul ecx, ecx, 0x4a                          # 0046b72d
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0046b730
L_0046b73a:
    # block 0x0046b73a: entered by je at 0x0046b718; je at 0x0046b724, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046b73a
    pop ebp                                      # 0046b73c
    ret                                          # 0046b73d

