(module
    ;; JavaScript 関数の外部からの呼び出し
    (import "js" "external_call" (func $external_call (result i32))) ;; 内部関数のためのグローバル変数
    (global $i (mut i32) (i32.const 0))
    (func $internal_call (result i32) ;; i32 を呼び出し元の関数に返す - 􏰀
        global.get $i
        i32.const 1
        i32.add
        global.set $i ;; 最初の 4 行は$i をインクリメントするコード
        global.get $i ;; $i を呼び出し元の関数に返す
    )
    (func (export "wasm_call")
        (loop $again
            call $internal_call
            i32.const 4_000_000
            i32.le_u
            br_if $again
        )
    )
    (func (export "js_call")
        (loop $again
            ;; インポートした$external call 関数を呼び出す
            (call $external_call)
            i32.const 4_000_000
            i32.le_u ;; $external call から返された値は 4,000,000 以下か?
            br_if $again ;; そうであれば, ループの先頭へ移動
        )
    )
)
