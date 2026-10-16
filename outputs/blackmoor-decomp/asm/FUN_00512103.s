# FUN_00512103
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512103
# extent:       0x00512103-0x00512126 (35 code bytes)
# span:         0x00512103-0x00512126 (code 35, tables 0, padding 0)
# sha256:       bfdd6f427db41ab2c7b832e6842b5649bd39ffa0012c95d2c2eabfbef35d914c
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512103
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      calls FUN_00512c18, KERNEL32.dll!EnterCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)

.org 0x00512103 - 0x401000
.globl FUN_00512103
FUN_00512103:
    # block 0x00512103: entry, 3 instruction(s), ends with jge to 0x00512117 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00512103
    cmp eax, 0x14                                # 00512107
    jge.d8 L_00512117                            # 0051210a
    # block 0x0051210c: entered by fall-through of jge at 0x0051210a, 5 instruction(s), calls FUN_00512c18, ends with ret
    add eax, 0x1c                                # 0051210c
    push eax                                     # 0051210f
    call FUN_00512c18                            # 00512110
    pop ecx                                      # 00512115
    ret                                          # 00512116
L_00512117:
    # block 0x00512117: entered by jge at 0x0051210a, 5 instruction(s), calls KERNEL32.dll!EnterCriticalSection, ends with ret
    mov eax, dword ptr [esp + stk_8]             # 00512117
    add eax, 0x20                                # 0051211b
    push eax                                     # 0051211e
    call dword ptr [0x52a0d0]                    # 0051211f
    ret                                          # 00512125

