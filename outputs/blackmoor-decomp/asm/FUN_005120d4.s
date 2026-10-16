# FUN_005120d4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005120d4
# extent:       0x005120d4-0x00512103 (47 code bytes)
# span:         0x005120d4-0x00512103 (code 47, tables 0, padding 0)
# sha256:       55b15da7db99d7ae0751cb4f83d5687554479ff897304deb30ec9b03f1b39a56
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005120d4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_00512c18, KERNEL32.dll!EnterCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)

.org 0x005120d4 - 0x401000
.globl FUN_005120d4
FUN_005120d4:
    # block 0x005120d4: entry, 4 instruction(s), ends with jb to 0x005120f8 (forward)
    mov eax, dword ptr [esp + stk_4]             # 005120d4
    mov ecx, 0x568430                            # 005120d8
    {load} cmp eax, ecx                          # 005120dd
    jb.d8 L_005120f8                             # 005120df
    # block 0x005120e1: entered by fall-through of jb at 0x005120df, 2 instruction(s), ends with ja to 0x005120f8 (forward)
    cmp eax, 0x568690                            # 005120e1
    ja.d8 L_005120f8                             # 005120e6
    # block 0x005120e8: entered by fall-through of ja at 0x005120e6, 7 instruction(s), calls FUN_00512c18, ends with ret
    {load} sub eax, ecx                          # 005120e8
    sar eax, 0x5                                 # 005120ea
    add eax, 0x1c                                # 005120ed
    push eax                                     # 005120f0
    call FUN_00512c18                            # 005120f1
    pop ecx                                      # 005120f6
    ret                                          # 005120f7
L_005120f8:
    # block 0x005120f8: entered by jb at 0x005120df; ja at 0x005120e6, 4 instruction(s), calls KERNEL32.dll!EnterCriticalSection, ends with ret
    add eax, 0x20                                # 005120f8
    push eax                                     # 005120fb
    call dword ptr [0x52a0d0]                    # 005120fc
    ret                                          # 00512102

