# FUN_005144ef
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005144ef
# extent:       0x005144ef-0x00514517 (40 code bytes)
# span:         0x005144ef-0x00514517 (code 40, tables 0, padding 0)
# sha256:       2344d29ba87c9fc101dc8b4832ad673b964a7d7d7be1e7efdedc2e5031d7c01c
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005144ef
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050ea7e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)

.org 0x005144ef - 0x401000
.globl FUN_005144ef
FUN_005144ef:
    # block 0x005144ef: entry, 3 instruction(s), ends with je to 0x0051450b (forward)
    mov eax, dword ptr [esp + stk_4]             # 005144ef
    cmp eax, 0x1                                 # 005144f3
    je.d8 L_0051450b                             # 005144f6
    # block 0x005144f8: entered by fall-through of je at 0x005144f6, 1 instruction(s), ends with jle to 0x00514516 (forward)
    jle.d8 L_00514516                            # 005144f8
    # block 0x005144fa: entered by fall-through of jle at 0x005144f8, 2 instruction(s), ends with jg to 0x00514516 (forward)
    cmp eax, 0x3                                 # 005144fa
    jg.d8 L_00514516                             # 005144fd
    # block 0x005144ff: entered by fall-through of jg at 0x005144fd, 3 instruction(s), calls FUN_0050ea7e, ends with ret
    call FUN_0050ea7e                            # 005144ff
    mov dword ptr [eax], 0x22                    # 00514504
    ret                                          # 0051450a
L_0051450b:
    # block 0x0051450b: entered by je at 0x005144f6, 2 instruction(s), calls FUN_0050ea7e, falls into the block at 0x00514516
    call FUN_0050ea7e                            # 0051450b
    mov dword ptr [eax], 0x21                    # 00514510
L_00514516:
    # block 0x00514516: entered by jle at 0x005144f8; jg at 0x005144fd, 1 instruction(s), ends with ret
    ret                                          # 00514516

