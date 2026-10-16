# FUN_004eb8fe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb8fe
# extent:       0x004eb8fe-0x004eb96e (112 code bytes)
# span:         0x004eb8fe-0x004eb96e (code 112, tables 0, padding 0)
# sha256:       c3c6a8c6dde61b43b9e0b55502d4940e8b510bfa4f399e3aabf49a54bc6be97b
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004eb8fe
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004eba54, FUN_0050cba8, FUN_004eda7c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004eba54, .text + (0x004eba54 - 0x401000)
.set FUN_004eda7c, .text + (0x004eda7c - 0x401000)
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x004eb8fe - 0x401000
.globl FUN_004eb8fe
FUN_004eb8fe:
    # block 0x004eb8fe: entry, 30 instruction(s), calls FUN_004eba54, FUN_0050cba8, FUN_004eda7c, ends with ret
    push ebp                                     # 004eb8fe
    {load} mov ebp, esp                          # 004eb8ff
    push -0x1                                    # 004eb901
    push 0x528ae2                                # 004eb903
    mov eax, dword ptr fs:[0x0]                  # 004eb908
    push eax                                     # 004eb90e
    mov dword ptr fs:[0x0], esp                  # 004eb90f
    push ecx                                     # 004eb916
    mov dword ptr [ebp - local_10], ecx          # 004eb917
    mov eax, dword ptr [ebp - local_10]          # 004eb91a
    mov dword ptr [eax], 0x52e4f8                # 004eb91d
    mov dword ptr [ebp - local_4], 0x1           # 004eb923
    mov ecx, dword ptr [ebp - local_10]          # 004eb92a
    call FUN_004eba54                            # 004eb92d
    mov byte ptr [ebp - local_4], 0x0            # 004eb932
    push 0x4e1c83                                # 004eb936
    push 0x2                                     # 004eb93b
    push 0x18f                                   # 004eb93d
    mov ecx, dword ptr [ebp - local_10]          # 004eb942
    add ecx, 0xca8                               # 004eb945
    push ecx                                     # 004eb94b
    call FUN_0050cba8                            # 004eb94c
    mov dword ptr [ebp - local_4], 0xffffffff    # 004eb951
    mov ecx, dword ptr [ebp - local_10]          # 004eb958
    call FUN_004eda7c                            # 004eb95b
    mov ecx, dword ptr [ebp - local_c]           # 004eb960
    mov dword ptr fs:[0x0], ecx                  # 004eb963
    {load} mov esp, ebp                          # 004eb96a
    pop ebp                                      # 004eb96c
    ret                                          # 004eb96d

