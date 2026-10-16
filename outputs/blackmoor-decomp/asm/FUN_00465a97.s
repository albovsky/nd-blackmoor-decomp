# FUN_00465a97
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465a97
# extent:       0x00465a97-0x00465aeb (84 code bytes)
# span:         0x00465a97-0x00465aeb (code 84, tables 0, padding 0)
# sha256:       e2b71bb06d0dc9be6797a436b7e2e01b8f491d4372d432fe2a5c00cc38d86d33
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00465a97
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00465b07
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
.set FUN_00465b07, .text + (0x00465b07 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00465a97 - 0x401000
.globl FUN_00465a97
FUN_00465a97:
    # block 0x00465a97: entry, 23 instruction(s), calls FUN_0051d716, FUN_00465b07, ends with ret
    push ebp                                     # 00465a97
    {load} mov ebp, esp                          # 00465a98
    push -0x1                                    # 00465a9a
    push 0x52818d                                # 00465a9c
    mov eax, dword ptr fs:[0x0]                  # 00465aa1
    push eax                                     # 00465aa7
    mov dword ptr fs:[0x0], esp                  # 00465aa8
    push ecx                                     # 00465aaf
    mov dword ptr [ebp - local_10], ecx          # 00465ab0
    mov ecx, dword ptr [ebp - local_10]          # 00465ab3
    call FUN_0051d716                            # 00465ab6
    mov dword ptr [ebp - local_4], 0x0           # 00465abb
    mov eax, dword ptr [ebp - local_10]          # 00465ac2
    mov dword ptr [eax], 0x52d190                # 00465ac5
    mov ecx, dword ptr [ebp - local_10]          # 00465acb
    call FUN_00465b07                            # 00465ace
    mov dword ptr [ebp - local_4], 0xffffffff    # 00465ad3
    mov eax, dword ptr [ebp - local_10]          # 00465ada
    mov ecx, dword ptr [ebp - local_c]           # 00465add
    mov dword ptr fs:[0x0], ecx                  # 00465ae0
    {load} mov esp, ebp                          # 00465ae7
    pop ebp                                      # 00465ae9
    ret                                          # 00465aea

