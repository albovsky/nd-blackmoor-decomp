# FUN_00527356
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527356
# extent:       0x00527356-0x0052736e (24 code bytes)
# span:         0x00527356-0x0052736e (code 24, tables 0, padding 0)
# sha256:       223926bfcceacf48e02b31169f0bc0601bbb4db91a6a4de490d7054d73743586
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527356
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0050cba8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x00527356 - 0x401000
.globl FUN_00527356
FUN_00527356:
    # block 0x00527356: entry, 8 instruction(s), calls FUN_0050cba8, ends with ret
    push 0x51e7ba                                # 00527356
    push 0x1e                                    # 0052735b
    push 0x4                                     # 0052735d
    mov eax, dword ptr [ebp - field_minus_10]    # 0052735f
    add eax, 0xea5                               # 00527362
    push eax                                     # 00527367
    call FUN_0050cba8                            # 00527368
    ret                                          # 0052736d

