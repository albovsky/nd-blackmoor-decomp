# FUN_004de66e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de66e
# extent:       0x004de66e-0x004de6d7 (105 code bytes)
# span:         0x004de66e-0x004de6d7 (code 105, tables 0, padding 0)
# sha256:       ddab2200f2009760580291b41d5ee2f1d34516eb425b5b9363cc8868bcfdd52f
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de66e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004de6fc, FUN_004ee99f, FUN_004e1c83
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004de6fc, .text + (0x004de6fc - 0x401000)
.set FUN_004e1c83, .text + (0x004e1c83 - 0x401000)
.set FUN_004ee99f, .text + (0x004ee99f - 0x401000)

.org 0x004de66e - 0x401000
.globl FUN_004de66e
FUN_004de66e:
    # block 0x004de66e: entry, 27 instruction(s), calls FUN_004de6fc, FUN_004ee99f, FUN_004e1c83, ends with ret
    push ebp                                     # 004de66e
    {load} mov ebp, esp                          # 004de66f
    push -0x1                                    # 004de671
    push 0x528946                                # 004de673
    mov eax, dword ptr fs:[0x0]                  # 004de678
    push eax                                     # 004de67e
    mov dword ptr fs:[0x0], esp                  # 004de67f
    push ecx                                     # 004de686
    mov dword ptr [ebp - local_10], ecx          # 004de687
    mov eax, dword ptr [ebp - local_10]          # 004de68a
    mov dword ptr [eax], 0x52e4d0                # 004de68d
    mov dword ptr [ebp - local_4], 0x1           # 004de693
    mov ecx, dword ptr [ebp - local_10]          # 004de69a
    call FUN_004de6fc                            # 004de69d
    mov byte ptr [ebp - local_4], 0x0            # 004de6a2
    mov ecx, dword ptr [ebp - local_10]          # 004de6a6
    add ecx, 0x57e                               # 004de6a9
    call FUN_004ee99f                            # 004de6af
    mov dword ptr [ebp - local_4], 0xffffffff    # 004de6b4
    mov ecx, dword ptr [ebp - local_10]          # 004de6bb
    add ecx, 0x3ef                               # 004de6be
    call FUN_004e1c83                            # 004de6c4
    mov ecx, dword ptr [ebp - local_c]           # 004de6c9
    mov dword ptr fs:[0x0], ecx                  # 004de6cc
    {load} mov esp, ebp                          # 004de6d3
    pop ebp                                      # 004de6d5
    ret                                          # 004de6d6

