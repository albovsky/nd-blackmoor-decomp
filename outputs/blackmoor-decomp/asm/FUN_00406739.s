# FUN_00406739
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406739
# extent:       0x00406739-0x004067a5 (108 code bytes)
# span:         0x00406739-0x004067a5 (code 108, tables 0, padding 0)
# sha256:       187e58c0861d13441403d802062eb99a1cdb77e8116b80f346ba08f586de3379
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406739
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_ddc; [edx + n] field_1c
# callees:      calls USER32.dll!SendMessageA, FUN_00404be1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_ddc, 0xddc  # offset +0xddc

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00406739 - 0x401000
.globl FUN_00406739
FUN_00406739:
    # block 0x00406739: entry, 17 instruction(s), calls USER32.dll!SendMessageA, ends with jne to 0x00406778 (forward)
    push ebp                                     # 00406739
    {load} mov ebp, esp                          # 0040673a
    sub esp, 0xc                                 # 0040673c
    mov dword ptr [ebp - local_c], ecx           # 0040673f
    mov eax, dword ptr [ebp - local_c]           # 00406742
    mov ecx, dword ptr [eax + field_ddc]         # 00406745
    mov dword ptr [ebp - local_8], ecx           # 0040674b
    push 0x0                                     # 0040674e
    push 0x0                                     # 00406750
    push 0x188                                   # 00406752
    mov edx, dword ptr [ebp - local_8]           # 00406757
    mov eax, dword ptr [edx + field_1c]          # 0040675a
    push eax                                     # 0040675d
    call dword ptr [0x52a4c8]                    # 0040675e
    mov dword ptr [ebp - local_4], eax           # 00406764
    cmp dword ptr [ebp - local_4], 0x0           # 00406767
    jne.d8 L_00406778                            # 0040676b
    # block 0x0040676d: entered by fall-through of jne at 0x0040676b, 2 instruction(s), ends with forward jump to 0x00406799
    mov word ptr [0x5e335e], 0xffff              # 0040676d
    jmp.d8 L_00406799                            # 00406776
L_00406778:
    # block 0x00406778: entered by jne at 0x0040676b, 7 instruction(s), falls into the block at 0x00406799
    mov ecx, dword ptr [ebp - local_4]           # 00406778
    sub ecx, 0x1                                 # 0040677b
    mov dword ptr [ebp - local_4], ecx           # 0040677e
    mov edx, dword ptr [ebp - local_4]           # 00406781
    mov dword ptr [4*edx + 0x5e350a], 0x0        # 00406784
    mov ax, word ptr [ebp - local_4]             # 0040678f
    mov word ptr [0x5e335e], ax                  # 00406793
L_00406799:
    # block 0x00406799: entered by jmp at 0x00406776, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 00406799
    call FUN_00404be1                            # 0040679c
    {load} mov esp, ebp                          # 004067a1
    pop ebp                                      # 004067a3
    ret                                          # 004067a4

