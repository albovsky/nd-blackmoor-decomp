# FUN_00420b9e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00420b9e
# extent:       0x00420b9e-0x00420c17 (121 code bytes)
# span:         0x00420b9e-0x00420c17 (code 121, tables 0, padding 0)
# sha256:       6a323858b8c714a58729ff1c74fe66f11f842730857d348ff765969bed8e5712
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m420b9e_report_name
# naming:       native port src/original_methods_fl31b.c:m420b9e_report_name (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Picks word +0xf75 or +0xf73 and string 0x543b60 or 0x543b88 by dword 0x5b15da, calls 0x4c51a5 with the table entry; 32/32, 2/2 jump directions. See tasks/fl31b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_f75; [edx + n] field_f73
# callees:      calls FUN_004c51a5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31b.c:m420b9e_report_name (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 32 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_f73, 0xf73  # offset +0xf73
.equ field_f75, 0xf75  # offset +0xf75

# --- external targets -----------------------------------------------
.set FUN_004c51a5, .text + (0x004c51a5 - 0x401000)

.org 0x00420b9e - 0x401000
.globl FUN_00420b9e
FUN_00420b9e:
    # block 0x00420b9e: entry, 6 instruction(s), ends with je to 0x00420be1 (forward)
    push ebp                                     # 00420b9e
    {load} mov ebp, esp                          # 00420b9f
    push ecx                                     # 00420ba1
    mov dword ptr [ebp - local_4], ecx           # 00420ba2
    cmp dword ptr [0x5b15da], 0x0                # 00420ba5
    je.d8 L_00420be1                             # 00420bac
    # block 0x00420bae: entered by fall-through of je at 0x00420bac, 12 instruction(s), calls FUN_004c51a5, ends with forward jump to 0x00420c13
    push 0x543b60                                # 00420bae
    push 0x5b15de                                # 00420bb3
    push 0x5b15de                                # 00420bb8
    mov eax, dword ptr [0x5d03af]                # 00420bbd
    push eax                                     # 00420bc2
    mov ecx, dword ptr [ebp - local_4]           # 00420bc3
    movsx edx, word ptr [ecx + field_f75]        # 00420bc6
    mov eax, dword ptr [4*edx + 0x5d02cb]        # 00420bcd
    push eax                                     # 00420bd4
    mov ecx, 0x5cf659                            # 00420bd5
    call FUN_004c51a5                            # 00420bda
    jmp.d8 L_00420c13                            # 00420bdf
L_00420be1:
    # block 0x00420be1: entered by je at 0x00420bac, 11 instruction(s), calls FUN_004c51a5, falls into the block at 0x00420c13
    push 0x543b88                                # 00420be1
    push 0x5b15de                                # 00420be6
    push 0x5b15de                                # 00420beb
    mov ecx, dword ptr [0x5d03af]                # 00420bf0
    push ecx                                     # 00420bf6
    mov edx, dword ptr [ebp - local_4]           # 00420bf7
    movsx eax, word ptr [edx + field_f73]        # 00420bfa
    mov ecx, dword ptr [4*eax + 0x5d02cb]        # 00420c01
    push ecx                                     # 00420c08
    mov ecx, 0x5cf659                            # 00420c09
    call FUN_004c51a5                            # 00420c0e
L_00420c13:
    # block 0x00420c13: entered by jmp at 0x00420bdf, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00420c13
    pop ebp                                      # 00420c15
    ret                                          # 00420c16

