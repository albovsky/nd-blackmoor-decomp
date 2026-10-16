# FUN_005132c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005132c9
# extent:       0x005132c9-0x0051332e (101 code bytes)
# span:         0x005132c9-0x0051332e (code 101, tables 0, padding 0)
# sha256:       f5083076db35f6343e351bf95f513dedce53dd0615c98a950253ce2189252afa
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005132c9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_8, stk_18
# callees:      calls FUN_0051771b, FUN_0051332e, FUN_0051777a, FUN_0050ea7e, FUN_0050ea87
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
.set FUN_0051332e, .text + (0x0051332e - 0x401000)
.set FUN_0051771b, .text + (0x0051771b - 0x401000)
.set FUN_0051777a, .text + (0x0051777a - 0x401000)

.org 0x005132c9 - 0x401000
.globl FUN_005132c9
FUN_005132c9:
    # block 0x005132c9: entry, 4 instruction(s), ends with jae to 0x00513316 (forward)
    push esi                                     # 005132c9
    mov esi, dword ptr [esp + stk_8]             # 005132ca
    cmp esi, dword ptr [0x63cee0]                # 005132ce
    jae.d8 L_00513316                            # 005132d4
    # block 0x005132d6: entered by fall-through of jae at 0x005132d4, 8 instruction(s), ends with je to 0x00513316 (forward)
    {load} mov ecx, esi                          # 005132d6
    {load} mov eax, esi                          # 005132d8
    sar ecx, 0x5                                 # 005132da
    and eax, 0x1f                                # 005132dd
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 005132e0
    lea eax, [eax + 8*eax]                       # 005132e7
    test byte ptr [ecx + 4*eax + field_4], 0x1   # 005132ea
    je.d8 L_00513316                             # 005132ef
    # block 0x005132f1: entered by fall-through of je at 0x005132ef, 15 instruction(s), calls FUN_0051771b, FUN_0051332e, FUN_0051777a, ends with ret
    push edi                                     # 005132f1
    push esi                                     # 005132f2
    call FUN_0051771b                            # 005132f3
    push dword ptr [esp + stk_18]                # 005132f8
    push dword ptr [esp + stk_18]                # 005132fc
    push esi                                     # 00513300
    call FUN_0051332e                            # 00513301
    push esi                                     # 00513306
    {load} mov edi, eax                          # 00513307
    call FUN_0051777a                            # 00513309
    add esp, 0x14                                # 0051330e
    {load} mov eax, edi                          # 00513311
    pop edi                                      # 00513313
    pop esi                                      # 00513314
    ret                                          # 00513315
L_00513316:
    # block 0x00513316: entered by jae at 0x005132d4; je at 0x005132ef, 7 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with ret
    call FUN_0050ea7e                            # 00513316
    mov dword ptr [eax], 0x9                     # 0051331b
    call FUN_0050ea87                            # 00513321
    and dword ptr [eax], 0x0                     # 00513326
    or eax, -0x1                                 # 00513329
    pop esi                                      # 0051332c
    ret                                          # 0051332d

