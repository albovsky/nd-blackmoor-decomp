# FUN_00446598
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446598
# extent:       0x00446598-0x004465fd (101 code bytes)
# span:         0x00446598-0x004465fd (code 101, tables 0, padding 0)
# sha256:       16de3b153ae659df97ba442a0cdf93d88c3a09c314bd4c8d3eab518eb2ef3b0c
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00446598
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_240; [ecx + n] field_240, field_244; [edx + n] field_244
# callees:      calls FUN_0050ca3e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00446598 - 0x401000
.globl FUN_00446598
FUN_00446598:
    # block 0x00446598: entry, 31 instruction(s), calls FUN_0050ca3e, ends with ret 0x8
    push ebp                                     # 00446598
    {load} mov ebp, esp                          # 00446599
    push ecx                                     # 0044659b
    mov dword ptr [ebp - local_4], ecx           # 0044659c
    mov eax, dword ptr [ebp - local_4]           # 0044659f
    mov ecx, dword ptr [ebp + arg_8]             # 004465a2
    mov dword ptr [eax + field_240], ecx         # 004465a5
    mov edx, dword ptr [ebp - local_4]           # 004465ab
    mov eax, dword ptr [ebp + arg_c]             # 004465ae
    mov dword ptr [edx + field_244], eax         # 004465b1
    mov ecx, dword ptr [ebp - local_4]           # 004465b7
    mov edx, dword ptr [ecx + field_240]         # 004465ba
    push edx                                     # 004465c0
    push 0x54823c                                # 004465c1
    mov eax, dword ptr [ebp - local_4]           # 004465c6
    add eax, 0x248                               # 004465c9
    push eax                                     # 004465ce
    call FUN_0050ca3e                            # 004465cf
    add esp, 0xc                                 # 004465d4
    mov ecx, dword ptr [ebp - local_4]           # 004465d7
    mov edx, dword ptr [ecx + field_244]         # 004465da
    push edx                                     # 004465e0
    push 0x548244                                # 004465e1
    mov eax, dword ptr [ebp - local_4]           # 004465e6
    add eax, 0x252                               # 004465e9
    push eax                                     # 004465ee
    call FUN_0050ca3e                            # 004465ef
    add esp, 0xc                                 # 004465f4
    {load} mov esp, ebp                          # 004465f7
    pop ebp                                      # 004465f9
    ret 0x8                                      # 004465fa

