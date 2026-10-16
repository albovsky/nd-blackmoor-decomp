# FUN_005146dc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005146dc
# extent:       0x005146dc-0x005146ff (35 code bytes)
# span:         0x005146dc-0x005146ff (code 35, tables 0, padding 0)
# sha256:       84749c64e12c57ce2a4dec7bdb50573ab3dd9f851b65e73be2fba62d0cfec3b2
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005146dc
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x005146dc - 0x401000
.globl FUN_005146dc
FUN_005146dc:
    # block 0x005146dc: entry, 16 instruction(s), ends with ret
    push ebp                                     # 005146dc
    {load} mov ebp, esp                          # 005146dd
    push ecx                                     # 005146df
    wait                                         # 005146e0
    fnstcw word ptr [ebp - local_4]              # 005146e1
    mov eax, dword ptr [ebp + arg_c]             # 005146e4
    {load} mov ecx, eax                          # 005146e7
    and eax, dword ptr [ebp + arg_8]             # 005146e9
    not ecx                                      # 005146ec
    and ecx, dword ptr [ebp - local_4]           # 005146ee
    {load} or ecx, eax                           # 005146f1
    mov dword ptr [ebp + arg_c], ecx             # 005146f3
    fldcw word ptr [ebp + arg_c]                 # 005146f6
    movsx eax, word ptr [ebp - local_4]          # 005146f9
    leave                                        # 005146fd
    ret                                          # 005146fe

