# FUN_004e7ba7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7ba7
# extent:       0x004e7ba7-0x004e7bf3 (76 code bytes)
# span:         0x004e7ba7-0x004e7bf3 (code 76, tables 0, padding 0)
# sha256:       69a3ab91d4020f7eabee71bf2ad325be550f70170fba08f94b0591770be1b07b
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7ba7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_764c, field_8236; [ecx + n] field_7650, field_8252; [edx + n] field_8232
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/inventory_view_runtime.c:inventory_view_close (function ledger class candidate_port; also inventory_view_open, reset_state; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_764c, 0x764c  # offset +0x764c
.equ field_7650, 0x7650  # offset +0x7650
.equ field_8232, 0x8232  # offset +0x8232
.equ field_8236, 0x8236  # offset +0x8236
.equ field_8252, 0x8252  # offset +0x8252

# --- external targets -----------------------------------------------

.org 0x004e7ba7 - 0x401000
.globl FUN_004e7ba7
FUN_004e7ba7:
    # block 0x004e7ba7: entry, 17 instruction(s), ends with ret
    push ebp                                     # 004e7ba7
    {load} mov ebp, esp                          # 004e7ba8
    push ecx                                     # 004e7baa
    mov dword ptr [ebp - local_4], ecx           # 004e7bab
    mov eax, dword ptr [ebp - local_4]           # 004e7bae
    mov dword ptr [eax + field_764c], 0x0        # 004e7bb1
    mov ecx, dword ptr [ebp - local_4]           # 004e7bbb
    mov dword ptr [ecx + field_7650], 0x0        # 004e7bbe
    mov edx, dword ptr [ebp - local_4]           # 004e7bc8
    mov dword ptr [edx + field_8232], 0xffffffff # 004e7bcb
    mov eax, dword ptr [ebp - local_4]           # 004e7bd5
    mov dword ptr [eax + field_8236], 0xffffffff # 004e7bd8
    mov ecx, dword ptr [ebp - local_4]           # 004e7be2
    mov dword ptr [ecx + field_8252], 0x0        # 004e7be5
    {load} mov esp, ebp                          # 004e7bef
    pop ebp                                      # 004e7bf1
    ret                                          # 004e7bf2

