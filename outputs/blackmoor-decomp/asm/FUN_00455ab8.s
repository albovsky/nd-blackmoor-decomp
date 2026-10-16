# FUN_00455ab8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00455ab8
# extent:       0x00455ab8-0x00455b2e (118 code bytes)
# span:         0x00455ab8-0x00455b2e (code 118, tables 0, padding 0)
# sha256:       687ea22b804798052a4dd74476665d244fd11781caf775fd0004cc117883a7e5
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00455ab8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_16e, field_76e; [edx + n] field_155
# callees:      calls FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_155, 0x155  # offset +0x155
.equ field_16e, 0x16e  # offset +0x16e
.equ field_76e, 0x76e  # offset +0x76e

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00455ab8 - 0x401000
.globl FUN_00455ab8
FUN_00455ab8:
    # block 0x00455ab8: entry, 18 instruction(s), ends with je to 0x00455b28 (forward)
    push ebp                                     # 00455ab8
    {load} mov ebp, esp                          # 00455ab9
    sub esp, 0x8                                 # 00455abb
    push esi                                     # 00455abe
    push edi                                     # 00455abf
    mov dword ptr [ebp - local_8], ecx           # 00455ac0
    mov eax, dword ptr [ebp - local_8]           # 00455ac3
    movsx ecx, word ptr [eax + field_1e]         # 00455ac6
    imul ecx, ecx, 0x8d                          # 00455aca
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00455ad0
    mov dword ptr [ebp - local_4], edx           # 00455ad6
    mov edi, 0x54a050                            # 00455ad9
    mov esi, dword ptr [ebp - local_4]           # 00455ade
    add esi, 0x74d                               # 00455ae1
    mov ecx, 0x9                                 # 00455ae7
    {load} xor eax, eax                          # 00455aec
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00455aee
    je.d8 L_00455b28                             # 00455af0
    # block 0x00455af2: entered by fall-through of je at 0x00455af0, 11 instruction(s), calls FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x00455b28
    mov ecx, dword ptr [ebp - local_4]           # 00455af2
    mov dx, word ptr [ecx + field_76e]           # 00455af5
    push edx                                     # 00455afc
    mov ecx, 0x5c3a67                            # 00455afd
    call FUN_004fb2e3                            # 00455b02
    call dword ptr [0x52a23c]                    # 00455b07
    add eax, 0x15e                               # 00455b0d
    mov ecx, dword ptr [ebp - local_8]           # 00455b12
    mov dword ptr [ecx + field_16e], eax         # 00455b15
    mov edx, dword ptr [ebp - local_8]           # 00455b1b
    mov dword ptr [edx + field_155], 0x1         # 00455b1e
L_00455b28:
    # block 0x00455b28: entered by je at 0x00455af0, 5 instruction(s), ends with ret
    pop edi                                      # 00455b28
    pop esi                                      # 00455b29
    {load} mov esp, ebp                          # 00455b2a
    pop ebp                                      # 00455b2c
    ret                                          # 00455b2d

