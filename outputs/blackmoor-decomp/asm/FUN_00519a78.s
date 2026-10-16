# FUN_00519a78
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519a78
# extent:       0x00519a78-0x00519a96 (30 code bytes)
# span:         0x00519a78-0x00519a96 (code 30, tables 0, padding 0)
# sha256:       f4cd5104388239c67662bd132ba4f619af36fc83784d9a4ce7e3e1a7c8eede33
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519a78
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14; [esp + n] stk_4
# callees:      calls FUN_00525371, FUN_00510122
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00519a96
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00510122, .text + (0x00510122 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00519a78 - 0x401000
.globl FUN_00519a78
FUN_00519a78:
    # block 0x00519a78: entry, 5 instruction(s), calls FUN_00525371, ends with jne to 0x00519a90 (forward)
    call FUN_00525371                            # 00519a78
    mov ecx, dword ptr [esp + stk_4]             # 00519a7d
    test ecx, ecx                                # 00519a81
    mov byte ptr [eax + field_14], cl            # 00519a83
    jne.d8 L_00519a90                            # 00519a86
    # block 0x00519a88: entered by fall-through of jne at 0x00519a86, 3 instruction(s), calls FUN_00510122, falls into the block at 0x00519a90
    push -0x3                                    # 00519a88
    call FUN_00510122                            # 00519a8a
    pop ecx                                      # 00519a8f
L_00519a90:
    # block 0x00519a90: entered by jne at 0x00519a86, 3 instruction(s), ends with ret 0x8
    push 0x1                                     # 00519a90
    pop eax                                      # 00519a92
    ret 0x8                                      # 00519a93

