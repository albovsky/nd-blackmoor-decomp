# FUN_005254b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005254b8
# extent:       0x005254b8-0x005254d2 (26 code bytes)
# span:         0x005254b8-0x005254d2 (code 26, tables 0, padding 0)
# sha256:       460caf3077ce02382c3d9b2f0005bdf3d275ec93b7f007d4e0fc4b178c9ce750
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525485 (+0x33)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005254b8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4
# callees:      calls FUN_0051dc43
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005254d2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x005254b8 - 0x401000
.globl FUN_005254b8
FUN_005254b8:
    # block 0x005254b8: entry, 5 instruction(s), calls FUN_0051dc43, ends with je to 0x005254cf (forward)
    push 0x8                                     # 005254b8
    call FUN_0051dc43                            # 005254ba
    test eax, eax                                # 005254bf
    pop ecx                                      # 005254c1
    je.d8 L_005254cf                             # 005254c2
    # block 0x005254c4: entered by fall-through of je at 0x005254c2, 3 instruction(s), ends with ret
    mov dword ptr [eax], 0x52fcf8                # 005254c4
    and dword ptr [eax + field_4], 0x0           # 005254ca
    ret                                          # 005254ce
L_005254cf:
    # block 0x005254cf: entered by je at 0x005254c2, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 005254cf
    ret                                          # 005254d1

