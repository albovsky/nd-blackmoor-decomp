# FUN_004b3c5a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3c5a
# extent:       0x004b3c5a-0x004b3d4d (243 code bytes)
# span:         0x004b3c5a-0x004b3d4d (code 243, tables 0, padding 0)
# sha256:       6287d20290a5341c74ec43019b5c209e850961cccf271fb5778da4ab96d30118
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b3c5a_lifted
# naming:       native port src/original_methods_fl39d.c:m4b3c5a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_71e, field_724, field_728, field_74e, field_750, field_758, field_76e; [ecx + n] field_71c, field_720, field_752, field_754, field_75a, field_77a; [edx + n] field_722, field_726, field_72a, field_74c, field_75c, field_77e
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4b3c5a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_71c, 0x71c  # offset +0x71c
.equ field_71e, 0x71e  # offset +0x71e
.equ field_720, 0x720  # offset +0x720
.equ field_722, 0x722  # offset +0x722
.equ field_724, 0x724  # offset +0x724
.equ field_726, 0x726  # offset +0x726
.equ field_728, 0x728  # offset +0x728
.equ field_72a, 0x72a  # offset +0x72a
.equ field_74c, 0x74c  # offset +0x74c
.equ field_74e, 0x74e  # offset +0x74e
.equ field_750, 0x750  # offset +0x750
.equ field_752, 0x752  # offset +0x752
.equ field_754, 0x754  # offset +0x754
.equ field_758, 0x758  # offset +0x758
.equ field_75a, 0x75a  # offset +0x75a
.equ field_75c, 0x75c  # offset +0x75c
.equ field_76e, 0x76e  # offset +0x76e
.equ field_77a, 0x77a  # offset +0x77a
.equ field_77e, 0x77e  # offset +0x77e

# --- external targets -----------------------------------------------

.org 0x004b3c5a - 0x401000
.globl FUN_004b3c5a
FUN_004b3c5a:
    # block 0x004b3c5a: entry, 45 instruction(s), ends with ret
    push ebp                                     # 004b3c5a
    {load} mov ebp, esp                          # 004b3c5b
    push ecx                                     # 004b3c5d
    mov dword ptr [ebp - local_4], ecx           # 004b3c5e
    mov eax, dword ptr [ebp - local_4]           # 004b3c61
    mov word ptr [eax + field_728], 0xffff       # 004b3c64
    mov ecx, dword ptr [ebp - local_4]           # 004b3c6d
    mov dword ptr [ecx + field_754], 0x0         # 004b3c70
    mov edx, dword ptr [ebp - local_4]           # 004b3c7a
    mov word ptr [edx + field_726], 0xffff       # 004b3c7d
    mov eax, dword ptr [ebp - local_4]           # 004b3c86
    mov dword ptr [eax + field_76e], 0x0         # 004b3c89
    mov ecx, dword ptr [ebp - local_4]           # 004b3c93
    mov word ptr [ecx + field_75a], 0xffff       # 004b3c96
    mov edx, dword ptr [ebp - local_4]           # 004b3c9f
    mov word ptr [edx + field_75c], 0xffff       # 004b3ca2
    mov eax, dword ptr [ebp - local_4]           # 004b3cab
    mov word ptr [eax + field_758], 0xffff       # 004b3cae
    mov ecx, dword ptr [ebp - local_4]           # 004b3cb7
    mov word ptr [ecx + field_71c], 0xffff       # 004b3cba
    mov edx, dword ptr [ebp - local_4]           # 004b3cc3
    mov word ptr [edx + field_72a], 0xffff       # 004b3cc6
    mov eax, dword ptr [ebp - local_4]           # 004b3ccf
    mov word ptr [eax + field_750], 0x0          # 004b3cd2
    mov ecx, dword ptr [ebp - local_4]           # 004b3cdb
    mov word ptr [ecx + field_752], 0x0          # 004b3cde
    mov edx, dword ptr [ebp - local_4]           # 004b3ce7
    mov word ptr [edx + field_74c], 0x0          # 004b3cea
    mov eax, dword ptr [ebp - local_4]           # 004b3cf3
    mov word ptr [eax + field_74e], 0x0          # 004b3cf6
    mov ecx, dword ptr [ebp - local_4]           # 004b3cff
    mov dword ptr [ecx + field_77a], 0x0         # 004b3d02
    mov edx, dword ptr [ebp - local_4]           # 004b3d0c
    mov dword ptr [edx + field_77e], 0x0         # 004b3d0f
    mov eax, dword ptr [ebp - local_4]           # 004b3d19
    mov word ptr [eax + field_71e], 0x0          # 004b3d1c
    mov ecx, dword ptr [ebp - local_4]           # 004b3d25
    mov word ptr [ecx + field_720], 0x0          # 004b3d28
    mov edx, dword ptr [ebp - local_4]           # 004b3d31
    mov word ptr [edx + field_722], 0x0          # 004b3d34
    mov eax, dword ptr [ebp - local_4]           # 004b3d3d
    mov word ptr [eax + field_724], 0x0          # 004b3d40
    {load} mov esp, ebp                          # 004b3d49
    pop ebp                                      # 004b3d4b
    ret                                          # 004b3d4c

