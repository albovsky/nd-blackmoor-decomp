# FUN_0048a3cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a3cb
# extent:       0x0048a3cb-0x0048a3db (16 code bytes)
# span:         0x0048a3cb-0x0048a3db (code 16, tables 0, padding 0)
# sha256:       705fea13cf6d97218e728c33248f3d4ee613886464e808b9f32db0493100a2e4
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048a3cb
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

.org 0x0048a3cb - 0x401000
.globl FUN_0048a3cb
FUN_0048a3cb:
    # block 0x0048a3cb: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048a3cb
    {load} mov ebp, esp                          # 0048a3cc
    push ecx                                     # 0048a3ce
    mov dword ptr [ebp - local_4], ecx           # 0048a3cf
    mov eax, 0x52d830                            # 0048a3d2
    {load} mov esp, ebp                          # 0048a3d7
    pop ebp                                      # 0048a3d9
    ret                                          # 0048a3da

