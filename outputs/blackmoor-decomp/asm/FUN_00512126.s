# FUN_00512126
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512126
# extent:       0x00512126-0x00512155 (47 code bytes)
# span:         0x00512126-0x00512155 (code 47, tables 0, padding 0)
# sha256:       a43f6eb674f00a9d6b91421e28facbfd868b98d122db4b94f45e87e560cbc2b3
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512126
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_00512c79, KERNEL32.dll!LeaveCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x00512126 - 0x401000
.globl FUN_00512126
FUN_00512126:
    # block 0x00512126: entry, 4 instruction(s), ends with jb to 0x0051214a (forward)
    mov eax, dword ptr [esp + stk_4]             # 00512126
    mov ecx, 0x568430                            # 0051212a
    {load} cmp eax, ecx                          # 0051212f
    jb.d8 L_0051214a                             # 00512131
    # block 0x00512133: entered by fall-through of jb at 0x00512131, 2 instruction(s), ends with ja to 0x0051214a (forward)
    cmp eax, 0x568690                            # 00512133
    ja.d8 L_0051214a                             # 00512138
    # block 0x0051213a: entered by fall-through of ja at 0x00512138, 7 instruction(s), calls FUN_00512c79, ends with ret
    {load} sub eax, ecx                          # 0051213a
    sar eax, 0x5                                 # 0051213c
    add eax, 0x1c                                # 0051213f
    push eax                                     # 00512142
    call FUN_00512c79                            # 00512143
    pop ecx                                      # 00512148
    ret                                          # 00512149
L_0051214a:
    # block 0x0051214a: entered by jb at 0x00512131; ja at 0x00512138, 4 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, ends with ret
    add eax, 0x20                                # 0051214a
    push eax                                     # 0051214d
    call dword ptr [0x52a0c8]                    # 0051214e
    ret                                          # 00512154

