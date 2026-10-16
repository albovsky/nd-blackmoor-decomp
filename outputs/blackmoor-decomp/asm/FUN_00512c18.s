# FUN_00512c18
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512c18
# extent:       0x00512c18-0x00512c79 (97 code bytes)
# span:         0x00512c18-0x00512c79 (code 97, tables 0, padding 0)
# sha256:       2c70ab089f646cf87bd3ebd0007ba19c0e78d9af69a3caca871509f334423772
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512c18
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ea90, FUN_0050e8ed, FUN_00512c18, KERNEL32.dll!InitializeCriticalSection, FUN_0050e936, FUN_00512c79, KERNEL32.dll!EnterCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x00512c18 - 0x401000
.globl FUN_00512c18
FUN_00512c18:
L_00512c18:
    # block 0x00512c18: entry, 7 instruction(s), ends with jne to 0x00512c6e (forward)
    push ebp                                     # 00512c18
    {load} mov ebp, esp                          # 00512c19
    mov eax, dword ptr [ebp + arg_8]             # 00512c1b
    push esi                                     # 00512c1e
    cmp dword ptr [4*eax + 0x5686b0], 0x0        # 00512c1f
    lea esi, [4*eax + 0x5686b0]                  # 00512c27
    jne.d8 L_00512c6e                            # 00512c2e
    # block 0x00512c30: entered by fall-through of jne at 0x00512c2e, 7 instruction(s), calls FUN_0050ea90, ends with jne to 0x00512c47 (forward)
    push edi                                     # 00512c30
    push 0x18                                    # 00512c31
    call FUN_0050ea90                            # 00512c33
    {load} mov edi, eax                          # 00512c38
    pop ecx                                      # 00512c3a
    test edi, edi                                # 00512c3b
    jne.d8 L_00512c47                            # 00512c3d
    # block 0x00512c3f: entered by fall-through of jne at 0x00512c3d, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x00512c47
    push 0x11                                    # 00512c3f
    call FUN_0050e8ed                            # 00512c41
    pop ecx                                      # 00512c46
L_00512c47:
    # block 0x00512c47: entered by jne at 0x00512c3d, 6 instruction(s), calls FUN_00512c18, ends with jne to 0x00512c5f (forward)
    push 0x11                                    # 00512c47
    call L_00512c18                              # 00512c49
    cmp dword ptr [esi], 0x0                     # 00512c4e
    pop ecx                                      # 00512c51
    push edi                                     # 00512c52
    jne.d8 L_00512c5f                            # 00512c53
    # block 0x00512c55: entered by fall-through of jne at 0x00512c53, 3 instruction(s), calls KERNEL32.dll!InitializeCriticalSection, ends with forward jump to 0x00512c65
    call dword ptr [0x52a0b4]                    # 00512c55
    mov dword ptr [esi], edi                     # 00512c5b
    jmp.d8 L_00512c65                            # 00512c5d
L_00512c5f:
    # block 0x00512c5f: entered by jne at 0x00512c53, 2 instruction(s), calls FUN_0050e936, falls into the block at 0x00512c65
    call FUN_0050e936                            # 00512c5f
    pop ecx                                      # 00512c64
L_00512c65:
    # block 0x00512c65: entered by jmp at 0x00512c5d, 4 instruction(s), calls FUN_00512c79, falls into the block at 0x00512c6e
    push 0x11                                    # 00512c65
    call FUN_00512c79                            # 00512c67
    pop ecx                                      # 00512c6c
    pop edi                                      # 00512c6d
L_00512c6e:
    # block 0x00512c6e: entered by jne at 0x00512c2e, 5 instruction(s), calls KERNEL32.dll!EnterCriticalSection, ends with ret
    push dword ptr [esi]                         # 00512c6e
    call dword ptr [0x52a0d0]                    # 00512c70
    pop esi                                      # 00512c76
    pop ebp                                      # 00512c77
    ret                                          # 00512c78

