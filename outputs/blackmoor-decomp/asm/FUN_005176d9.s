# FUN_005176d9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005176d9
# extent:       0x005176d9-0x0051771b (66 code bytes)
# span:         0x005176d9-0x0051771b (code 66, tables 0, padding 0)
# sha256:       ee2d07beb0a943b07cd84542393a20b66d6f82ade97141a8cf5a16d06e57ca33
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005176d9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4
# callees:      calls FUN_0050ea7e, FUN_0050ea87
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_0050ea87, .text + (0x0050ea87 - 0x401000)

.org 0x005176d9 - 0x401000
.globl FUN_005176d9
FUN_005176d9:
    # block 0x005176d9: entry, 3 instruction(s), ends with jae to 0x00517704 (forward)
    mov eax, dword ptr [esp + stk_4]             # 005176d9
    cmp eax, dword ptr [0x63cee0]                # 005176dd
    jae.d8 L_00517704                            # 005176e3
    # block 0x005176e5: entered by fall-through of jae at 0x005176e3, 8 instruction(s), ends with je to 0x00517704 (forward)
    {load} mov ecx, eax                          # 005176e5
    and eax, 0x1f                                # 005176e7
    sar ecx, 0x5                                 # 005176ea
    lea eax, [eax + 8*eax]                       # 005176ed
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 005176f0
    test byte ptr [ecx + 4*eax + field_4], 0x1   # 005176f7
    lea eax, [ecx + 4*eax]                       # 005176fc
    je.d8 L_00517704                             # 005176ff
    # block 0x00517701: entered by fall-through of je at 0x005176ff, 2 instruction(s), ends with ret
    mov eax, dword ptr [eax]                     # 00517701
    ret                                          # 00517703
L_00517704:
    # block 0x00517704: entered by jae at 0x005176e3; je at 0x005176ff, 6 instruction(s), calls FUN_0050ea7e, FUN_0050ea87, ends with ret
    call FUN_0050ea7e                            # 00517704
    mov dword ptr [eax], 0x9                     # 00517709
    call FUN_0050ea87                            # 0051770f
    and dword ptr [eax], 0x0                     # 00517714
    or eax, -0x1                                 # 00517717
    ret                                          # 0051771a

