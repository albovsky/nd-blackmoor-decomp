# FUN_00464fff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00464fff
# extent:       0x00464fff-0x00465075 (118 code bytes)
# span:         0x00464fff-0x00465075 (code 118, tables 0, padding 0)
# sha256:       4c0df100e41684c7b10af2a9e4715a93b93150b9a599404ed11c53243f7ebe88
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00464fff
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_d6, field_354; [edx + n] field_bd
# callees:      calls FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_bd, 0xbd  # offset +0xbd
.equ field_d6, 0xd6  # offset +0xd6
.equ field_354, 0x354  # offset +0x354

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00464fff - 0x401000
.globl FUN_00464fff
FUN_00464fff:
    # block 0x00464fff: entry, 18 instruction(s), ends with je to 0x0046506f (forward)
    push ebp                                     # 00464fff
    {load} mov ebp, esp                          # 00465000
    sub esp, 0x8                                 # 00465002
    push esi                                     # 00465005
    push edi                                     # 00465006
    mov dword ptr [ebp - local_8], ecx           # 00465007
    mov eax, dword ptr [ebp - local_8]           # 0046500a
    movsx ecx, word ptr [eax + field_1e]         # 0046500d
    imul ecx, ecx, 0x8d                          # 00465011
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00465017
    mov dword ptr [ebp - local_4], edx           # 0046501d
    mov edi, 0x54b350                            # 00465020
    mov esi, dword ptr [ebp - local_4]           # 00465025
    add esi, 0x333                               # 00465028
    mov ecx, 0x9                                 # 0046502e
    {load} xor eax, eax                          # 00465033
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00465035
    je.d8 L_0046506f                             # 00465037
    # block 0x00465039: entered by fall-through of je at 0x00465037, 11 instruction(s), calls FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x0046506f
    mov ecx, dword ptr [ebp - local_4]           # 00465039
    mov dx, word ptr [ecx + field_354]           # 0046503c
    push edx                                     # 00465043
    mov ecx, 0x5c3a67                            # 00465044
    call FUN_004fb2e3                            # 00465049
    call dword ptr [0x52a23c]                    # 0046504e
    add eax, 0x12c                               # 00465054
    mov ecx, dword ptr [ebp - local_8]           # 00465059
    mov dword ptr [ecx + field_d6], eax          # 0046505c
    mov edx, dword ptr [ebp - local_8]           # 00465062
    mov dword ptr [edx + field_bd], 0x1          # 00465065
L_0046506f:
    # block 0x0046506f: entered by je at 0x00465037, 5 instruction(s), ends with ret
    pop edi                                      # 0046506f
    pop esi                                      # 00465070
    {load} mov esp, ebp                          # 00465071
    pop ebp                                      # 00465073
    ret                                          # 00465074

