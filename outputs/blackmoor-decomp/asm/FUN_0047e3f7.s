# FUN_0047e3f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e3f7
# extent:       0x0047e3f7-0x0047e440 (73 code bytes)
# span:         0x0047e3f7-0x0047e440 (code 73, tables 0, padding 0)
# sha256:       a682b25100fdf24046627d28fbb64538aba06efc02bf3e118b8a278e392be495
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047e3f7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0047e3f7 - 0x401000
.globl FUN_0047e3f7
FUN_0047e3f7:
    # block 0x0047e3f7: entry, 21 instruction(s), ends with ret
    push ebp                                     # 0047e3f7
    {load} mov ebp, esp                          # 0047e3f8
    push ecx                                     # 0047e3fa
    push edi                                     # 0047e3fb
    mov dword ptr [ebp - local_4], ecx           # 0047e3fc
    mov dword ptr [0x5a055d], 0x0                # 0047e3ff
    mov word ptr [0x5a0561], 0x270f              # 0047e409
    mov ecx, 0x2e4                               # 0047e412
    {load} xor eax, eax                          # 0047e417
    mov edi, 0x5a0577                            # 0047e419
    rep stosd dword ptr es:[edi], eax            # 0047e41e
    {load} xor eax, eax                          # 0047e420
    mov dword ptr [0x5a0563], eax                # 0047e422
    mov dword ptr [0x5a0567], eax                # 0047e427
    mov dword ptr [0x5a056b], eax                # 0047e42c
    mov dword ptr [0x5a056f], eax                # 0047e431
    mov dword ptr [0x5a0573], eax                # 0047e436
    pop edi                                      # 0047e43b
    {load} mov esp, ebp                          # 0047e43c
    pop ebp                                      # 0047e43e
    ret                                          # 0047e43f

