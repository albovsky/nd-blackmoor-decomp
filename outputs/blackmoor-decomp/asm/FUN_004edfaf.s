# FUN_004edfaf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004edfaf
# extent:       0x004edfaf-0x004ee0d4 (293 code bytes)
# span:         0x004edfaf-0x004ee0d4 (code 293, tables 0, padding 0)
# sha256:       dab73ecd68c6b5e5e98c4955a484e410f564728f4a882e9e41c8b6ad667c6ed5
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4edfaf_centre_rect
# naming:       native port src/original_methods_fl28b.c:m4edfaf_centre_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      Centres a rectangle: the kind == 3 test of the whole dword, four truncating halvings (cdq/sub/sar) with wrapping sums, then the 0x4db993 call; every instruction and jump direction executed. See tasks/fl28b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_24, field_28, field_66d, field_671, field_68d; [ecx + n] field_1c, field_20, field_4af, field_665, field_669; [edx + n] field_1c, field_20, field_665, field_669, field_689, field_68d
# callees:      calls FUN_004db993
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4e7786_forward (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 95 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_4af, 0x4af  # offset +0x4af
.equ field_665, 0x665  # offset +0x665
.equ field_669, 0x669  # offset +0x669
.equ field_66d, 0x66d  # offset +0x66d
.equ field_671, 0x671  # offset +0x671
.equ field_689, 0x689  # offset +0x689
.equ field_68d, 0x68d  # offset +0x68d

# --- external targets -----------------------------------------------
.set FUN_004db993, .text + (0x004db993 - 0x401000)

.org 0x004edfaf - 0x401000
.globl FUN_004edfaf
FUN_004edfaf:
    # block 0x004edfaf: entry, 11 instruction(s), ends with je to 0x004ee038 (forward)
    push ebp                                     # 004edfaf
    {load} mov ebp, esp                          # 004edfb0
    sub esp, 0xc                                 # 004edfb2
    mov dword ptr [ebp - local_4], ecx           # 004edfb5
    mov eax, dword ptr [ebp + arg_8]             # 004edfb8
    mov dword ptr [ebp - local_8], eax           # 004edfbb
    mov ecx, dword ptr [ebp - local_4]           # 004edfbe
    mov edx, dword ptr [ecx + field_4af]         # 004edfc1
    mov dword ptr [ebp - local_c], edx           # 004edfc7
    cmp dword ptr [ebp - local_c], 0x3           # 004edfca
    je.d8 L_004ee038                             # 004edfce
    # block 0x004edfd0: entered by fall-through of je at 0x004edfce, 37 instruction(s), ends with forward jump to 0x004ee0b0
    mov eax, dword ptr [ebp - local_4]           # 004edfd0
    mov ecx, dword ptr [ebp - local_4]           # 004edfd3
    mov eax, dword ptr [eax + field_24]          # 004edfd6
    sub eax, dword ptr [ecx + field_1c]          # 004edfd9
    add eax, 0x1                                 # 004edfdc
    cdq                                          # 004edfdf
    {load} sub eax, edx                          # 004edfe0
    sar eax                                      # 004edfe2
    mov edx, dword ptr [ebp - local_4]           # 004edfe4
    mov ecx, dword ptr [edx + field_1c]          # 004edfe7
    {load} add ecx, eax                          # 004edfea
    movsx eax, word ptr [0x5b3790]               # 004edfec
    cdq                                          # 004edff3
    {load} sub eax, edx                          # 004edff4
    sar eax                                      # 004edff6
    {load} sub ecx, eax                          # 004edff8
    mov edx, dword ptr [ebp - local_4]           # 004edffa
    mov dword ptr [edx + field_689], ecx         # 004edffd
    mov eax, dword ptr [ebp - local_4]           # 004ee003
    mov ecx, dword ptr [ebp - local_4]           # 004ee006
    mov eax, dword ptr [eax + field_28]          # 004ee009
    sub eax, dword ptr [ecx + field_20]          # 004ee00c
    add eax, 0x1                                 # 004ee00f
    cdq                                          # 004ee012
    {load} sub eax, edx                          # 004ee013
    sar eax                                      # 004ee015
    mov edx, dword ptr [ebp - local_4]           # 004ee017
    mov ecx, dword ptr [edx + field_20]          # 004ee01a
    {load} add ecx, eax                          # 004ee01d
    movsx eax, word ptr [0x5b3792]               # 004ee01f
    cdq                                          # 004ee026
    {load} sub eax, edx                          # 004ee027
    sar eax                                      # 004ee029
    {load} sub ecx, eax                          # 004ee02b
    mov edx, dword ptr [ebp - local_4]           # 004ee02d
    mov dword ptr [edx + field_68d], ecx         # 004ee030
    jmp.d8 L_004ee0b0                            # 004ee036
L_004ee038:
    # block 0x004ee038: entered by je at 0x004edfce, 36 instruction(s), falls into the block at 0x004ee0b0
    mov eax, dword ptr [ebp - local_4]           # 004ee038
    mov ecx, dword ptr [ebp - local_4]           # 004ee03b
    mov eax, dword ptr [eax + field_66d]         # 004ee03e
    sub eax, dword ptr [ecx + field_665]         # 004ee044
    add eax, 0x1                                 # 004ee04a
    cdq                                          # 004ee04d
    {load} sub eax, edx                          # 004ee04e
    sar eax                                      # 004ee050
    mov edx, dword ptr [ebp - local_4]           # 004ee052
    mov ecx, dword ptr [edx + field_665]         # 004ee055
    {load} add ecx, eax                          # 004ee05b
    movsx eax, word ptr [0x5b3790]               # 004ee05d
    cdq                                          # 004ee064
    {load} sub eax, edx                          # 004ee065
    sar eax                                      # 004ee067
    {load} sub ecx, eax                          # 004ee069
    mov edx, dword ptr [ebp - local_4]           # 004ee06b
    mov dword ptr [edx + field_689], ecx         # 004ee06e
    mov eax, dword ptr [ebp - local_4]           # 004ee074
    mov ecx, dword ptr [ebp - local_4]           # 004ee077
    mov eax, dword ptr [eax + field_671]         # 004ee07a
    sub eax, dword ptr [ecx + field_669]         # 004ee080
    add eax, 0x1                                 # 004ee086
    cdq                                          # 004ee089
    {load} sub eax, edx                          # 004ee08a
    sar eax                                      # 004ee08c
    mov edx, dword ptr [ebp - local_4]           # 004ee08e
    mov ecx, dword ptr [edx + field_669]         # 004ee091
    {load} add ecx, eax                          # 004ee097
    movsx eax, word ptr [0x5b3792]               # 004ee099
    cdq                                          # 004ee0a0
    {load} sub eax, edx                          # 004ee0a1
    sar eax                                      # 004ee0a3
    {load} sub ecx, eax                          # 004ee0a5
    mov edx, dword ptr [ebp - local_4]           # 004ee0a7
    mov dword ptr [edx + field_68d], ecx         # 004ee0aa
L_004ee0b0:
    # block 0x004ee0b0: entered by jmp at 0x004ee036, 11 instruction(s), calls FUN_004db993, ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004ee0b0
    mov ecx, dword ptr [eax + field_68d]         # 004ee0b3
    push ecx                                     # 004ee0b9
    mov edx, dword ptr [ebp - local_4]           # 004ee0ba
    mov eax, dword ptr [edx + field_689]         # 004ee0bd
    push eax                                     # 004ee0c3
    mov ecx, 0x5830ce                            # 004ee0c4
    call FUN_004db993                            # 004ee0c9
    {load} mov esp, ebp                          # 004ee0ce
    pop ebp                                      # 004ee0d0
    ret 0x4                                      # 004ee0d1

