# FUN_00512437
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512437
# extent:       0x00512437-0x0051249c (101 code bytes)
# span:         0x00512437-0x0051249c (code 101, tables 0, padding 0)
# sha256:       46b6472c0b92e6a9b15da75a817f69d9a615e3473c0b994b3cc1e67f9bce2ef0
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512437
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_8, stk_18
# callees:      calls FUN_0051771b, FUN_0051249c, FUN_0051777a, FUN_0050ea7e, FUN_0050ea87
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)
.set FUN_0051249c, .text + (0x0051249c - 0x401000)
.set FUN_0051771b, .text + (0x0051771b - 0x401000)
.set FUN_0051777a, .text + (0x0051777a - 0x401000)

.org 0x00512437 - 0x401000
.globl FUN_00512437
FUN_00512437:
    # block 0x00512437: entry, 4 instruction(s), ends with jae to 0x00512484 (forward)
    push esi                                     # 00512437
    mov esi, dword ptr [esp + stk_8]             # 00512438
    cmp esi, dword ptr [0x63cee0]                # 0051243c
    jae.d8 L_00512484                            # 00512442
    # block 0x00512444: entered by fall-through of jae at 0x00512442, 8 instruction(s), ends with je to 0x00512484 (forward)
    {load} mov ecx, esi                          # 00512444
    {load} mov eax, esi                          # 00512446
    sar ecx, 0x5                                 # 00512448
    and eax, 0x1f                                # 0051244b
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 0051244e
    lea eax, [eax + 8*eax]                       # 00512455
    test byte ptr [ecx + 4*eax + field_4], 0x1   # 00512458
    je.d8 L_00512484                             # 0051245d
    # block 0x0051245f: entered by fall-through of je at 0x0051245d, 15 instruction(s), calls FUN_0051771b, FUN_0051249c, FUN_0051777a, ends with ret
    push edi                                     # 0051245f
    push esi                                     # 00512460
    call FUN_0051771b                            # 00512461
    push dword ptr [esp + stk_18]                # 00512466
    push dword ptr [esp + stk_18]                # 0051246a
    push esi                                     # 0051246e
    call FUN_0051249c                            # 0051246f
    push esi                                     # 00512474
    {load} mov edi, eax                          # 00512475
    call FUN_0051777a                            # 00512477
    add esp, 0x14                                # 0051247c
    {load} mov eax, edi                          # 0051247f
    pop edi                                      # 00512481
    pop esi                                      # 00512482
    ret                                          # 00512483
L_00512484:
    # block 0x00512484: entered by jae at 0x00512442; je at 0x0051245d, 7 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with ret
    call FUN_0050ea7e                            # 00512484
    mov dword ptr [eax], 0x9                     # 00512489
    call FUN_0050ea87                            # 0051248f
    and dword ptr [eax], 0x0                     # 00512494
    or eax, -0x1                                 # 00512497
    pop esi                                      # 0051249a
    ret                                          # 0051249b

