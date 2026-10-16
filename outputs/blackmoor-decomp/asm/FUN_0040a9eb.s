# FUN_0040a9eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a9eb
# extent:       0x0040a9eb-0x0040aa3d (82 code bytes)
# span:         0x0040a9eb-0x0040aa3d (code 82, tables 0, padding 0)
# sha256:       bcf65aa896cdc24685b9d4bb433b107799f9be2a3fdac7c6cb0c7ebcf8d1a39f
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040a9eb
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

.org 0x0040a9eb - 0x401000
.globl FUN_0040a9eb
FUN_0040a9eb:
    # block 0x0040a9eb: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040aa2f (forward)
    push ebp                                     # 0040a9eb
    {load} mov ebp, esp                          # 0040a9ec
    sub esp, 0x18                                # 0040a9ee
    push esi                                     # 0040a9f1
    push edi                                     # 0040a9f2
    mov dword ptr [ebp - local_18], ecx          # 0040a9f3
    push 0x13                                    # 0040a9f6
    lea eax, [ebp - local_14]                    # 0040a9f8
    push eax                                     # 0040a9fb
    mov ecx, dword ptr [ebp - local_18]          # 0040a9fc
    add ecx, 0x3cc                               # 0040a9ff
    call FUN_0051d5b2                            # 0040aa05
    mov edi, 0x53ec8c                            # 0040aa0a
    lea esi, [ebp - local_14]                    # 0040aa0f
    mov ecx, 0x4                                 # 0040aa12
    {load} xor edx, edx                          # 0040aa17
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040aa19
    je.d8 L_0040aa2f                             # 0040aa1b
    # block 0x0040aa1d: entered by fall-through of je at 0x0040aa1b, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040aa2f
    lea eax, [ebp - local_14]                    # 0040aa1d
    push eax                                     # 0040aa20
    call FUN_0050cb1b                            # 0040aa21
    add esp, 0x4                                 # 0040aa26
    mov word ptr [0x5ec2f0], ax                  # 0040aa29
L_0040aa2f:
    # block 0x0040aa2f: entered by je at 0x0040aa1b, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040aa2f
    call FUN_004090ab                            # 0040aa32
    pop edi                                      # 0040aa37
    pop esi                                      # 0040aa38
    {load} mov esp, ebp                          # 0040aa39
    pop ebp                                      # 0040aa3b
    ret                                          # 0040aa3c

