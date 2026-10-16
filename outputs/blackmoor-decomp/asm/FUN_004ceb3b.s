# FUN_004ceb3b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ceb3b
# extent:       0x004ceb3b-0x004ceb8c (81 code bytes)
# span:         0x004ceb3b-0x004ceb8c (code 81, tables 0, padding 0)
# sha256:       61578011ce5d01057cb728224926c06f146d69407b1def650e38302be816810d
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ceb3b
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_216; [ecx + n] field_202
# callees:      calls FUN_004d36ed, FUN_004cd218
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_202, 0x202  # offset +0x202
.equ field_216, 0x216  # offset +0x216

# --- external targets -----------------------------------------------
.set FUN_004cd218, .text + (0x004cd218 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)

.org 0x004ceb3b - 0x401000
.globl FUN_004ceb3b
FUN_004ceb3b:
    # block 0x004ceb3b: entry, 19 instruction(s), calls FUN_004d36ed, FUN_004cd218, ends with ret 0x4
    push ebp                                     # 004ceb3b
    {load} mov ebp, esp                          # 004ceb3c
    push ecx                                     # 004ceb3e
    mov dword ptr [ebp - local_4], ecx           # 004ceb3f
    mov eax, dword ptr [ebp - local_4]           # 004ceb42
    mov dword ptr [eax + field_216], 0x0         # 004ceb45
    mov dword ptr [0x5d1a45], 0x0                # 004ceb4f
    mov ecx, dword ptr [ebp - local_4]           # 004ceb59
    mov edx, dword ptr [ecx + field_202]         # 004ceb5c
    mov dword ptr [0x5839a9], edx                # 004ceb62
    call FUN_004d36ed                            # 004ceb68
    mov ecx, dword ptr [ebp - local_4]           # 004ceb6d
    call FUN_004cd218                            # 004ceb70
    movsx eax, word ptr [ebp + arg_8]            # 004ceb75
    imul eax, eax, 0x8d                          # 004ceb79
    mov byte ptr [eax + 0x5bb625], 0x1           # 004ceb7f
    {load} mov esp, ebp                          # 004ceb86
    pop ebp                                      # 004ceb88
    ret 0x4                                      # 004ceb89

