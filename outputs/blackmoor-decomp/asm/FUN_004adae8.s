# FUN_004adae8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004adae8
# extent:       0x004adae8-0x004adb6c (132 code bytes)
# span:         0x004adae8-0x004adb6c (code 132, tables 0, padding 0)
# sha256:       114a9d3a385e2624343816b0bca1a34d12d1a30dbedca0faeeac5367e304d571
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004adae8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_e6d, field_e75; [ecx + n] field_c20; [edx + n] field_c24
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_c20, 0xc20  # offset +0xc20
.equ field_c24, 0xc24  # offset +0xc24
.equ field_e6d, 0xe6d  # offset +0xe6d
.equ field_e75, 0xe75  # offset +0xe75

# --- external targets -----------------------------------------------

.org 0x004adae8 - 0x401000
.globl FUN_004adae8
FUN_004adae8:
    # block 0x004adae8: entry, 9 instruction(s), ends with forward jump to 0x004adb0f
    push ebp                                     # 004adae8
    {load} mov ebp, esp                          # 004adae9
    sub esp, 0x10                                # 004adaeb
    mov dword ptr [ebp - local_10], ecx          # 004adaee
    mov eax, dword ptr [ebp - local_10]          # 004adaf1
    mov ecx, dword ptr [eax + field_e6d]         # 004adaf4
    mov dword ptr [ebp - local_c], ecx           # 004adafa
    mov dword ptr [ebp - local_8], 0x0           # 004adafd
    jmp.d8 L_004adb0f                            # 004adb04
L_004adb06:
    # block 0x004adb06: entered by jmp at 0x004adb35; jmp at 0x004adb4f, 3 instruction(s), falls into the block at 0x004adb0f
    mov edx, dword ptr [ebp - local_8]           # 004adb06
    add edx, 0x1                                 # 004adb09
    mov dword ptr [ebp - local_8], edx           # 004adb0c
L_004adb0f:
    # block 0x004adb0f: entered by jmp at 0x004adb04, 4 instruction(s), ends with jge to 0x004adb51 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004adb0f
    mov ecx, dword ptr [ebp - local_8]           # 004adb12
    cmp ecx, dword ptr [eax + field_e75]         # 004adb15
    jge.d8 L_004adb51                            # 004adb1b
    # block 0x004adb1d: entered by fall-through of jge at 0x004adb1b, 8 instruction(s), ends with jne to 0x004adb37 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004adb1d
    add edx, dword ptr [ebp - local_8]           # 004adb20
    mov al, byte ptr [edx]                       # 004adb23
    mov byte ptr [ebp - local_4], al             # 004adb25
    mov ecx, dword ptr [ebp - local_4]           # 004adb28
    and ecx, 0xff                                # 004adb2b
    test ecx, ecx                                # 004adb31
    jne.d8 L_004adb37                            # 004adb33
    # block 0x004adb35: entered by fall-through of jne at 0x004adb33, 1 instruction(s), ends with backward jump to 0x004adb06
    jmp.d8 L_004adb06                            # 004adb35
L_004adb37:
    # block 0x004adb37: entered by jne at 0x004adb33, 7 instruction(s), ends with je to 0x004adb4f (forward)
    mov dl, byte ptr [ebp - local_4]             # 004adb37
    and dl, 0x7f                                 # 004adb3a
    mov byte ptr [ebp - local_4], dl             # 004adb3d
    mov eax, dword ptr [ebp - local_4]           # 004adb40
    and eax, 0xff                                # 004adb43
    cmp eax, 0x1                                 # 004adb48
    je.d8 L_004adb4f                             # 004adb4b
    # block 0x004adb4d: entered by fall-through of je at 0x004adb4b, 1 instruction(s), ends with forward jump to 0x004adb68
    jmp.d8 L_004adb68                            # 004adb4d
L_004adb4f:
    # block 0x004adb4f: entered by je at 0x004adb4b, 1 instruction(s), ends with backward jump to 0x004adb06
    jmp.d8 L_004adb06                            # 004adb4f
L_004adb51:
    # block 0x004adb51: entered by jge at 0x004adb1b, 4 instruction(s), falls into the block at 0x004adb68
    mov ecx, dword ptr [ebp - local_10]          # 004adb51
    mov dword ptr [ecx + field_c20], 0x2         # 004adb54
    mov edx, dword ptr [ebp - local_10]          # 004adb5e
    mov byte ptr [edx + field_c24], 0x1          # 004adb61
L_004adb68:
    # block 0x004adb68: entered by jmp at 0x004adb4d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004adb68
    pop ebp                                      # 004adb6a
    ret                                          # 004adb6b

