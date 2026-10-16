# FUN_00511a81
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511a81
# extent:       0x00511a81-0x00511adb (90 code bytes)
# span:         0x00511a81-0x00511adb (code 90, tables 0, padding 0)
# sha256:       94e8b800a3c48f8b6694659a75b6034fa04ec154961e293c1ee64aa26e9e8c7d
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511a81
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00512ee4, FUN_005118b3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00511adb
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005118b3, .text + (0x005118b3 - 0x401000)
.set FUN_00512ee4, .text + (0x00512ee4 - 0x401000)

.org 0x00511a81 - 0x401000
.globl FUN_00511a81
FUN_00511a81:
    # block 0x00511a81: entry, 8 instruction(s), calls FUN_00512ee4, ends with je to 0x00511ac1 (forward)
    push esi                                     # 00511a81
    mov esi, dword ptr [esp + stk_8]             # 00511a82
    movsx eax, byte ptr [esi]                    # 00511a86
    push eax                                     # 00511a89
    call FUN_00512ee4                            # 00511a8a
    cmp eax, 0x65                                # 00511a8f
    pop ecx                                      # 00511a92
    je.d8 L_00511ac1                             # 00511a93
L_00511a95:
    # block 0x00511a95: entered by jne at 0x00511abf; fall-through of je at 0x00511a93, 3 instruction(s), ends with jle to 0x00511aae (forward)
    inc esi                                      # 00511a95
    cmp dword ptr [0x56840c], 0x1                # 00511a96
    jle.d8 L_00511aae                            # 00511a9d
    # block 0x00511a9f: entered by fall-through of jle at 0x00511a9d, 7 instruction(s), calls FUN_005118b3, ends with forward jump to 0x00511abd
    movsx eax, byte ptr [esi]                    # 00511a9f
    push 0x4                                     # 00511aa2
    push eax                                     # 00511aa4
    call FUN_005118b3                            # 00511aa5
    pop ecx                                      # 00511aaa
    pop ecx                                      # 00511aab
    jmp.d8 L_00511abd                            # 00511aac
L_00511aae:
    # block 0x00511aae: entered by jle at 0x00511a9d, 4 instruction(s), falls into the block at 0x00511abd
    movsx eax, byte ptr [esi]                    # 00511aae
    mov ecx, dword ptr [0x568200]                # 00511ab1
    mov al, byte ptr [ecx + 2*eax]               # 00511ab7
    and eax, 0x4                                 # 00511aba
L_00511abd:
    # block 0x00511abd: entered by jmp at 0x00511aac, 2 instruction(s), ends with jne to 0x00511a95 (backward)
    test eax, eax                                # 00511abd
    jne.d8 L_00511a95                            # 00511abf
L_00511ac1:
    # block 0x00511ac1: entered by je at 0x00511a93; fall-through of jne at 0x00511abf, 4 instruction(s), falls into the block at 0x00511acc
    mov cl, byte ptr [0x568410]                  # 00511ac1
    mov al, byte ptr [esi]                       # 00511ac7
    mov byte ptr [esi], cl                       # 00511ac9
    inc esi                                      # 00511acb
L_00511acc:
    # block 0x00511acc: entered by jne at 0x00511ad7, 7 instruction(s), ends with jne to 0x00511acc (backward)
    mov cl, byte ptr [esi]                       # 00511acc
    mov byte ptr [esi], al                       # 00511ace
    {load} mov al, cl                            # 00511ad0
    mov cl, byte ptr [esi]                       # 00511ad2
    inc esi                                      # 00511ad4
    test cl, cl                                  # 00511ad5
    jne.d8 L_00511acc                            # 00511ad7
    # block 0x00511ad9: entered by fall-through of jne at 0x00511ad7, 2 instruction(s), ends with ret
    pop esi                                      # 00511ad9
    ret                                          # 00511ada

