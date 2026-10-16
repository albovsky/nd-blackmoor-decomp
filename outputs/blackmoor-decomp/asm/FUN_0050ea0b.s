# FUN_0050ea0b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ea0b
# extent:       0x0050ea0b-0x0050ea7e (115 code bytes)
# span:         0x0050ea0b-0x0050ea7e (code 115, tables 0, padding 0)
# sha256:       e4b2c7660400a51cf1e9ead61d63303211a8bb03222eb2f479f83dfa85a267eb
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ea0b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050ea87, FUN_0050ea7e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)

.org 0x0050ea0b - 0x401000
.globl FUN_0050ea0b
FUN_0050ea0b:
    # block 0x0050ea0b: entry, 6 instruction(s), calls FUN_0050ea87, falls into the block at 0x0050ea1e
    push esi                                     # 0050ea0b
    call FUN_0050ea87                            # 0050ea0c
    mov ecx, dword ptr [esp + stk_8]             # 0050ea11
    {load} xor esi, esi                          # 0050ea15
    mov dword ptr [eax], ecx                     # 0050ea17
    mov eax, 0x567e88                            # 0050ea19
L_0050ea1e:
    # block 0x0050ea1e: entered by jl at 0x0050ea2b, 2 instruction(s), ends with je to 0x0050ea44 (forward)
    cmp ecx, dword ptr [eax]                     # 0050ea1e
    je.d8 L_0050ea44                             # 0050ea20
    # block 0x0050ea22: entered by fall-through of je at 0x0050ea20, 4 instruction(s), ends with jl to 0x0050ea1e (backward)
    add eax, 0x8                                 # 0050ea22
    inc esi                                      # 0050ea25
    cmp eax, 0x567ff0                            # 0050ea26
    jl.d8 L_0050ea1e                             # 0050ea2b
    # block 0x0050ea2d: entered by fall-through of jl at 0x0050ea2b, 2 instruction(s), ends with jb to 0x0050ea54 (forward)
    cmp ecx, 0x13                                # 0050ea2d
    jb.d8 L_0050ea54                             # 0050ea30
    # block 0x0050ea32: entered by fall-through of jb at 0x0050ea30, 2 instruction(s), ends with ja to 0x0050ea54 (forward)
    cmp ecx, 0x24                                # 0050ea32
    ja.d8 L_0050ea54                             # 0050ea35
    # block 0x0050ea37: entered by fall-through of ja at 0x0050ea35, 4 instruction(s), calls FUN_0050ea7e, ends with ret
    call FUN_0050ea7e                            # 0050ea37
    mov dword ptr [eax], 0xd                     # 0050ea3c
    pop esi                                      # 0050ea42
    ret                                          # 0050ea43
L_0050ea44:
    # block 0x0050ea44: entered by je at 0x0050ea20, 5 instruction(s), calls FUN_0050ea7e, ends with ret
    call FUN_0050ea7e                            # 0050ea44
    mov ecx, dword ptr [8*esi + 0x567e8c]        # 0050ea49
    pop esi                                      # 0050ea50
    mov dword ptr [eax], ecx                     # 0050ea51
    ret                                          # 0050ea53
L_0050ea54:
    # block 0x0050ea54: entered by jb at 0x0050ea30; ja at 0x0050ea35, 2 instruction(s), ends with jb to 0x0050ea71 (forward)
    cmp ecx, 0xbc                                # 0050ea54
    jb.d8 L_0050ea71                             # 0050ea5a
    # block 0x0050ea5c: entered by fall-through of jb at 0x0050ea5a, 2 instruction(s), ends with ja to 0x0050ea71 (forward)
    cmp ecx, 0xca                                # 0050ea5c
    ja.d8 L_0050ea71                             # 0050ea62
    # block 0x0050ea64: entered by fall-through of ja at 0x0050ea62, 4 instruction(s), calls FUN_0050ea7e, ends with ret
    call FUN_0050ea7e                            # 0050ea64
    mov dword ptr [eax], 0x8                     # 0050ea69
    pop esi                                      # 0050ea6f
    ret                                          # 0050ea70
L_0050ea71:
    # block 0x0050ea71: entered by jb at 0x0050ea5a; ja at 0x0050ea62, 4 instruction(s), calls FUN_0050ea7e, ends with ret
    call FUN_0050ea7e                            # 0050ea71
    mov dword ptr [eax], 0x16                    # 0050ea76
    pop esi                                      # 0050ea7c
    ret                                          # 0050ea7d

