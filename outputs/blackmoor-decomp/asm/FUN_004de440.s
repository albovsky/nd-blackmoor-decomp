# FUN_004de440
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de440
# extent:       0x004de440-0x004de4f9 (185 code bytes)
# span:         0x004de440-0x004de4f9 (code 185, tables 0, padding 0)
# sha256:       9fb325bc5933ae1ffdd1a5d4f937ca66faddf167029061fa553439cf8cdf96eb
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de440
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ee69e, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_004ee69e, .text + (0x004ee69e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004de440 - 0x401000
.globl FUN_004de440
FUN_004de440:
    # block 0x004de440: entry, 23 instruction(s), calls FUN_004ee69e, FUN_0050ce04, ends with jge to 0x004de4a8 (forward)
    push ebp                                     # 004de440
    {load} mov ebp, esp                          # 004de441
    sub esp, 0x14                                # 004de443
    mov dword ptr [ebp - local_8], ecx           # 004de446
    mov ecx, dword ptr [ebp - local_8]           # 004de449
    call FUN_004ee69e                            # 004de44c
    mov dword ptr [ebp - local_4], eax           # 004de451
    fild dword ptr [ebp - local_4]               # 004de454
    fstp dword ptr [ebp - local_c]               # 004de457
    fld dword ptr [ebp - local_c]                # 004de45a
    fdiv dword ptr [0x52cbec]                    # 004de45d
    fstp dword ptr [0x5b0a78]                    # 004de463
    movsx eax, word ptr [0x5b0a7c]               # 004de469
    mov dword ptr [ebp - local_10], eax          # 004de470
    fild dword ptr [ebp - local_10]              # 004de473
    fstp dword ptr [ebp - local_14]              # 004de476
    fld dword ptr [0x5b0a78]                     # 004de479
    fmul dword ptr [ebp - local_14]              # 004de47f
    call FUN_0050ce04                            # 004de482
    mov dword ptr [0x5b0a82], eax                # 004de487
    mov ecx, dword ptr [0x5b0a82]                # 004de48c
    cmp ecx, dword ptr [0x5b0a26]                # 004de492
    jge.d8 L_004de4a8                            # 004de498
    # block 0x004de49a: entered by fall-through of jge at 0x004de498, 3 instruction(s), ends with forward jump to 0x004de4db
    mov edx, dword ptr [0x5b0a26]                # 004de49a
    mov dword ptr [0x5b0a82], edx                # 004de4a0
    jmp.d8 L_004de4db                            # 004de4a6
L_004de4a8:
    # block 0x004de4a8: entered by jge at 0x004de498, 6 instruction(s), ends with jle to 0x004de4db (forward)
    mov eax, dword ptr [0x5b0a1e]                # 004de4a8
    sub eax, dword ptr [0x5b0a16]                # 004de4ad
    mov ecx, dword ptr [0x5b0a82]                # 004de4b3
    {load} add ecx, eax                          # 004de4b9
    cmp ecx, dword ptr [0x5b0a2e]                # 004de4bb
    jle.d8 L_004de4db                            # 004de4c1
    # block 0x004de4c3: entered by fall-through of jle at 0x004de4c1, 5 instruction(s), falls into the block at 0x004de4db
    mov edx, dword ptr [0x5b0a1e]                # 004de4c3
    sub edx, dword ptr [0x5b0a16]                # 004de4c9
    mov eax, dword ptr [0x5b0a2e]                # 004de4cf
    {load} sub eax, edx                          # 004de4d4
    mov dword ptr [0x5b0a82], eax                # 004de4d6
L_004de4db:
    # block 0x004de4db: entered by jmp at 0x004de4a6; jle at 0x004de4c1, 8 instruction(s), ends with ret
    mov ecx, dword ptr [0x5b0a1e]                # 004de4db
    sub ecx, dword ptr [0x5b0a16]                # 004de4e1
    mov edx, dword ptr [0x5b0a82]                # 004de4e7
    {load} add edx, ecx                          # 004de4ed
    mov dword ptr [0x5b0a8a], edx                # 004de4ef
    {load} mov esp, ebp                          # 004de4f5
    pop ebp                                      # 004de4f7
    ret                                          # 004de4f8

