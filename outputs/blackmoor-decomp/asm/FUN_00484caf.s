# FUN_00484caf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00484caf
# extent:       0x00484caf-0x00484d87 (216 code bytes)
# span:         0x00484caf-0x00484d87 (code 216, tables 0, padding 0)
# sha256:       efe2f23539b342c092f2e420aec64754623d4d5435d8931b73ee0c408354c2be
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         clamp_rect
# naming:       native port src/action_family_ea_runtime.c:clamp_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      1:1 with clamp_rect (clip to view bounds). Native reads clip globals through the host view seam (not logged against the original); oracle aggregate.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:clamp_rect (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00484caf - 0x401000
.globl FUN_00484caf
FUN_00484caf:
    # block 0x00484caf: entry, 18 instruction(s), ends with jge to 0x00484d02 (forward)
    push ebp                                     # 00484caf
    {load} mov ebp, esp                          # 00484cb0
    sub esp, 0xc                                 # 00484cb2
    mov dword ptr [ebp - local_c], ecx           # 00484cb5
    mov eax, dword ptr [ebp + arg_8]             # 00484cb8
    mov ecx, dword ptr [ebp + arg_8]             # 00484cbb
    mov edx, dword ptr [eax + field_8]           # 00484cbe
    sub edx, dword ptr [ecx]                     # 00484cc1
    mov word ptr [ebp - local_8], dx             # 00484cc3
    mov eax, dword ptr [ebp + arg_8]             # 00484cc7
    mov ecx, dword ptr [ebp + arg_8]             # 00484cca
    mov edx, dword ptr [eax + field_c]           # 00484ccd
    sub edx, dword ptr [ecx + field_4]           # 00484cd0
    mov word ptr [ebp - local_4], dx             # 00484cd3
    mov eax, dword ptr [ebp + arg_8]             # 00484cd7
    mov ecx, dword ptr [eax + field_4]           # 00484cda
    cmp ecx, dword ptr [0x58319a]                # 00484cdd
    jge.d8 L_00484d02                            # 00484ce3
    # block 0x00484ce5: entered by fall-through of jge at 0x00484ce3, 9 instruction(s), falls into the block at 0x00484d02
    mov edx, dword ptr [ebp + arg_8]             # 00484ce5
    mov eax, dword ptr [0x58319a]                # 00484ce8
    mov dword ptr [edx + field_4], eax           # 00484ced
    movsx ecx, word ptr [ebp - local_4]          # 00484cf0
    mov edx, dword ptr [ebp + arg_8]             # 00484cf4
    mov eax, dword ptr [edx + field_4]           # 00484cf7
    {load} add eax, ecx                          # 00484cfa
    mov ecx, dword ptr [ebp + arg_8]             # 00484cfc
    mov dword ptr [ecx + field_c], eax           # 00484cff
L_00484d02:
    # block 0x00484d02: entered by jge at 0x00484ce3, 4 instruction(s), ends with jle to 0x00484d2e (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00484d02
    mov eax, dword ptr [edx + field_c]           # 00484d05
    cmp eax, dword ptr [0x5831a2]                # 00484d08
    jle.d8 L_00484d2e                            # 00484d0e
    # block 0x00484d10: entered by fall-through of jle at 0x00484d0e, 9 instruction(s), falls into the block at 0x00484d2e
    mov ecx, dword ptr [ebp + arg_8]             # 00484d10
    mov edx, dword ptr [0x5831a2]                # 00484d13
    mov dword ptr [ecx + field_c], edx           # 00484d19
    movsx eax, word ptr [ebp - local_4]          # 00484d1c
    mov ecx, dword ptr [ebp + arg_8]             # 00484d20
    mov edx, dword ptr [ecx + field_c]           # 00484d23
    {load} sub edx, eax                          # 00484d26
    mov eax, dword ptr [ebp + arg_8]             # 00484d28
    mov dword ptr [eax + field_4], edx           # 00484d2b
L_00484d2e:
    # block 0x00484d2e: entered by jle at 0x00484d0e, 4 instruction(s), ends with jge to 0x00484d57 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00484d2e
    mov edx, dword ptr [ecx]                     # 00484d31
    cmp edx, dword ptr [0x583196]                # 00484d33
    jge.d8 L_00484d57                            # 00484d39
    # block 0x00484d3b: entered by fall-through of jge at 0x00484d39, 9 instruction(s), falls into the block at 0x00484d57
    mov eax, dword ptr [ebp + arg_8]             # 00484d3b
    mov ecx, dword ptr [0x583196]                # 00484d3e
    mov dword ptr [eax], ecx                     # 00484d44
    movsx edx, word ptr [ebp - local_8]          # 00484d46
    mov eax, dword ptr [ebp + arg_8]             # 00484d4a
    mov ecx, dword ptr [eax]                     # 00484d4d
    {load} add ecx, edx                          # 00484d4f
    mov edx, dword ptr [ebp + arg_8]             # 00484d51
    mov dword ptr [edx + field_8], ecx           # 00484d54
L_00484d57:
    # block 0x00484d57: entered by jge at 0x00484d39, 4 instruction(s), ends with jle to 0x00484d81 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00484d57
    mov ecx, dword ptr [eax + field_8]           # 00484d5a
    cmp ecx, dword ptr [0x58319e]                # 00484d5d
    jle.d8 L_00484d81                            # 00484d63
    # block 0x00484d65: entered by fall-through of jle at 0x00484d63, 9 instruction(s), falls into the block at 0x00484d81
    mov edx, dword ptr [ebp + arg_8]             # 00484d65
    mov eax, dword ptr [0x58319e]                # 00484d68
    mov dword ptr [edx + field_8], eax           # 00484d6d
    movsx ecx, word ptr [ebp - local_8]          # 00484d70
    mov edx, dword ptr [ebp + arg_8]             # 00484d74
    mov eax, dword ptr [edx + field_8]           # 00484d77
    {load} sub eax, ecx                          # 00484d7a
    mov ecx, dword ptr [ebp + arg_8]             # 00484d7c
    mov dword ptr [ecx], eax                     # 00484d7f
L_00484d81:
    # block 0x00484d81: entered by jle at 0x00484d63, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00484d81
    pop ebp                                      # 00484d83
    ret 0x4                                      # 00484d84

