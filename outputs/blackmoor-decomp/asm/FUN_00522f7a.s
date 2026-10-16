# FUN_00522f7a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522f7a
# extent:       0x00522f7a-0x00522fbe (68 code bytes)
# span:         0x00522f7a-0x00522fbe (code 68, tables 0, padding 0)
# sha256:       554ac5cf38bceaaea52364b69ba5ed72c76fd54a6e6725e0ef96b405977988bc
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522f7a
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_20, field_28, field_2d; [esp + n] stk_8
# callees:      calls FUN_0051d0b9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_20, 0x20  # offset +0x20
.equ field_28, 0x28  # offset +0x28
.equ field_2d, 0x2d  # offset +0x2d

# --- external targets -----------------------------------------------
.set FUN_0051d0b9, .text + (0x0051d0b9 - 0x401000)

.org 0x00522f7a - 0x401000
.globl FUN_00522f7a
FUN_00522f7a:
    # block 0x00522f7a: entry, 4 instruction(s), ends with jne to 0x00522f93 (forward)
    push esi                                     # 00522f7a
    mov esi, dword ptr [esp + stk_8]             # 00522f7b
    cmp dword ptr [esi + field_28], 0x0          # 00522f7f
    jne.d8 L_00522f93                            # 00522f83
    # block 0x00522f85: entered by fall-through of jne at 0x00522f83, 3 instruction(s), calls FUN_0051d0b9, falls into the block at 0x00522f93
    push 0x8                                     # 00522f85
    call FUN_0051d0b9                            # 00522f87
    mov dword ptr [esi + field_28], 0x52e99c     # 00522f8c
L_00522f93:
    # block 0x00522f93: entered by jne at 0x00522f83, 3 instruction(s), ends with je to 0x00522faa (forward)
    mov eax, dword ptr [esi + field_20]          # 00522f93
    test ah, -0x80                               # 00522f96
    je.d8 L_00522faa                             # 00522f99
    # block 0x00522f9b: entered by fall-through of je at 0x00522f99, 2 instruction(s), ends with je to 0x00522fb7 (forward)
    cmp dword ptr [0x63c7a4], 0x0                # 00522f9b
    je.d8 L_00522fb7                             # 00522fa2
    # block 0x00522fa4: entered by fall-through of je at 0x00522fa2, 2 instruction(s), falls into the block at 0x00522faa
    or ah, 0x40                                  # 00522fa4
    mov dword ptr [esi + field_20], eax          # 00522fa7
L_00522faa:
    # block 0x00522faa: entered by je at 0x00522f99, 2 instruction(s), ends with je to 0x00522fb7 (forward)
    cmp dword ptr [0x63c7a4], 0x0                # 00522faa
    je.d8 L_00522fb7                             # 00522fb1
    # block 0x00522fb3: entered by fall-through of je at 0x00522fb1, 1 instruction(s), falls into the block at 0x00522fb7
    or byte ptr [esi + field_2d], 0x2            # 00522fb3
L_00522fb7:
    # block 0x00522fb7: entered by je at 0x00522fa2; je at 0x00522fb1, 4 instruction(s), ends with ret 0x4
    push 0x1                                     # 00522fb7
    pop eax                                      # 00522fb9
    pop esi                                      # 00522fba
    ret 0x4                                      # 00522fbb

