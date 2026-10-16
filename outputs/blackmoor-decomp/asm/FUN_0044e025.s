# FUN_0044e025
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e025
# extent:       0x0044e025-0x0044e035 (16 code bytes)
# span:         0x0044e025-0x0044e035 (code 16, tables 0, padding 0)
# sha256:       e5cb2553ab67884ebfb3c24f8d0220ada2940c841b3a5ecf1a0e121abb0bd198
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044e025
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

.org 0x0044e025 - 0x401000
.globl FUN_0044e025
FUN_0044e025:
    # block 0x0044e025: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0044e025
    {load} mov ebp, esp                          # 0044e026
    push ecx                                     # 0044e028
    mov dword ptr [ebp - local_4], ecx           # 0044e029
    mov eax, 0x52cc18                            # 0044e02c
    {load} mov esp, ebp                          # 0044e031
    pop ebp                                      # 0044e033
    ret                                          # 0044e034

