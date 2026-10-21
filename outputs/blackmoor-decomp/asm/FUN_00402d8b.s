# FUN_00402d8b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402d8b
# extent:       0x00402d8b-0x00402dd2 (71 code bytes)
# span:         0x00402d8b-0x00402dd2 (code 71, tables 0, padding 0)
# sha256:       3354ddf6694d96c185bca8b534164151d437d1afb119bfb627f831903c9a3ef6
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402d8b_toggle_5e6112
# naming:       native port src/original_methods_fl34a.c:m402d8b_toggle_5e6112 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e6112+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34a.c:m402d8b_toggle_5e6112 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402d8b - 0x401000
.globl FUN_00402d8b
FUN_00402d8b:
    # block 0x00402d8b: entry, 8 instruction(s), ends with jne to 0x00402db5 (forward)
    push ebp                                     # 00402d8b
    {load} mov ebp, esp                          # 00402d8c
    push ecx                                     # 00402d8e
    mov dword ptr [ebp - local_4], ecx           # 00402d8f
    mov eax, dword ptr [ebp - local_4]           # 00402d92
    mov ecx, dword ptr [eax + field_5c]          # 00402d95
    cmp dword ptr [4*ecx + 0x5e6112], 0x1        # 00402d98
    jne.d8 L_00402db5                            # 00402da0
    # block 0x00402da2: entered by fall-through of jne at 0x00402da0, 4 instruction(s), ends with forward jump to 0x00402dc6
    mov edx, dword ptr [ebp - local_4]           # 00402da2
    mov eax, dword ptr [edx + field_5c]          # 00402da5
    mov dword ptr [4*eax + 0x5e6112], 0x0        # 00402da8
    jmp.d8 L_00402dc6                            # 00402db3
L_00402db5:
    # block 0x00402db5: entered by jne at 0x00402da0, 3 instruction(s), falls into the block at 0x00402dc6
    mov ecx, dword ptr [ebp - local_4]           # 00402db5
    mov edx, dword ptr [ecx + field_5c]          # 00402db8
    mov dword ptr [4*edx + 0x5e6112], 0x1        # 00402dbb
L_00402dc6:
    # block 0x00402dc6: entered by jmp at 0x00402db3, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402dc6
    call FUN_0040236a                            # 00402dc9
    {load} mov esp, ebp                          # 00402dce
    pop ebp                                      # 00402dd0
    ret                                          # 00402dd1

