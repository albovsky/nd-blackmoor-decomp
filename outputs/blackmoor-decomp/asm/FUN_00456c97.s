# FUN_00456c97
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456c97
# extent:       0x00456c97-0x00456ceb (84 code bytes)
# span:         0x00456c97-0x00456ceb (code 84, tables 0, padding 0)
# sha256:       ff30b5615fbc3c845119e89e2c1a7ee988de2f906de15a468eec7f62f8c4dd76
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00456c97
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00456d07
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
.set FUN_00456d07, .text + (0x00456d07 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00456c97 - 0x401000
.globl FUN_00456c97
FUN_00456c97:
    # block 0x00456c97: entry, 23 instruction(s), calls FUN_0051d716, FUN_00456d07, ends with ret
    push ebp                                     # 00456c97
    {load} mov ebp, esp                          # 00456c98
    push -0x1                                    # 00456c9a
    push 0x52803d                                # 00456c9c
    mov eax, dword ptr fs:[0x0]                  # 00456ca1
    push eax                                     # 00456ca7
    mov dword ptr fs:[0x0], esp                  # 00456ca8
    push ecx                                     # 00456caf
    mov dword ptr [ebp - local_10], ecx          # 00456cb0
    mov ecx, dword ptr [ebp - local_10]          # 00456cb3
    call FUN_0051d716                            # 00456cb6
    mov dword ptr [ebp - local_4], 0x0           # 00456cbb
    mov eax, dword ptr [ebp - local_10]          # 00456cc2
    mov dword ptr [eax], 0x52cdd8                # 00456cc5
    mov ecx, dword ptr [ebp - local_10]          # 00456ccb
    call FUN_00456d07                            # 00456cce
    mov dword ptr [ebp - local_4], 0xffffffff    # 00456cd3
    mov eax, dword ptr [ebp - local_10]          # 00456cda
    mov ecx, dword ptr [ebp - local_c]           # 00456cdd
    mov dword ptr fs:[0x0], ecx                  # 00456ce0
    {load} mov esp, ebp                          # 00456ce7
    pop ebp                                      # 00456ce9
    ret                                          # 00456cea

