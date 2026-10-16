# FUN_0040a5c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a5c1
# extent:       0x0040a5c1-0x0040a613 (82 code bytes)
# span:         0x0040a5c1-0x0040a613 (code 82, tables 0, padding 0)
# sha256:       a3fe923d832d10397f1828971957e310fbe81cf1f1dbfe865c81c7c1ddc60a5c
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040a5c1
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004090ab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004090ab, .text + (0x004090ab - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x0040a5c1 - 0x401000
.globl FUN_0040a5c1
FUN_0040a5c1:
    # block 0x0040a5c1: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a605 (forward)
    push ebp                                     # 0040a5c1
    {load} mov ebp, esp                          # 0040a5c2
    sub esp, 0x18                                # 0040a5c4
    push esi                                     # 0040a5c7
    push edi                                     # 0040a5c8
    mov dword ptr [ebp - local_18], ecx          # 0040a5c9
    push 0x13                                    # 0040a5cc
    lea eax, [ebp - local_14]                    # 0040a5ce
    push eax                                     # 0040a5d1
    mov ecx, dword ptr [ebp - local_18]          # 0040a5d2
    add ecx, 0x8c                                # 0040a5d5
    call FUN_0051d5b2                            # 0040a5db
    mov edi, 0x53ec58                            # 0040a5e0
    lea esi, [ebp - local_14]                    # 0040a5e5
    mov ecx, 0x4                                 # 0040a5e8
    {load} xor edx, edx                          # 0040a5ed
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a5ef
    je.d8 L_0040a605                             # 0040a5f1
    # block 0x0040a5f3: entered by fall-through of je at 0x0040a5f1, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a605
    lea eax, [ebp - local_14]                    # 0040a5f3
    push eax                                     # 0040a5f6
    call FUN_0050cb1b                            # 0040a5f7
    add esp, 0x4                                 # 0040a5fc
    mov word ptr [0x5ec2d6], ax                  # 0040a5ff
L_0040a605:
    # block 0x0040a605: entered by je at 0x0040a5f1, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a605
    call FUN_004090ab                            # 0040a608
    pop edi                                      # 0040a60d
    pop esi                                      # 0040a60e
    {load} mov esp, ebp                          # 0040a60f
    pop ebp                                      # 0040a611
    ret                                          # 0040a612

