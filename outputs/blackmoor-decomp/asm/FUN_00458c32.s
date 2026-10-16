# FUN_00458c32
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00458c32
# extent:       0x00458c32-0x00458c9b (105 code bytes)
# span:         0x00458c32-0x00458c9b (code 105, tables 0, padding 0)
# sha256:       a0dda300fa44d45cb66c6e0efd9f126a56427680c42eb9630b869bfedef43bac
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00458c32
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_20, field_26; [ecx + n] field_b8, field_e1
# callees:      calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_20, 0x20  # offset +0x20
.equ field_26, 0x26  # offset +0x26
.equ field_b8, 0xb8  # offset +0xb8
.equ field_e1, 0xe1  # offset +0xe1

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x00458c32 - 0x401000
.globl FUN_00458c32
FUN_00458c32:
    # block 0x00458c32: entry, 28 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, ends with ret
    push ebp                                     # 00458c32
    {load} mov ebp, esp                          # 00458c33
    sub esp, 0x8                                 # 00458c35
    mov dword ptr [ebp - local_8], ecx           # 00458c38
    mov eax, dword ptr [ebp - local_8]           # 00458c3b
    movsx ecx, word ptr [eax + field_26]         # 00458c3e
    imul ecx, ecx, 0x8d                          # 00458c42
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00458c48
    mov dword ptr [ebp - local_4], edx           # 00458c4e
    mov eax, dword ptr [ebp - local_8]           # 00458c51
    add eax, 0xc0                                # 00458c54
    push eax                                     # 00458c59
    mov ecx, 0x5c3a67                            # 00458c5a
    call FUN_004fb77a                            # 00458c5f
    mov ecx, dword ptr [ebp - local_8]           # 00458c64
    mov dx, word ptr [ecx + field_e1]            # 00458c67
    push edx                                     # 00458c6e
    mov ecx, 0x5c3a67                            # 00458c6f
    call FUN_004fb2e3                            # 00458c74
    mov eax, dword ptr [ebp - local_8]           # 00458c79
    mov dword ptr [eax + field_20], 0x3          # 00458c7c
    call dword ptr [0x52a23c]                    # 00458c83
    add eax, 0x12c                               # 00458c89
    mov ecx, dword ptr [ebp - local_8]           # 00458c8e
    mov dword ptr [ecx + field_b8], eax          # 00458c91
    {load} mov esp, ebp                          # 00458c97
    pop ebp                                      # 00458c99
    ret                                          # 00458c9a

