# FUN_0040b2d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040b2d0
# extent:       0x0040b2d0-0x0040b31a (74 code bytes)
# span:         0x0040b2d0-0x0040b34a (code 74, tables 48, padding 0)
# sha256:       c7ed5199d4c54414ba54456a74fc5fadbdcb75f62840447389ebf91986264135
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040b2d0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_17_runtime.c:action17_cursor_index_for_type (function ledger class native_tests_only; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0040b2d0 - 0x401000
.globl FUN_0040b2d0
FUN_0040b2d0:
    # block 0x0040b2d0: entry, 11 instruction(s), ends with ja to 0x0040b314 (forward)
    push ebp                                     # 0040b2d0
    {load} mov ebp, esp                          # 0040b2d1
    push ecx                                     # 0040b2d3
    mov eax, dword ptr [ebp + arg_8]             # 0040b2d4
    and eax, 0xff                                # 0040b2d7
    mov dword ptr [ebp - local_4], eax           # 0040b2dc
    mov ecx, dword ptr [ebp - local_4]           # 0040b2df
    sub ecx, 0xe                                 # 0040b2e2
    mov dword ptr [ebp - local_4], ecx           # 0040b2e5
    cmp dword ptr [ebp - local_4], 0xb           # 0040b2e8
    ja.d8 L_0040b314                             # 0040b2ec
    # block 0x0040b2ee: entered by fall-through of ja at 0x0040b2ec, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x40b31a]
    mov edx, dword ptr [ebp - local_4]           # 0040b2ee
    jmp dword ptr [4*edx + SWTAB_0040b31a_VA]    # 0040b2f1
L_0040b2f8:
    # block 0x0040b2f8: entered by switch case, 2 instruction(s), ends with forward jump to 0x0040b316
    mov al, 0x5                                  # 0040b2f8
    jmp.d8 L_0040b316                            # 0040b2fa
L_0040b2fc:
    # block 0x0040b2fc: entered by switch case, 2 instruction(s), ends with forward jump to 0x0040b316
    mov al, 0x9                                  # 0040b2fc
    jmp.d8 L_0040b316                            # 0040b2fe
L_0040b300:
    # block 0x0040b300: entered by switch case, 2 instruction(s), ends with forward jump to 0x0040b316
    mov al, 0x6                                  # 0040b300
    jmp.d8 L_0040b316                            # 0040b302
L_0040b304:
    # block 0x0040b304: entered by switch case, 2 instruction(s), ends with forward jump to 0x0040b316
    mov al, 0x7                                  # 0040b304
    jmp.d8 L_0040b316                            # 0040b306
L_0040b308:
    # block 0x0040b308: entered by switch case, 2 instruction(s), ends with forward jump to 0x0040b316
    mov al, 0x8                                  # 0040b308
    jmp.d8 L_0040b316                            # 0040b30a
L_0040b30c:
    # block 0x0040b30c: entered by switch case, 2 instruction(s), ends with forward jump to 0x0040b316
    mov al, 0xa                                  # 0040b30c
    jmp.d8 L_0040b316                            # 0040b30e
L_0040b310:
    # block 0x0040b310: entered by switch case, 2 instruction(s), ends with forward jump to 0x0040b316
    mov al, 0xb                                  # 0040b310
    jmp.d8 L_0040b316                            # 0040b312
L_0040b314:
    # block 0x0040b314: entered by ja at 0x0040b2ec; switch case, 1 instruction(s), falls into the block at 0x0040b316
    {load} xor al, al                            # 0040b314
L_0040b316:
    # block 0x0040b316: entered by jmp at 0x0040b2fa; jmp at 0x0040b2fe; jmp at 0x0040b302; jmp at 0x0040b306; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0040b316
    pop ebp                                      # 0040b318
    ret                                          # 0040b319

# --- data items (not part of the function) -------------------------
.org 0x0040b31a - 0x401000
SWTAB_0040b31a:  # 12 case address(es)
    .long L_0040b2f8 - .text + 0x401000
    .long L_0040b308 - .text + 0x401000
    .long L_0040b2fc - .text + 0x401000
    .long L_0040b30c - .text + 0x401000
    .long L_0040b310 - .text + 0x401000
    .long L_0040b300 - .text + 0x401000
    .long L_0040b304 - .text + 0x401000
    .long L_0040b314 - .text + 0x401000
    .long L_0040b314 - .text + 0x401000
    .long L_0040b308 - .text + 0x401000
    .long L_0040b30c - .text + 0x401000
    .long L_0040b310 - .text + 0x401000
.set SWTAB_0040b31a_VA, SWTAB_0040b31a - .text + 0x401000

