# FUN_0050c1a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c1a7
# extent:       0x0050c1a7-0x0050c1b4 (13 code bytes)
# span:         0x0050c1a7-0x0050c1b4 (code 13, tables 0, padding 0)
# sha256:       783512c7b124b83d8068b7598dc4252544104f4dbcbee506a52a9fc49abc0456
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c1a7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4
# callees:      calls FUN_00525371, tail jump FUN_0051d994
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051d994, .text + (0x0051d994 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0050c1a7 - 0x401000
.globl FUN_0050c1a7
FUN_0050c1a7:
    # block 0x0050c1a7: entry, 3 instruction(s), calls FUN_00525371, ends with forward jump to 0x0051d994
    call FUN_00525371                            # 0050c1a7
    mov ecx, dword ptr [eax + field_4]           # 0050c1ac
    jmp.d32 FUN_0051d994                         # 0050c1af

