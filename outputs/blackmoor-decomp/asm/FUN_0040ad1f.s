# FUN_0040ad1f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040ad1f
# extent:       0x0040ad1f-0x0040ad71 (82 code bytes)
# span:         0x0040ad1f-0x0040ad71 (code 82, tables 0, padding 0)
# sha256:       5224ec8d6bd0d895a5380dbbf9787db1a2a550f6c4e6d880cf9a318574e192d0
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040ad1f
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

.org 0x0040ad1f - 0x401000
.globl FUN_0040ad1f
FUN_0040ad1f:
    # block 0x0040ad1f: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040ad63 (forward)
    push ebp                                     # 0040ad1f
    {load} mov ebp, esp                          # 0040ad20
    sub esp, 0x18                                # 0040ad22
    push esi                                     # 0040ad25
    push edi                                     # 0040ad26
    mov dword ptr [ebp - local_18], ecx          # 0040ad27
    push 0x13                                    # 0040ad2a
    lea eax, [ebp - local_14]                    # 0040ad2c
    push eax                                     # 0040ad2f
    mov ecx, dword ptr [ebp - local_18]          # 0040ad30
    add ecx, 0x64c                               # 0040ad33
    call FUN_0051d5b2                            # 0040ad39
    mov edi, 0x53ecb4                            # 0040ad3e
    lea esi, [ebp - local_14]                    # 0040ad43
    mov ecx, 0x4                                 # 0040ad46
    {load} xor edx, edx                          # 0040ad4b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040ad4d
    je.d8 L_0040ad63                             # 0040ad4f
    # block 0x0040ad51: entered by fall-through of je at 0x0040ad4f, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040ad63
    lea eax, [ebp - local_14]                    # 0040ad51
    push eax                                     # 0040ad54
    call FUN_0050cb1b                            # 0040ad55
    add esp, 0x4                                 # 0040ad5a
    mov word ptr [0x5ec304], ax                  # 0040ad5d
L_0040ad63:
    # block 0x0040ad63: entered by je at 0x0040ad4f, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040ad63
    call FUN_004090ab                            # 0040ad66
    pop edi                                      # 0040ad6b
    pop esi                                      # 0040ad6c
    {load} mov esp, ebp                          # 0040ad6d
    pop ebp                                      # 0040ad6f
    ret                                          # 0040ad70

