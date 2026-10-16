# FUN_005148cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005148cd
# extent:       0x005148cd-0x00514925 (88 code bytes)
# span:         0x005148cd-0x00514925 (code 88, tables 0, padding 0)
# sha256:       db7483051efa886d46183c11e2a44aee1f0d8174e4ccc36b18512a2e94e86c48
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005148cd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1
# callees:      calls FUN_005104fa, FUN_005188ce
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1

# --- external targets -----------------------------------------------
.set FUN_005104fa, .text + (0x005104fa - 0x401000)
.set FUN_005188ce, .text + (0x005188ce - 0x401000)

.org 0x005148cd - 0x401000
.globl FUN_005148cd
FUN_005148cd:
    # block 0x005148cd: entry, 2 instruction(s), ends with jne to 0x005148db (forward)
    cmp dword ptr [0x63e130], 0x0                # 005148cd
    jne.d8 L_005148db                            # 005148d4
    # block 0x005148d6: entered by fall-through of jne at 0x005148d4, 1 instruction(s), calls FUN_005104fa, falls into the block at 0x005148db
    call FUN_005104fa                            # 005148d6
L_005148db:
    # block 0x005148db: entered by jne at 0x005148d4, 5 instruction(s), ends with jne to 0x0051490d (forward)
    push esi                                     # 005148db
    mov esi, dword ptr [0x63e128]                # 005148dc
    mov al, byte ptr [esi]                       # 005148e2
    cmp al, 0x22                                 # 005148e4
    jne.d8 L_0051490d                            # 005148e6
L_005148e8:
    # block 0x005148e8: entered by je at 0x00514900; jmp at 0x00514903; fall-through of jne at 0x005148e6, 4 instruction(s), ends with je to 0x00514905 (forward)
    mov al, byte ptr [esi + field_1]             # 005148e8
    inc esi                                      # 005148eb
    cmp al, 0x22                                 # 005148ec
    je.d8 L_00514905                             # 005148ee
    # block 0x005148f0: entered by fall-through of je at 0x005148ee, 2 instruction(s), ends with je to 0x00514905 (forward)
    test al, al                                  # 005148f0
    je.d8 L_00514905                             # 005148f2
    # block 0x005148f4: entered by fall-through of je at 0x005148f2, 6 instruction(s), calls FUN_005188ce, ends with je to 0x005148e8 (backward)
    movzx eax, al                                # 005148f4
    push eax                                     # 005148f7
    call FUN_005188ce                            # 005148f8
    test eax, eax                                # 005148fd
    pop ecx                                      # 005148ff
    je.d8 L_005148e8                             # 00514900
    # block 0x00514902: entered by fall-through of je at 0x00514900, 2 instruction(s), ends with backward jump to 0x005148e8
    inc esi                                      # 00514902
    jmp.d8 L_005148e8                            # 00514903
L_00514905:
    # block 0x00514905: entered by je at 0x005148ee; je at 0x005148f2, 2 instruction(s), ends with jne to 0x00514917 (forward)
    cmp byte ptr [esi], 0x22                     # 00514905
    jne.d8 L_00514917                            # 00514908
L_0051490a:
    # block 0x0051490a: entered by jbe at 0x0051491f; fall-through of jne at 0x00514908, 2 instruction(s), ends with forward jump to 0x00514917
    inc esi                                      # 0051490a
    jmp.d8 L_00514917                            # 0051490b
L_0051490d:
    # block 0x0051490d: entered by jne at 0x005148e6, 2 instruction(s), ends with jbe to 0x00514917 (forward)
    cmp al, 0x20                                 # 0051490d
    jbe.d8 L_00514917                            # 0051490f
L_00514911:
    # block 0x00514911: entered by ja at 0x00514915; fall-through of jbe at 0x0051490f, 3 instruction(s), ends with ja to 0x00514911 (backward)
    inc esi                                      # 00514911
    cmp byte ptr [esi], 0x20                     # 00514912
    ja.d8 L_00514911                             # 00514915
L_00514917:
    # block 0x00514917: entered by jne at 0x00514908; jmp at 0x0051490b; jbe at 0x0051490f; fall-through of ja at 0x00514915, 3 instruction(s), ends with je to 0x00514921 (forward)
    mov al, byte ptr [esi]                       # 00514917
    test al, al                                  # 00514919
    je.d8 L_00514921                             # 0051491b
    # block 0x0051491d: entered by fall-through of je at 0x0051491b, 2 instruction(s), ends with jbe to 0x0051490a (backward)
    cmp al, 0x20                                 # 0051491d
    jbe.d8 L_0051490a                            # 0051491f
L_00514921:
    # block 0x00514921: entered by je at 0x0051491b; fall-through of jbe at 0x0051491f, 3 instruction(s), ends with ret
    {load} mov eax, esi                          # 00514921
    pop esi                                      # 00514923
    ret                                          # 00514924

