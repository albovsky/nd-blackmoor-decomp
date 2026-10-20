# FUN_00510d20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510d20
# extent:       0x00510d20-0x00510d6c (76 code bytes)
# span:         0x00510d20-0x00510d6c (code 76, tables 0, padding 0)
# sha256:       1403e85abeaef316ca19f39adef3cb4b62b241a750964376387fb8d858fa486f
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __CallSettingFrame@12
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca1d; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050ca1d, .text + (0x0050ca1d - 0x401000)

.org 0x00510d20 - 0x401000
.globl FUN_00510d20
FUN_00510d20:
    # block 0x00510d20: entry, 26 instruction(s), calls FUN_0050ca1d, indirect eax, ends with jne to 0x00510d5f (forward)
    push ebp                                     # 00510d20
    {load} mov ebp, esp                          # 00510d21
    sub esp, 0x4                                 # 00510d23
    push ebx                                     # 00510d26
    push ecx                                     # 00510d27
    mov eax, dword ptr [ebp + arg_c]             # 00510d28
    add eax, 0xc                                 # 00510d2b
    mov dword ptr [ebp - local_4], eax           # 00510d2e
    mov eax, dword ptr [ebp + arg_8]             # 00510d31
    push ebp                                     # 00510d34
    push dword ptr [ebp + arg_10]                # 00510d35
    mov ecx, dword ptr [ebp + arg_10]            # 00510d38
    mov ebp, dword ptr [ebp - local_4]           # 00510d3b
    call FUN_0050ca1d                            # 00510d3e
    push esi                                     # 00510d43
    push edi                                     # 00510d44
    call eax                                     # 00510d45
    pop edi                                      # 00510d47
    pop esi                                      # 00510d48
    {load} mov ebx, ebp                          # 00510d49
    pop ebp                                      # 00510d4b
    mov ecx, dword ptr [ebp + arg_10]            # 00510d4c
    push ebp                                     # 00510d4f
    {load} mov ebp, ebx                          # 00510d50
    cmp ecx, 0x100                               # 00510d52
    jne.d8 L_00510d5f                            # 00510d58
    # block 0x00510d5a: entered by fall-through of jne at 0x00510d58, 1 instruction(s), falls into the block at 0x00510d5f
    mov ecx, 0x2                                 # 00510d5a
L_00510d5f:
    # block 0x00510d5f: entered by jne at 0x00510d58, 7 instruction(s), calls FUN_0050ca1d, ends with ret 0xc
    push ecx                                     # 00510d5f
    call FUN_0050ca1d                            # 00510d60
    pop ebp                                      # 00510d65
    pop ecx                                      # 00510d66
    pop ebx                                      # 00510d67
    leave                                        # 00510d68
    ret 0xc                                      # 00510d69

