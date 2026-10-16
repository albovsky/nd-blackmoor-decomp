# FUN_0051b1eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b1eb
# extent:       0x0051b1eb-0x0051b20b (32 code bytes)
# span:         0x0051b1eb-0x0051b20b (code 32, tables 0, padding 0)
# sha256:       d214f6e1aa578df0098974c6298911b4b3f50db5d15c2538d47a28ee836664ae
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b1eb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_28; [esp + n] stk_8
# callees:      calls FUN_0051d0b9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_0051d0b9, .text + (0x0051d0b9 - 0x401000)

.org 0x0051b1eb - 0x401000
.globl FUN_0051b1eb
FUN_0051b1eb:
    # block 0x0051b1eb: entry, 4 instruction(s), ends with jne to 0x0051b204 (forward)
    push esi                                     # 0051b1eb
    mov esi, dword ptr [esp + stk_8]             # 0051b1ec
    cmp dword ptr [esi + field_28], 0x0          # 0051b1f0
    jne.d8 L_0051b204                            # 0051b1f4
    # block 0x0051b1f6: entered by fall-through of jne at 0x0051b1f4, 3 instruction(s), calls FUN_0051d0b9, falls into the block at 0x0051b204
    push 0x1                                     # 0051b1f6
    call FUN_0051d0b9                            # 0051b1f8
    mov dword ptr [esi + field_28], 0x52e96c     # 0051b1fd
L_0051b204:
    # block 0x0051b204: entered by jne at 0x0051b1f4, 4 instruction(s), ends with ret 0x4
    push 0x1                                     # 0051b204
    pop eax                                      # 0051b206
    pop esi                                      # 0051b207
    ret 0x4                                      # 0051b208

