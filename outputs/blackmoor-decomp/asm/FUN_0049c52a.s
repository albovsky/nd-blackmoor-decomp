# FUN_0049c52a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c52a
# extent:       0x0049c52a-0x0049c53a (16 code bytes)
# span:         0x0049c52a-0x0049c53a (code 16, tables 0, padding 0)
# sha256:       65b8f8184a9c2713718cbf853310e6f334f1da6eabbbeb9bfc32234405956edd
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049c52a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0049c52a - 0x401000
.globl FUN_0049c52a
FUN_0049c52a:
    # block 0x0049c52a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0049c52a
    {load} mov ebp, esp                          # 0049c52b
    push ecx                                     # 0049c52d
    mov dword ptr [ebp - local_4], ecx           # 0049c52e
    mov eax, 0x52db90                            # 0049c531
    {load} mov esp, ebp                          # 0049c536
    pop ebp                                      # 0049c538
    ret                                          # 0049c539

