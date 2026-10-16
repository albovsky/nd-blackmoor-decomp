# FUN_0051c9ac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c9ac
# extent:       0x0051c9ac-0x0051c9d3 (39 code bytes)
# span:         0x0051c9ac-0x0051c9d3 (code 39, tables 0, padding 0)
# sha256:       52dc2b64f8b4860e12be6f24c381e9e45b29a971563d83b840299eb57acf20b7
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c9ac
# arguments:    1 ebp-relative stack slot(s) referenced: arg_c; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051c4ec, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c4ec, .text + (0x0051c4ec - 0x401000)

.org 0x0051c9ac - 0x401000
.globl FUN_0051c9ac
FUN_0051c9ac:
    # block 0x0051c9ac: entry, 10 instruction(s), calls FUN_0051c4ec, ends with je to 0x0051c9c7 (forward)
    push ebp                                     # 0051c9ac
    {load} mov ebp, esp                          # 0051c9ad
    push esi                                     # 0051c9af
    {load} mov esi, ecx                          # 0051c9b0
    mov ecx, dword ptr [ebp + arg_c]             # 0051c9b2
    lea eax, [ebp + arg_c]                       # 0051c9b5
    push eax                                     # 0051c9b8
    call FUN_0051c4ec                            # 0051c9b9
    test eax, eax                                # 0051c9be
    je.d8 L_0051c9c7                             # 0051c9c0
    # block 0x0051c9c2: entered by fall-through of je at 0x0051c9c0, 2 instruction(s), ends with forward jump to 0x0051c9ce
    mov eax, dword ptr [ebp + arg_c]             # 0051c9c2
    jmp.d8 L_0051c9ce                            # 0051c9c5
L_0051c9c7:
    # block 0x0051c9c7: entered by je at 0x0051c9c0, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051c9ce
    {load} mov ecx, esi                          # 0051c9c7
    call FUN_0051ab4b                            # 0051c9c9
L_0051c9ce:
    # block 0x0051c9ce: entered by jmp at 0x0051c9c5, 3 instruction(s), ends with ret 0xc
    pop esi                                      # 0051c9ce
    pop ebp                                      # 0051c9cf
    ret 0xc                                      # 0051c9d0

