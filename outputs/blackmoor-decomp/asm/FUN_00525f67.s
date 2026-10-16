# FUN_00525f67
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525f67
# extent:       0x00525f67-0x00525fac (69 code bytes)
# span:         0x00525f67-0x00525fac (code 69, tables 0, padding 0)
# sha256:       ceade28fa0b149e2a80c8364e573b21cc730d461445fce26f4f675ee3c39a974
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525f67
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetVersion, KERNEL32.dll!InitializeCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00525f67 - 0x401000
.globl FUN_00525f67
FUN_00525f67:
    # block 0x00525f67: entry, 3 instruction(s), ends with jne to 0x00525fa5 (forward)
    cmp dword ptr [0x63c9e4], 0x0                # 00525f67
    push esi                                     # 00525f6e
    jne.d8 L_00525fa5                            # 00525f6f
    # block 0x00525f71: entered by fall-through of jne at 0x00525f6f, 6 instruction(s), calls KERNEL32.dll!GetVersion, ends with jae to 0x00525f93 (forward)
    push 0x1                                     # 00525f71
    pop esi                                      # 00525f73
    mov dword ptr [0x63c9e4], esi                # 00525f74
    call dword ptr [0x52a224]                    # 00525f7a
    cmp al, 0x4                                  # 00525f80
    jae.d8 L_00525f93                            # 00525f82
    # block 0x00525f84: entered by fall-through of jae at 0x00525f82, 2 instruction(s), ends with je to 0x00525f93 (forward)
    test eax, 0x80000000                         # 00525f84
    je.d8 L_00525f93                             # 00525f89
    # block 0x00525f8b: entered by fall-through of je at 0x00525f89, 2 instruction(s), ends with forward jump to 0x00525fa5
    mov dword ptr [0x63c9e0], esi                # 00525f8b
    jmp.d8 L_00525fa5                            # 00525f91
L_00525f93:
    # block 0x00525f93: entered by jae at 0x00525f82; je at 0x00525f89, 3 instruction(s), calls KERNEL32.dll!InitializeCriticalSection, falls into the block at 0x00525fa5
    and dword ptr [0x63c9e0], 0x0                # 00525f93
    push 0x63c830                                # 00525f9a
    call dword ptr [0x52a0b4]                    # 00525f9f
L_00525fa5:
    # block 0x00525fa5: entered by jne at 0x00525f6f; jmp at 0x00525f91, 3 instruction(s), ends with ret
    mov eax, dword ptr [0x63c9e4]                # 00525fa5
    pop esi                                      # 00525faa
    ret                                          # 00525fab

