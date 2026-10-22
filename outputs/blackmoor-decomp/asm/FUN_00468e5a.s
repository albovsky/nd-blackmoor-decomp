# FUN_00468e5a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468e5a
# extent:       0x00468e5a-0x00468f19 (191 code bytes)
# span:         0x00468e5a-0x00468f19 (code 191, tables 0, padding 0)
# sha256:       1a6233409da54964e27fc39f1b9fe30052760ecb3cefc14d935b80b23a3c0cb9
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00468e5a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_7e, field_554, field_556, field_55c; [ecx + n] field_158, field_52c, field_558, field_55a; [edx + n] field_7c, field_e0, field_548, field_552
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_7c, 0x7c  # offset +0x7c
.equ field_7e, 0x7e  # offset +0x7e
.equ field_e0, 0xe0  # offset +0xe0
.equ field_158, 0x158  # offset +0x158
.equ field_52c, 0x52c  # offset +0x52c
.equ field_548, 0x548  # offset +0x548
.equ field_552, 0x552  # offset +0x552
.equ field_554, 0x554  # offset +0x554
.equ field_556, 0x556  # offset +0x556
.equ field_558, 0x558  # offset +0x558
.equ field_55a, 0x55a  # offset +0x55a
.equ field_55c, 0x55c  # offset +0x55c

# --- external targets -----------------------------------------------

.org 0x00468e5a - 0x401000
.globl FUN_00468e5a
FUN_00468e5a:
    # block 0x00468e5a: entry, 28 instruction(s), ends with forward jump to 0x00468ef8
    push ebp                                     # 00468e5a
    {load} mov ebp, esp                          # 00468e5b
    sub esp, 0x8                                 # 00468e5d
    mov dword ptr [ebp - local_8], ecx           # 00468e60
    mov eax, dword ptr [ebp - local_8]           # 00468e63
    mov word ptr [eax + field_7e], 0xffff        # 00468e66
    mov ecx, dword ptr [ebp - local_8]           # 00468e6c
    mov dword ptr [ecx + field_52c], 0x0         # 00468e6f
    mov edx, dword ptr [ebp - local_8]           # 00468e79
    mov word ptr [edx + field_7c], 0xffff        # 00468e7c
    mov eax, dword ptr [ebp - local_8]           # 00468e82
    mov dword ptr [eax + field_55c], 0x0         # 00468e85
    mov ecx, dword ptr [ebp - local_8]           # 00468e8f
    mov dword ptr [ecx + field_158], 0x0         # 00468e92
    mov edx, dword ptr [ebp - local_8]           # 00468e9c
    mov word ptr [edx + field_552], 0xffff       # 00468e9f
    mov eax, dword ptr [ebp - local_8]           # 00468ea8
    mov word ptr [eax + field_554], 0xffff       # 00468eab
    mov ecx, dword ptr [ebp - local_8]           # 00468eb4
    mov word ptr [ecx + field_55a], 0xffff       # 00468eb7
    mov edx, dword ptr [ebp - local_8]           # 00468ec0
    mov word ptr [edx + field_548], 0xffff       # 00468ec3
    mov eax, dword ptr [ebp - local_8]           # 00468ecc
    mov word ptr [eax + field_556], 0xffff       # 00468ecf
    mov ecx, dword ptr [ebp - local_8]           # 00468ed8
    mov word ptr [ecx + field_558], 0xffff       # 00468edb
    mov word ptr [ebp - local_4], 0x0            # 00468ee4
    jmp.d8 L_00468ef8                            # 00468eea
L_00468eec:
    # block 0x00468eec: entered by jmp at 0x00468f13, 3 instruction(s), falls into the block at 0x00468ef8
    mov dx, word ptr [ebp - local_4]             # 00468eec
    add dx, 0x1                                  # 00468ef0
    mov word ptr [ebp - local_4], dx             # 00468ef4
L_00468ef8:
    # block 0x00468ef8: entered by jmp at 0x00468eea, 3 instruction(s), ends with jge to 0x00468f15 (forward)
    movsx eax, word ptr [ebp - local_4]          # 00468ef8
    cmp eax, 0x6                                 # 00468efc
    jge.d8 L_00468f15                            # 00468eff
    # block 0x00468f01: entered by fall-through of jge at 0x00468eff, 4 instruction(s), ends with backward jump to 0x00468eec
    movsx ecx, word ptr [ebp - local_4]          # 00468f01
    mov edx, dword ptr [ebp - local_8]           # 00468f05
    mov dword ptr [edx + 4*ecx + field_e0], 0x0  # 00468f08
    jmp.d8 L_00468eec                            # 00468f13
L_00468f15:
    # block 0x00468f15: entered by jge at 0x00468eff, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00468f15
    pop ebp                                      # 00468f17
    ret                                          # 00468f18

