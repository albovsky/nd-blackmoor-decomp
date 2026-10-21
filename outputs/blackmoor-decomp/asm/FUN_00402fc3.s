# FUN_00402fc3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402fc3
# extent:       0x00402fc3-0x0040300a (71 code bytes)
# span:         0x00402fc3-0x00403010 (code 71, tables 0, padding 6)
# sha256:       43ed873cc8e137e320dd27eb468063c8e6d7df9cec5dffa86e73375f0ef6104e
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402fc3_toggle_5e6132
# naming:       native port src/original_methods_fl34a.c:m402fc3_toggle_5e6132 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e6132+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34a.c:m402fc3_toggle_5e6132 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402fc3 - 0x401000
.globl FUN_00402fc3
FUN_00402fc3:
    # block 0x00402fc3: entry, 8 instruction(s), ends with jne to 0x00402fed (forward)
    push ebp                                     # 00402fc3
    {load} mov ebp, esp                          # 00402fc4
    push ecx                                     # 00402fc6
    mov dword ptr [ebp - local_4], ecx           # 00402fc7
    mov eax, dword ptr [ebp - local_4]           # 00402fca
    mov ecx, dword ptr [eax + field_5c]          # 00402fcd
    cmp dword ptr [4*ecx + 0x5e6132], 0x1        # 00402fd0
    jne.d8 L_00402fed                            # 00402fd8
    # block 0x00402fda: entered by fall-through of jne at 0x00402fd8, 4 instruction(s), ends with forward jump to 0x00402ffe
    mov edx, dword ptr [ebp - local_4]           # 00402fda
    mov eax, dword ptr [edx + field_5c]          # 00402fdd
    mov dword ptr [4*eax + 0x5e6132], 0x0        # 00402fe0
    jmp.d8 L_00402ffe                            # 00402feb
L_00402fed:
    # block 0x00402fed: entered by jne at 0x00402fd8, 3 instruction(s), falls into the block at 0x00402ffe
    mov ecx, dword ptr [ebp - local_4]           # 00402fed
    mov edx, dword ptr [ecx + field_5c]          # 00402ff0
    mov dword ptr [4*edx + 0x5e6132], 0x1        # 00402ff3
L_00402ffe:
    # block 0x00402ffe: entered by jmp at 0x00402feb, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402ffe
    call FUN_0040236a                            # 00403001
    {load} mov esp, ebp                          # 00403006
    pop ebp                                      # 00403008
    ret                                          # 00403009

# --- data items (not part of the function) -------------------------
.org 0x0040300a - 0x401000
PAD_0040300a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

