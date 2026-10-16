# FUN_0050d787
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d787
# extent:       0x0050d787-0x0050d7b6 (47 code bytes)
# span:         0x0050d787-0x0050d7b6 (code 47, tables 0, padding 0)
# sha256:       769960f8391d2e268435901b29a9985c4a2ccaf920b2fb03a883ddbcda1f8a65
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050d775 (+0x12)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d787
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ea90, FUN_0050e8ed
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x0050d787 - 0x401000
.globl FUN_0050d787
FUN_0050d787:
    # block 0x0050d787: entry, 6 instruction(s), calls FUN_0050ea90, ends with jne to 0x0050d7a8 (forward)
    push 0x80                                    # 0050d787
    call FUN_0050ea90                            # 0050d78c
    test eax, eax                                # 0050d791
    pop ecx                                      # 0050d793
    mov dword ptr [0x63e138], eax                # 0050d794
    jne.d8 L_0050d7a8                            # 0050d799
    # block 0x0050d79b: entered by fall-through of jne at 0x0050d799, 4 instruction(s), calls FUN_0050e8ed, falls into the block at 0x0050d7a8
    push 0x18                                    # 0050d79b
    call FUN_0050e8ed                            # 0050d79d
    mov eax, dword ptr [0x63e138]                # 0050d7a2
    pop ecx                                      # 0050d7a7
L_0050d7a8:
    # block 0x0050d7a8: entered by jne at 0x0050d799, 4 instruction(s), ends with ret
    and dword ptr [eax], 0x0                     # 0050d7a8
    mov eax, dword ptr [0x63e138]                # 0050d7ab
    mov dword ptr [0x63e134], eax                # 0050d7b0
    ret                                          # 0050d7b5

