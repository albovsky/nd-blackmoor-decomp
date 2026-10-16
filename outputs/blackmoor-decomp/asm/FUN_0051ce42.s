# FUN_0051ce42
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ce42
# extent:       0x0051ce42-0x0051ce72 (48 code bytes)
# span:         0x0051ce42-0x0051ce72 (code 48, tables 0, padding 0)
# sha256:       bd8c113617cd3b88021d994c4dfffc7b6c9fb01f74eea5abebc0159b2445f104
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ce42
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_4; [esp + n] stk_4
# callees:      calls FUN_0051d4f3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051d4f3, .text + (0x0051d4f3 - 0x401000)

.org 0x0051ce42 - 0x401000
.globl FUN_0051ce42
FUN_0051ce42:
    # block 0x0051ce42: entry, 4 instruction(s), ends with jb to 0x0051ce57 (forward)
    mov edx, dword ptr [esp + stk_4]             # 0051ce42
    mov eax, dword ptr [edx + field_4]           # 0051ce46
    cmp eax, 0x100                               # 0051ce49
    jb.d8 L_0051ce57                             # 0051ce4e
    # block 0x0051ce50: entered by fall-through of jb at 0x0051ce4e, 2 instruction(s), ends with jbe to 0x0051ce65 (forward)
    cmp eax, 0x108                               # 0051ce50
    jbe.d8 L_0051ce65                            # 0051ce55
L_0051ce57:
    # block 0x0051ce57: entered by jb at 0x0051ce4e; fall-through of jbe at 0x0051ce55, 2 instruction(s), ends with jb to 0x0051ce6d (forward)
    cmp eax, 0x200                               # 0051ce57
    jb.d8 L_0051ce6d                             # 0051ce5c
    # block 0x0051ce5e: entered by fall-through of jb at 0x0051ce5c, 2 instruction(s), ends with ja to 0x0051ce6d (forward)
    cmp eax, 0x209                               # 0051ce5e
    ja.d8 L_0051ce6d                             # 0051ce63
L_0051ce65:
    # block 0x0051ce65: entered by jbe at 0x0051ce55; fall-through of ja at 0x0051ce63, 3 instruction(s), calls FUN_0051d4f3, ends with forward jump to 0x0051ce6f
    push edx                                     # 0051ce65
    call FUN_0051d4f3                            # 0051ce66
    jmp.d8 L_0051ce6f                            # 0051ce6b
L_0051ce6d:
    # block 0x0051ce6d: entered by jb at 0x0051ce5c; ja at 0x0051ce63, 1 instruction(s), falls into the block at 0x0051ce6f
    {load} xor eax, eax                          # 0051ce6d
L_0051ce6f:
    # block 0x0051ce6f: entered by jmp at 0x0051ce6b, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051ce6f

