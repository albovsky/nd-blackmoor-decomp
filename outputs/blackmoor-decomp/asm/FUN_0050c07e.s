# FUN_0050c07e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c07e
# extent:       0x0050c07e-0x0050c0e9 (107 code bytes)
# span:         0x0050c07e-0x0050c0e9 (code 107, tables 0, padding 0)
# sha256:       cead2e7ace2235dbf9eadfb2adf9cb9dadf49695928a6a7c86e56e7e7f695e0a
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c07e
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_10, local_2c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050bf50, USER32.dll!IsIconic, USER32.dll!GetWindowPlacement, USER32.dll!GetWindowRect, FUN_0050c028; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
.equ local_2c, 0x2c  # offset -0x2c
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050bf50, .text + (0x0050bf50 - 0x401000)
.set FUN_0050c028, .text + (0x0050c028 - 0x401000)

.org 0x0050c07e - 0x401000
.globl FUN_0050c07e
FUN_0050c07e:
    # block 0x0050c07e: entry, 6 instruction(s), calls FUN_0050bf50, ends with je to 0x0050c09b (forward)
    push ebp                                     # 0050c07e
    {load} mov ebp, esp                          # 0050c07f
    sub esp, 0x2c                                # 0050c081
    call FUN_0050bf50                            # 0050c084
    test eax, eax                                # 0050c089
    je.d8 L_0050c09b                             # 0050c08b
    # block 0x0050c08d: entered by fall-through of je at 0x0050c08b, 4 instruction(s), calls indirect dword ptr [0x63c35c], ends with forward jump to 0x0050c0e5
    push dword ptr [ebp + arg_c]                 # 0050c08d
    push dword ptr [ebp + arg_8]                 # 0050c090
    call dword ptr [0x63c35c]                    # 0050c093
    jmp.d8 L_0050c0e5                            # 0050c099
L_0050c09b:
    # block 0x0050c09b: entered by je at 0x0050c08b, 2 instruction(s), ends with je to 0x0050c0a8 (forward)
    test byte ptr [ebp + arg_c], 0x3             # 0050c09b
    je.d8 L_0050c0a8                             # 0050c09f
    # block 0x0050c0a1: entered by fall-through of je at 0x0050c09f, 2 instruction(s), ends with forward jump to 0x0050c0e5
    mov eax, 0x12340042                          # 0050c0a1
    jmp.d8 L_0050c0e5                            # 0050c0a6
L_0050c0a8:
    # block 0x0050c0a8: entered by je at 0x0050c09f, 4 instruction(s), calls USER32.dll!IsIconic, ends with je to 0x0050c0c4 (forward)
    push dword ptr [ebp + arg_8]                 # 0050c0a8
    call dword ptr [0x52a464]                    # 0050c0ab
    test eax, eax                                # 0050c0b1
    je.d8 L_0050c0c4                             # 0050c0b3
    # block 0x0050c0b5: entered by fall-through of je at 0x0050c0b3, 5 instruction(s), calls USER32.dll!GetWindowPlacement, ends with forward jump to 0x0050c0d1
    lea eax, [ebp - local_2c]                    # 0050c0b5
    push eax                                     # 0050c0b8
    push dword ptr [ebp + arg_8]                 # 0050c0b9
    call dword ptr [0x52a468]                    # 0050c0bc
    jmp.d8 L_0050c0d1                            # 0050c0c2
L_0050c0c4:
    # block 0x0050c0c4: entered by je at 0x0050c0b3, 4 instruction(s), calls USER32.dll!GetWindowRect, falls into the block at 0x0050c0d1
    lea eax, [ebp - local_10]                    # 0050c0c4
    push eax                                     # 0050c0c7
    push dword ptr [ebp + arg_8]                 # 0050c0c8
    call dword ptr [0x52a46c]                    # 0050c0cb
L_0050c0d1:
    # block 0x0050c0d1: entered by jmp at 0x0050c0c2, 2 instruction(s), ends with je to 0x0050c0e3 (forward)
    test eax, eax                                # 0050c0d1
    je.d8 L_0050c0e3                             # 0050c0d3
    # block 0x0050c0d5: entered by fall-through of je at 0x0050c0d3, 5 instruction(s), calls FUN_0050c028, ends with forward jump to 0x0050c0e5
    push dword ptr [ebp + arg_c]                 # 0050c0d5
    lea eax, [ebp - local_10]                    # 0050c0d8
    push eax                                     # 0050c0db
    call FUN_0050c028                            # 0050c0dc
    jmp.d8 L_0050c0e5                            # 0050c0e1
L_0050c0e3:
    # block 0x0050c0e3: entered by je at 0x0050c0d3, 1 instruction(s), falls into the block at 0x0050c0e5
    {load} xor eax, eax                          # 0050c0e3
L_0050c0e5:
    # block 0x0050c0e5: entered by jmp at 0x0050c099; jmp at 0x0050c0a6; jmp at 0x0050c0e1, 2 instruction(s), ends with ret 0x8
    leave                                        # 0050c0e5
    ret 0x8                                      # 0050c0e6

