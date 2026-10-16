# FUN_004de1a4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de1a4
# extent:       0x004de1a4-0x004de1f5 (81 code bytes)
# span:         0x004de1a4-0x004de1f5 (code 81, tables 0, padding 0)
# sha256:       788a1f2c92b8278a0651d4ab3086488af79bcca92263b22a6d440efed27a7e78
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de1a4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004de214, FUN_004eda7c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004de214, .text + (0x004de214 - 0x401000)
.set FUN_004eda7c, .text + (0x004eda7c - 0x401000)

.org 0x004de1a4 - 0x401000
.globl FUN_004de1a4
FUN_004de1a4:
    # block 0x004de1a4: entry, 22 instruction(s), calls FUN_004de214, FUN_004eda7c, ends with ret
    push ebp                                     # 004de1a4
    {load} mov ebp, esp                          # 004de1a5
    push -0x1                                    # 004de1a7
    push 0x5288ec                                # 004de1a9
    mov eax, dword ptr fs:[0x0]                  # 004de1ae
    push eax                                     # 004de1b4
    mov dword ptr fs:[0x0], esp                  # 004de1b5
    push ecx                                     # 004de1bc
    mov dword ptr [ebp - local_10], ecx          # 004de1bd
    mov eax, dword ptr [ebp - local_10]          # 004de1c0
    mov dword ptr [eax], 0x52e4cc                # 004de1c3
    mov dword ptr [ebp - local_4], 0x0           # 004de1c9
    mov ecx, dword ptr [ebp - local_10]          # 004de1d0
    call FUN_004de214                            # 004de1d3
    mov dword ptr [ebp - local_4], 0xffffffff    # 004de1d8
    mov ecx, dword ptr [ebp - local_10]          # 004de1df
    call FUN_004eda7c                            # 004de1e2
    mov ecx, dword ptr [ebp - local_c]           # 004de1e7
    mov dword ptr fs:[0x0], ecx                  # 004de1ea
    {load} mov esp, ebp                          # 004de1f1
    pop ebp                                      # 004de1f3
    ret                                          # 004de1f4

