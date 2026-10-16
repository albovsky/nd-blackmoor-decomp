# FUN_00514f25
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514f25
# extent:       0x00514f25-0x00514f63 (62 code bytes)
# span:         0x00514f25-0x00514f63 (code 62, tables 0, padding 0)
# sha256:       11ec6359c6a0d08a1d4b1d9e2d7ad28aba0c9acf3ab840e4dd848bd04930911d
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514f25
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!HeapAlloc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00514f25 - 0x401000
.globl FUN_00514f25
FUN_00514f25:
    # block 0x00514f25: entry, 7 instruction(s), calls KERNEL32.dll!HeapAlloc, ends with jne to 0x00514f42 (forward)
    push 0x140                                   # 00514f25
    push 0x0                                     # 00514f2a
    push dword ptr [0x63cdd8]                    # 00514f2c
    call dword ptr [0x52a150]                    # 00514f32
    test eax, eax                                # 00514f38
    mov dword ptr [0x63cdd4], eax                # 00514f3a
    jne.d8 L_00514f42                            # 00514f3f
    # block 0x00514f41: entered by fall-through of jne at 0x00514f3f, 1 instruction(s), ends with ret
    ret                                          # 00514f41
L_00514f42:
    # block 0x00514f42: entered by jne at 0x00514f3f, 7 instruction(s), ends with ret
    and dword ptr [0x63cdcc], 0x0                # 00514f42
    and dword ptr [0x63cdd0], 0x0                # 00514f49
    push 0x1                                     # 00514f50
    mov dword ptr [0x63cdc8], eax                # 00514f52
    mov dword ptr [0x63cdc0], 0x10               # 00514f57
    pop eax                                      # 00514f61
    ret                                          # 00514f62

