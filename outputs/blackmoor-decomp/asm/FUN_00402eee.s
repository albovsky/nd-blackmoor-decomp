# FUN_00402eee
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402eee
# extent:       0x00402eee-0x00402f35 (71 code bytes)
# span:         0x00402eee-0x00402f35 (code 71, tables 0, padding 0)
# sha256:       36bd721d1d69ef2c6df4268dfde9e213eda8af0fe4946ac836ba1c648f760203
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402eee_toggle_5e6126
# naming:       native port src/original_methods_fl34a.c:m402eee_toggle_5e6126 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Toggles the dword at 0x5e6126+4*[self+0x5c] (exactly 1 becomes 0, anything else becomes 1), then calls 0x40236a; both directions of the compare taken, every instruction executed.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34a.c:m402eee_toggle_5e6126 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)

.org 0x00402eee - 0x401000
.globl FUN_00402eee
FUN_00402eee:
    # block 0x00402eee: entry, 8 instruction(s), ends with jne to 0x00402f18 (forward)
    push ebp                                     # 00402eee
    {load} mov ebp, esp                          # 00402eef
    push ecx                                     # 00402ef1
    mov dword ptr [ebp - local_4], ecx           # 00402ef2
    mov eax, dword ptr [ebp - local_4]           # 00402ef5
    mov ecx, dword ptr [eax + field_5c]          # 00402ef8
    cmp dword ptr [4*ecx + 0x5e6126], 0x1        # 00402efb
    jne.d8 L_00402f18                            # 00402f03
    # block 0x00402f05: entered by fall-through of jne at 0x00402f03, 4 instruction(s), ends with forward jump to 0x00402f29
    mov edx, dword ptr [ebp - local_4]           # 00402f05
    mov eax, dword ptr [edx + field_5c]          # 00402f08
    mov dword ptr [4*eax + 0x5e6126], 0x0        # 00402f0b
    jmp.d8 L_00402f29                            # 00402f16
L_00402f18:
    # block 0x00402f18: entered by jne at 0x00402f03, 3 instruction(s), falls into the block at 0x00402f29
    mov ecx, dword ptr [ebp - local_4]           # 00402f18
    mov edx, dword ptr [ecx + field_5c]          # 00402f1b
    mov dword ptr [4*edx + 0x5e6126], 0x1        # 00402f1e
L_00402f29:
    # block 0x00402f29: entered by jmp at 0x00402f16, 5 instruction(s), calls FUN_0040236a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00402f29
    call FUN_0040236a                            # 00402f2c
    {load} mov esp, ebp                          # 00402f31
    pop ebp                                      # 00402f33
    ret                                          # 00402f34

