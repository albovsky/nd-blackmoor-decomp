# FUN_004db1e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db1e8
# extent:       0x004db1e8-0x004db223 (59 code bytes)
# span:         0x004db1e8-0x004db223 (code 59, tables 0, padding 0)
# sha256:       313d274d1c502f6ebd6822042e41aa78eefe6e484a0620ad218c912731f96e7c
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004db1e8
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_c
# callees:      calls FUN_00525371, USER32.dll!LoadCursorA, USER32.dll!SetClassLongA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x004db1e8 - 0x401000
.globl FUN_004db1e8
FUN_004db1e8:
    # block 0x004db1e8: entry, 21 instruction(s), calls FUN_00525371, USER32.dll!LoadCursorA, USER32.dll!SetClassLongA, ends with ret 0x8
    push ebp                                     # 004db1e8
    {load} mov ebp, esp                          # 004db1e9
    sub esp, 0x8                                 # 004db1eb
    mov dword ptr [ebp - local_8], ecx           # 004db1ee
    call FUN_00525371                            # 004db1f1
    mov eax, dword ptr [eax + field_c]           # 004db1f6
    mov dword ptr [ebp - local_4], eax           # 004db1f9
    mov ecx, dword ptr [ebp + arg_c]             # 004db1fc
    and ecx, 0xffff                              # 004db1ff
    push ecx                                     # 004db205
    mov edx, dword ptr [ebp - local_4]           # 004db206
    push edx                                     # 004db209
    call dword ptr [0x52a4a4]                    # 004db20a
    push eax                                     # 004db210
    push -0xc                                    # 004db211
    mov eax, dword ptr [ebp + arg_8]             # 004db213
    push eax                                     # 004db216
    call dword ptr [0x52a470]                    # 004db217
    {load} mov esp, ebp                          # 004db21d
    pop ebp                                      # 004db21f
    ret 0x8                                      # 004db220

