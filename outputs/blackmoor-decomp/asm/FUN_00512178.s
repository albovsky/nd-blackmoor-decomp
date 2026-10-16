# FUN_00512178
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512178
# extent:       0x00512178-0x005121dd (101 code bytes)
# span:         0x00512178-0x005121dd (code 101, tables 0, padding 0)
# sha256:       82b3507a3e6b803ba31c2bfbb7fd38ba499395cce56c70642a5b67a3fe2b7adb
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512178
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_8, stk_18
# callees:      calls FUN_0051771b, FUN_005121dd, FUN_0051777a, FUN_0050ea7e, FUN_0050ea87
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
.set FUN_005121dd, .text + (0x005121dd - 0x401000)
.set FUN_0051771b, .text + (0x0051771b - 0x401000)
.set FUN_0051777a, .text + (0x0051777a - 0x401000)

.org 0x00512178 - 0x401000
.globl FUN_00512178
FUN_00512178:
    # block 0x00512178: entry, 4 instruction(s), ends with jae to 0x005121c5 (forward)
    push esi                                     # 00512178
    mov esi, dword ptr [esp + stk_8]             # 00512179
    cmp esi, dword ptr [0x63cee0]                # 0051217d
    jae.d8 L_005121c5                            # 00512183
    # block 0x00512185: entered by fall-through of jae at 0x00512183, 8 instruction(s), ends with je to 0x005121c5 (forward)
    {load} mov ecx, esi                          # 00512185
    {load} mov eax, esi                          # 00512187
    sar ecx, 0x5                                 # 00512189
    and eax, 0x1f                                # 0051218c
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 0051218f
    lea eax, [eax + 8*eax]                       # 00512196
    test byte ptr [ecx + 4*eax + field_4], 0x1   # 00512199
    je.d8 L_005121c5                             # 0051219e
    # block 0x005121a0: entered by fall-through of je at 0x0051219e, 15 instruction(s), calls FUN_0051771b, FUN_005121dd, FUN_0051777a, ends with ret
    push edi                                     # 005121a0
    push esi                                     # 005121a1
    call FUN_0051771b                            # 005121a2
    push dword ptr [esp + stk_18]                # 005121a7
    push dword ptr [esp + stk_18]                # 005121ab
    push esi                                     # 005121af
    call FUN_005121dd                            # 005121b0
    push esi                                     # 005121b5
    {load} mov edi, eax                          # 005121b6
    call FUN_0051777a                            # 005121b8
    add esp, 0x14                                # 005121bd
    {load} mov eax, edi                          # 005121c0
    pop edi                                      # 005121c2
    pop esi                                      # 005121c3
    ret                                          # 005121c4
L_005121c5:
    # block 0x005121c5: entered by jae at 0x00512183; je at 0x0051219e, 7 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with ret
    call FUN_0050ea7e                            # 005121c5
    mov dword ptr [eax], 0x9                     # 005121ca
    call FUN_0050ea87                            # 005121d0
    and dword ptr [eax], 0x0                     # 005121d5
    or eax, -0x1                                 # 005121d8
    pop esi                                      # 005121db
    ret                                          # 005121dc

