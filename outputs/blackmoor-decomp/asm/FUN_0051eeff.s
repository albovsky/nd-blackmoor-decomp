# FUN_0051eeff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051eeff
# extent:       0x0051eeff-0x0051ef58 (89 code bytes)
# span:         0x0051eeff-0x0051ef58 (code 89, tables 0, padding 0)
# sha256:       3c00bff6b7ffa19c4d47b417cc9811e66602d6ce53ee5df2f2226a1506a18f4e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051ee80 (+0x7f)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051eeff
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_14, field_18; [ecx + n] field_5c, field_60, field_64; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051ef58
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64

# --- external targets -----------------------------------------------

.org 0x0051eeff - 0x401000
.globl FUN_0051eeff
FUN_0051eeff:
    # block 0x0051eeff: entry, 6 instruction(s), ends with je to 0x0051ef29 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0051eeff
    push esi                                     # 0051ef03
    push edi                                     # 0051ef04
    mov esi, dword ptr [eax + field_4]           # 0051ef05
    cmp esi, 0x200                               # 0051ef08
    je.d8 L_0051ef29                             # 0051ef0e
    # block 0x0051ef10: entered by fall-through of je at 0x0051ef0e, 2 instruction(s), ends with je to 0x0051ef29 (forward)
    cmp esi, 0xa0                                # 0051ef10
    je.d8 L_0051ef29                             # 0051ef16
    # block 0x0051ef18: entered by fall-through of je at 0x0051ef16, 2 instruction(s), ends with je to 0x0051ef25 (forward)
    cmp esi, 0xf                                 # 0051ef18
    je.d8 L_0051ef25                             # 0051ef1b
    # block 0x0051ef1d: entered by fall-through of je at 0x0051ef1b, 2 instruction(s), ends with jne to 0x0051ef50 (forward)
    cmp esi, 0x118                               # 0051ef1d
    jne.d8 L_0051ef50                            # 0051ef23
L_0051ef25:
    # block 0x0051ef25: entered by je at 0x0051ef1b; je at 0x0051ef3c; fall-through of jne at 0x0051ef23, 2 instruction(s), ends with forward jump to 0x0051ef53
    {load} xor eax, eax                          # 0051ef25
    jmp.d8 L_0051ef53                            # 0051ef27
L_0051ef29:
    # block 0x0051ef29: entered by je at 0x0051ef0e; je at 0x0051ef16, 4 instruction(s), ends with jne to 0x0051ef3e (forward)
    mov edx, dword ptr [eax + field_14]          # 0051ef29
    mov edi, dword ptr [eax + field_18]          # 0051ef2c
    cmp dword ptr [ecx + field_5c], edx          # 0051ef2f
    jne.d8 L_0051ef3e                            # 0051ef32
    # block 0x0051ef34: entered by fall-through of jne at 0x0051ef32, 2 instruction(s), ends with jne to 0x0051ef3e (forward)
    cmp dword ptr [ecx + field_60], edi          # 0051ef34
    jne.d8 L_0051ef3e                            # 0051ef37
    # block 0x0051ef39: entered by fall-through of jne at 0x0051ef37, 2 instruction(s), ends with je to 0x0051ef25 (backward)
    cmp esi, dword ptr [ecx + field_64]          # 0051ef39
    je.d8 L_0051ef25                             # 0051ef3c
L_0051ef3e:
    # block 0x0051ef3e: entered by jne at 0x0051ef32; jne at 0x0051ef37; fall-through of je at 0x0051ef3c, 6 instruction(s), falls into the block at 0x0051ef50
    mov edx, dword ptr [eax + field_14]          # 0051ef3e
    mov esi, dword ptr [eax + field_18]          # 0051ef41
    mov dword ptr [ecx + field_5c], edx          # 0051ef44
    mov dword ptr [ecx + field_60], esi          # 0051ef47
    mov eax, dword ptr [eax + field_4]           # 0051ef4a
    mov dword ptr [ecx + field_64], eax          # 0051ef4d
L_0051ef50:
    # block 0x0051ef50: entered by jne at 0x0051ef23, 2 instruction(s), falls into the block at 0x0051ef53
    push 0x1                                     # 0051ef50
    pop eax                                      # 0051ef52
L_0051ef53:
    # block 0x0051ef53: entered by jmp at 0x0051ef27, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0051ef53
    pop esi                                      # 0051ef54
    ret 0x4                                      # 0051ef55

