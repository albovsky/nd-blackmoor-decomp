# FUN_0051d001
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d001
# extent:       0x0051d001-0x0051d042 (65 code bytes)
# span:         0x0051d001-0x0051d042 (code 65, tables 0, padding 0)
# sha256:       697874329c59662144854e44b9d87b94c84ca09914cd49e83df2865448c0a808
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d001
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [esi + n] field_14, field_24; [esp + n] stk_8, stk_14
# callees:      calls FUN_00525371, FUN_0051b720; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_0051b720, .text + (0x0051b720 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051d001 - 0x401000
.globl FUN_0051d001
FUN_0051d001:
    # block 0x0051d001: entry, 15 instruction(s), calls FUN_00525371, indirect edi, ends with jne to 0x0051d037 (forward)
    mov eax, dword ptr [esp + stk_8]             # 0051d001
    push esi                                     # 0051d005
    mov esi, dword ptr [esp + stk_8]             # 0051d006
    push edi                                     # 0051d00a
    mov dword ptr [esi + field_24], eax          # 0051d00b
    call FUN_00525371                            # 0051d00e
    movzx ecx, word ptr [esp + stk_14]           # 0051d013
    mov eax, dword ptr [eax + field_c]           # 0051d018
    mov edi, dword ptr [0x52a4a0]                # 0051d01b
    push ecx                                     # 0051d021
    push eax                                     # 0051d022
    call edi                                     # 0051d023
    test eax, eax                                # 0051d025
    mov dword ptr [esi + field_14], eax          # 0051d027
    jne.d8 L_0051d037                            # 0051d02a
    # block 0x0051d02c: entered by fall-through of jne at 0x0051d02a, 4 instruction(s), calls indirect edi, falls into the block at 0x0051d037
    push 0x7f00                                  # 0051d02c
    push eax                                     # 0051d031
    call edi                                     # 0051d032
    mov dword ptr [esi + field_14], eax          # 0051d034
L_0051d037:
    # block 0x0051d037: entered by jne at 0x0051d02a, 5 instruction(s), calls FUN_0051b720, ends with ret 0xc
    push esi                                     # 0051d037
    call FUN_0051b720                            # 0051d038
    pop edi                                      # 0051d03d
    pop esi                                      # 0051d03e
    ret 0xc                                      # 0051d03f

