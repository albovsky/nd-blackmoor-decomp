# FUN_0040af0b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040af0b
# extent:       0x0040af0b-0x0040af5d (82 code bytes)
# span:         0x0040af0b-0x0040af5d (code 82, tables 0, padding 0)
# sha256:       7b71c7e6094a780d477f40bce6a29c46d806b095a4174ac0e1d265923a1156f1
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040af0b
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

.org 0x0040af0b - 0x401000
.globl FUN_0040af0b
FUN_0040af0b:
    # block 0x0040af0b: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040af4f (forward)
    push ebp                                     # 0040af0b
    {load} mov ebp, esp                          # 0040af0c
    sub esp, 0x18                                # 0040af0e
    push esi                                     # 0040af11
    push edi                                     # 0040af12
    mov dword ptr [ebp - local_18], ecx          # 0040af13
    push 0x13                                    # 0040af16
    lea eax, [ebp - local_14]                    # 0040af18
    push eax                                     # 0040af1b
    mov ecx, dword ptr [ebp - local_18]          # 0040af1c
    add ecx, 0x7cc                               # 0040af1f
    call FUN_0051d5b2                            # 0040af25
    mov edi, 0x53eccc                            # 0040af2a
    lea esi, [ebp - local_14]                    # 0040af2f
    mov ecx, 0x4                                 # 0040af32
    {load} xor edx, edx                          # 0040af37
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040af39
    je.d8 L_0040af4f                             # 0040af3b
    # block 0x0040af3d: entered by fall-through of je at 0x0040af3b, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040af4f
    lea eax, [ebp - local_14]                    # 0040af3d
    push eax                                     # 0040af40
    call FUN_0050cb1b                            # 0040af41
    add esp, 0x4                                 # 0040af46
    mov word ptr [0x5ec310], ax                  # 0040af49
L_0040af4f:
    # block 0x0040af4f: entered by je at 0x0040af3b, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040af4f
    call FUN_004090ab                            # 0040af52
    pop edi                                      # 0040af57
    pop esi                                      # 0040af58
    {load} mov esp, ebp                          # 0040af59
    pop ebp                                      # 0040af5b
    ret                                          # 0040af5c

