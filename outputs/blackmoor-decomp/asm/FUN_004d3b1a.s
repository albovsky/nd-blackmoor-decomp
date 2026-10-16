# FUN_004d3b1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3b1a
# extent:       0x004d3b1a-0x004d3b6e (84 code bytes)
# span:         0x004d3b1a-0x004d3b6e (code 84, tables 0, padding 0)
# sha256:       70bdc251762c33f058f3ee5acae91e43a7bd04c8f1f931e26ba43f1edf1aa7f8
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3b1a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004d3b95
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
.set FUN_004d3b95, .text + (0x004d3b95 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004d3b1a - 0x401000
.globl FUN_004d3b1a
FUN_004d3b1a:
    # block 0x004d3b1a: entry, 23 instruction(s), calls FUN_0051d716, FUN_004d3b95, ends with ret
    push ebp                                     # 004d3b1a
    {load} mov ebp, esp                          # 004d3b1b
    push -0x1                                    # 004d3b1d
    push 0x52886d                                # 004d3b1f
    mov eax, dword ptr fs:[0x0]                  # 004d3b24
    push eax                                     # 004d3b2a
    mov dword ptr fs:[0x0], esp                  # 004d3b2b
    push ecx                                     # 004d3b32
    mov dword ptr [ebp - local_10], ecx          # 004d3b33
    mov ecx, dword ptr [ebp - local_10]          # 004d3b36
    call FUN_0051d716                            # 004d3b39
    mov dword ptr [ebp - local_4], 0x0           # 004d3b3e
    mov eax, dword ptr [ebp - local_10]          # 004d3b45
    mov dword ptr [eax], 0x52e310                # 004d3b48
    mov ecx, dword ptr [ebp - local_10]          # 004d3b4e
    call FUN_004d3b95                            # 004d3b51
    mov dword ptr [ebp - local_4], 0xffffffff    # 004d3b56
    mov eax, dword ptr [ebp - local_10]          # 004d3b5d
    mov ecx, dword ptr [ebp - local_c]           # 004d3b60
    mov dword ptr fs:[0x0], ecx                  # 004d3b63
    {load} mov esp, ebp                          # 004d3b6a
    pop ebp                                      # 004d3b6c
    ret                                          # 004d3b6d

