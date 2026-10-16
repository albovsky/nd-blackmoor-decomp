# FUN_00514d99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514d99
# extent:       0x00514d99-0x00514dd2 (57 code bytes)
# span:         0x00514d99-0x00514dd2 (code 57, tables 0, padding 0)
# sha256:       1fb93c4df1b31138d21effaed90fddc9421435e94ddb1618ce942896deb8d134
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514d99
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00514dd2; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00514dd2, .text + (0x00514dd2 - 0x401000)

.org 0x00514d99 - 0x401000
.globl FUN_00514d99
FUN_00514d99:
    # block 0x00514d99: entry, 3 instruction(s), ends with je to 0x00514db0 (forward)
    mov eax, dword ptr [0x63ca70]                # 00514d99
    cmp eax, 0x1                                 # 00514d9e
    je.d8 L_00514db0                             # 00514da1
    # block 0x00514da3: entered by fall-through of je at 0x00514da1, 2 instruction(s), ends with jne to 0x00514dd1 (forward)
    test eax, eax                                # 00514da3
    jne.d8 L_00514dd1                            # 00514da5
    # block 0x00514da7: entered by fall-through of jne at 0x00514da5, 2 instruction(s), ends with jne to 0x00514dd1 (forward)
    cmp dword ptr [0x567e80], 0x1                # 00514da7
    jne.d8 L_00514dd1                            # 00514dae
L_00514db0:
    # block 0x00514db0: entered by je at 0x00514da1; fall-through of jne at 0x00514dae, 6 instruction(s), calls FUN_00514dd2, ends with je to 0x00514dc6 (forward)
    push 0xfc                                    # 00514db0
    call FUN_00514dd2                            # 00514db5
    mov eax, dword ptr [0x63cc44]                # 00514dba
    pop ecx                                      # 00514dbf
    test eax, eax                                # 00514dc0
    je.d8 L_00514dc6                             # 00514dc2
    # block 0x00514dc4: entered by fall-through of je at 0x00514dc2, 1 instruction(s), calls indirect eax, falls into the block at 0x00514dc6
    call eax                                     # 00514dc4
L_00514dc6:
    # block 0x00514dc6: entered by je at 0x00514dc2, 3 instruction(s), calls FUN_00514dd2, falls into the block at 0x00514dd1
    push 0xff                                    # 00514dc6
    call FUN_00514dd2                            # 00514dcb
    pop ecx                                      # 00514dd0
L_00514dd1:
    # block 0x00514dd1: entered by jne at 0x00514da5; jne at 0x00514dae, 1 instruction(s), ends with ret
    ret                                          # 00514dd1

