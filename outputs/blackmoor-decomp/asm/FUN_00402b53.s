# FUN_00402b53
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402b53
# extent:       0x00402b53-0x00402b9a (71 code bytes)
# span:         0x00402b53-0x00402b9a (code 71, tables 0, padding 0)
# sha256:       d68a5335592c3545c4444c545e38faef3bbcc9e31ae4514c85bad378620a14a6
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402b53_toggle_5e60f2
# naming:       native port src/original_methods_fl34a.c:m402b53_toggle_5e60f2 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e60f2+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34a.c:m402b53_toggle_5e60f2 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402b53 - 0x401000
.globl FUN_00402b53
FUN_00402b53:
    # block 0x00402b53: entry, 8 instruction(s), ends with jne to 0x00402b7d (forward)
    push ebp                                     # 00402b53
    {load} mov ebp, esp                          # 00402b54
    push ecx                                     # 00402b56
    mov dword ptr [ebp - local_4], ecx           # 00402b57
    mov eax, dword ptr [ebp - local_4]           # 00402b5a
    mov ecx, dword ptr [eax + field_5c]          # 00402b5d
    cmp dword ptr [4*ecx + 0x5e60f2], 0x1        # 00402b60
    jne.d8 L_00402b7d                            # 00402b68
    # block 0x00402b6a: entered by fall-through of jne at 0x00402b68, 4 instruction(s), ends with forward jump to 0x00402b8e
    mov edx, dword ptr [ebp - local_4]           # 00402b6a
    mov eax, dword ptr [edx + field_5c]          # 00402b6d
    mov dword ptr [4*eax + 0x5e60f2], 0x0        # 00402b70
    jmp.d8 L_00402b8e                            # 00402b7b
L_00402b7d:
    # block 0x00402b7d: entered by jne at 0x00402b68, 3 instruction(s), falls into the block at 0x00402b8e
    mov ecx, dword ptr [ebp - local_4]           # 00402b7d
    mov edx, dword ptr [ecx + field_5c]          # 00402b80
    mov dword ptr [4*edx + 0x5e60f2], 0x1        # 00402b83
L_00402b8e:
    # block 0x00402b8e: entered by jmp at 0x00402b7b, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402b8e
    call FUN_0040236a                            # 00402b91
    {load} mov esp, ebp                          # 00402b96
    pop ebp                                      # 00402b98
    ret                                          # 00402b99

