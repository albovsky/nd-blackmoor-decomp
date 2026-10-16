# FUN_005102cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005102cf
# extent:       0x005102cf-0x00510319 (74 code bytes)
# span:         0x005102cf-0x00510319 (code 74, tables 0, padding 0)
# sha256:       5cd7939c25420eccc6e9ee051fa621a6a58462c828e38b85a10077d1dbec37b8
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005102cf
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x005102cf - 0x401000
.globl FUN_005102cf
FUN_005102cf:
    # block 0x005102cf: entry, 4 instruction(s), ends with jne to 0x005102ef (forward)
    mov eax, dword ptr [esp + stk_4]             # 005102cf
    and dword ptr [0x63ca74], 0x0                # 005102d3
    cmp eax, -0x2                                # 005102da
    jne.d8 L_005102ef                            # 005102dd
    # block 0x005102df: entered by fall-through of jne at 0x005102dd, 2 instruction(s), ends with indirect jump dword ptr [0x52a0ec]
    mov dword ptr [0x63ca74], 0x1                # 005102df
    jmp dword ptr [0x52a0ec]                     # 005102e9
L_005102ef:
    # block 0x005102ef: entered by jne at 0x005102dd, 2 instruction(s), ends with jne to 0x00510304 (forward)
    cmp eax, -0x3                                # 005102ef
    jne.d8 L_00510304                            # 005102f2
    # block 0x005102f4: entered by fall-through of jne at 0x005102f2, 2 instruction(s), ends with indirect jump dword ptr [0x52a168]
    mov dword ptr [0x63ca74], 0x1                # 005102f4
    jmp dword ptr [0x52a168]                     # 005102fe
L_00510304:
    # block 0x00510304: entered by jne at 0x005102f2, 2 instruction(s), ends with jne to 0x00510318 (forward)
    cmp eax, -0x4                                # 00510304
    jne.d8 L_00510318                            # 00510307
    # block 0x00510309: entered by fall-through of jne at 0x00510307, 2 instruction(s), falls into the block at 0x00510318
    mov eax, dword ptr [0x63cb2c]                # 00510309
    mov dword ptr [0x63ca74], 0x1                # 0051030e
L_00510318:
    # block 0x00510318: entered by jne at 0x00510307, 1 instruction(s), ends with ret
    ret                                          # 00510318

