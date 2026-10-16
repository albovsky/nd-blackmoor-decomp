# FUN_00525fac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525fac
# extent:       0x00525fac-0x00525ffa (78 code bytes)
# span:         0x00525fac-0x00525ffa (code 78, tables 0, padding 0)
# sha256:       3db036a721f7b1f28f1ad0d284034f79cfe8a91c330b9b73b648aec94ca1a24e
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525fac
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00525fac - 0x401000
.globl FUN_00525fac
FUN_00525fac:
    # block 0x00525fac: entry, 2 instruction(s), ends with je to 0x00525ff9 (forward)
    cmp dword ptr [0x63c9e4], 0x0                # 00525fac
    je.d8 L_00525ff9                             # 00525fb3
    # block 0x00525fb5: entered by fall-through of je at 0x00525fb3, 3 instruction(s), ends with jne to 0x00525ff9 (forward)
    dec dword ptr [0x63c9e4]                     # 00525fb5
    cmp dword ptr [0x63c9e0], 0x0                # 00525fbb
    jne.d8 L_00525ff9                            # 00525fc2
    # block 0x00525fc4: entered by fall-through of jne at 0x00525fc2, 8 instruction(s), calls indirect edi, falls into the block at 0x00525fde
    push ebx                                     # 00525fc4
    push esi                                     # 00525fc5
    push edi                                     # 00525fc6
    mov edi, dword ptr [0x52a0bc]                # 00525fc7
    push 0x63c830                                # 00525fcd
    call edi                                     # 00525fd2
    mov esi, 0x63c7e8                            # 00525fd4
    mov ebx, 0x63c848                            # 00525fd9
L_00525fde:
    # block 0x00525fde: entered by jl at 0x00525ff4, 2 instruction(s), ends with je to 0x00525fe8 (forward)
    cmp dword ptr [esi], 0x0                     # 00525fde
    je.d8 L_00525fe8                             # 00525fe1
    # block 0x00525fe3: entered by fall-through of je at 0x00525fe1, 3 instruction(s), calls indirect edi, falls into the block at 0x00525fe8
    push ebx                                     # 00525fe3
    call edi                                     # 00525fe4
    dec dword ptr [esi]                          # 00525fe6
L_00525fe8:
    # block 0x00525fe8: entered by je at 0x00525fe1, 4 instruction(s), ends with jl to 0x00525fde (backward)
    add ebx, 0x18                                # 00525fe8
    add esi, 0x4                                 # 00525feb
    cmp ebx, 0x63c9e0                            # 00525fee
    jl.d8 L_00525fde                             # 00525ff4
    # block 0x00525ff6: entered by fall-through of jl at 0x00525ff4, 3 instruction(s), falls into the block at 0x00525ff9
    pop edi                                      # 00525ff6
    pop esi                                      # 00525ff7
    pop ebx                                      # 00525ff8
L_00525ff9:
    # block 0x00525ff9: entered by je at 0x00525fb3; jne at 0x00525fc2, 1 instruction(s), ends with ret
    ret                                          # 00525ff9

