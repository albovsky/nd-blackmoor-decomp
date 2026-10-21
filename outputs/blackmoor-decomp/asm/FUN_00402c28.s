# FUN_00402c28
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402c28
# extent:       0x00402c28-0x00402c6f (71 code bytes)
# span:         0x00402c28-0x00402c6f (code 71, tables 0, padding 0)
# sha256:       cb88eb3878333c9aeb3b261e15758a5c8da8770749bd64b2fda05f0d72e2c393
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402c28_toggle_5e60fe
# naming:       native port src/original_methods_fl34a.c:m402c28_toggle_5e60fe (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e60fe+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34a.c:m402c28_toggle_5e60fe (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402c28 - 0x401000
.globl FUN_00402c28
FUN_00402c28:
    # block 0x00402c28: entry, 8 instruction(s), ends with jne to 0x00402c52 (forward)
    push ebp                                     # 00402c28
    {load} mov ebp, esp                          # 00402c29
    push ecx                                     # 00402c2b
    mov dword ptr [ebp - local_4], ecx           # 00402c2c
    mov eax, dword ptr [ebp - local_4]           # 00402c2f
    mov ecx, dword ptr [eax + field_5c]          # 00402c32
    cmp dword ptr [4*ecx + 0x5e60fe], 0x1        # 00402c35
    jne.d8 L_00402c52                            # 00402c3d
    # block 0x00402c3f: entered by fall-through of jne at 0x00402c3d, 4 instruction(s), ends with forward jump to 0x00402c63
    mov edx, dword ptr [ebp - local_4]           # 00402c3f
    mov eax, dword ptr [edx + field_5c]          # 00402c42
    mov dword ptr [4*eax + 0x5e60fe], 0x0        # 00402c45
    jmp.d8 L_00402c63                            # 00402c50
L_00402c52:
    # block 0x00402c52: entered by jne at 0x00402c3d, 3 instruction(s), falls into the block at 0x00402c63
    mov ecx, dword ptr [ebp - local_4]           # 00402c52
    mov edx, dword ptr [ecx + field_5c]          # 00402c55
    mov dword ptr [4*edx + 0x5e60fe], 0x1        # 00402c58
L_00402c63:
    # block 0x00402c63: entered by jmp at 0x00402c50, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402c63
    call FUN_0040236a                            # 00402c66
    {load} mov esp, ebp                          # 00402c6b
    pop ebp                                      # 00402c6d
    ret                                          # 00402c6e

