# FUN_0046dea0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046dea0
# extent:       0x0046dea0-0x0046deb0 (16 code bytes)
# span:         0x0046dea0-0x0046deb0 (code 16, tables 0, padding 0)
# sha256:       515233c4127dfed703a22e55cc9bc2c44444552ac56c056eb260c5e69c659f16
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046dea0
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

.org 0x0046dea0 - 0x401000
.globl FUN_0046dea0
FUN_0046dea0:
    # block 0x0046dea0: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0046dea0
    {load} mov ebp, esp                          # 0046dea1
    push ecx                                     # 0046dea3
    mov dword ptr [ebp - local_4], ecx           # 0046dea4
    mov eax, 0x52d2c8                            # 0046dea7
    {load} mov esp, ebp                          # 0046deac
    pop ebp                                      # 0046deae
    ret                                          # 0046deaf

