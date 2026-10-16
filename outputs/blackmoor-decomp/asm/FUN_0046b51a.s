# FUN_0046b51a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b51a
# extent:       0x0046b51a-0x0046b56e (84 code bytes)
# span:         0x0046b51a-0x0046b56e (code 84, tables 0, padding 0)
# sha256:       3fec8907c6d31b6052b5c3c49c7f372ffe3cb452ad7abbc84df96110ecf25741
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046b51a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0046b58a
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
.set FUN_0046b58a, .text + (0x0046b58a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0046b51a - 0x401000
.globl FUN_0046b51a
FUN_0046b51a:
    # block 0x0046b51a: entry, 23 instruction(s), calls FUN_0051d716, FUN_0046b58a, ends with ret
    push ebp                                     # 0046b51a
    {load} mov ebp, esp                          # 0046b51b
    push -0x1                                    # 0046b51d
    push 0x5281ed                                # 0046b51f
    mov eax, dword ptr fs:[0x0]                  # 0046b524
    push eax                                     # 0046b52a
    mov dword ptr fs:[0x0], esp                  # 0046b52b
    push ecx                                     # 0046b532
    mov dword ptr [ebp - local_10], ecx          # 0046b533
    mov ecx, dword ptr [ebp - local_10]          # 0046b536
    call FUN_0051d716                            # 0046b539
    mov dword ptr [ebp - local_4], 0x0           # 0046b53e
    mov eax, dword ptr [ebp - local_10]          # 0046b545
    mov dword ptr [eax], 0x52d2e8                # 0046b548
    mov ecx, dword ptr [ebp - local_10]          # 0046b54e
    call FUN_0046b58a                            # 0046b551
    mov dword ptr [ebp - local_4], 0xffffffff    # 0046b556
    mov eax, dword ptr [ebp - local_10]          # 0046b55d
    mov ecx, dword ptr [ebp - local_c]           # 0046b560
    mov dword ptr fs:[0x0], ecx                  # 0046b563
    {load} mov esp, ebp                          # 0046b56a
    pop ebp                                      # 0046b56c
    ret                                          # 0046b56d

