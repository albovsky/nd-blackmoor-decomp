# FUN_0051ab72
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ab72
# extent:       0x0051ab72-0x0051abe4 (114 code bytes)
# span:         0x0051ab72-0x0051abe4 (code 114, tables 0, padding 0)
# sha256:       012f02b5cea6c2f09435d5dcd7d5aa193264aca6ecdda78fcc4371577100bf55
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ab72
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_4, field_minus_c; [esi + n] field_14
# callees:      calls FUN_0050f978, FUN_00525397, FUN_0051dc31, FUN_0051dc43, FUN_0051f7a0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051dc31, .text + (0x0051dc31 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051f7a0, .text + (0x0051f7a0 - 0x401000)
.set FUN_00525397, .text + (0x00525397 - 0x401000)

.org 0x0051ab72 - 0x401000
.globl FUN_0051ab72
FUN_0051ab72:
    # block 0x0051ab72: entry, 7 instruction(s), calls FUN_0050f978, FUN_00525397, ends with jne to 0x0051abd2 (forward)
    mov eax, 0x528b56                            # 0051ab72
    call FUN_0050f978                            # 0051ab77
    push esi                                     # 0051ab7c
    call FUN_00525397                            # 0051ab7d
    {load} mov esi, eax                          # 0051ab82
    cmp dword ptr [esi + field_14], 0x0          # 0051ab84
    jne.d8 L_0051abd2                            # 0051ab88
    # block 0x0051ab8a: entered by fall-through of jne at 0x0051ab88, 2 instruction(s), ends with je to 0x0051abd2 (forward)
    cmp dword ptr [ebp + field_8], 0x0           # 0051ab8a
    je.d8 L_0051abd2                             # 0051ab8e
    # block 0x0051ab90: entered by fall-through of je at 0x0051ab8e, 12 instruction(s), calls FUN_0051dc31, FUN_0051dc43, ends with je to 0x0051abc2 (forward)
    push ebx                                     # 0051ab90
    push 0x521235                                # 0051ab91
    call FUN_0051dc31                            # 0051ab96
    push 0x48                                    # 0051ab9b
    {load} mov ebx, eax                          # 0051ab9d
    call FUN_0051dc43                            # 0051ab9f
    pop ecx                                      # 0051aba4
    {load} mov ecx, eax                          # 0051aba5
    mov dword ptr [ebp + field_8], ecx           # 0051aba7
    and dword ptr [ebp - field_minus_4], 0x0     # 0051abaa
    test ecx, ecx                                # 0051abae
    je.d8 L_0051abc2                             # 0051abb0
    # block 0x0051abb2: entered by fall-through of je at 0x0051abb0, 5 instruction(s), calls FUN_0051f7a0, ends with forward jump to 0x0051abc4
    push 0x1                                     # 0051abb2
    push 0x1c                                    # 0051abb4
    push 0x52e668                                # 0051abb6
    call FUN_0051f7a0                            # 0051abbb
    jmp.d8 L_0051abc4                            # 0051abc0
L_0051abc2:
    # block 0x0051abc2: entered by je at 0x0051abb0, 1 instruction(s), falls into the block at 0x0051abc4
    {load} xor eax, eax                          # 0051abc2
L_0051abc4:
    # block 0x0051abc4: entered by jmp at 0x0051abc0, 5 instruction(s), calls FUN_0051dc31, falls into the block at 0x0051abd2
    or dword ptr [ebp - field_minus_4], -0x1     # 0051abc4
    push ebx                                     # 0051abc8
    mov dword ptr [esi + field_14], eax          # 0051abc9
    call FUN_0051dc31                            # 0051abcc
    pop ebx                                      # 0051abd1
L_0051abd2:
    # block 0x0051abd2: entered by jne at 0x0051ab88; je at 0x0051ab8e, 6 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051abd2
    mov eax, dword ptr [esi + field_14]          # 0051abd5
    pop esi                                      # 0051abd8
    mov dword ptr fs:[0x0], ecx                  # 0051abd9
    leave                                        # 0051abe0
    ret 0x4                                      # 0051abe1

