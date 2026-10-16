# FUN_00525bb3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525bb3
# extent:       0x00525bb3-0x00525bd1 (30 code bytes)
# span:         0x00525bb3-0x00525bd1 (code 30, tables 0, padding 0)
# sha256:       5398943ef54ab4042875d3bf7d30be5e4616b2f0df93b458533a4102f84a0845
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525bb3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005258ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_005258ba, .text + (0x005258ba - 0x401000)

.org 0x00525bb3 - 0x401000
.globl FUN_00525bb3
FUN_00525bb3:
    # block 0x00525bb3: entry, 5 instruction(s), ends with je to 0x00525bcc (forward)
    push esi                                     # 00525bb3
    {load} mov esi, ecx                          # 00525bb4
    mov eax, dword ptr [esi]                     # 00525bb6
    test eax, eax                                # 00525bb8
    je.d8 L_00525bcc                             # 00525bba
    # block 0x00525bbc: entered by fall-through of je at 0x00525bba, 3 instruction(s), ends with je to 0x00525bcc (forward)
    mov ecx, dword ptr [0x63c704]                # 00525bbc
    test ecx, ecx                                # 00525bc2
    je.d8 L_00525bcc                             # 00525bc4
    # block 0x00525bc6: entered by fall-through of je at 0x00525bc4, 2 instruction(s), calls FUN_005258ba, falls into the block at 0x00525bcc
    push eax                                     # 00525bc6
    call FUN_005258ba                            # 00525bc7
L_00525bcc:
    # block 0x00525bcc: entered by je at 0x00525bba; je at 0x00525bc4, 3 instruction(s), ends with ret
    and dword ptr [esi], 0x0                     # 00525bcc
    pop esi                                      # 00525bcf
    ret                                          # 00525bd0

