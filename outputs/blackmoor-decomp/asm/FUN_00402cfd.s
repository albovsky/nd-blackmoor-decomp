# FUN_00402cfd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402cfd
# extent:       0x00402cfd-0x00402d44 (71 code bytes)
# span:         0x00402cfd-0x00402d44 (code 71, tables 0, padding 0)
# sha256:       9ca44573d600bd9caa97b345d818bd48f1ac6ad083f4d798905481931c56bda7
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402cfd_toggle_5e610a
# naming:       native port src/original_methods_fl34a.c:m402cfd_toggle_5e610a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e610a+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34a.c:m402cfd_toggle_5e610a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402cfd - 0x401000
.globl FUN_00402cfd
FUN_00402cfd:
    # block 0x00402cfd: entry, 8 instruction(s), ends with jne to 0x00402d27 (forward)
    push ebp                                     # 00402cfd
    {load} mov ebp, esp                          # 00402cfe
    push ecx                                     # 00402d00
    mov dword ptr [ebp - local_4], ecx           # 00402d01
    mov eax, dword ptr [ebp - local_4]           # 00402d04
    mov ecx, dword ptr [eax + field_5c]          # 00402d07
    cmp dword ptr [4*ecx + 0x5e610a], 0x1        # 00402d0a
    jne.d8 L_00402d27                            # 00402d12
    # block 0x00402d14: entered by fall-through of jne at 0x00402d12, 4 instruction(s), ends with forward jump to 0x00402d38
    mov edx, dword ptr [ebp - local_4]           # 00402d14
    mov eax, dword ptr [edx + field_5c]          # 00402d17
    mov dword ptr [4*eax + 0x5e610a], 0x0        # 00402d1a
    jmp.d8 L_00402d38                            # 00402d25
L_00402d27:
    # block 0x00402d27: entered by jne at 0x00402d12, 3 instruction(s), falls into the block at 0x00402d38
    mov ecx, dword ptr [ebp - local_4]           # 00402d27
    mov edx, dword ptr [ecx + field_5c]          # 00402d2a
    mov dword ptr [4*edx + 0x5e610a], 0x1        # 00402d2d
L_00402d38:
    # block 0x00402d38: entered by jmp at 0x00402d25, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402d38
    call FUN_0040236a                            # 00402d3b
    {load} mov esp, ebp                          # 00402d40
    pop ebp                                      # 00402d42
    ret                                          # 00402d43

