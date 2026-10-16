# FUN_0050cd72
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cd72
# extent:       0x0050cd72-0x0050ce03 (145 code bytes)
# span:         0x0050cd72-0x0050ce04 (code 145, tables 0, padding 1)
# sha256:       80837e0fb028e3ec3a9f775050ebc6df817391a532e8df80266b77737267c519
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cd72
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [ecx + n] field_1
# callees:      calls FUN_00511fab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 74 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00511fab, .text + (0x00511fab - 0x401000)

.org 0x0050cd72 - 0x401000
.globl FUN_0050cd72
FUN_0050cd72:
    # block 0x0050cd72: entry, 6 instruction(s), ends with je to 0x0050cd8f (forward)
    push ebp                                     # 0050cd72
    {load} mov ebp, esp                          # 0050cd73
    mov eax, dword ptr [ebp + arg_c]             # 0050cd75
    push esi                                     # 0050cd78
    test eax, eax                                # 0050cd79
    je.d8 L_0050cd8f                             # 0050cd7b
    # block 0x0050cd7d: entered by fall-through of je at 0x0050cd7b, 3 instruction(s), ends with je to 0x0050cd8f (forward)
    mov al, byte ptr [eax]                       # 0050cd7d
    test al, al                                  # 0050cd7f
    je.d8 L_0050cd8f                             # 0050cd81
    # block 0x0050cd83: entered by fall-through of je at 0x0050cd81, 6 instruction(s), ends with forward jump to 0x0050cd92
    mov esi, dword ptr [ebp + arg_8]             # 0050cd83
    mov byte ptr [esi], al                       # 0050cd86
    inc esi                                      # 0050cd88
    mov byte ptr [esi], 0x3a                     # 0050cd89
    inc esi                                      # 0050cd8c
    jmp.d8 L_0050cd92                            # 0050cd8d
L_0050cd8f:
    # block 0x0050cd8f: entered by je at 0x0050cd7b; je at 0x0050cd81, 1 instruction(s), falls into the block at 0x0050cd92
    mov esi, dword ptr [ebp + arg_8]             # 0050cd8f
L_0050cd92:
    # block 0x0050cd92: entered by jmp at 0x0050cd8d, 4 instruction(s), ends with je to 0x0050cdc3 (forward)
    mov edx, dword ptr [ebp + arg_10]            # 0050cd92
    test edx, edx                                # 0050cd95
    {load} mov ecx, edx                          # 0050cd97
    je.d8 L_0050cdc3                             # 0050cd99
    # block 0x0050cd9b: entered by fall-through of je at 0x0050cd99, 3 instruction(s), ends with je to 0x0050cdc3 (forward)
    mov al, byte ptr [edx]                       # 0050cd9b
    test al, al                                  # 0050cd9d
    je.d8 L_0050cdc3                             # 0050cd9f
L_0050cda1:
    # block 0x0050cda1: entered by jne at 0x0050cdaa; fall-through of je at 0x0050cd9f, 6 instruction(s), ends with jne to 0x0050cda1 (backward)
    mov byte ptr [esi], al                       # 0050cda1
    mov al, byte ptr [ecx + field_1]             # 0050cda3
    inc esi                                      # 0050cda6
    inc ecx                                      # 0050cda7
    test al, al                                  # 0050cda8
    jne.d8 L_0050cda1                            # 0050cdaa
    # block 0x0050cdac: entered by fall-through of jne at 0x0050cdaa, 8 instruction(s), calls FUN_00511fab, ends with je to 0x0050cdc3 (forward)
    push ecx                                     # 0050cdac
    push edx                                     # 0050cdad
    call FUN_00511fab                            # 0050cdae
    mov al, byte ptr [eax]                       # 0050cdb3
    pop ecx                                      # 0050cdb5
    cmp al, 0x2f                                 # 0050cdb6
    pop ecx                                      # 0050cdb8
    je.d8 L_0050cdc3                             # 0050cdb9
    # block 0x0050cdbb: entered by fall-through of je at 0x0050cdb9, 2 instruction(s), ends with je to 0x0050cdc3 (forward)
    cmp al, 0x5c                                 # 0050cdbb
    je.d8 L_0050cdc3                             # 0050cdbd
    # block 0x0050cdbf: entered by fall-through of je at 0x0050cdbd, 2 instruction(s), falls into the block at 0x0050cdc3
    mov byte ptr [esi], 0x5c                     # 0050cdbf
    inc esi                                      # 0050cdc2
L_0050cdc3:
    # block 0x0050cdc3: entered by je at 0x0050cd99; je at 0x0050cd9f; je at 0x0050cdb9; je at 0x0050cdbd, 4 instruction(s), ends with je to 0x0050cddb (forward)
    mov eax, dword ptr [ebp + arg_14]            # 0050cdc3
    test eax, eax                                # 0050cdc6
    {load} mov ecx, eax                          # 0050cdc8
    je.d8 L_0050cddb                             # 0050cdca
    # block 0x0050cdcc: entered by fall-through of je at 0x0050cdca, 1 instruction(s), falls into the block at 0x0050cdce
    mov al, byte ptr [eax]                       # 0050cdcc
L_0050cdce:
    # block 0x0050cdce: entered by jmp at 0x0050cdd9, 2 instruction(s), ends with je to 0x0050cddb (forward)
    test al, al                                  # 0050cdce
    je.d8 L_0050cddb                             # 0050cdd0
    # block 0x0050cdd2: entered by fall-through of je at 0x0050cdd0, 5 instruction(s), ends with backward jump to 0x0050cdce
    mov byte ptr [esi], al                       # 0050cdd2
    mov al, byte ptr [ecx + field_1]             # 0050cdd4
    inc esi                                      # 0050cdd7
    inc ecx                                      # 0050cdd8
    jmp.d8 L_0050cdce                            # 0050cdd9
L_0050cddb:
    # block 0x0050cddb: entered by je at 0x0050cdca; je at 0x0050cdd0, 3 instruction(s), ends with je to 0x0050cdfd (forward)
    mov eax, dword ptr [ebp + arg_18]            # 0050cddb
    test eax, eax                                # 0050cdde
    je.d8 L_0050cdfd                             # 0050cde0
    # block 0x0050cde2: entered by fall-through of je at 0x0050cde0, 3 instruction(s), ends with je to 0x0050cdf1 (forward)
    mov cl, byte ptr [eax]                       # 0050cde2
    test cl, cl                                  # 0050cde4
    je.d8 L_0050cdf1                             # 0050cde6
    # block 0x0050cde8: entered by fall-through of je at 0x0050cde6, 2 instruction(s), ends with je to 0x0050cdf1 (forward)
    cmp cl, 0x2e                                 # 0050cde8
    je.d8 L_0050cdf1                             # 0050cdeb
    # block 0x0050cded: entered by fall-through of je at 0x0050cdeb, 2 instruction(s), falls into the block at 0x0050cdf1
    mov byte ptr [esi], 0x2e                     # 0050cded
    inc esi                                      # 0050cdf0
L_0050cdf1:
    # block 0x0050cdf1: entered by je at 0x0050cde6; je at 0x0050cdeb; jmp at 0x0050cdfb, 6 instruction(s), ends with je to 0x0050ce00 (forward)
    mov cl, byte ptr [eax]                       # 0050cdf1
    mov byte ptr [esi], cl                       # 0050cdf3
    inc esi                                      # 0050cdf5
    inc eax                                      # 0050cdf6
    test cl, cl                                  # 0050cdf7
    je.d8 L_0050ce00                             # 0050cdf9
    # block 0x0050cdfb: entered by fall-through of je at 0x0050cdf9, 1 instruction(s), ends with backward jump to 0x0050cdf1
    jmp.d8 L_0050cdf1                            # 0050cdfb
L_0050cdfd:
    # block 0x0050cdfd: entered by je at 0x0050cde0, 1 instruction(s), falls into the block at 0x0050ce00
    and byte ptr [esi], 0x0                      # 0050cdfd
L_0050ce00:
    # block 0x0050ce00: entered by je at 0x0050cdf9, 3 instruction(s), ends with ret
    pop esi                                      # 0050ce00
    pop ebp                                      # 0050ce01
    ret                                          # 0050ce02

# --- data items (not part of the function) -------------------------
.org 0x0050ce03 - 0x401000
PAD_0050ce03:  # 1 byte(s) of int3 padding
    .fill 1, 1, 0xcc

