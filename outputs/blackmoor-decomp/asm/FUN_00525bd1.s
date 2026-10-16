# FUN_00525bd1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525bd1
# extent:       0x00525bd1-0x00525c1c (75 code bytes)
# span:         0x00525bd1-0x00525c1c (code 75, tables 0, padding 0)
# sha256:       7eee76f8bcc0d09f6f1e11ee29e880c2cd6d1bca0d601546bc9985bbc33ca90a
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525bd1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_00525ffa, FUN_0052606a; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00525ffa, .text + (0x00525ffa - 0x401000)
.set FUN_0052606a, .text + (0x0052606a - 0x401000)

.org 0x00525bd1 - 0x401000
.globl FUN_00525bd1
FUN_00525bd1:
    # block 0x00525bd1: entry, 12 instruction(s), calls FUN_0050f978, ends with jne to 0x00525c09 (forward)
    mov eax, 0x52906c                            # 00525bd1
    call FUN_0050f978                            # 00525bd6
    push ecx                                     # 00525bdb
    push ecx                                     # 00525bdc
    push ebx                                     # 00525bdd
    push esi                                     # 00525bde
    push edi                                     # 00525bdf
    {load} mov esi, ecx                          # 00525be0
    {load} xor edi, edi                          # 00525be2
    mov dword ptr [ebp - field_minus_10], esp    # 00525be4
    cmp dword ptr [esi], edi                     # 00525be7
    jne.d8 L_00525c09                            # 00525be9
    # block 0x00525beb: entered by fall-through of jne at 0x00525be9, 5 instruction(s), calls FUN_00525ffa, ends with jne to 0x00525bfe (forward)
    push 0x10                                    # 00525beb
    call FUN_00525ffa                            # 00525bed
    mov dword ptr [ebp - field_minus_4], edi     # 00525bf2
    cmp dword ptr [esi], edi                     # 00525bf5
    jne.d8 L_00525bfe                            # 00525bf7
    # block 0x00525bf9: entered by fall-through of jne at 0x00525bf7, 2 instruction(s), calls indirect dword ptr [ebp + 0x8], falls into the block at 0x00525bfe
    call dword ptr [ebp + field_8]               # 00525bf9
    mov dword ptr [esi], eax                     # 00525bfc
L_00525bfe:
    # block 0x00525bfe: entered by jne at 0x00525bf7, 3 instruction(s), calls FUN_0052606a, falls into the block at 0x00525c09
    or dword ptr [ebp - field_minus_4], -0x1     # 00525bfe
    push 0x10                                    # 00525c02
    call FUN_0052606a                            # 00525c04
L_00525c09:
    # block 0x00525c09: entered by jne at 0x00525be9, 8 instruction(s), ends with ret 0x4
    mov eax, dword ptr [esi]                     # 00525c09
    mov ecx, dword ptr [ebp - field_minus_c]     # 00525c0b
    pop edi                                      # 00525c0e
    pop esi                                      # 00525c0f
    mov dword ptr fs:[0x0], ecx                  # 00525c10
    pop ebx                                      # 00525c17
    leave                                        # 00525c18
    ret 0x4                                      # 00525c19

