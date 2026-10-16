# FUN_00468dea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468dea
# extent:       0x00468dea-0x00468e3e (84 code bytes)
# span:         0x00468dea-0x00468e3e (code 84, tables 0, padding 0)
# sha256:       d4b37a34179b26080643611fe163811fe697aa23c4adfee49962ed2276c1e76b
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00468dea
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00468e5a
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
.set FUN_00468e5a, .text + (0x00468e5a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00468dea - 0x401000
.globl FUN_00468dea
FUN_00468dea:
    # block 0x00468dea: entry, 23 instruction(s), calls FUN_0051d716, FUN_00468e5a, ends with ret
    push ebp                                     # 00468dea
    {load} mov ebp, esp                          # 00468deb
    push -0x1                                    # 00468ded
    push 0x5281bd                                # 00468def
    mov eax, dword ptr fs:[0x0]                  # 00468df4
    push eax                                     # 00468dfa
    mov dword ptr fs:[0x0], esp                  # 00468dfb
    push ecx                                     # 00468e02
    mov dword ptr [ebp - local_10], ecx          # 00468e03
    mov ecx, dword ptr [ebp - local_10]          # 00468e06
    call FUN_0051d716                            # 00468e09
    mov dword ptr [ebp - local_4], 0x0           # 00468e0e
    mov eax, dword ptr [ebp - local_10]          # 00468e15
    mov dword ptr [eax], 0x52d220                # 00468e18
    mov ecx, dword ptr [ebp - local_10]          # 00468e1e
    call FUN_00468e5a                            # 00468e21
    mov dword ptr [ebp - local_4], 0xffffffff    # 00468e26
    mov eax, dword ptr [ebp - local_10]          # 00468e2d
    mov ecx, dword ptr [ebp - local_c]           # 00468e30
    mov dword ptr fs:[0x0], ecx                  # 00468e33
    {load} mov esp, ebp                          # 00468e3a
    pop ebp                                      # 00468e3c
    ret                                          # 00468e3d

