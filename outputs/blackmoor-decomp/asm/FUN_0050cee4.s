# FUN_0050cee4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cee4
# extent:       0x0050cee4-0x0050cf15 (49 code bytes)
# span:         0x0050cee4-0x0050cf15 (code 49, tables 0, padding 0)
# sha256:       74b05488da3454a55ad584855019c17f66a638720786e4de8e6bfb76eee07fa5
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cee4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_c; [esp + n] stk_8
# callees:      calls FUN_005120d4, FUN_0050cf15, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050cf15, .text + (0x0050cf15 - 0x401000)
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)

.org 0x0050cee4 - 0x401000
.globl FUN_0050cee4
FUN_0050cee4:
    # block 0x0050cee4: entry, 6 instruction(s), ends with je to 0x0050cef9 (forward)
    push esi                                     # 0050cee4
    mov esi, dword ptr [esp + stk_8]             # 0050cee5
    push edi                                     # 0050cee9
    or edi, -0x1                                 # 0050ceea
    test byte ptr [esi + field_c], 0x40          # 0050ceed
    je.d8 L_0050cef9                             # 0050cef1
    # block 0x0050cef3: entered by fall-through of je at 0x0050cef1, 2 instruction(s), ends with forward jump to 0x0050cf10
    and dword ptr [esi + field_c], 0x0           # 0050cef3
    jmp.d8 L_0050cf10                            # 0050cef7
L_0050cef9:
    # block 0x0050cef9: entered by je at 0x0050cef1, 8 instruction(s), calls FUN_005120d4, FUN_0050cf15, FUN_00512126, falls into the block at 0x0050cf10
    push esi                                     # 0050cef9
    call FUN_005120d4                            # 0050cefa
    push esi                                     # 0050ceff
    call FUN_0050cf15                            # 0050cf00
    push esi                                     # 0050cf05
    {load} mov edi, eax                          # 0050cf06
    call FUN_00512126                            # 0050cf08
    add esp, 0xc                                 # 0050cf0d
L_0050cf10:
    # block 0x0050cf10: entered by jmp at 0x0050cef7, 4 instruction(s), ends with ret
    {load} mov eax, edi                          # 0050cf10
    pop edi                                      # 0050cf12
    pop esi                                      # 0050cf13
    ret                                          # 0050cf14

