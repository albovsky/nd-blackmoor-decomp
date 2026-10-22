# FUN_004f67be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f67be
# extent:       0x004f67be-0x004f6810 (82 code bytes)
# span:         0x004f67be-0x004f6810 (code 82, tables 0, padding 0)
# sha256:       ccf5431d4172610417f8b9fb3db07a16270b75d1ea98be26e762ecf330300a29
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f67be_lifted
# naming:       native port src/original_methods_fl39d.c:m4f67be_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (17 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_004f646c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4f67be_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f646c, .text + (0x004f646c - 0x401000)

.org 0x004f67be - 0x401000
.globl FUN_004f67be
FUN_004f67be:
    # block 0x004f67be: entry, 7 instruction(s), ends with je to 0x004f67df (forward)
    push ebp                                     # 004f67be
    {load} mov ebp, esp                          # 004f67bf
    sub esp, 0x8                                 # 004f67c1
    mov dword ptr [ebp - local_8], ecx           # 004f67c4
    movsx eax, word ptr [0x63a4cd]               # 004f67c7
    test eax, eax                                # 004f67ce
    je.d8 L_004f67df                             # 004f67d0
    # block 0x004f67d2: entered by fall-through of je at 0x004f67d0, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f67df
    push 0x55e8cc                                # 004f67d2
    call FUN_0044a2b7                            # 004f67d7
    add esp, 0x4                                 # 004f67dc
L_004f67df:
    # block 0x004f67df: entered by je at 0x004f67d0, 2 instruction(s), ends with forward jump to 0x004f67f1
    mov dword ptr [ebp - local_4], 0x0           # 004f67df
    jmp.d8 L_004f67f1                            # 004f67e6
L_004f67e8:
    # block 0x004f67e8: entered by jmp at 0x004f6805, 3 instruction(s), falls into the block at 0x004f67f1
    mov ecx, dword ptr [ebp - local_4]           # 004f67e8
    add ecx, 0x1                                 # 004f67eb
    mov dword ptr [ebp - local_4], ecx           # 004f67ee
L_004f67f1:
    # block 0x004f67f1: entered by jmp at 0x004f67e6, 2 instruction(s), ends with jge to 0x004f6807 (forward)
    cmp dword ptr [ebp - local_4], 0x20          # 004f67f1
    jge.d8 L_004f6807                            # 004f67f5
    # block 0x004f67f7: entered by fall-through of jge at 0x004f67f5, 6 instruction(s), calls FUN_004f646c, ends with backward jump to 0x004f67e8
    push 0x1                                     # 004f67f7
    mov edx, dword ptr [ebp - local_4]           # 004f67f9
    push edx                                     # 004f67fc
    mov ecx, dword ptr [ebp - local_8]           # 004f67fd
    call FUN_004f646c                            # 004f6800
    jmp.d8 L_004f67e8                            # 004f6805
L_004f6807:
    # block 0x004f6807: entered by jge at 0x004f67f5, 4 instruction(s), ends with ret
    mov eax, 0x1                                 # 004f6807
    {load} mov esp, ebp                          # 004f680c
    pop ebp                                      # 004f680e
    ret                                          # 004f680f

