# FUN_00521077
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521077
# extent:       0x00521077-0x005210a2 (43 code bytes)
# span:         0x00521077-0x005210a2 (code 43, tables 0, padding 0)
# sha256:       99132818e20f035eec9ba0295a296762f54fbf2bc7708959636a4e658e4cfeaf
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521077
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_20
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls USER32.dll!GetClassNameA, KERNEL32.dll!lstrcmpiA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_20, 0x20  # offset -0x20
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00521077 - 0x401000
.globl FUN_00521077
FUN_00521077:
    # block 0x00521077: entry, 17 instruction(s), calls USER32.dll!GetClassNameA, KERNEL32.dll!lstrcmpiA, ends with ret 0x8
    push ebp                                     # 00521077
    {load} mov ebp, esp                          # 00521078
    sub esp, 0x20                                # 0052107a
    lea eax, [ebp - local_20]                    # 0052107d
    push 0x20                                    # 00521080
    push eax                                     # 00521082
    push dword ptr [ebp + arg_8]                 # 00521083
    call dword ptr [0x52a3b8]                    # 00521086
    push dword ptr [ebp + arg_c]                 # 0052108c
    lea eax, [ebp - local_20]                    # 0052108f
    push eax                                     # 00521092
    call dword ptr [0x52a230]                    # 00521093
    neg eax                                      # 00521099
    {load} sbb eax, eax                          # 0052109b
    inc eax                                      # 0052109d
    leave                                        # 0052109e
    ret 0x8                                      # 0052109f

