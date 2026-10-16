# FUN_005210a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005210a2
# extent:       0x005210a2-0x00521117 (117 code bytes)
# span:         0x005210a2-0x00521117 (code 117, tables 0, padding 0)
# sha256:       4ce8929d9fd438d7b0be61bdf0bc3ae7f05795804019c1c3e4b6527a29c1c164
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005210a2
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls USER32.dll!ClientToScreen, USER32.dll!GetDlgCtrlID, USER32.dll!GetWindowLongA, USER32.dll!GetWindowRect, USER32.dll!PtInRect; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 46 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x005210a2 - 0x401000
.globl FUN_005210a2
FUN_005210a2:
    # block 0x005210a2: entry, 12 instruction(s), calls USER32.dll!ClientToScreen, falls into the block at 0x005210c2
    push ebp                                     # 005210a2
    {load} mov ebp, esp                          # 005210a3
    sub esp, 0x10                                # 005210a5
    push esi                                     # 005210a8
    lea eax, [ebp + arg_c]                       # 005210a9
    push edi                                     # 005210ac
    push eax                                     # 005210ad
    push dword ptr [ebp + arg_8]                 # 005210ae
    call dword ptr [0x52a478]                    # 005210b1
    mov edi, dword ptr [0x52a450]                # 005210b7
    push 0x5                                     # 005210bd
    push dword ptr [ebp + arg_8]                 # 005210bf
L_005210c2:
    # block 0x005210c2: entered by jmp at 0x00521109, 4 instruction(s), calls indirect edi, ends with je to 0x0052110f (forward)
    call edi                                     # 005210c2
    {load} mov esi, eax                          # 005210c4
    test esi, esi                                # 005210c6
    je.d8 L_0052110f                             # 005210c8
    # block 0x005210ca: entered by fall-through of je at 0x005210c8, 4 instruction(s), calls USER32.dll!GetDlgCtrlID, ends with je to 0x00521106 (forward)
    push esi                                     # 005210ca
    call dword ptr [0x52a40c]                    # 005210cb
    .insn 0x66, 0x3d, 0xffff{:u16}               # 005210d1
    je.d8 L_00521106                             # 005210d5
    # block 0x005210d7: entered by fall-through of je at 0x005210d5, 5 instruction(s), calls USER32.dll!GetWindowLongA, ends with je to 0x00521106 (forward)
    push -0x10                                   # 005210d7
    push esi                                     # 005210d9
    call dword ptr [0x52a454]                    # 005210da
    test eax, 0x10000000                         # 005210e0
    je.d8 L_00521106                             # 005210e5
    # block 0x005210e7: entered by fall-through of je at 0x005210e5, 11 instruction(s), calls USER32.dll!GetWindowRect, USER32.dll!PtInRect, ends with jne to 0x0052110b (forward)
    lea eax, [ebp - local_10]                    # 005210e7
    push eax                                     # 005210ea
    push esi                                     # 005210eb
    call dword ptr [0x52a46c]                    # 005210ec
    push dword ptr [ebp + arg_10]                # 005210f2
    lea eax, [ebp - local_10]                    # 005210f5
    push dword ptr [ebp + arg_c]                 # 005210f8
    push eax                                     # 005210fb
    call dword ptr [0x52a3bc]                    # 005210fc
    test eax, eax                                # 00521102
    jne.d8 L_0052110b                            # 00521104
L_00521106:
    # block 0x00521106: entered by je at 0x005210d5; je at 0x005210e5; fall-through of jne at 0x00521104, 3 instruction(s), ends with backward jump to 0x005210c2
    push 0x2                                     # 00521106
    push esi                                     # 00521108
    jmp.d8 L_005210c2                            # 00521109
L_0052110b:
    # block 0x0052110b: entered by jne at 0x00521104, 2 instruction(s), ends with forward jump to 0x00521111
    {load} mov eax, esi                          # 0052110b
    jmp.d8 L_00521111                            # 0052110d
L_0052110f:
    # block 0x0052110f: entered by je at 0x005210c8, 1 instruction(s), falls into the block at 0x00521111
    {load} xor eax, eax                          # 0052110f
L_00521111:
    # block 0x00521111: entered by jmp at 0x0052110d, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 00521111
    pop esi                                      # 00521112
    leave                                        # 00521113
    ret 0xc                                      # 00521114

