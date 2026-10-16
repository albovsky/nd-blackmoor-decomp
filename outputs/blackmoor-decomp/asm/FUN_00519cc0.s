# FUN_00519cc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519cc0
# extent:       0x00519cc0-0x00519cdf (31 code bytes)
# span:         0x00519cc0-0x00519cdf (code 31, tables 0, padding 0)
# sha256:       c7487fe742a6b75e27f9ce6cd362f54fe6cc1a4461b9ad100e89f22e1b9fc7d8
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519cc0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050f997
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0050f997, .text + (0x0050f997 - 0x401000)

.org 0x00519cc0 - 0x401000
.globl FUN_00519cc0
FUN_00519cc0:
    # block 0x00519cc0: entry, 10 instruction(s), calls FUN_0050f997, ends with ret
    push ebp                                     # 00519cc0
    {load} mov ebp, esp                          # 00519cc1
    push ecx                                     # 00519cc3
    lea eax, [ebp - local_4]                     # 00519cc4
    push 0x5344e0                                # 00519cc7
    push eax                                     # 00519ccc
    mov dword ptr [ebp - local_4], 0x63c668      # 00519ccd
    call FUN_0050f997                            # 00519cd4
    mov eax, 0x52ffb0                            # 00519cd9
    ret                                          # 00519cde

