# FUN_00514893
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514893
# extent:       0x00514893-0x005148cd (58 code bytes)
# span:         0x00514893-0x005148cd (code 58, tables 0, padding 0)
# sha256:       5f8fa04e91a2ea6c47976ce168a4869b18a51842ff6640ff2a35218504b087b8
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514893
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00514893 - 0x401000
.globl FUN_00514893
FUN_00514893:
    # block 0x00514893: entry, 8 instruction(s), ends with je to 0x005148ba (forward)
    mov edx, dword ptr [esp + stk_8]             # 00514893
    mov ecx, dword ptr [0x568adc]                # 00514897
    push esi                                     # 0051489d
    mov esi, dword ptr [esp + stk_8]             # 0051489e
    cmp dword ptr [edx], esi                     # 005148a2
    push edi                                     # 005148a4
    {load} mov eax, edx                          # 005148a5
    je.d8 L_005148ba                             # 005148a7
    # block 0x005148a9: entered by fall-through of je at 0x005148a7, 2 instruction(s), falls into the block at 0x005148af
    lea edi, [ecx + 2*ecx]                       # 005148a9
    lea edi, [edx + 4*edi]                       # 005148ac
L_005148af:
    # block 0x005148af: entered by jne at 0x005148b8, 3 instruction(s), ends with jae to 0x005148ba (forward)
    add eax, 0xc                                 # 005148af
    {load} cmp eax, edi                          # 005148b2
    jae.d8 L_005148ba                            # 005148b4
    # block 0x005148b6: entered by fall-through of jae at 0x005148b4, 2 instruction(s), ends with jne to 0x005148af (backward)
    cmp dword ptr [eax], esi                     # 005148b6
    jne.d8 L_005148af                            # 005148b8
L_005148ba:
    # block 0x005148ba: entered by je at 0x005148a7; jae at 0x005148b4; fall-through of jne at 0x005148b8, 4 instruction(s), ends with jae to 0x005148c8 (forward)
    lea ecx, [ecx + 2*ecx]                       # 005148ba
    lea ecx, [edx + 4*ecx]                       # 005148bd
    {load} cmp eax, ecx                          # 005148c0
    jae.d8 L_005148c8                            # 005148c2
    # block 0x005148c4: entered by fall-through of jae at 0x005148c2, 2 instruction(s), ends with je to 0x005148ca (forward)
    cmp dword ptr [eax], esi                     # 005148c4
    je.d8 L_005148ca                             # 005148c6
L_005148c8:
    # block 0x005148c8: entered by jae at 0x005148c2; fall-through of je at 0x005148c6, 1 instruction(s), falls into the block at 0x005148ca
    {load} xor eax, eax                          # 005148c8
L_005148ca:
    # block 0x005148ca: entered by je at 0x005148c6, 3 instruction(s), ends with ret
    pop edi                                      # 005148ca
    pop esi                                      # 005148cb
    ret                                          # 005148cc

