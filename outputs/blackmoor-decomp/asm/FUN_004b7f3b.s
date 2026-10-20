# FUN_004b7f3b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7f3b
# extent:       0x004b7f3b-0x004b7ff4 (185 code bytes)
# span:         0x004b7f3b-0x004b7ff4 (code 185, tables 0, padding 0)
# sha256:       83b0fbf598a4dd2924e32ee21d1971ca1dcb6f137972c22e3c2dc0e85f25f0d9
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b7f3b_reset
# naming:       native port src/original_methods_fl18.c:m4b7f3b_reset (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4b7f3b_reset. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 185 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_6, field_14, field_1c, field_546; [ecx + n] field_4, field_8, field_c, field_18, field_34; [edx + n] field_8, field_c, field_20, field_61e
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_f5_runtime.c:tqz_cleanup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 48 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_34, 0x34  # offset +0x34
.equ field_546, 0x546  # offset +0x546
.equ field_61e, 0x61e  # offset +0x61e

# --- external targets -----------------------------------------------

.org 0x004b7f3b - 0x401000
.globl FUN_004b7f3b
FUN_004b7f3b:
    # block 0x004b7f3b: entry, 48 instruction(s), ends with ret
    push ebp                                     # 004b7f3b
    {load} mov ebp, esp                          # 004b7f3c
    push ecx                                     # 004b7f3e
    push edi                                     # 004b7f3f
    mov dword ptr [ebp - local_4], ecx           # 004b7f40
    mov eax, dword ptr [ebp - local_4]           # 004b7f43
    mov word ptr [eax + field_6], 0xffff         # 004b7f46
    mov ecx, dword ptr [ebp - local_4]           # 004b7f4c
    mov word ptr [ecx + field_4], 0xffff         # 004b7f4f
    mov edx, dword ptr [ebp - local_4]           # 004b7f55
    mov dword ptr [edx + field_8], 0x0           # 004b7f58
    mov eax, dword ptr [ebp - local_4]           # 004b7f5f
    mov dword ptr [eax + field_14], 0x0          # 004b7f62
    mov ecx, dword ptr [ebp - local_4]           # 004b7f69
    mov dword ptr [ecx + field_18], 0x0          # 004b7f6c
    mov edx, dword ptr [ebp - local_4]           # 004b7f73
    mov dword ptr [edx + field_20], 0x0          # 004b7f76
    mov eax, dword ptr [ebp - local_4]           # 004b7f7d
    mov dword ptr [eax + field_1c], 0x0          # 004b7f80
    mov ecx, dword ptr [ebp - local_4]           # 004b7f87
    mov dword ptr [ecx + field_34], 0x0          # 004b7f8a
    mov edx, dword ptr [ebp - local_4]           # 004b7f91
    mov dword ptr [edx + field_c], 0x0           # 004b7f94
    {load} xor eax, eax                          # 004b7f9b
    mov ecx, dword ptr [ebp - local_4]           # 004b7f9d
    add ecx, 0x54e                               # 004b7fa0
    mov dword ptr [ecx], eax                     # 004b7fa6
    mov dword ptr [ecx + field_4], eax           # 004b7fa8
    mov dword ptr [ecx + field_8], eax           # 004b7fab
    mov dword ptr [ecx + field_c], eax           # 004b7fae
    mov ecx, 0x2e                                # 004b7fb1
    {load} xor eax, eax                          # 004b7fb6
    mov edi, dword ptr [ebp - local_4]           # 004b7fb8
    add edi, 0x496                               # 004b7fbb
    rep stosd dword ptr es:[edi], eax            # 004b7fc1
    mov ecx, 0x32                                # 004b7fc3
    {load} xor eax, eax                          # 004b7fc8
    mov edi, dword ptr [ebp - local_4]           # 004b7fca
    add edi, 0x55e                               # 004b7fcd
    rep stosd dword ptr es:[edi], eax            # 004b7fd3
    mov edx, dword ptr [ebp - local_4]           # 004b7fd5
    mov dword ptr [edx + field_61e], 0xffffffff  # 004b7fd8
    mov eax, dword ptr [ebp - local_4]           # 004b7fe2
    mov dword ptr [eax + field_546], 0xffffffff  # 004b7fe5
    pop edi                                      # 004b7fef
    {load} mov esp, ebp                          # 004b7ff0
    pop ebp                                      # 004b7ff2
    ret                                          # 004b7ff3

