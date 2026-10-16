# FUN_005254d8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005254d8
# extent:       0x005254d8-0x005254fe (38 code bytes)
# span:         0x005254d8-0x005254fe (code 38, tables 0, padding 0)
# sha256:       490495f861b14d335030120bad47a950554bbffc34b27e5b3b343d505904c229
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525485 (+0x53)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005254d8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c575, FUN_00520a2c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c575, .text + (0x0050c575 - 0x401000)
.set FUN_00520a2c, .text + (0x00520a2c - 0x401000)

.org 0x005254d8 - 0x401000
.globl FUN_005254d8
FUN_005254d8:
    # block 0x005254d8: entry, 6 instruction(s), calls FUN_0050c575, ends with je to 0x005254fa (forward)
    push esi                                     # 005254d8
    mov ecx, 0x63c5a8                            # 005254d9
    call FUN_0050c575                            # 005254de
    {load} mov esi, eax                          # 005254e3
    test esi, esi                                # 005254e5
    je.d8 L_005254fa                             # 005254e7
    # block 0x005254e9: entered by fall-through of je at 0x005254e7, 6 instruction(s), calls FUN_00520a2c, ends with ret
    {load} mov ecx, esi                          # 005254e9
    call FUN_00520a2c                            # 005254eb
    mov dword ptr [esi], 0x52fd08                # 005254f0
    {load} mov eax, esi                          # 005254f6
    pop esi                                      # 005254f8
    ret                                          # 005254f9
L_005254fa:
    # block 0x005254fa: entered by je at 0x005254e7, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 005254fa
    pop esi                                      # 005254fc
    ret                                          # 005254fd

