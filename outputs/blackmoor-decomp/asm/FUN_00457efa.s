# FUN_00457efa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457efa
# extent:       0x00457efa-0x00457f0a (16 code bytes)
# span:         0x00457efa-0x00457f0a (code 16, tables 0, padding 0)
# sha256:       76cfc744c3b314fd823d1aa901ea876702549dd1ecc7e852fdda567aef784927
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00457efa
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

.org 0x00457efa - 0x401000
.globl FUN_00457efa
FUN_00457efa:
    # block 0x00457efa: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00457efa
    {load} mov ebp, esp                          # 00457efb
    push ecx                                     # 00457efd
    mov dword ptr [ebp - local_4], ecx           # 00457efe
    mov eax, 0x52ce28                            # 00457f01
    {load} mov esp, ebp                          # 00457f06
    pop ebp                                      # 00457f08
    ret                                          # 00457f09

