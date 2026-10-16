# FUN_0040a999
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a999
# extent:       0x0040a999-0x0040a9eb (82 code bytes)
# span:         0x0040a999-0x0040a9eb (code 82, tables 0, padding 0)
# sha256:       fdf40f59959eeb759f1c680e257a2a69e0ccb1feb3f2baac09ba0c27c974fd0c
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040a999
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

.org 0x0040a999 - 0x401000
.globl FUN_0040a999
FUN_0040a999:
    # block 0x0040a999: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a9dd (forward)
    push ebp                                     # 0040a999
    {load} mov ebp, esp                          # 0040a99a
    sub esp, 0x18                                # 0040a99c
    push esi                                     # 0040a99f
    push edi                                     # 0040a9a0
    mov dword ptr [ebp - local_18], ecx          # 0040a9a1
    push 0x13                                    # 0040a9a4
    lea eax, [ebp - local_14]                    # 0040a9a6
    push eax                                     # 0040a9a9
    mov ecx, dword ptr [ebp - local_18]          # 0040a9aa
    add ecx, 0x38c                               # 0040a9ad
    call FUN_0051d5b2                            # 0040a9b3
    mov edi, 0x53ec88                            # 0040a9b8
    lea esi, [ebp - local_14]                    # 0040a9bd
    mov ecx, 0x4                                 # 0040a9c0
    {load} xor edx, edx                          # 0040a9c5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a9c7
    je.d8 L_0040a9dd                             # 0040a9c9
    # block 0x0040a9cb: entered by fall-through of je at 0x0040a9c9, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a9dd
    lea eax, [ebp - local_14]                    # 0040a9cb
    push eax                                     # 0040a9ce
    call FUN_0050cb1b                            # 0040a9cf
    add esp, 0x4                                 # 0040a9d4
    mov word ptr [0x5ec2ee], ax                  # 0040a9d7
L_0040a9dd:
    # block 0x0040a9dd: entered by je at 0x0040a9c9, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a9dd
    call FUN_004090ab                            # 0040a9e0
    pop edi                                      # 0040a9e5
    pop esi                                      # 0040a9e6
    {load} mov esp, ebp                          # 0040a9e7
    pop ebp                                      # 0040a9e9
    ret                                          # 0040a9ea

