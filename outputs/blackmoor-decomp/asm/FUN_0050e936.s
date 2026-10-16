# FUN_0050e936
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e936
# extent:       0x0050e936-0x0050e97e (72 code bytes)
# span:         0x0050e936-0x0050e97e (code 72, tables 0, padding 0)
# sha256:       7122e0d5a40ebec8b94712a0a95861e63bdcbd6fa8075a4487e0d6980ae5cc4c
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e936
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00512c18, FUN_00514f63, FUN_00514f8e, FUN_00512c79, KERNEL32.dll!HeapFree
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00514f63, .text + (0x00514f63 - 0x401000)
.set FUN_00514f8e, .text + (0x00514f8e - 0x401000)

.org 0x0050e936 - 0x401000
.globl FUN_0050e936
FUN_0050e936:
    # block 0x0050e936: entry, 4 instruction(s), ends with je to 0x0050e97c (forward)
    push esi                                     # 0050e936
    mov esi, dword ptr [esp + stk_8]             # 0050e937
    test esi, esi                                # 0050e93b
    je.d8 L_0050e97c                             # 0050e93d
    # block 0x0050e93f: entered by fall-through of je at 0x0050e93d, 8 instruction(s), calls FUN_00512c18, FUN_00514f63, ends with je to 0x0050e965 (forward)
    push 0x9                                     # 0050e93f
    call FUN_00512c18                            # 0050e941
    push esi                                     # 0050e946
    call FUN_00514f63                            # 0050e947
    pop ecx                                      # 0050e94c
    test eax, eax                                # 0050e94d
    pop ecx                                      # 0050e94f
    je.d8 L_0050e965                             # 0050e950
    # block 0x0050e952: entered by fall-through of je at 0x0050e950, 8 instruction(s), calls FUN_00514f8e, FUN_00512c79, ends with ret
    push esi                                     # 0050e952
    push eax                                     # 0050e953
    call FUN_00514f8e                            # 0050e954
    push 0x9                                     # 0050e959
    call FUN_00512c79                            # 0050e95b
    add esp, 0xc                                 # 0050e960
    pop esi                                      # 0050e963
    ret                                          # 0050e964
L_0050e965:
    # block 0x0050e965: entered by je at 0x0050e950, 7 instruction(s), calls FUN_00512c79, KERNEL32.dll!HeapFree, falls into the block at 0x0050e97c
    push 0x9                                     # 0050e965
    call FUN_00512c79                            # 0050e967
    pop ecx                                      # 0050e96c
    push esi                                     # 0050e96d
    push 0x0                                     # 0050e96e
    push dword ptr [0x63cdd8]                    # 0050e970
    call dword ptr [0x52a14c]                    # 0050e976
L_0050e97c:
    # block 0x0050e97c: entered by je at 0x0050e93d, 2 instruction(s), ends with ret
    pop esi                                      # 0050e97c
    ret                                          # 0050e97d

