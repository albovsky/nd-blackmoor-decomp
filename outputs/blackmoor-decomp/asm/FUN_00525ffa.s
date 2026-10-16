# FUN_00525ffa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525ffa
# extent:       0x00525ffa-0x0052606a (112 code bytes)
# span:         0x00525ffa-0x0052606a (code 112, tables 0, padding 0)
# sha256:       a1147d1cb6f29eaee435d5d625a7464d621463e10943d67fca7bc9236896917c
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525ffa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10
# callees:      calls FUN_00525f67, KERNEL32.dll!InitializeCriticalSection, KERNEL32.dll!LeaveCriticalSection; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00525f67, .text + (0x00525f67 - 0x401000)

.org 0x00525ffa - 0x401000
.globl FUN_00525ffa
FUN_00525ffa:
    # block 0x00525ffa: entry, 4 instruction(s), ends with jne to 0x0052600a (forward)
    push ebx                                     # 00525ffa
    {load} xor ebx, ebx                          # 00525ffb
    cmp dword ptr [0x63c9e4], ebx                # 00525ffd
    jne.d8 L_0052600a                            # 00526003
    # block 0x00526005: entered by fall-through of jne at 0x00526003, 1 instruction(s), calls FUN_00525f67, falls into the block at 0x0052600a
    call FUN_00525f67                            # 00526005
L_0052600a:
    # block 0x0052600a: entered by jne at 0x00526003, 2 instruction(s), ends with jne to 0x00526066 (forward)
    cmp dword ptr [0x63c9e0], ebx                # 0052600a
    jne.d8 L_00526066                            # 00526010
    # block 0x00526012: entered by fall-through of jne at 0x00526010, 7 instruction(s), ends with jne to 0x00526057 (forward)
    push esi                                     # 00526012
    push edi                                     # 00526013
    mov edi, dword ptr [esp + stk_10]            # 00526014
    cmp dword ptr [4*edi + 0x63c7e8], ebx        # 00526018
    mov ebx, dword ptr [0x52a0d0]                # 0052601f
    lea esi, [4*edi + 0x63c7e8]                  # 00526025
    jne.d8 L_00526057                            # 0052602c
    # block 0x0052602e: entered by fall-through of jne at 0x0052602c, 6 instruction(s), calls indirect ebx, ends with jne to 0x0052604f (forward)
    push ebp                                     # 0052602e
    mov ebp, 0x63c830                            # 0052602f
    push ebp                                     # 00526034
    call ebx                                     # 00526035
    cmp dword ptr [esi], 0x0                     # 00526037
    jne.d8 L_0052604f                            # 0052603a
    # block 0x0052603c: entered by fall-through of jne at 0x0052603a, 5 instruction(s), calls KERNEL32.dll!InitializeCriticalSection, falls into the block at 0x0052604f
    lea eax, [edi + 2*edi]                       # 0052603c
    lea eax, [8*eax + 0x63c848]                  # 0052603f
    push eax                                     # 00526046
    call dword ptr [0x52a0b4]                    # 00526047
    inc dword ptr [esi]                          # 0052604d
L_0052604f:
    # block 0x0052604f: entered by jne at 0x0052603a, 3 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, falls into the block at 0x00526057
    push ebp                                     # 0052604f
    call dword ptr [0x52a0c8]                    # 00526050
    pop ebp                                      # 00526056
L_00526057:
    # block 0x00526057: entered by jne at 0x0052602c, 6 instruction(s), calls indirect ebx, falls into the block at 0x00526066
    lea eax, [edi + 2*edi]                       # 00526057
    lea eax, [8*eax + 0x63c848]                  # 0052605a
    push eax                                     # 00526061
    call ebx                                     # 00526062
    pop edi                                      # 00526064
    pop esi                                      # 00526065
L_00526066:
    # block 0x00526066: entered by jne at 0x00526010, 2 instruction(s), ends with ret 0x4
    pop ebx                                      # 00526066
    ret 0x4                                      # 00526067

