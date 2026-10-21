# FUN_00402ea7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402ea7
# extent:       0x00402ea7-0x00402eee (71 code bytes)
# span:         0x00402ea7-0x00402eee (code 71, tables 0, padding 0)
# sha256:       beef5b01fb5ae801d99d3597867e99f70d1268a7d1751fb0cba873096021b1fa
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402ea7_toggle_5e6122
# naming:       native port src/original_methods_fl34a.c:m402ea7_toggle_5e6122 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e6122+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34a.c:m402ea7_toggle_5e6122 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402ea7 - 0x401000
.globl FUN_00402ea7
FUN_00402ea7:
    # block 0x00402ea7: entry, 8 instruction(s), ends with jne to 0x00402ed1 (forward)
    push ebp                                     # 00402ea7
    {load} mov ebp, esp                          # 00402ea8
    push ecx                                     # 00402eaa
    mov dword ptr [ebp - local_4], ecx           # 00402eab
    mov eax, dword ptr [ebp - local_4]           # 00402eae
    mov ecx, dword ptr [eax + field_5c]          # 00402eb1
    cmp dword ptr [4*ecx + 0x5e6122], 0x1        # 00402eb4
    jne.d8 L_00402ed1                            # 00402ebc
    # block 0x00402ebe: entered by fall-through of jne at 0x00402ebc, 4 instruction(s), ends with forward jump to 0x00402ee2
    mov edx, dword ptr [ebp - local_4]           # 00402ebe
    mov eax, dword ptr [edx + field_5c]          # 00402ec1
    mov dword ptr [4*eax + 0x5e6122], 0x0        # 00402ec4
    jmp.d8 L_00402ee2                            # 00402ecf
L_00402ed1:
    # block 0x00402ed1: entered by jne at 0x00402ebc, 3 instruction(s), falls into the block at 0x00402ee2
    mov ecx, dword ptr [ebp - local_4]           # 00402ed1
    mov edx, dword ptr [ecx + field_5c]          # 00402ed4
    mov dword ptr [4*edx + 0x5e6122], 0x1        # 00402ed7
L_00402ee2:
    # block 0x00402ee2: entered by jmp at 0x00402ecf, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402ee2
    call FUN_0040236a                            # 00402ee5
    {load} mov esp, ebp                          # 00402eea
    pop ebp                                      # 00402eec
    ret                                          # 00402eed

