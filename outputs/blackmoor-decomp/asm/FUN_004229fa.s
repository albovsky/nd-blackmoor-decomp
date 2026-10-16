# FUN_004229fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004229fa
# extent:       0x004229fa-0x00422a0a (16 code bytes)
# span:         0x004229fa-0x00422a0a (code 16, tables 0, padding 0)
# sha256:       e475d835c63070e47ab10164983aa5ec131b47dc56e589d4abc4ec625dc70fe7
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004229fa
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

.org 0x004229fa - 0x401000
.globl FUN_004229fa
FUN_004229fa:
    # block 0x004229fa: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004229fa
    {load} mov ebp, esp                          # 004229fb
    push ecx                                     # 004229fd
    mov dword ptr [ebp - local_4], ecx           # 004229fe
    mov eax, 0x52c608                            # 00422a01
    {load} mov esp, ebp                          # 00422a06
    pop ebp                                      # 00422a08
    ret                                          # 00422a09

