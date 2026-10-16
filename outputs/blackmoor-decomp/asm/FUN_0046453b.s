# FUN_0046453b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046453b
# extent:       0x0046453b-0x0046458e (83 code bytes)
# span:         0x0046453b-0x0046458e (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046453b
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0046453b - 0x401000
.globl FUN_0046453b
FUN_0046453b:
    # block 0x0046453b: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 0046453b
    {load} mov ebp, esp                          # 0046453c
    push ecx                                     # 0046453e
    mov dword ptr [ebp - local_4], ecx           # 0046453f
    mov eax, dword ptr [ebp + arg_8]             # 00464542
    mov ecx, dword ptr [eax + field_4]           # 00464545
    add ecx, dword ptr [0x58318a]                # 00464548
    mov edx, dword ptr [ebp + arg_c]             # 0046454e
    mov dword ptr [edx + field_4], ecx           # 00464551
    mov eax, dword ptr [ebp + arg_8]             # 00464554
    mov ecx, dword ptr [eax + field_c]           # 00464557
    add ecx, dword ptr [0x58318a]                # 0046455a
    mov edx, dword ptr [ebp + arg_c]             # 00464560
    mov dword ptr [edx + field_c], ecx           # 00464563
    mov eax, dword ptr [ebp + arg_8]             # 00464566
    mov ecx, dword ptr [eax]                     # 00464569
    add ecx, dword ptr [0x583186]                # 0046456b
    mov edx, dword ptr [ebp + arg_c]             # 00464571
    mov dword ptr [edx], ecx                     # 00464574
    mov eax, dword ptr [ebp + arg_8]             # 00464576
    mov ecx, dword ptr [eax + field_8]           # 00464579
    add ecx, dword ptr [0x583186]                # 0046457c
    mov edx, dword ptr [ebp + arg_c]             # 00464582
    mov dword ptr [edx + field_8], ecx           # 00464585
    {load} mov esp, ebp                          # 00464588
    pop ebp                                      # 0046458a
    ret 0x8                                      # 0046458b

