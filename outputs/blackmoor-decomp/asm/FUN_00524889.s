# FUN_00524889
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524889
# extent:       0x00524889-0x005248bb (50 code bytes)
# span:         0x00524889-0x005248bb (code 50, tables 0, padding 0)
# sha256:       10b46d092875f814e8dbd63617cf2560b00541ae74e46dd871b726be403526c1
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524880 (+0x9)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524889
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051dc43, FUN_0051a7c3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005248bb
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a7c3, .text + (0x0051a7c3 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00524889 - 0x401000
.globl FUN_00524889
FUN_00524889:
    # block 0x00524889: entry, 12 instruction(s), calls FUN_0050f978, FUN_0051dc43, ends with je to 0x005248af (forward)
    mov eax, 0x528bed                            # 00524889
    call FUN_0050f978                            # 0052488e
    push ecx                                     # 00524893
    push 0x3c                                    # 00524894
    call FUN_0051dc43                            # 00524896
    pop ecx                                      # 0052489b
    {load} mov ecx, eax                          # 0052489c
    mov dword ptr [ebp - field_minus_10], ecx    # 0052489e
    {load} xor eax, eax                          # 005248a1
    {load} cmp ecx, eax                          # 005248a3
    mov dword ptr [ebp - field_minus_4], eax     # 005248a5
    je.d8 L_005248af                             # 005248a8
    # block 0x005248aa: entered by fall-through of je at 0x005248a8, 1 instruction(s), calls FUN_0051a7c3, falls into the block at 0x005248af
    call FUN_0051a7c3                            # 005248aa
L_005248af:
    # block 0x005248af: entered by je at 0x005248a8, 4 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 005248af
    mov dword ptr fs:[0x0], ecx                  # 005248b2
    leave                                        # 005248b9
    ret                                          # 005248ba

