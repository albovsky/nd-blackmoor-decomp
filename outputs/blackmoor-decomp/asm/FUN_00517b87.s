# FUN_00517b87
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00517b87
# extent:       0x00517b87-0x00518026 (1183 code bytes)
# span:         0x00517b87-0x00518026 (code 1183, tables 0, padding 0)
# sha256:       a316b9e12b34528ccc733ba5c54259440a944242b99b95f0c1d5a0f11a034d64
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x3eb)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00517b87
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c, stk_20
# callees:      calls FUN_00517a70
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 412 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         switch_table_outside_text:0x00568d2e
# note:         further_unindexed_code_at:0x00518026
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_00517a70, .text + (0x00517a70 - 0x401000)

.org 0x00517b87 - 0x401000
.globl FUN_00517b87
FUN_00517b87:
    # block 0x00517b87: entry, 3 instruction(s), ends with indirect jump dword ptr [4*eax + 0x568d2e]
    sub esp, 0x2c                                # 00517b87
    and eax, 0x3f                                # 00517b8a
    jmp dword ptr [4*eax + 0x568d2e]             # 00517b8d
L_00517b94:
    # block 0x00517b94: entered by fall-through, 3 instruction(s), ends with ret
    fdiv st, st(0)                               # 00517b94
    add esp, 0x2c                                # 00517b96
    ret                                          # 00517b99
L_00517b9a:
    # block 0x00517b9a: entered by fall-through, 2 instruction(s), falls into the block at 0x00517b9f
    add esp, 0x2c                                # 00517b9a
    int 0x6                                      # 00517b9d
L_00517b9f:
    # block 0x00517b9f: entered by fall-through, 3 instruction(s), ends with ret
    fdivr st, st(0)                              # 00517b9f
    add esp, 0x2c                                # 00517ba1
    ret                                          # 00517ba4
L_00517ba5:
    # block 0x00517ba5: entered by fall-through, 2 instruction(s), falls into the block at 0x00517baa
    add esp, 0x2c                                # 00517ba5
    int 0x6                                      # 00517ba8
L_00517baa:
    # block 0x00517baa: entered by fall-through, 3 instruction(s), ends with ret
    fdiv st, st(0)                               # 00517baa
    add esp, 0x2c                                # 00517bac
    ret                                          # 00517baf
L_00517bb0:
    # block 0x00517bb0: entered by fall-through, 3 instruction(s), ends with ret
    fdivp st(0), st                              # 00517bb0
    add esp, 0x2c                                # 00517bb2
    ret                                          # 00517bb5
L_00517bb6:
    # block 0x00517bb6: entered by fall-through, 3 instruction(s), ends with ret
    fdivr st, st(0)                              # 00517bb6
    add esp, 0x2c                                # 00517bb8
    ret                                          # 00517bbb
L_00517bbc:
    # block 0x00517bbc: entered by fall-through, 3 instruction(s), ends with ret
    fdivrp st(0), st                             # 00517bbc
    add esp, 0x2c                                # 00517bbe
    ret                                          # 00517bc1
L_00517bc2:
    # block 0x00517bc2: entered by fall-through, 9 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517bc2
    fld st(0)                                    # 00517bc6
    fstp tbyte ptr [esp]                         # 00517bc8
    fstp tbyte ptr [esp + stk_20]                # 00517bcb
    call FUN_00517a70                            # 00517bcf
    fld tbyte ptr [esp + stk_20]                 # 00517bd4
    fxch st(1)                                   # 00517bd8
    add esp, 0x2c                                # 00517bda
    ret                                          # 00517bdd
L_00517bde:
    # block 0x00517bde: entered by fall-through, 2 instruction(s), falls into the block at 0x00517be3
    add esp, 0x2c                                # 00517bde
    int 0x6                                      # 00517be1
L_00517be3:
    # block 0x00517be3: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517be3
    fstp tbyte ptr [esp + stk_c]                 # 00517be6
    call FUN_00517a70                            # 00517bea
    fld tbyte ptr [esp + stk_c]                  # 00517bef
    fxch st(1)                                   # 00517bf3
    add esp, 0x2c                                # 00517bf5
    ret                                          # 00517bf8
L_00517bf9:
    # block 0x00517bf9: entered by fall-through, 2 instruction(s), falls into the block at 0x00517bfe
    add esp, 0x2c                                # 00517bf9
    int 0x6                                      # 00517bfc
L_00517bfe:
    # block 0x00517bfe: entered by fall-through, 9 instruction(s), calls FUN_00517a70, ends with ret
    fxch st(1)                                   # 00517bfe
    fstp tbyte ptr [esp + stk_c]                 # 00517c00
    fld st(0)                                    # 00517c04
    fstp tbyte ptr [esp]                         # 00517c06
    fstp tbyte ptr [esp + stk_20]                # 00517c09
    call FUN_00517a70                            # 00517c0d
    fld tbyte ptr [esp + stk_20]                 # 00517c12
    add esp, 0x2c                                # 00517c16
    ret                                          # 00517c19
L_00517c1a:
    # block 0x00517c1a: entered by fall-through, 5 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517c1a
    fstp tbyte ptr [esp + stk_c]                 # 00517c1d
    call FUN_00517a70                            # 00517c21
    add esp, 0x2c                                # 00517c26
    ret                                          # 00517c29
L_00517c2a:
    # block 0x00517c2a: entered by fall-through, 6 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517c2a
    fstp tbyte ptr [esp]                         # 00517c2e
    call FUN_00517a70                            # 00517c31
    fld tbyte ptr [esp + stk_c]                  # 00517c36
    add esp, 0x2c                                # 00517c3a
    ret                                          # 00517c3d
L_00517c3e:
    # block 0x00517c3e: entered by fall-through, 5 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517c3e
    fstp tbyte ptr [esp]                         # 00517c42
    call FUN_00517a70                            # 00517c45
    add esp, 0x2c                                # 00517c4a
    ret                                          # 00517c4d
L_00517c4e:
    # block 0x00517c4e: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517c4e
    fxch st(1)                                   # 00517c52
    fld st(0)                                    # 00517c54
    fstp tbyte ptr [esp]                         # 00517c56
    fstp tbyte ptr [esp + stk_20]                # 00517c59
    call FUN_00517a70                            # 00517c5d
    fxch st(1)                                   # 00517c62
    fld tbyte ptr [esp + stk_20]                 # 00517c64
    fxch st(2)                                   # 00517c68
    add esp, 0x2c                                # 00517c6a
    ret                                          # 00517c6d
L_00517c6e:
    # block 0x00517c6e: entered by fall-through, 2 instruction(s), falls into the block at 0x00517c73
    add esp, 0x2c                                # 00517c6e
    int 0x6                                      # 00517c71
L_00517c73:
    # block 0x00517c73: entered by fall-through, 9 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517c73
    fxch st(1)                                   # 00517c76
    fstp tbyte ptr [esp + stk_c]                 # 00517c78
    call FUN_00517a70                            # 00517c7c
    fxch st(1)                                   # 00517c81
    fld tbyte ptr [esp + stk_c]                  # 00517c83
    fxch st(2)                                   # 00517c87
    add esp, 0x2c                                # 00517c89
    ret                                          # 00517c8c
L_00517c8d:
    # block 0x00517c8d: entered by fall-through, 2 instruction(s), falls into the block at 0x00517c92
    add esp, 0x2c                                # 00517c8d
    int 0x6                                      # 00517c90
L_00517c92:
    # block 0x00517c92: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fxch st(2)                                   # 00517c92
    fstp tbyte ptr [esp + stk_c]                 # 00517c94
    fxch st(1)                                   # 00517c98
    fld st(0)                                    # 00517c9a
    fstp tbyte ptr [esp]                         # 00517c9c
    fstp tbyte ptr [esp + stk_20]                # 00517c9f
    call FUN_00517a70                            # 00517ca3
    fxch st(1)                                   # 00517ca8
    fld tbyte ptr [esp + stk_20]                 # 00517caa
    add esp, 0x2c                                # 00517cae
    ret                                          # 00517cb1
L_00517cb2:
    # block 0x00517cb2: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517cb2
    fxch st(1)                                   # 00517cb5
    fstp tbyte ptr [esp + stk_c]                 # 00517cb7
    call FUN_00517a70                            # 00517cbb
    fxch st(1)                                   # 00517cc0
    add esp, 0x2c                                # 00517cc2
    ret                                          # 00517cc5
L_00517cc6:
    # block 0x00517cc6: entered by fall-through, 8 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517cc6
    fxch st(1)                                   # 00517cca
    fstp tbyte ptr [esp]                         # 00517ccc
    call FUN_00517a70                            # 00517ccf
    fxch st(1)                                   # 00517cd4
    fld tbyte ptr [esp + stk_c]                  # 00517cd6
    add esp, 0x2c                                # 00517cda
    ret                                          # 00517cdd
L_00517cde:
    # block 0x00517cde: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517cde
    fxch st(1)                                   # 00517ce2
    fstp tbyte ptr [esp]                         # 00517ce4
    call FUN_00517a70                            # 00517ce7
    fxch st(1)                                   # 00517cec
    add esp, 0x2c                                # 00517cee
    ret                                          # 00517cf1
L_00517cf2:
    # block 0x00517cf2: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517cf2
    fxch st(2)                                   # 00517cf6
    fld st(0)                                    # 00517cf8
    fstp tbyte ptr [esp]                         # 00517cfa
    fstp tbyte ptr [esp + stk_20]                # 00517cfd
    call FUN_00517a70                            # 00517d01
    fxch st(2)                                   # 00517d06
    fld tbyte ptr [esp + stk_20]                 # 00517d08
    fxch st(3)                                   # 00517d0c
    add esp, 0x2c                                # 00517d0e
    ret                                          # 00517d11
L_00517d12:
    # block 0x00517d12: entered by fall-through, 2 instruction(s), falls into the block at 0x00517d17
    add esp, 0x2c                                # 00517d12
    int 0x6                                      # 00517d15
L_00517d17:
    # block 0x00517d17: entered by fall-through, 9 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517d17
    fxch st(2)                                   # 00517d1a
    fstp tbyte ptr [esp + stk_c]                 # 00517d1c
    call FUN_00517a70                            # 00517d20
    fxch st(2)                                   # 00517d25
    fld tbyte ptr [esp + stk_c]                  # 00517d27
    fxch st(3)                                   # 00517d2b
    add esp, 0x2c                                # 00517d2d
    ret                                          # 00517d30
L_00517d31:
    # block 0x00517d31: entered by fall-through, 2 instruction(s), falls into the block at 0x00517d36
    add esp, 0x2c                                # 00517d31
    int 0x6                                      # 00517d34
L_00517d36:
    # block 0x00517d36: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fxch st(3)                                   # 00517d36
    fstp tbyte ptr [esp + stk_c]                 # 00517d38
    fxch st(2)                                   # 00517d3c
    fld st(0)                                    # 00517d3e
    fstp tbyte ptr [esp]                         # 00517d40
    fstp tbyte ptr [esp + stk_20]                # 00517d43
    call FUN_00517a70                            # 00517d47
    fxch st(2)                                   # 00517d4c
    fld tbyte ptr [esp + stk_20]                 # 00517d4e
    add esp, 0x2c                                # 00517d52
    ret                                          # 00517d55
L_00517d56:
    # block 0x00517d56: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517d56
    fxch st(2)                                   # 00517d59
    fstp tbyte ptr [esp + stk_c]                 # 00517d5b
    call FUN_00517a70                            # 00517d5f
    fxch st(2)                                   # 00517d64
    add esp, 0x2c                                # 00517d66
    ret                                          # 00517d69
L_00517d6a:
    # block 0x00517d6a: entered by fall-through, 8 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517d6a
    fxch st(2)                                   # 00517d6e
    fstp tbyte ptr [esp]                         # 00517d70
    call FUN_00517a70                            # 00517d73
    fxch st(2)                                   # 00517d78
    fld tbyte ptr [esp + stk_c]                  # 00517d7a
    add esp, 0x2c                                # 00517d7e
    ret                                          # 00517d81
L_00517d82:
    # block 0x00517d82: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517d82
    fxch st(2)                                   # 00517d86
    fstp tbyte ptr [esp]                         # 00517d88
    call FUN_00517a70                            # 00517d8b
    fxch st(2)                                   # 00517d90
    add esp, 0x2c                                # 00517d92
    ret                                          # 00517d95
L_00517d96:
    # block 0x00517d96: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517d96
    fxch st(3)                                   # 00517d9a
    fld st(0)                                    # 00517d9c
    fstp tbyte ptr [esp]                         # 00517d9e
    fstp tbyte ptr [esp + stk_20]                # 00517da1
    call FUN_00517a70                            # 00517da5
    fxch st(3)                                   # 00517daa
    fld tbyte ptr [esp + stk_20]                 # 00517dac
    fxch st(4)                                   # 00517db0
    add esp, 0x2c                                # 00517db2
    ret                                          # 00517db5
L_00517db6:
    # block 0x00517db6: entered by fall-through, 2 instruction(s), falls into the block at 0x00517dbb
    add esp, 0x2c                                # 00517db6
    int 0x6                                      # 00517db9
L_00517dbb:
    # block 0x00517dbb: entered by fall-through, 9 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517dbb
    fxch st(3)                                   # 00517dbe
    fstp tbyte ptr [esp + stk_c]                 # 00517dc0
    call FUN_00517a70                            # 00517dc4
    fxch st(3)                                   # 00517dc9
    fld tbyte ptr [esp + stk_c]                  # 00517dcb
    fxch st(4)                                   # 00517dcf
    add esp, 0x2c                                # 00517dd1
    ret                                          # 00517dd4
L_00517dd5:
    # block 0x00517dd5: entered by fall-through, 2 instruction(s), falls into the block at 0x00517dda
    add esp, 0x2c                                # 00517dd5
    int 0x6                                      # 00517dd8
L_00517dda:
    # block 0x00517dda: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fxch st(4)                                   # 00517dda
    fstp tbyte ptr [esp + stk_c]                 # 00517ddc
    fxch st(3)                                   # 00517de0
    fld st(0)                                    # 00517de2
    fstp tbyte ptr [esp]                         # 00517de4
    fstp tbyte ptr [esp + stk_20]                # 00517de7
    call FUN_00517a70                            # 00517deb
    fxch st(3)                                   # 00517df0
    fld tbyte ptr [esp + stk_20]                 # 00517df2
    add esp, 0x2c                                # 00517df6
    ret                                          # 00517df9
L_00517dfa:
    # block 0x00517dfa: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517dfa
    fxch st(3)                                   # 00517dfd
    fstp tbyte ptr [esp + stk_c]                 # 00517dff
    call FUN_00517a70                            # 00517e03
    fxch st(3)                                   # 00517e08
    add esp, 0x2c                                # 00517e0a
    ret                                          # 00517e0d
L_00517e0e:
    # block 0x00517e0e: entered by fall-through, 8 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517e0e
    fxch st(3)                                   # 00517e12
    fstp tbyte ptr [esp]                         # 00517e14
    call FUN_00517a70                            # 00517e17
    fxch st(3)                                   # 00517e1c
    fld tbyte ptr [esp + stk_c]                  # 00517e1e
    add esp, 0x2c                                # 00517e22
    ret                                          # 00517e25
L_00517e26:
    # block 0x00517e26: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517e26
    fxch st(3)                                   # 00517e2a
    fstp tbyte ptr [esp]                         # 00517e2c
    call FUN_00517a70                            # 00517e2f
    fxch st(3)                                   # 00517e34
    add esp, 0x2c                                # 00517e36
    ret                                          # 00517e39
L_00517e3a:
    # block 0x00517e3a: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517e3a
    fxch st(4)                                   # 00517e3e
    fld st(0)                                    # 00517e40
    fstp tbyte ptr [esp]                         # 00517e42
    fstp tbyte ptr [esp + stk_20]                # 00517e45
    call FUN_00517a70                            # 00517e49
    fxch st(4)                                   # 00517e4e
    fld tbyte ptr [esp + stk_20]                 # 00517e50
    fxch st(5)                                   # 00517e54
    add esp, 0x2c                                # 00517e56
    ret                                          # 00517e59
L_00517e5a:
    # block 0x00517e5a: entered by fall-through, 2 instruction(s), falls into the block at 0x00517e5f
    add esp, 0x2c                                # 00517e5a
    int 0x6                                      # 00517e5d
L_00517e5f:
    # block 0x00517e5f: entered by fall-through, 9 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517e5f
    fxch st(4)                                   # 00517e62
    fstp tbyte ptr [esp + stk_c]                 # 00517e64
    call FUN_00517a70                            # 00517e68
    fxch st(4)                                   # 00517e6d
    fld tbyte ptr [esp + stk_c]                  # 00517e6f
    fxch st(5)                                   # 00517e73
    add esp, 0x2c                                # 00517e75
    ret                                          # 00517e78
L_00517e79:
    # block 0x00517e79: entered by fall-through, 2 instruction(s), falls into the block at 0x00517e7e
    add esp, 0x2c                                # 00517e79
    int 0x6                                      # 00517e7c
L_00517e7e:
    # block 0x00517e7e: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fxch st(5)                                   # 00517e7e
    fstp tbyte ptr [esp + stk_c]                 # 00517e80
    fxch st(4)                                   # 00517e84
    fld st(0)                                    # 00517e86
    fstp tbyte ptr [esp]                         # 00517e88
    fstp tbyte ptr [esp + stk_20]                # 00517e8b
    call FUN_00517a70                            # 00517e8f
    fxch st(4)                                   # 00517e94
    fld tbyte ptr [esp + stk_20]                 # 00517e96
    add esp, 0x2c                                # 00517e9a
    ret                                          # 00517e9d
L_00517e9e:
    # block 0x00517e9e: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517e9e
    fxch st(4)                                   # 00517ea1
    fstp tbyte ptr [esp + stk_c]                 # 00517ea3
    call FUN_00517a70                            # 00517ea7
    fxch st(4)                                   # 00517eac
    add esp, 0x2c                                # 00517eae
    ret                                          # 00517eb1
L_00517eb2:
    # block 0x00517eb2: entered by fall-through, 8 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517eb2
    fxch st(4)                                   # 00517eb6
    fstp tbyte ptr [esp]                         # 00517eb8
    call FUN_00517a70                            # 00517ebb
    fxch st(4)                                   # 00517ec0
    fld tbyte ptr [esp + stk_c]                  # 00517ec2
    add esp, 0x2c                                # 00517ec6
    ret                                          # 00517ec9
L_00517eca:
    # block 0x00517eca: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517eca
    fxch st(4)                                   # 00517ece
    fstp tbyte ptr [esp]                         # 00517ed0
    call FUN_00517a70                            # 00517ed3
    fxch st(4)                                   # 00517ed8
    add esp, 0x2c                                # 00517eda
    ret                                          # 00517edd
L_00517ede:
    # block 0x00517ede: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517ede
    fxch st(5)                                   # 00517ee2
    fld st(0)                                    # 00517ee4
    fstp tbyte ptr [esp]                         # 00517ee6
    fstp tbyte ptr [esp + stk_20]                # 00517ee9
    call FUN_00517a70                            # 00517eed
    fxch st(5)                                   # 00517ef2
    fld tbyte ptr [esp + stk_20]                 # 00517ef4
    fxch st(6)                                   # 00517ef8
    add esp, 0x2c                                # 00517efa
    ret                                          # 00517efd
L_00517efe:
    # block 0x00517efe: entered by fall-through, 2 instruction(s), falls into the block at 0x00517f03
    add esp, 0x2c                                # 00517efe
    int 0x6                                      # 00517f01
L_00517f03:
    # block 0x00517f03: entered by fall-through, 9 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517f03
    fxch st(5)                                   # 00517f06
    fstp tbyte ptr [esp + stk_c]                 # 00517f08
    call FUN_00517a70                            # 00517f0c
    fxch st(5)                                   # 00517f11
    fld tbyte ptr [esp + stk_c]                  # 00517f13
    fxch st(6)                                   # 00517f17
    add esp, 0x2c                                # 00517f19
    ret                                          # 00517f1c
L_00517f1d:
    # block 0x00517f1d: entered by fall-through, 2 instruction(s), falls into the block at 0x00517f22
    add esp, 0x2c                                # 00517f1d
    int 0x6                                      # 00517f20
L_00517f22:
    # block 0x00517f22: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fxch st(6)                                   # 00517f22
    fstp tbyte ptr [esp + stk_c]                 # 00517f24
    fxch st(5)                                   # 00517f28
    fld st(0)                                    # 00517f2a
    fstp tbyte ptr [esp]                         # 00517f2c
    fstp tbyte ptr [esp + stk_20]                # 00517f2f
    call FUN_00517a70                            # 00517f33
    fxch st(5)                                   # 00517f38
    fld tbyte ptr [esp + stk_20]                 # 00517f3a
    add esp, 0x2c                                # 00517f3e
    ret                                          # 00517f41
L_00517f42:
    # block 0x00517f42: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517f42
    fxch st(5)                                   # 00517f45
    fstp tbyte ptr [esp + stk_c]                 # 00517f47
    call FUN_00517a70                            # 00517f4b
    fxch st(5)                                   # 00517f50
    add esp, 0x2c                                # 00517f52
    ret                                          # 00517f55
L_00517f56:
    # block 0x00517f56: entered by fall-through, 8 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517f56
    fxch st(5)                                   # 00517f5a
    fstp tbyte ptr [esp]                         # 00517f5c
    call FUN_00517a70                            # 00517f5f
    fxch st(5)                                   # 00517f64
    fld tbyte ptr [esp + stk_c]                  # 00517f66
    add esp, 0x2c                                # 00517f6a
    ret                                          # 00517f6d
L_00517f6e:
    # block 0x00517f6e: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517f6e
    fxch st(5)                                   # 00517f72
    fstp tbyte ptr [esp]                         # 00517f74
    call FUN_00517a70                            # 00517f77
    fxch st(5)                                   # 00517f7c
    add esp, 0x2c                                # 00517f7e
    ret                                          # 00517f81
L_00517f82:
    # block 0x00517f82: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517f82
    fxch st(6)                                   # 00517f86
    fld st(0)                                    # 00517f88
    fstp tbyte ptr [esp]                         # 00517f8a
    fstp tbyte ptr [esp + stk_20]                # 00517f8d
    call FUN_00517a70                            # 00517f91
    fxch st(6)                                   # 00517f96
    fld tbyte ptr [esp + stk_20]                 # 00517f98
    fxch st(7)                                   # 00517f9c
    add esp, 0x2c                                # 00517f9e
    ret                                          # 00517fa1
L_00517fa2:
    # block 0x00517fa2: entered by fall-through, 2 instruction(s), falls into the block at 0x00517fa7
    add esp, 0x2c                                # 00517fa2
    int 0x6                                      # 00517fa5
L_00517fa7:
    # block 0x00517fa7: entered by fall-through, 9 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517fa7
    fxch st(6)                                   # 00517faa
    fstp tbyte ptr [esp + stk_c]                 # 00517fac
    call FUN_00517a70                            # 00517fb0
    fxch st(6)                                   # 00517fb5
    fld tbyte ptr [esp + stk_c]                  # 00517fb7
    fxch st(7)                                   # 00517fbb
    add esp, 0x2c                                # 00517fbd
    ret                                          # 00517fc0
L_00517fc1:
    # block 0x00517fc1: entered by fall-through, 2 instruction(s), falls into the block at 0x00517fc6
    add esp, 0x2c                                # 00517fc1
    int 0x6                                      # 00517fc4
L_00517fc6:
    # block 0x00517fc6: entered by fall-through, 11 instruction(s), calls FUN_00517a70, ends with ret
    fxch st(7)                                   # 00517fc6
    fstp tbyte ptr [esp + stk_c]                 # 00517fc8
    fxch st(6)                                   # 00517fcc
    fld st(0)                                    # 00517fce
    fstp tbyte ptr [esp]                         # 00517fd0
    fstp tbyte ptr [esp + stk_20]                # 00517fd3
    call FUN_00517a70                            # 00517fd7
    fxch st(6)                                   # 00517fdc
    fld tbyte ptr [esp + stk_20]                 # 00517fde
    add esp, 0x2c                                # 00517fe2
    ret                                          # 00517fe5
L_00517fe6:
    # block 0x00517fe6: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp]                         # 00517fe6
    fxch st(6)                                   # 00517fe9
    fstp tbyte ptr [esp + stk_c]                 # 00517feb
    call FUN_00517a70                            # 00517fef
    fxch st(6)                                   # 00517ff4
    add esp, 0x2c                                # 00517ff6
    ret                                          # 00517ff9
L_00517ffa:
    # block 0x00517ffa: entered by fall-through, 8 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00517ffa
    fxch st(6)                                   # 00517ffe
    fstp tbyte ptr [esp]                         # 00518000
    call FUN_00517a70                            # 00518003
    fxch st(6)                                   # 00518008
    fld tbyte ptr [esp + stk_c]                  # 0051800a
    add esp, 0x2c                                # 0051800e
    ret                                          # 00518011
L_00518012:
    # block 0x00518012: entered by fall-through, 7 instruction(s), calls FUN_00517a70, ends with ret
    fstp tbyte ptr [esp + stk_c]                 # 00518012
    fxch st(6)                                   # 00518016
    fstp tbyte ptr [esp]                         # 00518018
    call FUN_00517a70                            # 0051801b
    fxch st(6)                                   # 00518020
    add esp, 0x2c                                # 00518022
    ret                                          # 00518025

