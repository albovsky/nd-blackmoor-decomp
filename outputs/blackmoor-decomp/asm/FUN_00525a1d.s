# FUN_00525a1d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525a1d
# extent:       0x00525a1d-0x00525ab6 (153 code bytes)
# span:         0x00525a1d-0x00525ab6 (code 153, tables 0, padding 0)
# sha256:       5be71e111182e545a766fc997d0e965f624772715d18eaf967d1595931c7a8bb
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525a1d
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ebx + n] field_10, field_14, field_1c; [ecx + n] field_4; [esi + n] field_8, field_c
# callees:      calls KERNEL32.dll!EnterCriticalSection, FUN_00525697, KERNEL32.dll!LeaveCriticalSection, KERNEL32.dll!LocalFree, KERNEL32.dll!TlsSetValue; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
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
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_00525697, .text + (0x00525697 - 0x401000)

.org 0x00525a1d - 0x401000
.globl FUN_00525a1d
FUN_00525a1d:
    # block 0x00525a1d: entry, 13 instruction(s), ends with jle to 0x00525a76 (forward)
    push ebp                                     # 00525a1d
    {load} mov ebp, esp                          # 00525a1e
    push ecx                                     # 00525a20
    push ebx                                     # 00525a21
    push esi                                     # 00525a22
    mov esi, dword ptr [ebp + arg_8]             # 00525a23
    push edi                                     # 00525a26
    push 0x1                                     # 00525a27
    {load} mov ebx, ecx                          # 00525a29
    pop edi                                      # 00525a2b
    cmp dword ptr [esi + field_8], edi           # 00525a2c
    mov dword ptr [ebp - local_4], edi           # 00525a2f
    jle.d8 L_00525a76                            # 00525a32
L_00525a34:
    # block 0x00525a34: entered by jl at 0x00525a6e; fall-through of jle at 0x00525a32, 3 instruction(s), ends with je to 0x00525a53 (forward)
    mov eax, dword ptr [ebp + arg_c]             # 00525a34
    test eax, eax                                # 00525a37
    je.d8 L_00525a53                             # 00525a39
    # block 0x00525a3b: entered by fall-through of je at 0x00525a39, 3 instruction(s), ends with je to 0x00525a53 (forward)
    mov ecx, dword ptr [ebx + field_10]          # 00525a3b
    cmp dword ptr [ecx + 8*edi + field_4], eax   # 00525a3e
    je.d8 L_00525a53                             # 00525a42
    # block 0x00525a44: entered by fall-through of je at 0x00525a42, 3 instruction(s), ends with je to 0x00525a6a (forward)
    mov eax, dword ptr [esi + field_c]           # 00525a44
    cmp dword ptr [eax + 4*edi], 0x0             # 00525a47
    je.d8 L_00525a6a                             # 00525a4b
    # block 0x00525a4d: entered by fall-through of je at 0x00525a4b, 2 instruction(s), ends with forward jump to 0x00525a6a
    and dword ptr [ebp - local_4], 0x0           # 00525a4d
    jmp.d8 L_00525a6a                            # 00525a51
L_00525a53:
    # block 0x00525a53: entered by je at 0x00525a39; je at 0x00525a42, 4 instruction(s), ends with je to 0x00525a63 (forward)
    mov eax, dword ptr [esi + field_c]           # 00525a53
    mov ecx, dword ptr [eax + 4*edi]             # 00525a56
    test ecx, ecx                                # 00525a59
    je.d8 L_00525a63                             # 00525a5b
    # block 0x00525a5d: entered by fall-through of je at 0x00525a5b, 3 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x00525a63
    mov eax, dword ptr [ecx]                     # 00525a5d
    push 0x1                                     # 00525a5f
    call dword ptr [eax]                         # 00525a61
L_00525a63:
    # block 0x00525a63: entered by je at 0x00525a5b, 2 instruction(s), falls into the block at 0x00525a6a
    mov eax, dword ptr [esi + field_c]           # 00525a63
    and dword ptr [eax + 4*edi], 0x0             # 00525a66
L_00525a6a:
    # block 0x00525a6a: entered by je at 0x00525a4b; jmp at 0x00525a51, 3 instruction(s), ends with jl to 0x00525a34 (backward)
    inc edi                                      # 00525a6a
    cmp edi, dword ptr [esi + field_8]           # 00525a6b
    jl.d8 L_00525a34                             # 00525a6e
    # block 0x00525a70: entered by fall-through of jl at 0x00525a6e, 2 instruction(s), ends with je to 0x00525aaf (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00525a70
    je.d8 L_00525aaf                             # 00525a74
L_00525a76:
    # block 0x00525a76: entered by jle at 0x00525a32; fall-through of je at 0x00525a74, 12 instruction(s), calls KERNEL32.dll!EnterCriticalSection, FUN_00525697, KERNEL32.dll!LeaveCriticalSection, KERNEL32.dll!..., ends with je to 0x00525aa5 (forward)
    lea edi, [ebx + field_1c]                    # 00525a76
    push edi                                     # 00525a79
    call dword ptr [0x52a0d0]                    # 00525a7a
    push esi                                     # 00525a80
    lea ecx, [ebx + field_14]                    # 00525a81
    call FUN_00525697                            # 00525a84
    push edi                                     # 00525a89
    call dword ptr [0x52a0c8]                    # 00525a8a
    push dword ptr [esi + field_c]               # 00525a90
    call dword ptr [0x52a1d8]                    # 00525a93
    test esi, esi                                # 00525a99
    je.d8 L_00525aa5                             # 00525a9b
    # block 0x00525a9d: entered by fall-through of je at 0x00525a9b, 4 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x00525aa5
    mov eax, dword ptr [esi]                     # 00525a9d
    push 0x1                                     # 00525a9f
    {load} mov ecx, esi                          # 00525aa1
    call dword ptr [eax]                         # 00525aa3
L_00525aa5:
    # block 0x00525aa5: entered by je at 0x00525a9b, 3 instruction(s), calls KERNEL32.dll!TlsSetValue, falls into the block at 0x00525aaf
    push 0x0                                     # 00525aa5
    push dword ptr [ebx]                         # 00525aa7
    call dword ptr [0x52a0d4]                    # 00525aa9
L_00525aaf:
    # block 0x00525aaf: entered by je at 0x00525a74, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 00525aaf
    pop esi                                      # 00525ab0
    pop ebx                                      # 00525ab1
    leave                                        # 00525ab2
    ret 0x8                                      # 00525ab3

