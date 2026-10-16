# FUN_00510a9f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510a9f
# extent:       0x00510a9f-0x00510ac9 (42 code bytes)
# span:         0x00510a9f-0x00510ac9 (code 42, tables 0, padding 0)
# sha256:       f0f5dbe69fb310efa0038c2524f469faee972ea0f54294bdd15eae978c1fc0ee
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00510a51 (+0x4e)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510a9f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10, field_14, field_1c; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x00510a9f - 0x401000
.globl FUN_00510a9f
FUN_00510a9f:
    # block 0x00510a9f: entry, 4 instruction(s), ends with jne to 0x00510ac6 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00510a9f
    mov eax, dword ptr [eax]                     # 00510aa3
    cmp dword ptr [eax], 0xe06d7363              # 00510aa5
    jne.d8 L_00510ac6                            # 00510aab
    # block 0x00510aad: entered by fall-through of jne at 0x00510aab, 2 instruction(s), ends with jne to 0x00510ac6 (forward)
    cmp dword ptr [eax + field_10], 0x3          # 00510aad
    jne.d8 L_00510ac6                            # 00510ab1
    # block 0x00510ab3: entered by fall-through of jne at 0x00510ab1, 2 instruction(s), ends with jne to 0x00510ac6 (forward)
    cmp dword ptr [eax + field_14], 0x19930520   # 00510ab3
    jne.d8 L_00510ac6                            # 00510aba
    # block 0x00510abc: entered by fall-through of jne at 0x00510aba, 2 instruction(s), ends with jne to 0x00510ac6 (forward)
    cmp dword ptr [eax + field_1c], 0x0          # 00510abc
    jne.d8 L_00510ac6                            # 00510ac0
    # block 0x00510ac2: entered by fall-through of jne at 0x00510ac0, 3 instruction(s), ends with ret
    push 0x1                                     # 00510ac2
    pop eax                                      # 00510ac4
    ret                                          # 00510ac5
L_00510ac6:
    # block 0x00510ac6: entered by jne at 0x00510aab; jne at 0x00510ab1; jne at 0x00510aba; jne at 0x00510ac0, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00510ac6
    ret                                          # 00510ac8

