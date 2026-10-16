# FUN_00524d5f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524d5f
# extent:       0x00524d5f-0x00524d9f (64 code bytes)
# span:         0x00524d5f-0x00524d9f (code 64, tables 0, padding 0)
# sha256:       be2e4fa57f97d87227bf2e5c212d22d530f7d23012bd79151219808b98009953
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524d43 (+0x1c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524d5f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [ecx + n] field_80
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00524d9f
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------

.org 0x00524d5f - 0x401000
.globl FUN_00524d5f
FUN_00524d5f:
    # block 0x00524d5f: entry, 3 instruction(s), ends with je to 0x00524d81 (forward)
    mov edx, dword ptr [0x63c420]                # 00524d5f
    test edx, edx                                # 00524d65
    je.d8 L_00524d81                             # 00524d67
    # block 0x00524d69: entered by fall-through of je at 0x00524d67, 3 instruction(s), ends with jne to 0x00524d7a (forward)
    cmp dword ptr [ecx + field_80], 0x0          # 00524d69
    lea eax, [ecx + field_80]                    # 00524d70
    jne.d8 L_00524d7a                            # 00524d76
    # block 0x00524d78: entered by fall-through of jne at 0x00524d76, 1 instruction(s), falls into the block at 0x00524d7a
    mov dword ptr [eax], edx                     # 00524d78
L_00524d7a:
    # block 0x00524d7a: entered by jne at 0x00524d76, 1 instruction(s), falls into the block at 0x00524d81
    and dword ptr [0x63c420], 0x0                # 00524d7a
L_00524d81:
    # block 0x00524d81: entered by je at 0x00524d67, 3 instruction(s), ends with je to 0x00524d94 (forward)
    mov ecx, dword ptr [ecx + field_80]          # 00524d81
    test ecx, ecx                                # 00524d87
    je.d8 L_00524d94                             # 00524d89
    # block 0x00524d8b: entered by fall-through of je at 0x00524d89, 4 instruction(s), calls indirect dword ptr [eax + 0xc], ends with forward jump to 0x00524d9b
    mov eax, dword ptr [ecx]                     # 00524d8b
    push 0x0                                     # 00524d8d
    call dword ptr [eax + field_c]               # 00524d8f
    jmp.d8 L_00524d9b                            # 00524d92
L_00524d94:
    # block 0x00524d94: entered by je at 0x00524d89, 1 instruction(s), falls into the block at 0x00524d9b
    and dword ptr [0x567a08], 0x0                # 00524d94
L_00524d9b:
    # block 0x00524d9b: entered by jmp at 0x00524d92, 3 instruction(s), ends with ret
    push 0x1                                     # 00524d9b
    pop eax                                      # 00524d9d
    ret                                          # 00524d9e

