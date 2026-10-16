# FUN_0051eb0c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051eb0c
# extent:       0x0051eb0c-0x0051eb41 (53 code bytes)
# span:         0x0051eb0c-0x0051eb41 (code 53, tables 0, padding 0)
# sha256:       622aaa56abfaa4e29630ca27d87df7535ca1d28aa06b34d6eab3452fe1811ae9
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051eb0c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_minus_2; [esp + n] stk_8, stk_c, stk_10, stk_18
# callees:      calls KERNEL32.dll!MultiByteToWideChar
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_2, 0x2  # offset -0x2
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x0051eb0c - 0x401000
.globl FUN_0051eb0c
FUN_0051eb0c:
    # block 0x0051eb0c: entry, 4 instruction(s), ends with jne to 0x0051eb20 (forward)
    cmp dword ptr [esp + stk_c], 0x0             # 0051eb0c
    push esi                                     # 0051eb11
    mov esi, dword ptr [esp + stk_8]             # 0051eb12
    jne.d8 L_0051eb20                            # 0051eb16
    # block 0x0051eb18: entered by fall-through of jne at 0x0051eb16, 2 instruction(s), ends with je to 0x0051eb20 (forward)
    test esi, esi                                # 0051eb18
    je.d8 L_0051eb20                             # 0051eb1a
    # block 0x0051eb1c: entered by fall-through of je at 0x0051eb1a, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051eb1c
    pop esi                                      # 0051eb1e
    ret                                          # 0051eb1f
L_0051eb20:
    # block 0x0051eb20: entered by jne at 0x0051eb16; je at 0x0051eb1a, 9 instruction(s), calls KERNEL32.dll!MultiByteToWideChar, ends with jle to 0x0051eb3f (forward)
    push dword ptr [esp + stk_10]                # 0051eb20
    push esi                                     # 0051eb24
    push -0x1                                    # 0051eb25
    push dword ptr [esp + stk_18]                # 0051eb27
    push 0x0                                     # 0051eb2b
    push 0x0                                     # 0051eb2d
    call dword ptr [0x52a1f0]                    # 0051eb2f
    test eax, eax                                # 0051eb35
    jle.d8 L_0051eb3f                            # 0051eb37
    # block 0x0051eb39: entered by fall-through of jle at 0x0051eb37, 1 instruction(s), falls into the block at 0x0051eb3f
    and word ptr [esi + 2*eax - field_minus_2], 0x0 # 0051eb39
L_0051eb3f:
    # block 0x0051eb3f: entered by jle at 0x0051eb37, 2 instruction(s), ends with ret
    pop esi                                      # 0051eb3f
    ret                                          # 0051eb40

