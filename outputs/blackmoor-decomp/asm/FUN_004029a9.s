# FUN_004029a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004029a9
# extent:       0x004029a9-0x004029f0 (71 code bytes)
# span:         0x004029a9-0x004029f0 (code 71, tables 0, padding 0)
# sha256:       8f3aa04d0aa1511bcd05e016729987270d0e164c47d727069f62a1ccdfc2a8e1
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4029a9_toggle_5e60da
# naming:       native port src/original_methods_fl32a.c:m4029a9_toggle_5e60da (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e60da+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl32a.c:m4029a9_toggle_5e60da (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x004029a9 - 0x401000
.globl FUN_004029a9
FUN_004029a9:
    # block 0x004029a9: entry, 8 instruction(s), ends with jne to 0x004029d3 (forward)
    push ebp                                     # 004029a9
    {load} mov ebp, esp                          # 004029aa
    push ecx                                     # 004029ac
    mov dword ptr [ebp - local_4], ecx           # 004029ad
    mov eax, dword ptr [ebp - local_4]           # 004029b0
    mov ecx, dword ptr [eax + field_5c]          # 004029b3
    cmp dword ptr [4*ecx + 0x5e60da], 0x1        # 004029b6
    jne.d8 L_004029d3                            # 004029be
    # block 0x004029c0: entered by fall-through of jne at 0x004029be, 4 instruction(s), ends with forward jump to 0x004029e4
    mov edx, dword ptr [ebp - local_4]           # 004029c0
    mov eax, dword ptr [edx + field_5c]          # 004029c3
    mov dword ptr [4*eax + 0x5e60da], 0x0        # 004029c6
    jmp.d8 L_004029e4                            # 004029d1
L_004029d3:
    # block 0x004029d3: entered by jne at 0x004029be, 3 instruction(s), falls into the block at 0x004029e4
    mov ecx, dword ptr [ebp - local_4]           # 004029d3
    mov edx, dword ptr [ecx + field_5c]          # 004029d6
    mov dword ptr [4*edx + 0x5e60da], 0x1        # 004029d9
L_004029e4:
    # block 0x004029e4: entered by jmp at 0x004029d1, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004029e4
    call FUN_0040236a                            # 004029e7
    {load} mov esp, ebp                          # 004029ec
    pop ebp                                      # 004029ee
    ret                                          # 004029ef

