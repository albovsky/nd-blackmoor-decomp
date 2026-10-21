# FUN_004029f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004029f0
# extent:       0x004029f0-0x00402a37 (71 code bytes)
# span:         0x004029f0-0x00402a37 (code 71, tables 0, padding 0)
# sha256:       522e22c947013b78901fbf0997024ebf5bf16c28df1022f497022a8476992f32
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4029f0_toggle_5e60de
# naming:       native port src/original_methods_fl32a.c:m4029f0_toggle_5e60de (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e60de+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32a.c:m4029f0_toggle_5e60de (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x004029f0 - 0x401000
.globl FUN_004029f0
FUN_004029f0:
    # block 0x004029f0: entry, 8 instruction(s), ends with jne to 0x00402a1a (forward)
    push ebp                                     # 004029f0
    {load} mov ebp, esp                          # 004029f1
    push ecx                                     # 004029f3
    mov dword ptr [ebp - local_4], ecx           # 004029f4
    mov eax, dword ptr [ebp - local_4]           # 004029f7
    mov ecx, dword ptr [eax + field_5c]          # 004029fa
    cmp dword ptr [4*ecx + 0x5e60de], 0x1        # 004029fd
    jne.d8 L_00402a1a                            # 00402a05
    # block 0x00402a07: entered by fall-through of jne at 0x00402a05, 4 instruction(s), ends with forward jump to 0x00402a2b
    mov edx, dword ptr [ebp - local_4]           # 00402a07
    mov eax, dword ptr [edx + field_5c]          # 00402a0a
    mov dword ptr [4*eax + 0x5e60de], 0x0        # 00402a0d
    jmp.d8 L_00402a2b                            # 00402a18
L_00402a1a:
    # block 0x00402a1a: entered by jne at 0x00402a05, 3 instruction(s), falls into the block at 0x00402a2b
    mov ecx, dword ptr [ebp - local_4]           # 00402a1a
    mov edx, dword ptr [ecx + field_5c]          # 00402a1d
    mov dword ptr [4*edx + 0x5e60de], 0x1        # 00402a20
L_00402a2b:
    # block 0x00402a2b: entered by jmp at 0x00402a18, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402a2b
    call FUN_0040236a                            # 00402a2e
    {load} mov esp, ebp                          # 00402a33
    pop ebp                                      # 00402a35
    ret                                          # 00402a36

