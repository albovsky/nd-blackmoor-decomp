# FUN_004a7c0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7c0a
# extent:       0x004a7c0a-0x004a7c5e (84 code bytes)
# span:         0x004a7c0a-0x004a7c5e (code 84, tables 0, padding 0)
# sha256:       0086abae2f619290dba1b11ffe1c552d77c24c0f6d587b65b6eb45a525576803
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a7c0a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004a7c7a
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
.set FUN_004a7c7a, .text + (0x004a7c7a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004a7c0a - 0x401000
.globl FUN_004a7c0a
FUN_004a7c0a:
    # block 0x004a7c0a: entry, 23 instruction(s), calls FUN_0051d716, FUN_004a7c7a, ends with ret
    push ebp                                     # 004a7c0a
    {load} mov ebp, esp                          # 004a7c0b
    push -0x1                                    # 004a7c0d
    push 0x52862d                                # 004a7c0f
    mov eax, dword ptr fs:[0x0]                  # 004a7c14
    push eax                                     # 004a7c1a
    mov dword ptr fs:[0x0], esp                  # 004a7c1b
    push ecx                                     # 004a7c22
    mov dword ptr [ebp - local_10], ecx          # 004a7c23
    mov ecx, dword ptr [ebp - local_10]          # 004a7c26
    call FUN_0051d716                            # 004a7c29
    mov dword ptr [ebp - local_4], 0x0           # 004a7c2e
    mov eax, dword ptr [ebp - local_10]          # 004a7c35
    mov dword ptr [eax], 0x52ddf0                # 004a7c38
    mov ecx, dword ptr [ebp - local_10]          # 004a7c3e
    call FUN_004a7c7a                            # 004a7c41
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a7c46
    mov eax, dword ptr [ebp - local_10]          # 004a7c4d
    mov ecx, dword ptr [ebp - local_c]           # 004a7c50
    mov dword ptr fs:[0x0], ecx                  # 004a7c53
    {load} mov esp, ebp                          # 004a7c5a
    pop ebp                                      # 004a7c5c
    ret                                          # 004a7c5d

