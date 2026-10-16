# FUN_005166ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005166ab
# extent:       0x005166ab-0x005166d4 (41 code bytes)
# span:         0x005166ab-0x005166d4 (code 41, tables 0, padding 0)
# sha256:       7fb3256d6a32ec3598f16254eb4d3861ed0ab80dde21818301f069ef8824edbc
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005166ab
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x005166ab - 0x401000
.globl FUN_005166ab
FUN_005166ab:
    # block 0x005166ab: entry, 3 instruction(s), ends with jb to 0x005166ba (forward)
    mov eax, dword ptr [esp + stk_4]             # 005166ab
    cmp eax, dword ptr [0x63cee0]                # 005166af
    jb.d8 L_005166ba                             # 005166b5
    # block 0x005166b7: entered by fall-through of jb at 0x005166b5, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 005166b7
    ret                                          # 005166b9
L_005166ba:
    # block 0x005166ba: entered by jb at 0x005166b5, 8 instruction(s), ends with ret
    {load} mov ecx, eax                          # 005166ba
    and eax, 0x1f                                # 005166bc
    sar ecx, 0x5                                 # 005166bf
    lea eax, [eax + 8*eax]                       # 005166c2
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 005166c5
    mov al, byte ptr [ecx + 4*eax + field_4]     # 005166cc
    and eax, 0x40                                # 005166d0
    ret                                          # 005166d3

