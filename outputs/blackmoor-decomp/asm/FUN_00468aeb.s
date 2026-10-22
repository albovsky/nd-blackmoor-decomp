# FUN_00468aeb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468aeb
# extent:       0x00468aeb-0x00468d32 (583 code bytes)
# span:         0x00468aeb-0x00468d40 (code 583, tables 0, padding 14)
# sha256:       16353170168d77b7c746b5f7d84ccf698a858581f6c63d5d3c4615e4d4206774
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m468aeb_lifted
# naming:       native port src/original_methods_fl40.c:m468aeb_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 5 seeds; oracle: 162/162 instructions executed, 14/14 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       18 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 6 more
# fields:       [eax + n] field_244; [ecx + n] field_21, field_131
# callees:      calls FUN_004c5377, FUN_004c7770
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m468aeb_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 162 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ field_21, 0x21  # offset +0x21
.equ field_131, 0x131  # offset +0x131
.equ field_244, 0x244  # offset +0x244

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c7770, .text + (0x004c7770 - 0x401000)

.org 0x00468aeb - 0x401000
.globl FUN_00468aeb
FUN_00468aeb:
    # block 0x00468aeb: entry, 5 instruction(s), ends with je to 0x00468b10 (forward)
    push ebp                                     # 00468aeb
    {load} mov ebp, esp                          # 00468aec
    sub esp, 0x48                                # 00468aee
    cmp dword ptr [0x61e80a], 0x0                # 00468af1
    je.d8 L_00468b10                             # 00468af8
    # block 0x00468afa: entered by fall-through of je at 0x00468af8, 4 instruction(s), ends with je to 0x00468b15 (forward)
    movsx eax, word ptr [0x61e664]               # 00468afa
    imul eax, eax, 0x8d                          # 00468b01
    cmp dword ptr [eax + 0x5bb632], 0x1          # 00468b07
    je.d8 L_00468b15                             # 00468b0e
L_00468b10:
    # block 0x00468b10: entered by je at 0x00468af8; fall-through of je at 0x00468b0e, 1 instruction(s), ends with forward jump to 0x00468d2e
    jmp.d32 L_00468d2e                           # 00468b10
L_00468b15:
    # block 0x00468b15: entered by je at 0x00468b0e, 14 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00468b5d
    push 0x54b8e0                                # 00468b15
    push 0x583186                                # 00468b1a
    push 0x583196                                # 00468b1f
    mov ecx, dword ptr [0x5cf665]                # 00468b24
    push ecx                                     # 00468b2a
    mov edx, dword ptr [0x5d15e3]                # 00468b2b
    push edx                                     # 00468b31
    mov ecx, 0x5cf659                            # 00468b32
    call FUN_004c5377                            # 00468b37
    mov eax, dword ptr [0x61e806]                # 00468b3c
    movsx ecx, word ptr [eax + field_244]        # 00468b41
    mov dword ptr [ebp - local_2c], ecx          # 00468b48
    mov dword ptr [ebp - local_20], 0x0          # 00468b4b
    jmp.d8 L_00468b5d                            # 00468b52
L_00468b54:
    # block 0x00468b54: entered by jmp at 0x00468c80, 3 instruction(s), falls into the block at 0x00468b5d
    mov edx, dword ptr [ebp - local_20]          # 00468b54
    add edx, 0x1                                 # 00468b57
    mov dword ptr [ebp - local_20], edx          # 00468b5a
L_00468b5d:
    # block 0x00468b5d: entered by jmp at 0x00468b52, 3 instruction(s), ends with jge to 0x00468c85 (forward)
    mov eax, dword ptr [ebp - local_20]          # 00468b5d
    cmp eax, dword ptr [0x61e89c]                # 00468b60
    jge.d32 L_00468c85                           # 00468b66
    # block 0x00468b6c: entered by fall-through of jge at 0x00468b66, 45 instruction(s), ends with forward jump to 0x00468c24
    mov ecx, dword ptr [ebp - local_20]          # 00468b6c
    mov edx, dword ptr [8*ecx + 0x61e81c]        # 00468b6f
    mov eax, dword ptr [8*edx + 0x61e77e]        # 00468b76
    mov dword ptr [ebp - local_30], eax          # 00468b7d
    mov ecx, dword ptr [ebp - local_20]          # 00468b80
    mov edx, dword ptr [8*ecx + 0x61e81c]        # 00468b83
    mov eax, dword ptr [8*edx + 0x61e782]        # 00468b8a
    mov dword ptr [ebp - local_3c], eax          # 00468b91
    mov ecx, dword ptr [ebp - local_20]          # 00468b94
    mov edx, dword ptr [8*ecx + 0x61e820]        # 00468b97
    mov eax, dword ptr [8*edx + 0x61e77e]        # 00468b9e
    mov dword ptr [ebp - local_38], eax          # 00468ba5
    mov ecx, dword ptr [ebp - local_20]          # 00468ba8
    mov edx, dword ptr [8*ecx + 0x61e820]        # 00468bab
    mov eax, dword ptr [8*edx + 0x61e782]        # 00468bb2
    mov dword ptr [ebp - local_44], eax          # 00468bb9
    mov ecx, dword ptr [ebp - local_30]          # 00468bbc
    sub ecx, dword ptr [ebp - local_2c]          # 00468bbf
    mov dword ptr [ebp - local_48], ecx          # 00468bc2
    mov edx, dword ptr [ebp - local_3c]          # 00468bc5
    sub edx, dword ptr [ebp - local_2c]          # 00468bc8
    mov dword ptr [ebp - local_40], edx          # 00468bcb
    mov eax, dword ptr [ebp - local_30]          # 00468bce
    add eax, dword ptr [ebp - local_2c]          # 00468bd1
    mov dword ptr [ebp - local_10], eax          # 00468bd4
    mov ecx, dword ptr [ebp - local_3c]          # 00468bd7
    add ecx, dword ptr [ebp - local_2c]          # 00468bda
    mov dword ptr [ebp - local_34], ecx          # 00468bdd
    mov edx, dword ptr [ebp - local_38]          # 00468be0
    sub edx, dword ptr [ebp - local_2c]          # 00468be3
    mov dword ptr [ebp - local_18], edx          # 00468be6
    mov eax, dword ptr [ebp - local_44]          # 00468be9
    sub eax, dword ptr [ebp - local_2c]          # 00468bec
    mov dword ptr [ebp - local_1c], eax          # 00468bef
    mov ecx, dword ptr [ebp - local_38]          # 00468bf2
    add ecx, dword ptr [ebp - local_2c]          # 00468bf5
    mov dword ptr [ebp - local_28], ecx          # 00468bf8
    mov edx, dword ptr [ebp - local_44]          # 00468bfb
    add edx, dword ptr [ebp - local_2c]          # 00468bfe
    mov dword ptr [ebp - local_24], edx          # 00468c01
    mov eax, dword ptr [ebp - local_40]          # 00468c04
    mov dword ptr [ebp - local_c], eax           # 00468c07
    mov ecx, dword ptr [ebp - local_1c]          # 00468c0a
    mov dword ptr [ebp - local_14], ecx          # 00468c0d
    jmp.d8 L_00468c24                            # 00468c10
L_00468c12:
    # block 0x00468c12: entered by jmp at 0x00468c7e, 6 instruction(s), falls into the block at 0x00468c24
    mov edx, dword ptr [ebp - local_c]           # 00468c12
    add edx, 0x1                                 # 00468c15
    mov dword ptr [ebp - local_c], edx           # 00468c18
    mov eax, dword ptr [ebp - local_14]          # 00468c1b
    add eax, 0x1                                 # 00468c1e
    mov dword ptr [ebp - local_14], eax          # 00468c21
L_00468c24:
    # block 0x00468c24: entered by jmp at 0x00468c10, 3 instruction(s), ends with jg to 0x00468c80 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00468c24
    cmp ecx, dword ptr [ebp - local_34]          # 00468c27
    jg.d8 L_00468c80                             # 00468c2a
    # block 0x00468c2c: entered by fall-through of jg at 0x00468c2a, 5 instruction(s), ends with forward jump to 0x00468c4c
    mov edx, dword ptr [ebp - local_48]          # 00468c2c
    mov dword ptr [ebp - local_4], edx           # 00468c2f
    mov eax, dword ptr [ebp - local_18]          # 00468c32
    mov dword ptr [ebp - local_8], eax           # 00468c35
    jmp.d8 L_00468c4c                            # 00468c38
L_00468c3a:
    # block 0x00468c3a: entered by jmp at 0x00468c7c, 6 instruction(s), falls into the block at 0x00468c4c
    mov ecx, dword ptr [ebp - local_4]           # 00468c3a
    add ecx, 0x1                                 # 00468c3d
    mov dword ptr [ebp - local_4], ecx           # 00468c40
    mov edx, dword ptr [ebp - local_8]           # 00468c43
    add edx, 0x1                                 # 00468c46
    mov dword ptr [ebp - local_8], edx           # 00468c49
L_00468c4c:
    # block 0x00468c4c: entered by jmp at 0x00468c38, 3 instruction(s), ends with jg to 0x00468c7e (forward)
    mov eax, dword ptr [ebp - local_4]           # 00468c4c
    cmp eax, dword ptr [ebp - local_10]          # 00468c4f
    jg.d8 L_00468c7e                             # 00468c52
    # block 0x00468c54: entered by fall-through of jg at 0x00468c52, 15 instruction(s), calls FUN_004c7770, ends with backward jump to 0x00468c3a
    mov cx, word ptr [0x61e81a]                  # 00468c54
    push ecx                                     # 00468c5b
    mov edx, dword ptr [ebp - local_14]          # 00468c5c
    push edx                                     # 00468c5f
    mov eax, dword ptr [ebp - local_8]           # 00468c60
    push eax                                     # 00468c63
    mov ecx, dword ptr [ebp - local_c]           # 00468c64
    push ecx                                     # 00468c67
    mov edx, dword ptr [ebp - local_4]           # 00468c68
    push edx                                     # 00468c6b
    mov eax, dword ptr [0x5cf665]                # 00468c6c
    push eax                                     # 00468c71
    mov ecx, 0x5cf659                            # 00468c72
    call FUN_004c7770                            # 00468c77
    jmp.d8 L_00468c3a                            # 00468c7c
L_00468c7e:
    # block 0x00468c7e: entered by jg at 0x00468c52, 1 instruction(s), ends with backward jump to 0x00468c12
    jmp.d8 L_00468c12                            # 00468c7e
L_00468c80:
    # block 0x00468c80: entered by jg at 0x00468c2a, 1 instruction(s), ends with backward jump to 0x00468b54
    jmp.d32 L_00468b54                           # 00468c80
L_00468c85:
    # block 0x00468c85: entered by jge at 0x00468b66, 2 instruction(s), ends with forward jump to 0x00468c97
    mov dword ptr [ebp - local_20], 0x0          # 00468c85
    jmp.d8 L_00468c97                            # 00468c8c
L_00468c8e:
    # block 0x00468c8e: entered by jmp at 0x00468cd7, 3 instruction(s), falls into the block at 0x00468c97
    mov ecx, dword ptr [ebp - local_20]          # 00468c8e
    add ecx, 0x1                                 # 00468c91
    mov dword ptr [ebp - local_20], ecx          # 00468c94
L_00468c97:
    # block 0x00468c97: entered by jmp at 0x00468c8c, 2 instruction(s), ends with jge to 0x00468cd9 (forward)
    cmp dword ptr [ebp - local_20], 0x11         # 00468c97
    jge.d8 L_00468cd9                            # 00468c9b
    # block 0x00468c9d: entered by fall-through of jge at 0x00468c9b, 17 instruction(s), calls FUN_004c5377, ends with backward jump to 0x00468c8e
    push 0x54b910                                # 00468c9d
    mov edx, dword ptr [ebp - local_20]          # 00468ca2
    shl edx, 0x4                                 # 00468ca5
    add edx, 0x61e66e                            # 00468ca8
    push edx                                     # 00468cae
    mov eax, dword ptr [ebp - local_20]          # 00468caf
    shl eax, 0x4                                 # 00468cb2
    mov ecx, dword ptr [0x61e806]                # 00468cb5
    lea edx, [ecx + eax + field_21]              # 00468cbb
    push edx                                     # 00468cbf
    mov eax, dword ptr [0x5cf665]                # 00468cc0
    push eax                                     # 00468cc5
    mov ecx, dword ptr [0x5d15e3]                # 00468cc6
    push ecx                                     # 00468ccc
    mov ecx, 0x5cf659                            # 00468ccd
    call FUN_004c5377                            # 00468cd2
    jmp.d8 L_00468c8e                            # 00468cd7
L_00468cd9:
    # block 0x00468cd9: entered by jge at 0x00468c9b, 2 instruction(s), ends with jl to 0x00468d2e (forward)
    cmp dword ptr [0x61e816], 0x0                # 00468cd9
    jl.d8 L_00468d2e                             # 00468ce0
    # block 0x00468ce2: entered by fall-through of jl at 0x00468ce0, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x00468d2e
    push 0x54b940                                # 00468ce2
    mov edx, dword ptr [0x61e816]                # 00468ce7
    shl edx, 0x4                                 # 00468ced
    add edx, 0x61e66e                            # 00468cf0
    push edx                                     # 00468cf6
    mov eax, dword ptr [0x61e816]                # 00468cf7
    shl eax, 0x4                                 # 00468cfc
    mov ecx, dword ptr [0x61e806]                # 00468cff
    lea edx, [ecx + eax + field_131]             # 00468d05
    push edx                                     # 00468d0c
    mov eax, dword ptr [0x5cf665]                # 00468d0d
    push eax                                     # 00468d12
    movsx ecx, word ptr [0x61e66c]               # 00468d13
    imul ecx, ecx, 0x4a                          # 00468d1a
    mov edx, dword ptr [ecx + 0x5d1599]          # 00468d1d
    push edx                                     # 00468d23
    mov ecx, 0x5cf659                            # 00468d24
    call FUN_004c5377                            # 00468d29
L_00468d2e:
    # block 0x00468d2e: entered by jmp at 0x00468b10; jl at 0x00468ce0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00468d2e
    pop ebp                                      # 00468d30
    ret                                          # 00468d31

# --- data items (not part of the function) -------------------------
.org 0x00468d32 - 0x401000
PAD_00468d32:  # 14 byte(s) of int3 padding
    .fill 14, 1, 0xcc

