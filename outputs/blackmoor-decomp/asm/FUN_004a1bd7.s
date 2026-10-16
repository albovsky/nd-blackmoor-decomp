# FUN_004a1bd7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1bd7
# extent:       0x004a1bd7-0x004a1c2b (84 code bytes)
# span:         0x004a1bd7-0x004a1c2b (code 84, tables 0, padding 0)
# sha256:       b5b4f32fe2e26aef2ca0709f5010cba3067d96d4f40cea93e39097a96be02ff9
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a1bd7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004a1c47
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004a1c47, .text + (0x004a1c47 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004a1bd7 - 0x401000
.globl FUN_004a1bd7
FUN_004a1bd7:
    # block 0x004a1bd7: entry, 23 instruction(s), calls FUN_0051d716, FUN_004a1c47, ends with ret
    push ebp                                     # 004a1bd7
    {load} mov ebp, esp                          # 004a1bd8
    push -0x1                                    # 004a1bda
    push 0x52859d                                # 004a1bdc
    mov eax, dword ptr fs:[0x0]                  # 004a1be1
    push eax                                     # 004a1be7
    mov dword ptr fs:[0x0], esp                  # 004a1be8
    push ecx                                     # 004a1bef
    mov dword ptr [ebp - local_10], ecx          # 004a1bf0
    mov ecx, dword ptr [ebp - local_10]          # 004a1bf3
    call FUN_0051d716                            # 004a1bf6
    mov dword ptr [ebp - local_4], 0x0           # 004a1bfb
    mov eax, dword ptr [ebp - local_10]          # 004a1c02
    mov dword ptr [eax], 0x52dc58                # 004a1c05
    mov ecx, dword ptr [ebp - local_10]          # 004a1c0b
    call FUN_004a1c47                            # 004a1c0e
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a1c13
    mov eax, dword ptr [ebp - local_10]          # 004a1c1a
    mov ecx, dword ptr [ebp - local_c]           # 004a1c1d
    mov dword ptr fs:[0x0], ecx                  # 004a1c20
    {load} mov esp, ebp                          # 004a1c27
    pop ebp                                      # 004a1c29
    ret                                          # 004a1c2a

