# FUN_0043ef27
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ef27
# extent:       0x0043ef27-0x0043ef3b (20 code bytes)
# span:         0x0043ef27-0x0043ef3b (code 20, tables 0, padding 0)
# sha256:       67face5f5899d2b0dce2d34561d485da5fd7feedd26748c1505826073d7fd91c
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043ef27
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0043ef27 - 0x401000
.globl FUN_0043ef27
FUN_0043ef27:
    # block 0x0043ef27: entry, 9 instruction(s), ends with ret
    push ebp                                     # 0043ef27
    {load} mov ebp, esp                          # 0043ef28
    push ecx                                     # 0043ef2a
    mov dword ptr [ebp - local_4], ecx           # 0043ef2b
    mov eax, dword ptr [ebp - local_4]           # 0043ef2e
    mov dword ptr [eax], 0x52ca10                # 0043ef31
    {load} mov esp, ebp                          # 0043ef37
    pop ebp                                      # 0043ef39
    ret                                          # 0043ef3a

