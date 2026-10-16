# FUN_0040a8a3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a8a3
# extent:       0x0040a8a3-0x0040a8f5 (82 code bytes)
# span:         0x0040a8a3-0x0040a8f5 (code 82, tables 0, padding 0)
# sha256:       8d44a887e255ff425233743078d6c1726900b6c2d5a4cd4f26b44bea0bd7dc0d
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040a8a3
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

.org 0x0040a8a3 - 0x401000
.globl FUN_0040a8a3
FUN_0040a8a3:
    # block 0x0040a8a3: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a8e7 (forward)
    push ebp                                     # 0040a8a3
    {load} mov ebp, esp                          # 0040a8a4
    sub esp, 0x18                                # 0040a8a6
    push esi                                     # 0040a8a9
    push edi                                     # 0040a8aa
    mov dword ptr [ebp - local_18], ecx          # 0040a8ab
    push 0x13                                    # 0040a8ae
    lea eax, [ebp - local_14]                    # 0040a8b0
    push eax                                     # 0040a8b3
    mov ecx, dword ptr [ebp - local_18]          # 0040a8b4
    add ecx, 0x2cc                               # 0040a8b7
    call FUN_0051d5b2                            # 0040a8bd
    mov edi, 0x53ec7c                            # 0040a8c2
    lea esi, [ebp - local_14]                    # 0040a8c7
    mov ecx, 0x4                                 # 0040a8ca
    {load} xor edx, edx                          # 0040a8cf
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a8d1
    je.d8 L_0040a8e7                             # 0040a8d3
    # block 0x0040a8d5: entered by fall-through of je at 0x0040a8d3, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a8e7
    lea eax, [ebp - local_14]                    # 0040a8d5
    push eax                                     # 0040a8d8
    call FUN_0050cb1b                            # 0040a8d9
    add esp, 0x4                                 # 0040a8de
    mov word ptr [0x5ec2e8], ax                  # 0040a8e1
L_0040a8e7:
    # block 0x0040a8e7: entered by je at 0x0040a8d3, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a8e7
    call FUN_004090ab                            # 0040a8ea
    pop edi                                      # 0040a8ef
    pop esi                                      # 0040a8f0
    {load} mov esp, ebp                          # 0040a8f1
    pop ebp                                      # 0040a8f3
    ret                                          # 0040a8f4

