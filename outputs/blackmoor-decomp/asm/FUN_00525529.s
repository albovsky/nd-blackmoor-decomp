# FUN_00525529
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525529
# extent:       0x00525529-0x00525545 (28 code bytes)
# span:         0x00525529-0x00525545 (code 28, tables 0, padding 0)
# sha256:       e27ea1d996c017a104836e3e4c8cfb340d3a2af0e71aae15c29c83a9a9ec6f5c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005254fe (+0x2b)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525529
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4
# callees:      calls FUN_0050c575
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050c575, .text + (0x0050c575 - 0x401000)

.org 0x00525529 - 0x401000
.globl FUN_00525529
FUN_00525529:
    # block 0x00525529: entry, 4 instruction(s), calls FUN_0050c575, ends with je to 0x00525542 (forward)
    mov ecx, 0x63c580                            # 00525529
    call FUN_0050c575                            # 0052552e
    test eax, eax                                # 00525533
    je.d8 L_00525542                             # 00525535
    # block 0x00525537: entered by fall-through of je at 0x00525535, 3 instruction(s), ends with ret
    and dword ptr [eax + field_4], 0x0           # 00525537
    mov dword ptr [eax], 0x52fd80                # 0052553b
    ret                                          # 00525541
L_00525542:
    # block 0x00525542: entered by je at 0x00525535, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00525542
    ret                                          # 00525544

