# FUN_0050ff61
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ff61
# extent:       0x0050ff61-0x0050ff75 (20 code bytes)
# span:         0x0050ff61-0x0050ff75 (code 20, tables 0, padding 0)
# sha256:       63cd3e5eb894ebd119b7fbc579efa608580f2aae76650be6580c8abc17509b63
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050fee4 (+0x7d)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ff61
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14, field_minus_1c
# callees:      calls FUN_00514755
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050ff75
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_1c, 0x1c  # offset -0x1c

# --- external targets -----------------------------------------------
.set FUN_00514755, .text + (0x00514755 - 0x401000)

.org 0x0050ff61 - 0x401000
.globl FUN_0050ff61
FUN_0050ff61:
    # block 0x0050ff61: entry, 10 instruction(s), calls FUN_00514755, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 0050ff61
    mov ecx, dword ptr [eax]                     # 0050ff64
    mov ecx, dword ptr [ecx]                     # 0050ff66
    mov dword ptr [ebp - field_minus_1c], ecx    # 0050ff68
    push eax                                     # 0050ff6b
    push ecx                                     # 0050ff6c
    call FUN_00514755                            # 0050ff6d
    pop ecx                                      # 0050ff72
    pop ecx                                      # 0050ff73
    ret                                          # 0050ff74

