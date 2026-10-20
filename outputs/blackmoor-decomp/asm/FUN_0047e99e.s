# FUN_0047e99e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e99e
# extent:       0x0047e99e-0x0047e9d3 (53 code bytes)
# span:         0x0047e99e-0x0047e9d3 (code 53, tables 0, padding 0)
# sha256:       c79a9aef8da7071bd7a7489b72ab12802f5aecc36e3c8e8a2e2ccca68cd760ea
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         rect_valid
# naming:       native port src/action_family_eb_runtime.c:rect_valid (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with rect_valid (nonzero when both edge pairs differ). Native takes the body and a rectangle offset where the original takes a pointer.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_c; [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:rect_valid (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0047e99e - 0x401000
.globl FUN_0047e99e
FUN_0047e99e:
    # block 0x0047e99e: entry, 10 instruction(s), ends with je to 0x0047e9c4 (forward)
    push ebp                                     # 0047e99e
    {load} mov ebp, esp                          # 0047e99f
    push ecx                                     # 0047e9a1
    mov dword ptr [ebp - local_4], ecx           # 0047e9a2
    mov eax, dword ptr [ebp + arg_8]             # 0047e9a5
    mov ecx, dword ptr [ebp + arg_8]             # 0047e9a8
    mov edx, dword ptr [eax + field_c]           # 0047e9ab
    sub edx, dword ptr [ecx + field_4]           # 0047e9ae
    test edx, edx                                # 0047e9b1
    je.d8 L_0047e9c4                             # 0047e9b3
    # block 0x0047e9b5: entered by fall-through of je at 0x0047e9b3, 6 instruction(s), ends with jne to 0x0047e9c8 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0047e9b5
    mov ecx, dword ptr [ebp + arg_8]             # 0047e9b8
    mov edx, dword ptr [eax + field_8]           # 0047e9bb
    sub edx, dword ptr [ecx]                     # 0047e9be
    test edx, edx                                # 0047e9c0
    jne.d8 L_0047e9c8                            # 0047e9c2
L_0047e9c4:
    # block 0x0047e9c4: entered by je at 0x0047e9b3; fall-through of jne at 0x0047e9c2, 2 instruction(s), ends with forward jump to 0x0047e9cd
    {load} xor eax, eax                          # 0047e9c4
    jmp.d8 L_0047e9cd                            # 0047e9c6
L_0047e9c8:
    # block 0x0047e9c8: entered by jne at 0x0047e9c2, 1 instruction(s), falls into the block at 0x0047e9cd
    mov eax, 0x1                                 # 0047e9c8
L_0047e9cd:
    # block 0x0047e9cd: entered by jmp at 0x0047e9c6, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0047e9cd
    pop ebp                                      # 0047e9cf
    ret 0x4                                      # 0047e9d0

