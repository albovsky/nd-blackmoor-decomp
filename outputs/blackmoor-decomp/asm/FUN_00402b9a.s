# FUN_00402b9a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402b9a
# extent:       0x00402b9a-0x00402be1 (71 code bytes)
# span:         0x00402b9a-0x00402be1 (code 71, tables 0, padding 0)
# sha256:       3f5f85634844fbe2c5a241303185341acae714d30d103aef69d8217ecfe6f1fc
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402b9a_toggle_5e60f6
# naming:       native port src/original_methods_fl34a.c:m402b9a_toggle_5e60f6 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e60f6+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34a.c:m402b9a_toggle_5e60f6 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402b9a - 0x401000
.globl FUN_00402b9a
FUN_00402b9a:
    # block 0x00402b9a: entry, 8 instruction(s), ends with jne to 0x00402bc4 (forward)
    push ebp                                     # 00402b9a
    {load} mov ebp, esp                          # 00402b9b
    push ecx                                     # 00402b9d
    mov dword ptr [ebp - local_4], ecx           # 00402b9e
    mov eax, dword ptr [ebp - local_4]           # 00402ba1
    mov ecx, dword ptr [eax + field_5c]          # 00402ba4
    cmp dword ptr [4*ecx + 0x5e60f6], 0x1        # 00402ba7
    jne.d8 L_00402bc4                            # 00402baf
    # block 0x00402bb1: entered by fall-through of jne at 0x00402baf, 4 instruction(s), ends with forward jump to 0x00402bd5
    mov edx, dword ptr [ebp - local_4]           # 00402bb1
    mov eax, dword ptr [edx + field_5c]          # 00402bb4
    mov dword ptr [4*eax + 0x5e60f6], 0x0        # 00402bb7
    jmp.d8 L_00402bd5                            # 00402bc2
L_00402bc4:
    # block 0x00402bc4: entered by jne at 0x00402baf, 3 instruction(s), falls into the block at 0x00402bd5
    mov ecx, dword ptr [ebp - local_4]           # 00402bc4
    mov edx, dword ptr [ecx + field_5c]          # 00402bc7
    mov dword ptr [4*edx + 0x5e60f6], 0x1        # 00402bca
L_00402bd5:
    # block 0x00402bd5: entered by jmp at 0x00402bc2, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402bd5
    call FUN_0040236a                            # 00402bd8
    {load} mov esp, ebp                          # 00402bdd
    pop ebp                                      # 00402bdf
    ret                                          # 00402be0

