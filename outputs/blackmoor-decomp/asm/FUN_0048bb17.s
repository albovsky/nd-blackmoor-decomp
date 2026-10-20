# FUN_0048bb17
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048bb17
# extent:       0x0048bb17-0x0048bb86 (111 code bytes)
# span:         0x0048bb17-0x0048bb86 (code 111, tables 0, padding 0)
# sha256:       6641270acd0adc0dfa9724340851a5ebc3243d0b1b5a95a66bf021c6e2f76a25
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         reset_fields
# naming:       native port src/action_family_d8_runtime.c:reset_fields (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      reset_fields stores exactly the 12 fields of the original (+0x26/+0x2e/+0x30 = -1, +0x1c = 0xff, +0x41/+0x43, bytes +0x40/+0x45/+0x46/+0x47, dwords +0x1e/+0x22);
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_26, field_40, field_45; [ecx + n] field_1e, field_2e, field_43, field_46; [edx + n] field_22, field_30, field_41, field_47
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d8_runtime.c:reset_fields (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_26, 0x26  # offset +0x26
.equ field_2e, 0x2e  # offset +0x2e
.equ field_30, 0x30  # offset +0x30
.equ field_40, 0x40  # offset +0x40
.equ field_41, 0x41  # offset +0x41
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_46, 0x46  # offset +0x46
.equ field_47, 0x47  # offset +0x47

# --- external targets -----------------------------------------------

.org 0x0048bb17 - 0x401000
.globl FUN_0048bb17
FUN_0048bb17:
    # block 0x0048bb17: entry, 31 instruction(s), ends with ret
    push ebp                                     # 0048bb17
    {load} mov ebp, esp                          # 0048bb18
    push ecx                                     # 0048bb1a
    mov dword ptr [ebp - local_4], ecx           # 0048bb1b
    mov eax, dword ptr [ebp - local_4]           # 0048bb1e
    mov word ptr [eax + field_26], 0xffff        # 0048bb21
    mov ecx, dword ptr [ebp - local_4]           # 0048bb27
    mov word ptr [ecx + field_2e], 0xffff        # 0048bb2a
    mov edx, dword ptr [ebp - local_4]           # 0048bb30
    mov word ptr [edx + field_30], 0xffff        # 0048bb33
    mov eax, dword ptr [ebp - local_4]           # 0048bb39
    mov byte ptr [eax + field_1c], -0x1          # 0048bb3c
    mov ecx, dword ptr [ebp - local_4]           # 0048bb40
    mov word ptr [ecx + field_43], 0x0           # 0048bb43
    mov edx, dword ptr [ebp - local_4]           # 0048bb49
    mov word ptr [edx + field_41], 0x0           # 0048bb4c
    mov eax, dword ptr [ebp - local_4]           # 0048bb52
    mov byte ptr [eax + field_40], 0x0           # 0048bb55
    mov ecx, dword ptr [ebp - local_4]           # 0048bb59
    mov byte ptr [ecx + field_46], 0x0           # 0048bb5c
    mov edx, dword ptr [ebp - local_4]           # 0048bb60
    mov byte ptr [edx + field_47], 0x0           # 0048bb63
    mov eax, dword ptr [ebp - local_4]           # 0048bb67
    mov byte ptr [eax + field_45], 0x0           # 0048bb6a
    mov ecx, dword ptr [ebp - local_4]           # 0048bb6e
    mov dword ptr [ecx + field_1e], 0x0          # 0048bb71
    mov edx, dword ptr [ebp - local_4]           # 0048bb78
    mov dword ptr [edx + field_22], 0x0          # 0048bb7b
    {load} mov esp, ebp                          # 0048bb82
    pop ebp                                      # 0048bb84
    ret                                          # 0048bb85

