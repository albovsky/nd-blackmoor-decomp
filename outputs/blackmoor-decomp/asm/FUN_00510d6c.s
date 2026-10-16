# FUN_00510d6c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510d6c
# extent:       0x00510d6c-0x00510dc0 (84 code bytes)
# span:         0x00510d6c-0x00510dc0 (code 84, tables 0, padding 0)
# sha256:       2f193207d8e77f67bc584f958e92acb63bb4aa3ad73a9b1bd0ae8f40bcd606f4
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510d6c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4
# callees:      calls FUN_00512bef, KERNEL32.dll!TlsAlloc, FUN_0050e97e, KERNEL32.dll!TlsSetValue, FUN_00510dc0, KERNEL32.dll!GetCurrentThreadId
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)
.set FUN_00510dc0, .text + (0x00510dc0 - 0x401000)
.set FUN_00512bef, .text + (0x00512bef - 0x401000)

.org 0x00510d6c - 0x401000
.globl FUN_00510d6c
FUN_00510d6c:
    # block 0x00510d6c: entry, 6 instruction(s), calls FUN_00512bef, KERNEL32.dll!TlsAlloc, ends with je to 0x00510dbc (forward)
    push esi                                     # 00510d6c
    call FUN_00512bef                            # 00510d6d
    call dword ptr [0x52a0b8]                    # 00510d72
    cmp eax, -0x1                                # 00510d78
    mov dword ptr [0x5681f0], eax                # 00510d7b
    je.d8 L_00510dbc                             # 00510d80
    # block 0x00510d82: entered by fall-through of je at 0x00510d80, 8 instruction(s), calls FUN_0050e97e, ends with je to 0x00510dbc (forward)
    push 0x74                                    # 00510d82
    push 0x1                                     # 00510d84
    call FUN_0050e97e                            # 00510d86
    {load} mov esi, eax                          # 00510d8b
    pop ecx                                      # 00510d8d
    test esi, esi                                # 00510d8e
    pop ecx                                      # 00510d90
    je.d8 L_00510dbc                             # 00510d91
    # block 0x00510d93: entered by fall-through of je at 0x00510d91, 5 instruction(s), calls KERNEL32.dll!TlsSetValue, ends with je to 0x00510dbc (forward)
    push esi                                     # 00510d93
    push dword ptr [0x5681f0]                    # 00510d94
    call dword ptr [0x52a0d4]                    # 00510d9a
    test eax, eax                                # 00510da0
    je.d8 L_00510dbc                             # 00510da2
    # block 0x00510da4: entered by fall-through of je at 0x00510da2, 10 instruction(s), calls FUN_00510dc0, KERNEL32.dll!GetCurrentThreadId, ends with ret
    push esi                                     # 00510da4
    call FUN_00510dc0                            # 00510da5
    pop ecx                                      # 00510daa
    call dword ptr [0x52a2a0]                    # 00510dab
    or dword ptr [esi + field_4], -0x1           # 00510db1
    push 0x1                                     # 00510db5
    mov dword ptr [esi], eax                     # 00510db7
    pop eax                                      # 00510db9
    pop esi                                      # 00510dba
    ret                                          # 00510dbb
L_00510dbc:
    # block 0x00510dbc: entered by je at 0x00510d80; je at 0x00510d91; je at 0x00510da2, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 00510dbc
    pop esi                                      # 00510dbe
    ret                                          # 00510dbf

