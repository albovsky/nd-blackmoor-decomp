# FUN_0045b36a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b36a
# extent:       0x0045b36a-0x0045b37a (16 code bytes)
# span:         0x0045b36a-0x0045b37a (code 16, tables 0, padding 0)
# sha256:       6b456d52634b3c0a574424ffea760adc6110d16053dd90fce07948a69ee7121a
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045b36a
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

.org 0x0045b36a - 0x401000
.globl FUN_0045b36a
FUN_0045b36a:
    # block 0x0045b36a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0045b36a
    {load} mov ebp, esp                          # 0045b36b
    push ecx                                     # 0045b36d
    mov dword ptr [ebp - local_4], ecx           # 0045b36e
    mov eax, 0x52cf38                            # 0045b371
    {load} mov esp, ebp                          # 0045b376
    pop ebp                                      # 0045b378
    ret                                          # 0045b379

