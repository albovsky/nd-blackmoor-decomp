# FUN_004eb9c8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb9c8
# extent:       0x004eb9c8-0x004eba54 (140 code bytes)
# span:         0x004eb9c8-0x004eba54 (code 140, tables 0, padding 0)
# sha256:       61b19888833d27387a951acfe10271c7f91c007ba236f01c26262ae7e7c2d690
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4eb9c8_lifted
# naming:       native port src/original_methods_fl39d.c:m4eb9c8_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_ca0, field_fce, field_fda; [ecx + n] field_ca4, field_28da; [edx + n] field_4, field_8, field_c, field_fca
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4eb9c8_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_ca0, 0xca0  # offset +0xca0
.equ field_ca4, 0xca4  # offset +0xca4
.equ field_fca, 0xfca  # offset +0xfca
.equ field_fce, 0xfce  # offset +0xfce
.equ field_fda, 0xfda  # offset +0xfda
.equ field_28da, 0x28da  # offset +0x28da

# --- external targets -----------------------------------------------

.org 0x004eb9c8 - 0x401000
.globl FUN_004eb9c8
FUN_004eb9c8:
    # block 0x004eb9c8: entry, 16 instruction(s), ends with forward jump to 0x004eba25
    push ebp                                     # 004eb9c8
    {load} mov ebp, esp                          # 004eb9c9
    sub esp, 0x8                                 # 004eb9cb
    mov dword ptr [ebp - local_8], ecx           # 004eb9ce
    mov eax, dword ptr [ebp - local_8]           # 004eb9d1
    mov dword ptr [eax + field_ca0], 0x0         # 004eb9d4
    mov ecx, dword ptr [ebp - local_8]           # 004eb9de
    mov dword ptr [ecx + field_ca4], 0x0         # 004eb9e1
    mov edx, dword ptr [ebp - local_8]           # 004eb9eb
    mov dword ptr [edx + field_fca], 0xffffffff  # 004eb9ee
    mov eax, dword ptr [ebp - local_8]           # 004eb9f8
    mov dword ptr [eax + field_fce], 0xffffffff  # 004eb9fb
    mov ecx, dword ptr [ebp - local_8]           # 004eba05
    mov word ptr [ecx + field_28da], 0x0         # 004eba08
    mov word ptr [ebp - local_4], 0x0            # 004eba11
    jmp.d8 L_004eba25                            # 004eba17
L_004eba19:
    # block 0x004eba19: entered by jmp at 0x004eba4e, 3 instruction(s), falls into the block at 0x004eba25
    mov dx, word ptr [ebp - local_4]             # 004eba19
    add dx, 0x1                                  # 004eba1d
    mov word ptr [ebp - local_4], dx             # 004eba21
L_004eba25:
    # block 0x004eba25: entered by jmp at 0x004eba17, 3 instruction(s), ends with jge to 0x004eba50 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004eba25
    cmp eax, 0x190                               # 004eba29
    jge.d8 L_004eba50                            # 004eba2e
    # block 0x004eba30: entered by fall-through of jge at 0x004eba2e, 10 instruction(s), ends with backward jump to 0x004eba19
    {load} xor ecx, ecx                          # 004eba30
    movsx edx, word ptr [ebp - local_4]          # 004eba32
    shl edx, 0x4                                 # 004eba36
    mov eax, dword ptr [ebp - local_8]           # 004eba39
    lea edx, [eax + edx + field_fda]             # 004eba3c
    mov dword ptr [edx], ecx                     # 004eba43
    mov dword ptr [edx + field_4], ecx           # 004eba45
    mov dword ptr [edx + field_8], ecx           # 004eba48
    mov dword ptr [edx + field_c], ecx           # 004eba4b
    jmp.d8 L_004eba19                            # 004eba4e
L_004eba50:
    # block 0x004eba50: entered by jge at 0x004eba2e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004eba50
    pop ebp                                      # 004eba52
    ret                                          # 004eba53

