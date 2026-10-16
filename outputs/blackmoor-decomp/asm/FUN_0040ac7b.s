# FUN_0040ac7b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040ac7b
# extent:       0x0040ac7b-0x0040accd (82 code bytes)
# span:         0x0040ac7b-0x0040accd (code 82, tables 0, padding 0)
# sha256:       51f34abc3c73edcb4f9730519cc50ffc1f0513734b186622acc933341f2d83f5
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040ac7b
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

.org 0x0040ac7b - 0x401000
.globl FUN_0040ac7b
FUN_0040ac7b:
    # block 0x0040ac7b: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040acbf (forward)
    push ebp                                     # 0040ac7b
    {load} mov ebp, esp                          # 0040ac7c
    sub esp, 0x18                                # 0040ac7e
    push esi                                     # 0040ac81
    push edi                                     # 0040ac82
    mov dword ptr [ebp - local_18], ecx          # 0040ac83
    push 0x13                                    # 0040ac86
    lea eax, [ebp - local_14]                    # 0040ac88
    push eax                                     # 0040ac8b
    mov ecx, dword ptr [ebp - local_18]          # 0040ac8c
    add ecx, 0x5cc                               # 0040ac8f
    call FUN_0051d5b2                            # 0040ac95
    mov edi, 0x53ecac                            # 0040ac9a
    lea esi, [ebp - local_14]                    # 0040ac9f
    mov ecx, 0x4                                 # 0040aca2
    {load} xor edx, edx                          # 0040aca7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040aca9
    je.d8 L_0040acbf                             # 0040acab
    # block 0x0040acad: entered by fall-through of je at 0x0040acab, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040acbf
    lea eax, [ebp - local_14]                    # 0040acad
    push eax                                     # 0040acb0
    call FUN_0050cb1b                            # 0040acb1
    add esp, 0x4                                 # 0040acb6
    mov word ptr [0x5ec300], ax                  # 0040acb9
L_0040acbf:
    # block 0x0040acbf: entered by je at 0x0040acab, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040acbf
    call FUN_004090ab                            # 0040acc2
    pop edi                                      # 0040acc7
    pop esi                                      # 0040acc8
    {load} mov esp, ebp                          # 0040acc9
    pop ebp                                      # 0040accb
    ret                                          # 0040accc

