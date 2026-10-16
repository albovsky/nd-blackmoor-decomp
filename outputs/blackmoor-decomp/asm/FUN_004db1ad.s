# FUN_004db1ad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db1ad
# extent:       0x004db1ad-0x004db1e8 (59 code bytes)
# span:         0x004db1ad-0x004db1e8 (code 59, tables 0, padding 0)
# sha256:       f8bc790886701524d6c7b497a8afeac8bd9db74d92344470ab4d607027486993
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004db1ad
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c
# callees:      calls FUN_00525371, USER32.dll!LoadCursorA, USER32.dll!SetCursor
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x004db1ad - 0x401000
.globl FUN_004db1ad
FUN_004db1ad:
    # block 0x004db1ad: entry, 20 instruction(s), calls FUN_00525371, USER32.dll!LoadCursorA, USER32.dll!SetCursor, ends with ret 0x4
    push ebp                                     # 004db1ad
    {load} mov ebp, esp                          # 004db1ae
    sub esp, 0xc                                 # 004db1b0
    mov dword ptr [ebp - local_c], ecx           # 004db1b3
    call FUN_00525371                            # 004db1b6
    mov eax, dword ptr [eax + field_c]           # 004db1bb
    mov dword ptr [ebp - local_4], eax           # 004db1be
    mov ecx, dword ptr [ebp + arg_8]             # 004db1c1
    and ecx, 0xffff                              # 004db1c4
    push ecx                                     # 004db1ca
    mov edx, dword ptr [ebp - local_4]           # 004db1cb
    push edx                                     # 004db1ce
    call dword ptr [0x52a4a4]                    # 004db1cf
    mov dword ptr [ebp - local_8], eax           # 004db1d5
    mov eax, dword ptr [ebp - local_8]           # 004db1d8
    push eax                                     # 004db1db
    call dword ptr [0x52a474]                    # 004db1dc
    {load} mov esp, ebp                          # 004db1e2
    pop ebp                                      # 004db1e4
    ret 0x4                                      # 004db1e5

