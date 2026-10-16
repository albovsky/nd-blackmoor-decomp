# FUN_004db0d6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db0d6
# extent:       0x004db0d6-0x004db10c (54 code bytes)
# span:         0x004db0d6-0x004db10c (code 54, tables 0, padding 0)
# sha256:       213cbfa4e1e25320451f3006ab6db8b62130fc47fe968885841ac79f31f96c67
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004db0d6
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_10, local_14
# fields:       [ecx + n] field_1c
# callees:      calls USER32.dll!GetClientRect, FUN_00520f11, USER32.dll!ClipCursor
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_00520f11, .text + (0x00520f11 - 0x401000)

.org 0x004db0d6 - 0x401000
.globl FUN_004db0d6
FUN_004db0d6:
    # block 0x004db0d6: entry, 20 instruction(s), calls USER32.dll!GetClientRect, FUN_00520f11, USER32.dll!ClipCursor, ends with ret 0x4
    push ebp                                     # 004db0d6
    {load} mov ebp, esp                          # 004db0d7
    sub esp, 0x14                                # 004db0d9
    mov dword ptr [ebp - local_14], ecx          # 004db0dc
    lea eax, [ebp - local_10]                    # 004db0df
    push eax                                     # 004db0e2
    mov ecx, dword ptr [ebp + arg_8]             # 004db0e3
    mov edx, dword ptr [ecx + field_1c]          # 004db0e6
    push edx                                     # 004db0e9
    call dword ptr [0x52a4d8]                    # 004db0ea
    lea eax, [ebp - local_10]                    # 004db0f0
    push eax                                     # 004db0f3
    mov ecx, dword ptr [ebp + arg_8]             # 004db0f4
    call FUN_00520f11                            # 004db0f7
    lea ecx, [ebp - local_10]                    # 004db0fc
    push ecx                                     # 004db0ff
    call dword ptr [0x52a480]                    # 004db100
    {load} mov esp, ebp                          # 004db106
    pop ebp                                      # 004db108
    ret 0x4                                      # 004db109

