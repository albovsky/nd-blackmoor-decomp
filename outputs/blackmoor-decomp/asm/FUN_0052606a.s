# FUN_0052606a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052606a
# extent:       0x0052606a-0x0052608b (33 code bytes)
# span:         0x0052606a-0x0052608b (code 33, tables 0, padding 0)
# sha256:       fc70898fd8bfb452c2284a05a372119f0f98def9138f625c68c69447c093f27c
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052606a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls KERNEL32.dll!LeaveCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x0052608b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0052606a - 0x401000
.globl FUN_0052606a
FUN_0052606a:
    # block 0x0052606a: entry, 2 instruction(s), ends with jne to 0x00526088 (forward)
    cmp dword ptr [0x63c9e0], 0x0                # 0052606a
    jne.d8 L_00526088                            # 00526071
    # block 0x00526073: entered by fall-through of jne at 0x00526071, 5 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, falls into the block at 0x00526088
    mov eax, dword ptr [esp + stk_4]             # 00526073
    lea eax, [eax + 2*eax]                       # 00526077
    lea eax, [8*eax + 0x63c848]                  # 0052607a
    push eax                                     # 00526081
    call dword ptr [0x52a0c8]                    # 00526082
L_00526088:
    # block 0x00526088: entered by jne at 0x00526071, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 00526088

