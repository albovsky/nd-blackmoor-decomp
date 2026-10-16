# FUN_00516e4e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516e4e
# extent:       0x00516e4e-0x00516eaa (92 code bytes)
# span:         0x00516e4e-0x00516eaa (code 92, tables 0, padding 0)
# sha256:       1eae0b305247849e7b2c4304ee0e7c851a20fc5dc2e48493665762331c82003c
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516e4e
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       4 ebp-relative slot(s): local_c, local_24, local_26, local_28
# fields:       [esi + n] field_4, field_8, field_c
# callees:      calls FUN_00516eaa, FUN_00518d76, FUN_005128b0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_c, 0xc  # offset -0xc
.equ local_24, 0x24  # offset -0x24
.equ local_26, 0x26  # offset -0x26
.equ local_28, 0x28  # offset -0x28
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)
.set FUN_00516eaa, .text + (0x00516eaa - 0x401000)
.set FUN_00518d76, .text + (0x00518d76 - 0x401000)

.org 0x00516e4e - 0x401000
.globl FUN_00516e4e
FUN_00516e4e:
    # block 0x00516e4e: entry, 41 instruction(s), calls FUN_00516eaa, FUN_00518d76, FUN_005128b0, ends with ret
    push ebp                                     # 00516e4e
    {load} mov ebp, esp                          # 00516e4f
    sub esp, 0x28                                # 00516e51
    push esi                                     # 00516e54
    lea eax, [ebp + arg_8]                       # 00516e55
    push edi                                     # 00516e58
    push eax                                     # 00516e59
    lea eax, [ebp - local_c]                     # 00516e5a
    push eax                                     # 00516e5d
    call FUN_00516eaa                            # 00516e5e
    pop ecx                                      # 00516e63
    lea eax, [ebp - local_28]                    # 00516e64
    pop ecx                                      # 00516e67
    lea esi, [ebp - local_c]                     # 00516e68
    push eax                                     # 00516e6b
    push 0x0                                     # 00516e6c
    push 0x11                                    # 00516e6e
    sub esp, 0xc                                 # 00516e70
    {load} mov edi, esp                          # 00516e73
    movsd dword ptr es:[edi], dword ptr [esi]    # 00516e75
    movsd dword ptr es:[edi], dword ptr [esi]    # 00516e76
    movsw word ptr es:[edi], word ptr [esi]      # 00516e77
    call FUN_00518d76                            # 00516e79
    mov esi, dword ptr [ebp + arg_10]            # 00516e7e
    mov edi, dword ptr [ebp + arg_14]            # 00516e81
    mov dword ptr [esi + field_8], eax           # 00516e84
    movsx eax, byte ptr [ebp - local_26]         # 00516e87
    mov dword ptr [esi], eax                     # 00516e8b
    movsx eax, word ptr [ebp - local_28]         # 00516e8d
    mov dword ptr [esi + field_4], eax           # 00516e91
    lea eax, [ebp - local_24]                    # 00516e94
    push eax                                     # 00516e97
    push edi                                     # 00516e98
    call FUN_005128b0                            # 00516e99
    add esp, 0x20                                # 00516e9e
    mov dword ptr [esi + field_c], edi           # 00516ea1
    {load} mov eax, esi                          # 00516ea4
    pop edi                                      # 00516ea6
    pop esi                                      # 00516ea7
    leave                                        # 00516ea8
    ret                                          # 00516ea9

