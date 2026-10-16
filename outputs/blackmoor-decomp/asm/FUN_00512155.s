# FUN_00512155
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512155
# extent:       0x00512155-0x00512178 (35 code bytes)
# span:         0x00512155-0x00512178 (code 35, tables 0, padding 0)
# sha256:       31b217fde48c87db45c047b211c7be674e574a200799894067ddabe1122192ae
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512155
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      calls FUN_00512c79, KERNEL32.dll!LeaveCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x00512155 - 0x401000
.globl FUN_00512155
FUN_00512155:
    # block 0x00512155: entry, 3 instruction(s), ends with jge to 0x00512169 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00512155
    cmp eax, 0x14                                # 00512159
    jge.d8 L_00512169                            # 0051215c
    # block 0x0051215e: entered by fall-through of jge at 0x0051215c, 5 instruction(s), calls FUN_00512c79, ends with ret
    add eax, 0x1c                                # 0051215e
    push eax                                     # 00512161
    call FUN_00512c79                            # 00512162
    pop ecx                                      # 00512167
    ret                                          # 00512168
L_00512169:
    # block 0x00512169: entered by jge at 0x0051215c, 5 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, ends with ret
    mov eax, dword ptr [esp + stk_8]             # 00512169
    add eax, 0x20                                # 0051216d
    push eax                                     # 00512170
    call dword ptr [0x52a0c8]                    # 00512171
    ret                                          # 00512177

