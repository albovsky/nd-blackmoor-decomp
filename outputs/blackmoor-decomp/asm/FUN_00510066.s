# FUN_00510066
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510066
# extent:       0x00510066-0x005100ab (69 code bytes)
# span:         0x00510066-0x005100ab (code 69, tables 0, padding 0)
# sha256:       8ba29e0469125f0bb301ac936c85ac80ca22492f89b4962a9f287a87e33474b7
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510066
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_minus_4; [esp + n] stk_c
# callees:      calls FUN_00512c18, FUN_00514f63, FUN_00512c79, KERNEL32.dll!HeapSize
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00514f63, .text + (0x00514f63 - 0x401000)

.org 0x00510066 - 0x401000
.globl FUN_00510066
FUN_00510066:
    # block 0x00510066: entry, 10 instruction(s), calls FUN_00512c18, FUN_00514f63, ends with je to 0x0051008e (forward)
    push esi                                     # 00510066
    push 0x9                                     # 00510067
    call FUN_00512c18                            # 00510069
    mov esi, dword ptr [esp + stk_c]             # 0051006e
    push esi                                     # 00510072
    call FUN_00514f63                            # 00510073
    pop ecx                                      # 00510078
    test eax, eax                                # 00510079
    pop ecx                                      # 0051007b
    je.d8 L_0051008e                             # 0051007c
    # block 0x0051007e: entered by fall-through of je at 0x0051007c, 6 instruction(s), calls FUN_00512c79, ends with forward jump to 0x005100a7
    mov esi, dword ptr [esi - field_minus_4]     # 0051007e
    push 0x9                                     # 00510081
    sub esi, 0x9                                 # 00510083
    call FUN_00512c79                            # 00510086
    pop ecx                                      # 0051008b
    jmp.d8 L_005100a7                            # 0051008c
L_0051008e:
    # block 0x0051008e: entered by je at 0x0051007c, 8 instruction(s), calls FUN_00512c79, KERNEL32.dll!HeapSize, falls into the block at 0x005100a7
    push 0x9                                     # 0051008e
    call FUN_00512c79                            # 00510090
    pop ecx                                      # 00510095
    push esi                                     # 00510096
    push 0x0                                     # 00510097
    push dword ptr [0x63cdd8]                    # 00510099
    call dword ptr [0x52a164]                    # 0051009f
    {load} mov esi, eax                          # 005100a5
L_005100a7:
    # block 0x005100a7: entered by jmp at 0x0051008c, 3 instruction(s), ends with ret
    {load} mov eax, esi                          # 005100a7
    pop esi                                      # 005100a9
    ret                                          # 005100aa

