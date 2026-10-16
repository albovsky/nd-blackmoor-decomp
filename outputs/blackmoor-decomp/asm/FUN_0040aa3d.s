# FUN_0040aa3d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040aa3d
# extent:       0x0040aa3d-0x0040aa8f (82 code bytes)
# span:         0x0040aa3d-0x0040aa8f (code 82, tables 0, padding 0)
# sha256:       d09491a1a6d0dd33974c6386bea761bc985bbdf0bd1f11270536fb5ea557c409
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040aa3d
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

.org 0x0040aa3d - 0x401000
.globl FUN_0040aa3d
FUN_0040aa3d:
    # block 0x0040aa3d: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040aa81 (forward)
    push ebp                                     # 0040aa3d
    {load} mov ebp, esp                          # 0040aa3e
    sub esp, 0x18                                # 0040aa40
    push esi                                     # 0040aa43
    push edi                                     # 0040aa44
    mov dword ptr [ebp - local_18], ecx          # 0040aa45
    push 0x13                                    # 0040aa48
    lea eax, [ebp - local_14]                    # 0040aa4a
    push eax                                     # 0040aa4d
    mov ecx, dword ptr [ebp - local_18]          # 0040aa4e
    add ecx, 0x40c                               # 0040aa51
    call FUN_0051d5b2                            # 0040aa57
    mov edi, 0x53ec90                            # 0040aa5c
    lea esi, [ebp - local_14]                    # 0040aa61
    mov ecx, 0x4                                 # 0040aa64
    {load} xor edx, edx                          # 0040aa69
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040aa6b
    je.d8 L_0040aa81                             # 0040aa6d
    # block 0x0040aa6f: entered by fall-through of je at 0x0040aa6d, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040aa81
    lea eax, [ebp - local_14]                    # 0040aa6f
    push eax                                     # 0040aa72
    call FUN_0050cb1b                            # 0040aa73
    add esp, 0x4                                 # 0040aa78
    mov word ptr [0x5ec2f2], ax                  # 0040aa7b
L_0040aa81:
    # block 0x0040aa81: entered by je at 0x0040aa6d, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040aa81
    call FUN_004090ab                            # 0040aa84
    pop edi                                      # 0040aa89
    pop esi                                      # 0040aa8a
    {load} mov esp, ebp                          # 0040aa8b
    pop ebp                                      # 0040aa8d
    ret                                          # 0040aa8e

