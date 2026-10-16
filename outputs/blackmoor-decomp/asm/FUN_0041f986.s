# FUN_0041f986
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041f986
# extent:       0x0041f986-0x0041fa11 (139 code bytes)
# span:         0x0041f986-0x0041fa11 (code 139, tables 0, padding 0)
# sha256:       4ecaa6058ea78bb879facfba9cbc086bf37ea8054a039fddaf12c87a6fcd96fd
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041f986
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_ea5; [ecx + n] field_ea5; [edx + n] field_ea5
# callees:      calls FUN_0051e745, FUN_0051ea75, FUN_0051eac4
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:build_list (function ledger class candidate_port; also phase0; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 40 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_ea5, 0xea5  # offset +0xea5

# --- external targets -----------------------------------------------
.set FUN_0051e745, .text + (0x0051e745 - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)

.org 0x0041f986 - 0x401000
.globl FUN_0041f986
FUN_0041f986:
    # block 0x0041f986: entry, 7 instruction(s), ends with forward jump to 0x0041f9a4
    push ebp                                     # 0041f986
    {load} mov ebp, esp                          # 0041f987
    sub esp, 0xc                                 # 0041f989
    push edi                                     # 0041f98c
    mov dword ptr [ebp - local_c], ecx           # 0041f98d
    mov word ptr [ebp - local_4], 0x0            # 0041f990
    jmp.d8 L_0041f9a4                            # 0041f996
L_0041f998:
    # block 0x0041f998: entered by jmp at 0x0041f9fc, 3 instruction(s), falls into the block at 0x0041f9a4
    mov ax, word ptr [ebp - local_4]             # 0041f998
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041f99c
    mov word ptr [ebp - local_4], ax             # 0041f9a0
L_0041f9a4:
    # block 0x0041f9a4: entered by jmp at 0x0041f996, 3 instruction(s), ends with jge to 0x0041f9fe (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041f9a4
    cmp ecx, 0x1e                                # 0041f9a8
    jge.d8 L_0041f9fe                            # 0041f9ab
    # block 0x0041f9ad: entered by fall-through of jge at 0x0041f9ab, 20 instruction(s), calls FUN_0051e745, FUN_0051ea75, FUN_0051eac4, ends with backward jump to 0x0041f998
    movsx edx, word ptr [ebp - local_4]          # 0041f9ad
    mov eax, dword ptr [ebp - local_c]           # 0041f9b1
    lea ecx, [eax + 4*edx + field_ea5]           # 0041f9b4
    call FUN_0051e745                            # 0041f9bb
    push 0x190                                   # 0041f9c0
    movsx ecx, word ptr [ebp - local_4]          # 0041f9c5
    mov edx, dword ptr [ebp - local_c]           # 0041f9c9
    lea ecx, [edx + 4*ecx + field_ea5]           # 0041f9cc
    call FUN_0051ea75                            # 0041f9d3
    mov dword ptr [ebp - local_8], eax           # 0041f9d8
    mov ecx, 0x64                                # 0041f9db
    {load} xor eax, eax                          # 0041f9e0
    mov edi, dword ptr [ebp - local_8]           # 0041f9e2
    rep stosd dword ptr es:[edi], eax            # 0041f9e5
    push -0x1                                    # 0041f9e7
    movsx eax, word ptr [ebp - local_4]          # 0041f9e9
    mov ecx, dword ptr [ebp - local_c]           # 0041f9ed
    lea ecx, [ecx + 4*eax + field_ea5]           # 0041f9f0
    call FUN_0051eac4                            # 0041f9f7
    jmp.d8 L_0041f998                            # 0041f9fc
L_0041f9fe:
    # block 0x0041f9fe: entered by jge at 0x0041f9ab, 7 instruction(s), calls FUN_0051e745, ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0041f9fe
    add ecx, 0xf1d                               # 0041fa01
    call FUN_0051e745                            # 0041fa07
    pop edi                                      # 0041fa0c
    {load} mov esp, ebp                          # 0041fa0d
    pop ebp                                      # 0041fa0f
    ret                                          # 0041fa10

