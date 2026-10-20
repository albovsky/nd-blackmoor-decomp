# FUN_004e7728
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7728
# extent:       0x004e7728-0x004e7757 (47 code bytes)
# span:         0x004e7728-0x004e7757 (code 47, tables 0, padding 0)
# sha256:       691b2826eb2df5c2ec2cd06089d97c289c645c483dc5f1bfa1b8e7ce65203dd0
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7728_open
# naming:       native port src/original_methods_fl16.c:m4e7728_open (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4e7728_open (0x43dbd5, 0x4d36ed via Fl16Host callbacks, [this+0x991] := value, then 0x4edf96 as a direct call).
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_991
# callees:      calls FUN_0043dbd5, FUN_004d36ed, FUN_004edf96
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:phase0 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004edf96, .text + (0x004edf96 - 0x401000)

.org 0x004e7728 - 0x401000
.globl FUN_004e7728
FUN_004e7728:
    # block 0x004e7728: entry, 16 instruction(s), calls FUN_0043dbd5, FUN_004d36ed, FUN_004edf96, ends with ret 0x4
    push ebp                                     # 004e7728
    {load} mov ebp, esp                          # 004e7729
    push ecx                                     # 004e772b
    mov dword ptr [ebp - local_4], ecx           # 004e772c
    call FUN_0043dbd5                            # 004e772f
    call FUN_004d36ed                            # 004e7734
    mov eax, dword ptr [ebp - local_4]           # 004e7739
    mov ecx, dword ptr [ebp + arg_8]             # 004e773c
    mov dword ptr [eax + field_991], ecx         # 004e773f
    mov edx, dword ptr [ebp + arg_8]             # 004e7745
    push edx                                     # 004e7748
    mov ecx, dword ptr [ebp - local_4]           # 004e7749
    call FUN_004edf96                            # 004e774c
    {load} mov esp, ebp                          # 004e7751
    pop ebp                                      # 004e7753
    ret 0x4                                      # 004e7754

