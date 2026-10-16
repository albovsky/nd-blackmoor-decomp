# FUN_0040a8f5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a8f5
# extent:       0x0040a8f5-0x0040a947 (82 code bytes)
# span:         0x0040a8f5-0x0040a947 (code 82, tables 0, padding 0)
# sha256:       64a309cd0f637e3f85ad81c98bfd515454829a85f57d79086f0b813ea0e066f0
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040a8f5
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

.org 0x0040a8f5 - 0x401000
.globl FUN_0040a8f5
FUN_0040a8f5:
    # block 0x0040a8f5: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a939 (forward)
    push ebp                                     # 0040a8f5
    {load} mov ebp, esp                          # 0040a8f6
    sub esp, 0x18                                # 0040a8f8
    push esi                                     # 0040a8fb
    push edi                                     # 0040a8fc
    mov dword ptr [ebp - local_18], ecx          # 0040a8fd
    push 0x13                                    # 0040a900
    lea eax, [ebp - local_14]                    # 0040a902
    push eax                                     # 0040a905
    mov ecx, dword ptr [ebp - local_18]          # 0040a906
    add ecx, 0x30c                               # 0040a909
    call FUN_0051d5b2                            # 0040a90f
    mov edi, 0x53ec80                            # 0040a914
    lea esi, [ebp - local_14]                    # 0040a919
    mov ecx, 0x4                                 # 0040a91c
    {load} xor edx, edx                          # 0040a921
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a923
    je.d8 L_0040a939                             # 0040a925
    # block 0x0040a927: entered by fall-through of je at 0x0040a925, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a939
    lea eax, [ebp - local_14]                    # 0040a927
    push eax                                     # 0040a92a
    call FUN_0050cb1b                            # 0040a92b
    add esp, 0x4                                 # 0040a930
    mov word ptr [0x5ec2ea], ax                  # 0040a933
L_0040a939:
    # block 0x0040a939: entered by je at 0x0040a925, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a939
    call FUN_004090ab                            # 0040a93c
    pop edi                                      # 0040a941
    pop esi                                      # 0040a942
    {load} mov esp, ebp                          # 0040a943
    pop ebp                                      # 0040a945
    ret                                          # 0040a946

