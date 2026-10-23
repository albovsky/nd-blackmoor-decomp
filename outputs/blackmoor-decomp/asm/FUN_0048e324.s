# FUN_0048e324
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e324
# extent:       0x0048e324-0x0048e393 (111 code bytes)
# span:         0x0048e324-0x0048e393 (code 111, tables 0, padding 0)
# sha256:       31c1a6c5c4799114f46aa5228bfc756a465f311e730a09e2f76521482ca203c9
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048e324
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------

.org 0x0048e324 - 0x401000
.globl FUN_0048e324
FUN_0048e324:
    # block 0x0048e324: entry, 7 instruction(s), ends with forward jump to 0x0048e342
    push ebp                                     # 0048e324
    {load} mov ebp, esp                          # 0048e325
    sub esp, 0x8                                 # 0048e327
    push edi                                     # 0048e32a
    mov dword ptr [ebp - local_8], ecx           # 0048e32b
    mov word ptr [ebp - local_4], 0x0            # 0048e32e
    jmp.d8 L_0048e342                            # 0048e334
L_0048e336:
    # block 0x0048e336: entered by jmp at 0x0048e38c, 3 instruction(s), falls into the block at 0x0048e342
    mov ax, word ptr [ebp - local_4]             # 0048e336
    .insn 0x66, 0x05, 0x0001{:u16}               # 0048e33a
    mov word ptr [ebp - local_4], ax             # 0048e33e
L_0048e342:
    # block 0x0048e342: entered by jmp at 0x0048e334, 3 instruction(s), ends with jge to 0x0048e38e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0048e342
    cmp ecx, 0x19                                # 0048e346
    jge.d8 L_0048e38e                            # 0048e349
    # block 0x0048e34b: entered by fall-through of jge at 0x0048e349, 14 instruction(s), ends with backward jump to 0x0048e336
    movsx edx, word ptr [ebp - local_4]          # 0048e34b
    imul edx, edx, 0x204                         # 0048e34f
    mov word ptr [edx + 0x591b1c], 0x0           # 0048e355
    movsx eax, word ptr [ebp - local_4]          # 0048e35e
    imul eax, eax, 0x204                         # 0048e362
    mov word ptr [eax + 0x591b1e], 0x270f        # 0048e368
    mov ecx, 0x7f                                # 0048e371
    {load} xor eax, eax                          # 0048e376
    movsx edi, word ptr [ebp - local_4]          # 0048e378
    imul edi, edi, 0x204                         # 0048e37c
    add edi, 0x591b22                            # 0048e382
    rep stosd dword ptr es:[edi], eax            # 0048e388
    stosw word ptr es:[edi], ax                  # 0048e38a
    jmp.d8 L_0048e336                            # 0048e38c
L_0048e38e:
    # block 0x0048e38e: entered by jge at 0x0048e349, 4 instruction(s), ends with ret
    pop edi                                      # 0048e38e
    {load} mov esp, ebp                          # 0048e38f
    pop ebp                                      # 0048e391
    ret                                          # 0048e392

