# FUN_004691ee
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004691ee
# extent:       0x004691ee-0x00469259 (107 code bytes)
# span:         0x004691ee-0x00469259 (code 107, tables 0, padding 0)
# sha256:       86acdcf3fcf3539d3364dea00b8087835482cb052b6ba60e7c544fdcf78e5d61
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004691ee
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_548
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_548, 0x548  # offset +0x548

# --- external targets -----------------------------------------------

.org 0x004691ee - 0x401000
.globl FUN_004691ee
FUN_004691ee:
    # block 0x004691ee: entry, 22 instruction(s), ends with ret 0x4
    push ebp                                     # 004691ee
    {load} mov ebp, esp                          # 004691ef
    push ecx                                     # 004691f1
    mov dword ptr [ebp - local_4], ecx           # 004691f2
    mov dword ptr [0x5b44f0], 0x16               # 004691f5
    mov dword ptr [0x5b44f4], 0x1                # 004691ff
    mov eax, dword ptr [0x5d0377]                # 00469209
    mov dword ptr [0x5d162d], eax                # 0046920e
    mov ecx, dword ptr [0x5b44f0]                # 00469213
    shl ecx, 0x5                                 # 00469219
    mov edx, dword ptr [0x5b44f4]                # 0046921c
    shl edx, 0x4                                 # 00469222
    lea eax, [ecx + edx + 0x5b160c]              # 00469225
    mov dword ptr [0x5d1631], eax                # 0046922c
    mov dword ptr [0x5d1639], 0x1                # 00469231
    mov dword ptr [0x5c39e5], 0x272e             # 0046923b
    mov ecx, dword ptr [ebp - local_4]           # 00469245
    mov dx, word ptr [ebp + arg_8]               # 00469248
    mov word ptr [ecx + field_548], dx           # 0046924c
    {load} mov esp, ebp                          # 00469253
    pop ebp                                      # 00469255
    ret 0x4                                      # 00469256

