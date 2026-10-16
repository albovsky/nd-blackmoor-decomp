# FUN_0050c539
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c539
# extent:       0x0050c539-0x0050c54d (20 code bytes)
# span:         0x0050c539-0x0050c54d (code 20, tables 0, padding 0)
# sha256:       cf65526a3409007a83c4665c3094b4935b0120bae0a0bab5c2a784aa181f6c72
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c539
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050c54d, KERNEL32.dll!DeleteCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050c54d, .text + (0x0050c54d - 0x401000)

.org 0x0050c539 - 0x401000
.globl FUN_0050c539
FUN_0050c539:
    # block 0x0050c539: entry, 8 instruction(s), calls FUN_0050c54d, KERNEL32.dll!DeleteCriticalSection, ends with ret
    push esi                                     # 0050c539
    {load} mov esi, ecx                          # 0050c53a
    call FUN_0050c54d                            # 0050c53c
    add esi, 0x10                                # 0050c541
    push esi                                     # 0050c544
    call dword ptr [0x52a0bc]                    # 0050c545
    pop esi                                      # 0050c54b
    ret                                          # 0050c54c

