# FUN_0050c4e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c4e8
# extent:       0x0050c4e8-0x0050c511 (41 code bytes)
# span:         0x0050c4e8-0x0050c511 (code 41, tables 0, padding 0)
# sha256:       a2a48053ae111f00dd0a7730e04b46c3e06c8651d6b26f54c231bb76dc5d8705
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c4e8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051fa94
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051fa94, .text + (0x0051fa94 - 0x401000)

.org 0x0050c4e8 - 0x401000
.globl FUN_0050c4e8
FUN_0050c4e8:
    # block 0x0050c4e8: entry, 11 instruction(s), calls FUN_0050f978, FUN_0051fa94, ends with ret
    mov eax, 0x529130                            # 0050c4e8
    call FUN_0050f978                            # 0050c4ed
    push ecx                                     # 0050c4f2
    mov dword ptr [ebp - field_minus_10], ecx    # 0050c4f3
    mov dword ptr [ecx], 0x52ff14                # 0050c4f6
    and dword ptr [ebp - field_minus_4], 0x0     # 0050c4fc
    call FUN_0051fa94                            # 0050c500
    mov ecx, dword ptr [ebp - field_minus_c]     # 0050c505
    mov dword ptr fs:[0x0], ecx                  # 0050c508
    leave                                        # 0050c50f
    ret                                          # 0050c510

