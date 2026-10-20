# FUN_0044d8ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d8ad
# extent:       0x0044d8ad-0x0044d946 (153 code bytes)
# span:         0x0044d8ad-0x0044d946 (code 153, tables 0, padding 0)
# sha256:       ae511437a9a901f309142c541ae0971ede882f8d55d31f867f4b0b27d8a9e375
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         step_hour
# naming:       native port src/action_family_aa_runtime.c:step_hour (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      step_hour matches increase (+1 mod 12, flip AM at 0xb) and decrease (0 -> 0xb, else -1 mod 12, flip AM at 0xa); object image compared against the original after each handler step.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_3d, field_41; [ecx + n] field_3d; [edx + n] field_3d, field_41
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_aa_runtime.c:step_hour (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 53 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41

# --- external targets -----------------------------------------------

.org 0x0044d8ad - 0x401000
.globl FUN_0044d8ad
FUN_0044d8ad:
    # block 0x0044d8ad: entry, 6 instruction(s), ends with je to 0x0044d8f3 (forward)
    push ebp                                     # 0044d8ad
    {load} mov ebp, esp                          # 0044d8ae
    push ecx                                     # 0044d8b0
    mov dword ptr [ebp - local_4], ecx           # 0044d8b1
    cmp dword ptr [ebp + arg_8], 0x0             # 0044d8b4
    je.d8 L_0044d8f3                             # 0044d8b8
    # block 0x0044d8ba: entered by fall-through of je at 0x0044d8b8, 12 instruction(s), ends with jne to 0x0044d8f1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0044d8ba
    movsx eax, word ptr [eax + field_3d]         # 0044d8bd
    add eax, 0x1                                 # 0044d8c1
    cdq                                          # 0044d8c4
    mov ecx, 0xc                                 # 0044d8c5
    idiv ecx                                     # 0044d8ca
    mov eax, dword ptr [ebp - local_4]           # 0044d8cc
    mov word ptr [eax + field_3d], dx            # 0044d8cf
    mov ecx, dword ptr [ebp - local_4]           # 0044d8d3
    movsx edx, word ptr [ecx + field_3d]         # 0044d8d6
    cmp edx, 0xb                                 # 0044d8da
    jne.d8 L_0044d8f1                            # 0044d8dd
    # block 0x0044d8df: entered by fall-through of jne at 0x0044d8dd, 6 instruction(s), falls into the block at 0x0044d8f1
    mov eax, dword ptr [ebp - local_4]           # 0044d8df
    {load} xor ecx, ecx                          # 0044d8e2
    cmp dword ptr [eax + field_41], 0x0          # 0044d8e4
    sete cl                                      # 0044d8e8
    mov edx, dword ptr [ebp - local_4]           # 0044d8eb
    mov dword ptr [edx + field_41], ecx          # 0044d8ee
L_0044d8f1:
    # block 0x0044d8f1: entered by jne at 0x0044d8dd, 1 instruction(s), ends with forward jump to 0x0044d940
    jmp.d8 L_0044d940                            # 0044d8f1
L_0044d8f3:
    # block 0x0044d8f3: entered by je at 0x0044d8b8, 4 instruction(s), ends with jne to 0x0044d909 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0044d8f3
    movsx ecx, word ptr [eax + field_3d]         # 0044d8f6
    test ecx, ecx                                # 0044d8fa
    jne.d8 L_0044d909                            # 0044d8fc
    # block 0x0044d8fe: entered by fall-through of jne at 0x0044d8fc, 3 instruction(s), ends with forward jump to 0x0044d922
    mov edx, dword ptr [ebp - local_4]           # 0044d8fe
    mov word ptr [edx + field_3d], 0xb           # 0044d901
    jmp.d8 L_0044d922                            # 0044d907
L_0044d909:
    # block 0x0044d909: entered by jne at 0x0044d8fc, 8 instruction(s), falls into the block at 0x0044d922
    mov eax, dword ptr [ebp - local_4]           # 0044d909
    movsx eax, word ptr [eax + field_3d]         # 0044d90c
    sub eax, 0x1                                 # 0044d910
    cdq                                          # 0044d913
    mov ecx, 0xc                                 # 0044d914
    idiv ecx                                     # 0044d919
    mov eax, dword ptr [ebp - local_4]           # 0044d91b
    mov word ptr [eax + field_3d], dx            # 0044d91e
L_0044d922:
    # block 0x0044d922: entered by jmp at 0x0044d907, 4 instruction(s), ends with jne to 0x0044d940 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044d922
    movsx edx, word ptr [ecx + field_3d]         # 0044d925
    cmp edx, 0xa                                 # 0044d929
    jne.d8 L_0044d940                            # 0044d92c
    # block 0x0044d92e: entered by fall-through of jne at 0x0044d92c, 6 instruction(s), falls into the block at 0x0044d940
    mov eax, dword ptr [ebp - local_4]           # 0044d92e
    {load} xor ecx, ecx                          # 0044d931
    cmp dword ptr [eax + field_41], 0x0          # 0044d933
    sete cl                                      # 0044d937
    mov edx, dword ptr [ebp - local_4]           # 0044d93a
    mov dword ptr [edx + field_41], ecx          # 0044d93d
L_0044d940:
    # block 0x0044d940: entered by jmp at 0x0044d8f1; jne at 0x0044d92c, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0044d940
    pop ebp                                      # 0044d942
    ret 0x4                                      # 0044d943

