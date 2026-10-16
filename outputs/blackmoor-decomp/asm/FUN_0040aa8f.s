# FUN_0040aa8f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040aa8f
# extent:       0x0040aa8f-0x0040aae1 (82 code bytes)
# span:         0x0040aa8f-0x0040aae1 (code 82, tables 0, padding 0)
# sha256:       0d5f2e26eddf99917055253f34a3c69ced06480adff38280de8511b6142ae7d4
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040aa8f
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

.org 0x0040aa8f - 0x401000
.globl FUN_0040aa8f
FUN_0040aa8f:
    # block 0x0040aa8f: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040aad3 (forward)
    push ebp                                     # 0040aa8f
    {load} mov ebp, esp                          # 0040aa90
    sub esp, 0x18                                # 0040aa92
    push esi                                     # 0040aa95
    push edi                                     # 0040aa96
    mov dword ptr [ebp - local_18], ecx          # 0040aa97
    push 0x13                                    # 0040aa9a
    lea eax, [ebp - local_14]                    # 0040aa9c
    push eax                                     # 0040aa9f
    mov ecx, dword ptr [ebp - local_18]          # 0040aaa0
    add ecx, 0x44c                               # 0040aaa3
    call FUN_0051d5b2                            # 0040aaa9
    mov edi, 0x53ec94                            # 0040aaae
    lea esi, [ebp - local_14]                    # 0040aab3
    mov ecx, 0x4                                 # 0040aab6
    {load} xor edx, edx                          # 0040aabb
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040aabd
    je.d8 L_0040aad3                             # 0040aabf
    # block 0x0040aac1: entered by fall-through of je at 0x0040aabf, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040aad3
    lea eax, [ebp - local_14]                    # 0040aac1
    push eax                                     # 0040aac4
    call FUN_0050cb1b                            # 0040aac5
    add esp, 0x4                                 # 0040aaca
    mov word ptr [0x5ec2f4], ax                  # 0040aacd
L_0040aad3:
    # block 0x0040aad3: entered by je at 0x0040aabf, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040aad3
    call FUN_004090ab                            # 0040aad6
    pop edi                                      # 0040aadb
    pop esi                                      # 0040aadc
    {load} mov esp, ebp                          # 0040aadd
    pop ebp                                      # 0040aadf
    ret                                          # 0040aae0

