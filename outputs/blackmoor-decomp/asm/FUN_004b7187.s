# FUN_004b7187
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7187
# extent:       0x004b7187-0x004b71db (84 code bytes)
# span:         0x004b7187-0x004b71db (code 84, tables 0, padding 0)
# sha256:       b4d21d20473fe43c17ffc300dc5e0c98c59f61dd73f4ab3f62268e3f8dd87925
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b7187
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004b71f7
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
.set FUN_004b71f7, .text + (0x004b71f7 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004b7187 - 0x401000
.globl FUN_004b7187
FUN_004b7187:
    # block 0x004b7187: entry, 23 instruction(s), calls FUN_0051d716, FUN_004b71f7, ends with ret
    push ebp                                     # 004b7187
    {load} mov ebp, esp                          # 004b7188
    push -0x1                                    # 004b718a
    push 0x52877d                                # 004b718c
    mov eax, dword ptr fs:[0x0]                  # 004b7191
    push eax                                     # 004b7197
    mov dword ptr fs:[0x0], esp                  # 004b7198
    push ecx                                     # 004b719f
    mov dword ptr [ebp - local_10], ecx          # 004b71a0
    mov ecx, dword ptr [ebp - local_10]          # 004b71a3
    call FUN_0051d716                            # 004b71a6
    mov dword ptr [ebp - local_4], 0x0           # 004b71ab
    mov eax, dword ptr [ebp - local_10]          # 004b71b2
    mov dword ptr [eax], 0x52e1a8                # 004b71b5
    mov ecx, dword ptr [ebp - local_10]          # 004b71bb
    call FUN_004b71f7                            # 004b71be
    mov dword ptr [ebp - local_4], 0xffffffff    # 004b71c3
    mov eax, dword ptr [ebp - local_10]          # 004b71ca
    mov ecx, dword ptr [ebp - local_c]           # 004b71cd
    mov dword ptr fs:[0x0], ecx                  # 004b71d0
    {load} mov esp, ebp                          # 004b71d7
    pop ebp                                      # 004b71d9
    ret                                          # 004b71da

