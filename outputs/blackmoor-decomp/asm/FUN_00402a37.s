# FUN_00402a37
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402a37
# extent:       0x00402a37-0x00402a7e (71 code bytes)
# span:         0x00402a37-0x00402a7e (code 71, tables 0, padding 0)
# sha256:       f3c944f1af7780f092a4d9085e4312a9bfd7c96df7f6a4a0e04ae4e39ac20db7
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402a37_toggle_5e60e2
# naming:       native port src/original_methods_fl32a.c:m402a37_toggle_5e60e2 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e60e2+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32a.c:m402a37_toggle_5e60e2 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402a37 - 0x401000
.globl FUN_00402a37
FUN_00402a37:
    # block 0x00402a37: entry, 8 instruction(s), ends with jne to 0x00402a61 (forward)
    push ebp                                     # 00402a37
    {load} mov ebp, esp                          # 00402a38
    push ecx                                     # 00402a3a
    mov dword ptr [ebp - local_4], ecx           # 00402a3b
    mov eax, dword ptr [ebp - local_4]           # 00402a3e
    mov ecx, dword ptr [eax + field_5c]          # 00402a41
    cmp dword ptr [4*ecx + 0x5e60e2], 0x1        # 00402a44
    jne.d8 L_00402a61                            # 00402a4c
    # block 0x00402a4e: entered by fall-through of jne at 0x00402a4c, 4 instruction(s), ends with forward jump to 0x00402a72
    mov edx, dword ptr [ebp - local_4]           # 00402a4e
    mov eax, dword ptr [edx + field_5c]          # 00402a51
    mov dword ptr [4*eax + 0x5e60e2], 0x0        # 00402a54
    jmp.d8 L_00402a72                            # 00402a5f
L_00402a61:
    # block 0x00402a61: entered by jne at 0x00402a4c, 3 instruction(s), falls into the block at 0x00402a72
    mov ecx, dword ptr [ebp - local_4]           # 00402a61
    mov edx, dword ptr [ecx + field_5c]          # 00402a64
    mov dword ptr [4*edx + 0x5e60e2], 0x1        # 00402a67
L_00402a72:
    # block 0x00402a72: entered by jmp at 0x00402a5f, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402a72
    call FUN_0040236a                            # 00402a75
    {load} mov esp, ebp                          # 00402a7a
    pop ebp                                      # 00402a7c
    ret                                          # 00402a7d

