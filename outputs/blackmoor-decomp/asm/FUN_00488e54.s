# FUN_00488e54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00488e54
# extent:       0x00488e54-0x00488e9c (72 code bytes)
# span:         0x00488e54-0x00488e9c (code 72, tables 0, padding 0)
# sha256:       82440d9327df275f18c23a9c59fd2475f4039b8b9235da1e0fa5b92df952ecc7
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00488e54
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_2c; [ecx + n] field_cc
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_2c, 0x2c  # offset +0x2c
.equ field_cc, 0xcc  # offset +0xcc

# --- external targets -----------------------------------------------

.org 0x00488e54 - 0x401000
.globl FUN_00488e54
FUN_00488e54:
    # block 0x00488e54: entry, 6 instruction(s), ends with forward jump to 0x00488e71
    push ebp                                     # 00488e54
    {load} mov ebp, esp                          # 00488e55
    sub esp, 0x8                                 # 00488e57
    mov dword ptr [ebp - local_8], ecx           # 00488e5a
    mov word ptr [ebp - local_4], 0x0            # 00488e5d
    jmp.d8 L_00488e71                            # 00488e63
L_00488e65:
    # block 0x00488e65: entered by jmp at 0x00488e89, 3 instruction(s), falls into the block at 0x00488e71
    mov ax, word ptr [ebp - local_4]             # 00488e65
    .insn 0x66, 0x05, 0x0001{:u16}               # 00488e69
    mov word ptr [ebp - local_4], ax             # 00488e6d
L_00488e71:
    # block 0x00488e71: entered by jmp at 0x00488e63, 3 instruction(s), ends with jge to 0x00488e8b (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00488e71
    cmp ecx, 0x28                                # 00488e75
    jge.d8 L_00488e8b                            # 00488e78
    # block 0x00488e7a: entered by fall-through of jge at 0x00488e78, 4 instruction(s), ends with backward jump to 0x00488e65
    movsx edx, word ptr [ebp - local_4]          # 00488e7a
    mov eax, dword ptr [ebp - local_8]           # 00488e7e
    mov dword ptr [eax + 4*edx + field_2c], 0x0  # 00488e81
    jmp.d8 L_00488e65                            # 00488e89
L_00488e8b:
    # block 0x00488e8b: entered by jge at 0x00488e78, 5 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_8]           # 00488e8b
    mov dword ptr [ecx + field_cc], 0x0          # 00488e8e
    {load} mov esp, ebp                          # 00488e98
    pop ebp                                      # 00488e9a
    ret                                          # 00488e9b

