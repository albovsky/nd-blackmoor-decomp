# FUN_0050e761
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e761
# extent:       0x0050e761-0x0050e781 (32 code bytes)
# span:         0x0050e761-0x0050e781 (code 32, tables 0, padding 0)
# sha256:       ebbccb7223226fd09c851c1b307900d7b0584c613eabfb698c0f271d422028d1
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e761
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls KERNEL32.dll!FindClose, FUN_0050ea7e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)

.org 0x0050e761 - 0x401000
.globl FUN_0050e761
FUN_0050e761:
    # block 0x0050e761: entry, 4 instruction(s), calls KERNEL32.dll!FindClose, ends with jne to 0x0050e77e (forward)
    push dword ptr [esp + stk_4]                 # 0050e761
    call dword ptr [0x52a110]                    # 0050e765
    test eax, eax                                # 0050e76b
    jne.d8 L_0050e77e                            # 0050e76d
    # block 0x0050e76f: entered by fall-through of jne at 0x0050e76d, 4 instruction(s), calls FUN_0050ea7e, ends with ret
    call FUN_0050ea7e                            # 0050e76f
    mov dword ptr [eax], 0x16                    # 0050e774
    or eax, -0x1                                 # 0050e77a
    ret                                          # 0050e77d
L_0050e77e:
    # block 0x0050e77e: entered by jne at 0x0050e76d, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050e77e
    ret                                          # 0050e780

