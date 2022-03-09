save:
        mov LEFT, acc                ; Get y0.
        swp                         ; Duplicate to bak.
        mov LEFT, acc                ; Get h.
transmit:
        jez save                    ; If remaining height is 0, restart.
        mov acc, RIGHT               ; Transmit remaining height.
        sub 1                       ; Decrement remaining height
foo:    swp                         ; Put remaining height in acc and current y
                                    ;   in bak.
        mov acc, RIGHT               ; Transmit current y.
        add 1                       ; increment current y.
        swp                         ; Put remaining height in acc and current y
                                    ;   in bak.
        jmp transmit                ; Loop around.
        jmp foo
