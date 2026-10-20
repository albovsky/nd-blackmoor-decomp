# FUN_00423097
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423097
# extent:       0x00423097-0x004230d1 (58 code bytes)
# span:         0x00423097-0x004230d1 (code 58, tables 0, padding 0)
# sha256:       9ef78e5e90da3f4962a0ddc051cae69dc5052a7bf3c04653428f1a6347cb3e0f
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m423097_clear_table
# naming:       native port src/original_methods_fl16.c:m423097_clear_table (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m423097_clear_table (0x400 dwords zeroed, returns this).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m423097_clear_table (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------

.org 0x00423097 - 0x401000
.globl FUN_00423097
FUN_00423097:
    # block 0x00423097: entry, 6 instruction(s), ends with forward jump to 0x004230b2
    push ebp                                     # 00423097
    {load} mov ebp, esp                          # 00423098
    sub esp, 0x8                                 # 0042309a
    mov dword ptr [ebp - local_8], ecx           # 0042309d
    mov dword ptr [ebp - local_4], 0x0           # 004230a0
    jmp.d8 L_004230b2                            # 004230a7
L_004230a9:
    # block 0x004230a9: entered by jmp at 0x004230c8, 3 instruction(s), falls into the block at 0x004230b2
    mov eax, dword ptr [ebp - local_4]           # 004230a9
    add eax, 0x1                                 # 004230ac
    mov dword ptr [ebp - local_4], eax           # 004230af
L_004230b2:
    # block 0x004230b2: entered by jmp at 0x004230a7, 2 instruction(s), ends with jge to 0x004230ca (forward)
    cmp dword ptr [ebp - local_4], 0x400         # 004230b2
    jge.d8 L_004230ca                            # 004230b9
    # block 0x004230bb: entered by fall-through of jge at 0x004230b9, 4 instruction(s), ends with backward jump to 0x004230a9
    mov ecx, dword ptr [ebp - local_4]           # 004230bb
    mov edx, dword ptr [ebp - local_8]           # 004230be
    mov dword ptr [edx + 4*ecx], 0x0             # 004230c1
    jmp.d8 L_004230a9                            # 004230c8
L_004230ca:
    # block 0x004230ca: entered by jge at 0x004230b9, 4 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_8]           # 004230ca
    {load} mov esp, ebp                          # 004230cd
    pop ebp                                      # 004230cf
    ret                                          # 004230d0

