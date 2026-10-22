# FUN_004a9f63
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9f63
# extent:       0x004a9f63-0x004a9fcb (104 code bytes)
# span:         0x004a9f63-0x004a9fcb (code 104, tables 0, padding 0)
# sha256:       b5aeaa82542b3cd73851de4a85139580bbc665349add59d0ebcc485fccc67440
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a9f63_lifted
# naming:       native port src/original_methods_fl39d.c:m4a9f63_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (15 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1d, field_29; [ecx + n] field_29; [edx + n] field_29
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004a9f27
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4a9f63_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1d, 0x1d  # offset +0x1d
.equ field_29, 0x29  # offset +0x29

# --- external targets -----------------------------------------------
.set FUN_004a9f27, .text + (0x004a9f27 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004a9f63 - 0x401000
.globl FUN_004a9f63
FUN_004a9f63:
    # block 0x004a9f63: entry, 7 instruction(s), ends with je to 0x004a9f86 (forward)
    push ebp                                     # 004a9f63
    {load} mov ebp, esp                          # 004a9f64
    sub esp, 0x8                                 # 004a9f66
    mov dword ptr [ebp - local_8], ecx           # 004a9f69
    mov eax, dword ptr [ebp - local_8]           # 004a9f6c
    cmp dword ptr [eax + field_1d], 0x0          # 004a9f6f
    je.d8 L_004a9f86                             # 004a9f73
    # block 0x004a9f75: entered by fall-through of je at 0x004a9f73, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004a9f86
    mov ecx, dword ptr [ebp - local_8]           # 004a9f75
    add ecx, 0x1d                                # 004a9f78
    push ecx                                     # 004a9f7b
    mov ecx, 0x5cf659                            # 004a9f7c
    call FUN_004c2dfb                            # 004a9f81
L_004a9f86:
    # block 0x004a9f86: entered by je at 0x004a9f73, 4 instruction(s), ends with jne to 0x004a9f98 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004a9f86
    movsx eax, word ptr [edx + field_29]         # 004a9f89
    test eax, eax                                # 004a9f8d
    jne.d8 L_004a9f98                            # 004a9f8f
    # block 0x004a9f91: entered by fall-through of jne at 0x004a9f8f, 1 instruction(s), falls into the block at 0x004a9f98
    mov dword ptr [ebp - local_4], 0x1           # 004a9f91
L_004a9f98:
    # block 0x004a9f98: entered by jne at 0x004a9f8f, 4 instruction(s), ends with je to 0x004a9fbf (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004a9f98
    movsx edx, word ptr [ecx + field_29]         # 004a9f9b
    cmp edx, -0x1                                # 004a9f9f
    je.d8 L_004a9fbf                             # 004a9fa2
    # block 0x004a9fa4: entered by fall-through of je at 0x004a9fa2, 4 instruction(s), ends with je to 0x004a9fbf (forward)
    mov eax, dword ptr [ebp - local_8]           # 004a9fa4
    movsx ecx, word ptr [eax + field_29]         # 004a9fa7
    test ecx, ecx                                # 004a9fab
    je.d8 L_004a9fbf                             # 004a9fad
    # block 0x004a9faf: entered by fall-through of je at 0x004a9fad, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004a9fbf
    mov edx, dword ptr [ebp - local_8]           # 004a9faf
    mov ax, word ptr [edx + field_29]            # 004a9fb2
    push eax                                     # 004a9fb6
    call FUN_004d3992                            # 004a9fb7
    add esp, 0x4                                 # 004a9fbc
L_004a9fbf:
    # block 0x004a9fbf: entered by je at 0x004a9fa2; je at 0x004a9fad, 5 instruction(s), calls FUN_004a9f27, ends with ret
    mov ecx, dword ptr [ebp - local_8]           # 004a9fbf
    call FUN_004a9f27                            # 004a9fc2
    {load} mov esp, ebp                          # 004a9fc7
    pop ebp                                      # 004a9fc9
    ret                                          # 004a9fca

