# FUN_004de5f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de5f0
# extent:       0x004de5f0-0x004de66e (126 code bytes)
# span:         0x004de5f0-0x004de66e (code 126, tables 0, padding 0)
# sha256:       62a16ba6d12becb82774d8c7cc3ce0c06b39c5665543a5d0ffd8c8fdf388fe0b
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de5f0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e1c50, FUN_004ee980, FUN_004de6d7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004de6d7, .text + (0x004de6d7 - 0x401000)
.set FUN_004e1c50, .text + (0x004e1c50 - 0x401000)
.set FUN_004ee980, .text + (0x004ee980 - 0x401000)

.org 0x004de5f0 - 0x401000
.globl FUN_004de5f0
FUN_004de5f0:
    # block 0x004de5f0: entry, 36 instruction(s), calls FUN_004e1c50, FUN_004ee980, FUN_004de6d7, ends with ret
    push ebp                                     # 004de5f0
    {load} mov ebp, esp                          # 004de5f1
    push -0x1                                    # 004de5f3
    push 0x52891e                                # 004de5f5
    mov eax, dword ptr fs:[0x0]                  # 004de5fa
    push eax                                     # 004de600
    mov dword ptr fs:[0x0], esp                  # 004de601
    push ecx                                     # 004de608
    push edi                                     # 004de609
    mov dword ptr [ebp - local_10], ecx          # 004de60a
    mov ecx, dword ptr [ebp - local_10]          # 004de60d
    add ecx, 0x3ef                               # 004de610
    call FUN_004e1c50                            # 004de616
    mov dword ptr [ebp - local_4], 0x0           # 004de61b
    mov ecx, dword ptr [ebp - local_10]          # 004de622
    add ecx, 0x57e                               # 004de625
    call FUN_004ee980                            # 004de62b
    mov byte ptr [ebp - local_4], 0x1            # 004de630
    mov eax, dword ptr [ebp - local_10]          # 004de634
    mov dword ptr [eax], 0x52e4d0                # 004de637
    mov ecx, 0xe2                                # 004de63d
    {load} xor eax, eax                          # 004de642
    mov edi, dword ptr [ebp - local_10]          # 004de644
    add edi, 0x4                                 # 004de647
    rep stosd dword ptr es:[edi], eax            # 004de64a
    stosb byte ptr es:[edi], al                  # 004de64c
    mov ecx, dword ptr [ebp - local_10]          # 004de64d
    call FUN_004de6d7                            # 004de650
    mov dword ptr [ebp - local_4], 0xffffffff    # 004de655
    mov eax, dword ptr [ebp - local_10]          # 004de65c
    mov ecx, dword ptr [ebp - local_c]           # 004de65f
    mov dword ptr fs:[0x0], ecx                  # 004de662
    pop edi                                      # 004de669
    {load} mov esp, ebp                          # 004de66a
    pop ebp                                      # 004de66c
    ret                                          # 004de66d

