# FUN_00521117
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521117
# extent:       0x00521117-0x0052116f (88 code bytes)
# span:         0x00521117-0x0052116f (code 88, tables 0, padding 0)
# sha256:       09789820a31a670d12ec776e81509c41ef0bac8605923a79a7f65f659d953a59
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521117
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_100
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!lstrlenA, USER32.dll!GetWindowTextA, KERNEL32.dll!lstrcmpA, USER32.dll!SetWindowTextA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_100, 0x100  # offset -0x100
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00521117 - 0x401000
.globl FUN_00521117
FUN_00521117:
    # block 0x00521117: entry, 10 instruction(s), calls KERNEL32.dll!lstrlenA, ends with ja to 0x0052115e (forward)
    push ebp                                     # 00521117
    {load} mov ebp, esp                          # 00521118
    sub esp, 0x100                               # 0052111a
    push esi                                     # 00521120
    push dword ptr [ebp + arg_c]                 # 00521121
    call dword ptr [0x52a1f8]                    # 00521124
    {load} mov esi, eax                          # 0052112a
    mov eax, 0x100                               # 0052112c
    {load} cmp esi, eax                          # 00521131
    ja.d8 L_0052115e                             # 00521133
    # block 0x00521135: entered by fall-through of ja at 0x00521133, 7 instruction(s), calls USER32.dll!GetWindowTextA, ends with jne to 0x0052115e (forward)
    push eax                                     # 00521135
    lea eax, [ebp - local_100]                   # 00521136
    push eax                                     # 0052113c
    push dword ptr [ebp + arg_8]                 # 0052113d
    call dword ptr [0x52a408]                    # 00521140
    {load} cmp eax, esi                          # 00521146
    jne.d8 L_0052115e                            # 00521148
    # block 0x0052114a: entered by fall-through of jne at 0x00521148, 6 instruction(s), calls KERNEL32.dll!lstrcmpA, ends with je to 0x0052116a (forward)
    push dword ptr [ebp + arg_c]                 # 0052114a
    lea eax, [ebp - local_100]                   # 0052114d
    push eax                                     # 00521153
    call dword ptr [0x52a1e4]                    # 00521154
    test eax, eax                                # 0052115a
    je.d8 L_0052116a                             # 0052115c
L_0052115e:
    # block 0x0052115e: entered by ja at 0x00521133; jne at 0x00521148; fall-through of je at 0x0052115c, 3 instruction(s), calls USER32.dll!SetWindowTextA, falls into the block at 0x0052116a
    push dword ptr [ebp + arg_c]                 # 0052115e
    push dword ptr [ebp + arg_8]                 # 00521161
    call dword ptr [0x52a328]                    # 00521164
L_0052116a:
    # block 0x0052116a: entered by je at 0x0052115c, 3 instruction(s), ends with ret 0x8
    pop esi                                      # 0052116a
    leave                                        # 0052116b
    ret 0x8                                      # 0052116c

