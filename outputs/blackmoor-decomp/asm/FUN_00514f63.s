# FUN_00514f63
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514f63
# extent:       0x00514f63-0x00514f8e (43 code bytes)
# span:         0x00514f63-0x00514f8e (code 43, tables 0, padding 0)
# sha256:       fb5c4e0fc1f8337007e65e211edd59111f76794a0c15c40014fc7c55711e7cbe
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514f63
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00514f63 - 0x401000
.globl FUN_00514f63
FUN_00514f63:
    # block 0x00514f63: entry, 4 instruction(s), falls into the block at 0x00514f73
    mov eax, dword ptr [0x63cdd0]                # 00514f63
    lea ecx, [eax + 4*eax]                       # 00514f68
    mov eax, dword ptr [0x63cdd4]                # 00514f6b
    lea ecx, [eax + 4*ecx]                       # 00514f70
L_00514f73:
    # block 0x00514f73: entered by jmp at 0x00514f89, 2 instruction(s), ends with jae to 0x00514f8b (forward)
    {load} cmp eax, ecx                          # 00514f73
    jae.d8 L_00514f8b                            # 00514f75
    # block 0x00514f77: entered by fall-through of jae at 0x00514f75, 4 instruction(s), ends with jb to 0x00514f8d (forward)
    mov edx, dword ptr [esp + stk_4]             # 00514f77
    sub edx, dword ptr [eax + field_c]           # 00514f7b
    cmp edx, 0x100000                            # 00514f7e
    jb.d8 L_00514f8d                             # 00514f84
    # block 0x00514f86: entered by fall-through of jb at 0x00514f84, 2 instruction(s), ends with backward jump to 0x00514f73
    add eax, 0x14                                # 00514f86
    jmp.d8 L_00514f73                            # 00514f89
L_00514f8b:
    # block 0x00514f8b: entered by jae at 0x00514f75, 1 instruction(s), falls into the block at 0x00514f8d
    {load} xor eax, eax                          # 00514f8b
L_00514f8d:
    # block 0x00514f8d: entered by jb at 0x00514f84, 1 instruction(s), ends with ret
    ret                                          # 00514f8d

