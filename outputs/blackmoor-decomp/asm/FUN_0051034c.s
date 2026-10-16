# FUN_0051034c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051034c
# extent:       0x0051034c-0x00510375 (41 code bytes)
# span:         0x0051034c-0x00510375 (code 41, tables 0, padding 0)
# sha256:       04c0455ea63717c8b577a08cd3fb62d8abb3cf4038c03d7143e8e940cf0437b4
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051034c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0051034c - 0x401000
.globl FUN_0051034c
FUN_0051034c:
    # block 0x0051034c: entry, 17 instruction(s), ends with ret
    push edi                                     # 0051034c
    push 0x40                                    # 0051034d
    pop ecx                                      # 0051034f
    {load} xor eax, eax                          # 00510350
    mov edi, 0x63e020                            # 00510352
    rep stosd dword ptr es:[edi], eax            # 00510357
    stosb byte ptr es:[edi], al                  # 00510359
    {load} xor eax, eax                          # 0051035a
    mov edi, 0x63df10                            # 0051035c
    mov dword ptr [0x63df04], eax                # 00510361
    mov dword ptr [0x63df1c], eax                # 00510366
    mov dword ptr [0x63e124], eax                # 0051036b
    stosd dword ptr es:[edi], eax                # 00510370
    stosd dword ptr es:[edi], eax                # 00510371
    stosd dword ptr es:[edi], eax                # 00510372
    pop edi                                      # 00510373
    ret                                          # 00510374

