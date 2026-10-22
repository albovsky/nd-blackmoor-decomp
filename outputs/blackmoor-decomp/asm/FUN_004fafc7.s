# FUN_004fafc7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fafc7
# extent:       0x004fafc7-0x004fb018 (81 code bytes)
# span:         0x004fafc7-0x004fb018 (code 81, tables 0, padding 0)
# sha256:       1ecca54e5d3cb4fe1319a5f132111dd97c71224a8e5a35914f1c6758eee14ed3
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fafc7_lifted
# naming:       native port src/original_methods_fl39d.c:m4fafc7_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (13 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_004fb1c6
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4fafc7_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fb1c6, .text + (0x004fb1c6 - 0x401000)

.org 0x004fafc7 - 0x401000
.globl FUN_004fafc7
FUN_004fafc7:
    # block 0x004fafc7: entry, 7 instruction(s), ends with je to 0x004fafe8 (forward)
    push ebp                                     # 004fafc7
    {load} mov ebp, esp                          # 004fafc8
    sub esp, 0x8                                 # 004fafca
    mov dword ptr [ebp - local_8], ecx           # 004fafcd
    movsx eax, word ptr [0x63a4cd]               # 004fafd0
    test eax, eax                                # 004fafd7
    je.d8 L_004fafe8                             # 004fafd9
    # block 0x004fafdb: entered by fall-through of je at 0x004fafd9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004fafe8
    push 0x560648                                # 004fafdb
    call FUN_0044a2b7                            # 004fafe0
    add esp, 0x4                                 # 004fafe5
L_004fafe8:
    # block 0x004fafe8: entered by je at 0x004fafd9, 2 instruction(s), ends with forward jump to 0x004faffc
    mov word ptr [ebp - local_4], 0x0            # 004fafe8
    jmp.d8 L_004faffc                            # 004fafee
L_004faff0:
    # block 0x004faff0: entered by jmp at 0x004fb012, 3 instruction(s), falls into the block at 0x004faffc
    mov cx, word ptr [ebp - local_4]             # 004faff0
    add cx, 0x1                                  # 004faff4
    mov word ptr [ebp - local_4], cx             # 004faff8
L_004faffc:
    # block 0x004faffc: entered by jmp at 0x004fafee, 3 instruction(s), ends with jge to 0x004fb014 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004faffc
    cmp edx, 0xe                                 # 004fb000
    jge.d8 L_004fb014                            # 004fb003
    # block 0x004fb005: entered by fall-through of jge at 0x004fb003, 5 instruction(s), calls FUN_004fb1c6, ends with backward jump to 0x004faff0
    mov ax, word ptr [ebp - local_4]             # 004fb005
    push eax                                     # 004fb009
    mov ecx, dword ptr [ebp - local_8]           # 004fb00a
    call FUN_004fb1c6                            # 004fb00d
    jmp.d8 L_004faff0                            # 004fb012
L_004fb014:
    # block 0x004fb014: entered by jge at 0x004fb003, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004fb014
    pop ebp                                      # 004fb016
    ret                                          # 004fb017

