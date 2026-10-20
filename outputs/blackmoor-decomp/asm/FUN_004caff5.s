# FUN_004caff5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004caff5
# extent:       0x004caff5-0x004cb058 (99 code bytes)
# span:         0x004caff5-0x004cb058 (code 99, tables 0, padding 0)
# sha256:       a776522294aae088b4c9d1ed34e814d9bdedecf7be8c7d13a0d36fff1043448d
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004caff5
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004cc70f, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004cc70f, .text + (0x004cc70f - 0x401000)

.org 0x004caff5 - 0x401000
.globl FUN_004caff5
FUN_004caff5:
    # block 0x004caff5: entry, 31 instruction(s), calls FUN_004cc70f, ends with je to 0x004cb050 (forward)
    push ebp                                     # 004caff5
    {load} mov ebp, esp                          # 004caff6
    push ecx                                     # 004caff8
    push esi                                     # 004caff9
    push edi                                     # 004caffa
    mov dword ptr [ebp - local_4], ecx           # 004caffb
    push 0x69                                    # 004caffe
    mov eax, dword ptr [ebp + arg_8]             # 004cb000
    push eax                                     # 004cb003
    mov ecx, dword ptr [ebp - local_4]           # 004cb004
    call FUN_004cc70f                            # 004cb007
    mov ecx, dword ptr [ebp + arg_c]             # 004cb00c
    mov esi, dword ptr [ecx]                     # 004cb00f
    mov edx, dword ptr [ebp + arg_8]             # 004cb011
    mov edi, dword ptr [edx]                     # 004cb014
    mov ecx, 0x1a                                # 004cb016
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004cb01b
    movsb byte ptr es:[edi], byte ptr [esi]      # 004cb01d
    mov eax, dword ptr [ebp + arg_10]            # 004cb01e
    mov ecx, dword ptr [eax]                     # 004cb021
    add ecx, 0x69                                # 004cb023
    mov edx, dword ptr [ebp + arg_10]            # 004cb026
    mov dword ptr [edx], ecx                     # 004cb029
    mov eax, dword ptr [ebp + arg_c]             # 004cb02b
    mov ecx, dword ptr [eax]                     # 004cb02e
    add ecx, 0x69                                # 004cb030
    mov edx, dword ptr [ebp + arg_c]             # 004cb033
    mov dword ptr [edx], ecx                     # 004cb036
    movsx eax, word ptr [0x63a4cd]               # 004cb038
    test eax, eax                                # 004cb03f
    je.d8 L_004cb050                             # 004cb041
    # block 0x004cb043: entered by fall-through of je at 0x004cb041, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004cb050
    push 0x558b1c                                # 004cb043
    call FUN_0044a2b7                            # 004cb048
    add esp, 0x4                                 # 004cb04d
L_004cb050:
    # block 0x004cb050: entered by je at 0x004cb041, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004cb050
    pop esi                                      # 004cb051
    {load} mov esp, ebp                          # 004cb052
    pop ebp                                      # 004cb054
    ret 0xc                                      # 004cb055

