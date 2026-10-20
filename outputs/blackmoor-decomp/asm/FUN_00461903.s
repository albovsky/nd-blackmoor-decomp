# FUN_00461903
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00461903
# extent:       0x00461903-0x004619be (187 code bytes)
# span:         0x00461903-0x004619be (code 187, tables 0, padding 0)
# sha256:       a17fe1bef790c68f79f85e52e9244bf7761a113a697a548c15e8877a9c1ad439
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m461903_copy_record_357
# naming:       native port src/original_methods_fl29c.c:m461903_copy_record_357 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0x357 bytes, stores the pointer, reports a failure, copies 0xd5 dwords + word + byte, advances cells C then B, trace; logic sits in the copy_record helper. See fl29c-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl29c.c:m461903_copy_record_357 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00461903 - 0x401000
.globl FUN_00461903
FUN_00461903:
    # block 0x00461903: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0046196a (forward)
    push ebp                                     # 00461903
    {load} mov ebp, esp                          # 00461904
    sub esp, 0x8                                 # 00461906
    push esi                                     # 00461909
    push edi                                     # 0046190a
    mov dword ptr [ebp - local_8], ecx           # 0046190b
    push 0x357                                   # 0046190e
    call FUN_0051dc43                            # 00461913
    add esp, 0x4                                 # 00461918
    mov dword ptr [ebp - local_4], eax           # 0046191b
    mov eax, dword ptr [ebp + arg_8]             # 0046191e
    mov ecx, dword ptr [ebp - local_4]           # 00461921
    mov dword ptr [eax], ecx                     # 00461924
    cmp dword ptr [ebp - local_4], 0x0           # 00461926
    jne.d8 L_0046196a                            # 0046192a
    # block 0x0046192c: entered by fall-through of jne at 0x0046192a, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0046196a
    movsx edx, word ptr [0x5c39e3]               # 0046192c
    push edx                                     # 00461933
    mov eax, dword ptr [0x5bb57b]                # 00461934
    push eax                                     # 00461939
    push 0x54b0dc                                # 0046193a
    push 0x63888b                                # 0046193f
    call FUN_0050ca3e                            # 00461944
    add esp, 0x10                                # 00461949
    push 0x63888b                                # 0046194c
    push 0x54b108                                # 00461951
    mov ecx, 0x583979                            # 00461956
    call FUN_0042639d                            # 0046195b
    mov ecx, 0x5cf659                            # 00461960
    call FUN_004c97b4                            # 00461965
L_0046196a:
    # block 0x0046196a: entered by jne at 0x0046192a, 21 instruction(s), ends with je to 0x004619b6 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0046196a
    mov esi, dword ptr [ecx]                     # 0046196d
    mov edx, dword ptr [ebp + arg_8]             # 0046196f
    mov edi, dword ptr [edx]                     # 00461972
    mov ecx, 0xd5                                # 00461974
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00461979
    movsw word ptr es:[edi], word ptr [esi]      # 0046197b
    movsb byte ptr es:[edi], byte ptr [esi]      # 0046197d
    mov eax, dword ptr [ebp + arg_10]            # 0046197e
    mov ecx, dword ptr [eax]                     # 00461981
    add ecx, 0x357                               # 00461983
    mov edx, dword ptr [ebp + arg_10]            # 00461989
    mov dword ptr [edx], ecx                     # 0046198c
    mov eax, dword ptr [ebp + arg_c]             # 0046198e
    mov ecx, dword ptr [eax]                     # 00461991
    add ecx, 0x357                               # 00461993
    mov edx, dword ptr [ebp + arg_c]             # 00461999
    mov dword ptr [edx], ecx                     # 0046199c
    movsx eax, word ptr [0x63a4cd]               # 0046199e
    test eax, eax                                # 004619a5
    je.d8 L_004619b6                             # 004619a7
    # block 0x004619a9: entered by fall-through of je at 0x004619a7, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004619b6
    push 0x54b124                                # 004619a9
    call FUN_0044a2b7                            # 004619ae
    add esp, 0x4                                 # 004619b3
L_004619b6:
    # block 0x004619b6: entered by je at 0x004619a7, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004619b6
    pop esi                                      # 004619b7
    {load} mov esp, ebp                          # 004619b8
    pop ebp                                      # 004619ba
    ret 0xc                                      # 004619bb

