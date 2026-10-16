# FUN_004b5b1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5b1a
# extent:       0x004b5b1a-0x004b5b6e (84 code bytes)
# span:         0x004b5b1a-0x004b5b6e (code 84, tables 0, padding 0)
# sha256:       810f9a30ef4ca010828c8693a892b0192aace7da45a25fd2cc1e5be91af61830
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b5b1a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004b5b8a
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
.set FUN_004b5b8a, .text + (0x004b5b8a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004b5b1a - 0x401000
.globl FUN_004b5b1a
FUN_004b5b1a:
    # block 0x004b5b1a: entry, 23 instruction(s), calls FUN_0051d716, FUN_004b5b8a, ends with ret
    push ebp                                     # 004b5b1a
    {load} mov ebp, esp                          # 004b5b1b
    push -0x1                                    # 004b5b1d
    push 0x52874d                                # 004b5b1f
    mov eax, dword ptr fs:[0x0]                  # 004b5b24
    push eax                                     # 004b5b2a
    mov dword ptr fs:[0x0], esp                  # 004b5b2b
    push ecx                                     # 004b5b32
    mov dword ptr [ebp - local_10], ecx          # 004b5b33
    mov ecx, dword ptr [ebp - local_10]          # 004b5b36
    call FUN_0051d716                            # 004b5b39
    mov dword ptr [ebp - local_4], 0x0           # 004b5b3e
    mov eax, dword ptr [ebp - local_10]          # 004b5b45
    mov dword ptr [eax], 0x52e120                # 004b5b48
    mov ecx, dword ptr [ebp - local_10]          # 004b5b4e
    call FUN_004b5b8a                            # 004b5b51
    mov dword ptr [ebp - local_4], 0xffffffff    # 004b5b56
    mov eax, dword ptr [ebp - local_10]          # 004b5b5d
    mov ecx, dword ptr [ebp - local_c]           # 004b5b60
    mov dword ptr fs:[0x0], ecx                  # 004b5b63
    {load} mov esp, ebp                          # 004b5b6a
    pop ebp                                      # 004b5b6c
    ret                                          # 004b5b6d

