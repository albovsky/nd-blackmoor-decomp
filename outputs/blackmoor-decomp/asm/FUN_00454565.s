# FUN_00454565
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454565
# extent:       0x00454565-0x004545b0 (75 code bytes)
# span:         0x00454565-0x004545b0 (code 75, tables 0, padding 0)
# sha256:       d80598154d2a1d68c7cd4dd883dc4224151760ae51bb6ca297cc979dccc96d6d
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00454565
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [ecx + n] field_4; [esi + n] field_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x00454565 - 0x401000
.globl FUN_00454565
FUN_00454565:
    # block 0x00454565: entry, 30 instruction(s), ends with ret 0xc
    push ebp                                     # 00454565
    {load} mov ebp, esp                          # 00454566
    sub esp, 0x8                                 # 00454568
    push esi                                     # 0045456b
    mov dword ptr [ebp - local_8], ecx           # 0045456c
    mov eax, dword ptr [ebp + arg_c]             # 0045456f
    mov ecx, dword ptr [ebp + arg_8]             # 00454572
    mov edx, dword ptr [eax]                     # 00454575
    sub edx, dword ptr [ecx]                     # 00454577
    mov eax, dword ptr [ebp + arg_10]            # 00454579
    mov ecx, dword ptr [ebp + arg_8]             # 0045457c
    mov eax, dword ptr [eax + field_4]           # 0045457f
    sub eax, dword ptr [ecx + field_4]           # 00454582
    imul edx, eax                                # 00454585
    mov ecx, dword ptr [ebp + arg_10]            # 00454588
    mov eax, dword ptr [ebp + arg_8]             # 0045458b
    mov ecx, dword ptr [ecx]                     # 0045458e
    sub ecx, dword ptr [eax]                     # 00454590
    mov eax, dword ptr [ebp + arg_c]             # 00454592
    mov esi, dword ptr [ebp + arg_8]             # 00454595
    mov eax, dword ptr [eax + field_4]           # 00454598
    sub eax, dword ptr [esi + field_4]           # 0045459b
    imul ecx, eax                                # 0045459e
    {load} sub edx, ecx                          # 004545a1
    mov dword ptr [ebp - local_4], edx           # 004545a3
    mov eax, dword ptr [ebp - local_4]           # 004545a6
    pop esi                                      # 004545a9
    {load} mov esp, ebp                          # 004545aa
    pop ebp                                      # 004545ac
    ret 0xc                                      # 004545ad

