# FUN_00521235
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521235
# extent:       0x00521235-0x00521287 (82 code bytes)
# span:         0x00521235-0x00521287 (code 82, tables 0, padding 0)
# sha256:       dbb5cb6f647912a17ac0ac50d269f50a2c23a7bda0e1d2d2d23497e28604b1db
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005211ff (+0x36)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521235
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esi + n] field_c; [esp + n] stk_8
# callees:      calls FUN_0052513f, FUN_00510066, FUN_0050e936, FUN_005100ab, FUN_00519cc0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_00510066, .text + (0x00510066 - 0x401000)
.set FUN_005100ab, .text + (0x005100ab - 0x401000)
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)

.org 0x00521235 - 0x401000
.globl FUN_00521235
FUN_00521235:
    # block 0x00521235: entry, 5 instruction(s), calls FUN_0052513f, ends with je to 0x0052127e (forward)
    push esi                                     # 00521235
    call FUN_0052513f                            # 00521236
    {load} mov esi, eax                          # 0052123b
    test esi, esi                                # 0052123d
    je.d8 L_0052127e                             # 0052123f
    # block 0x00521241: entered by fall-through of je at 0x0052123f, 3 instruction(s), ends with je to 0x0052127e (forward)
    mov eax, dword ptr [esi + field_c]           # 00521241
    test eax, eax                                # 00521244
    je.d8 L_0052127e                             # 00521246
    # block 0x00521248: entered by fall-through of je at 0x00521246, 7 instruction(s), calls FUN_00510066, ends with ja to 0x00521269 (forward)
    push eax                                     # 00521248
    call FUN_00510066                            # 00521249
    pop ecx                                      # 0052124e
    mov ecx, dword ptr [esp + stk_8]             # 0052124f
    lea edx, [ecx + field_4]                     # 00521253
    {load} cmp eax, edx                          # 00521256
    ja.d8 L_00521269                             # 00521258
    # block 0x0052125a: entered by fall-through of ja at 0x00521258, 5 instruction(s), calls FUN_0050e936, ends with forward jump to 0x00521279
    push dword ptr [esi + field_c]               # 0052125a
    call FUN_0050e936                            # 0052125d
    and dword ptr [esi + field_c], 0x0           # 00521262
    pop ecx                                      # 00521266
    jmp.d8 L_00521279                            # 00521267
L_00521269:
    # block 0x00521269: entered by ja at 0x00521258, 7 instruction(s), calls FUN_005100ab, falls into the block at 0x00521279
    {load} sub eax, ecx                          # 00521269
    sub eax, 0x4                                 # 0052126b
    push eax                                     # 0052126e
    push dword ptr [esi + field_c]               # 0052126f
    call FUN_005100ab                            # 00521272
    pop ecx                                      # 00521277
    pop ecx                                      # 00521278
L_00521279:
    # block 0x00521279: entered by jmp at 0x00521267, 4 instruction(s), ends with ret
    push 0x1                                     # 00521279
    pop eax                                      # 0052127b
    pop esi                                      # 0052127c
    ret                                          # 0052127d
L_0052127e:
    # block 0x0052127e: entered by je at 0x0052123f; je at 0x00521246, 4 instruction(s), calls FUN_00519cc0, ends with ret
    call FUN_00519cc0                            # 0052127e
    {load} xor eax, eax                          # 00521283
    pop esi                                      # 00521285
    ret                                          # 00521286

