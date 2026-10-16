# FUN_0040a6b7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040a6b7
# extent:       0x0040a6b7-0x0040a709 (82 code bytes)
# span:         0x0040a6b7-0x0040a709 (code 82, tables 0, padding 0)
# sha256:       1dc4802b1f9e819311e6d3dd5dd84155be4d47bbbd4ff2d2e58c15dcf50df7ad
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040a6b7
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

.org 0x0040a6b7 - 0x401000
.globl FUN_0040a6b7
FUN_0040a6b7:
    # block 0x0040a6b7: entry, 18 instruction(s), calls FUN_0051d5b2, ends with je to 0x0040a6fb (forward)
    push ebp                                     # 0040a6b7
    {load} mov ebp, esp                          # 0040a6b8
    sub esp, 0x18                                # 0040a6ba
    push esi                                     # 0040a6bd
    push edi                                     # 0040a6be
    mov dword ptr [ebp - local_18], ecx          # 0040a6bf
    push 0x13                                    # 0040a6c2
    lea eax, [ebp - local_14]                    # 0040a6c4
    push eax                                     # 0040a6c7
    mov ecx, dword ptr [ebp - local_18]          # 0040a6c8
    add ecx, 0x14c                               # 0040a6cb
    call FUN_0051d5b2                            # 0040a6d1
    mov edi, 0x53ec64                            # 0040a6d6
    lea esi, [ebp - local_14]                    # 0040a6db
    mov ecx, 0x4                                 # 0040a6de
    {load} xor edx, edx                          # 0040a6e3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0040a6e5
    je.d8 L_0040a6fb                             # 0040a6e7
    # block 0x0040a6e9: entered by fall-through of je at 0x0040a6e7, 5 instruction(s), calls FUN_0050cb1b, falls into the block at 0x0040a6fb
    lea eax, [ebp - local_14]                    # 0040a6e9
    push eax                                     # 0040a6ec
    call FUN_0050cb1b                            # 0040a6ed
    add esp, 0x4                                 # 0040a6f2
    mov word ptr [0x5ec2dc], ax                  # 0040a6f5
L_0040a6fb:
    # block 0x0040a6fb: entered by je at 0x0040a6e7, 7 instruction(s), calls FUN_004090ab, ends with ret
    mov ecx, dword ptr [ebp - local_18]          # 0040a6fb
    call FUN_004090ab                            # 0040a6fe
    pop edi                                      # 0040a703
    pop esi                                      # 0040a704
    {load} mov esp, ebp                          # 0040a705
    pop ebp                                      # 0040a707
    ret                                          # 0040a708

