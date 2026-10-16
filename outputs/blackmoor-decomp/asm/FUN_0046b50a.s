# FUN_0046b50a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b50a
# extent:       0x0046b50a-0x0046b51a (16 code bytes)
# span:         0x0046b50a-0x0046b51a (code 16, tables 0, padding 0)
# sha256:       7be40a0198ea63e8e85bbefdc6b0c06b09a5029a72868d025fca0f02b76b5f4f
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046b50a
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

.org 0x0046b50a - 0x401000
.globl FUN_0046b50a
FUN_0046b50a:
    # block 0x0046b50a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0046b50a
    {load} mov ebp, esp                          # 0046b50b
    push ecx                                     # 0046b50d
    mov dword ptr [ebp - local_4], ecx           # 0046b50e
    mov eax, 0x52d2b0                            # 0046b511
    {load} mov esp, ebp                          # 0046b516
    pop ebp                                      # 0046b518
    ret                                          # 0046b519

