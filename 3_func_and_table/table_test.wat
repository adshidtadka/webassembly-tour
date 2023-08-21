(module
    (import "js" "tbl" (table $tbl 4 anyfunc))
    ;; increment 関数をインポート
    (import "js" "increment" (func $increment (result i32)))
    (import "js" "decrement" (func $decrement (result i32)))
    ;; wasm_increment 関数をインポート
    (import "js" "wasm_increment" (func $wasm_increment (result i32)))
    (import "js" "wasm_decrement" (func $wasm_decrement (result i32)))
    ;; テーブル関数の型定義はすべて i32 であり, パラメータはない
    (type $returns_i32 (func (result i32)))
    ;; JavaScript の increment 関数のテーブルインデックス
    (global $inc_ptr i32 (i32.const 0))
    ;; JavaScript の decrement 関数のテーブルインデックス
    (global $dec_ptr i32 (i32.const 1))
    ;; WASM の increment 関数のインデックス
    (global $wasm_inc_ptr i32 (i32.const 2))
    ;; WASM の decrement 関数のインデックス
    (global $wasm_dec_ptr i32 (i32.const 3))

    ;; JavaScript 関数の間接的な呼び出しのパフォーマンスをテスト
    (func (export "js_table_test")
        (loop $inc_cycle
            ;; JavaScript の increment 関数を間接的に呼び出す
            (call_indirect (type $returns_i32) (global.get $inc_ptr)) i32.const 4_000_000
            i32.le_u ;; $inc_ptr から返された値は 4,000,000 以下か?
            br_if $inc_cycle  ;; そうであればループを繰り返す
        )
        (loop $dec_cycle
            ;; JavaScript の decrement 関数を間接的に呼び出す
            (call_indirect (type $returns_i32) (global.get $dec_ptr)) i32.const 4_000_000
            i32.le_u ;; $dec_ptr から返された値は 4,000,000 以下か?
            br_if $dec_cycle  ;; そうであればループを繰り返す
        )
    )
    ;; JavaScript 関数の直接の呼び出しのパフォーマンスをテスト
    (func (export "js_import_test")
        (loop $inc_cycle
            ;; JavaScript の increment 関数を直接呼び出す
            call $increment
            i32.const 4_000_000
            i32.le_u ;; $increment から返された値は 4,000,000 以下か?
            br_if $inc_cycle  ;; そうであればループを繰り返す
        )
        (loop $dec_cycle
            ;; JavaScript の decrement 関数を直接呼び出す
            call $decrement
            i32.const 4_000_000
            i32.le_u ;; $decrement から返された値は 4,000,000 以下か?
            br_if $dec_cycle  ;; そうであればループを繰り返す
        )
    )
    ;; WASM 関数の間接的な呼び出しのパフォーマンスをテスト
    (func (export "wasm_table_test")
        (loop $inc_cycle
            ;; WASM の increment 関数を間接的に呼び出す
            (call_indirect (type $returns_i32) (global.get $wasm_inc_ptr)) i32.const 4_000_000
            i32.le_u ;; $wasm_inc_ptr から返された値は 4,000,000 以下か?
            br_if $inc_cycle  ;; そうであればループを繰り返す
        )
        (loop $dec_cycle
            ;; WASM の decrement 関数を間接的に呼び出す
            (call_indirect (type $returns_i32) (global.get $wasm_dec_ptr)) i32.const 4_000_000
            i32.le_u ;; $wasm_dec_ptr から返された値は 4,000,000 以下か?
            br_if $dec_cycle  ;; そうであればループを繰り返す
        )
    )
    ;; WASM 関数の直接の呼び出しのパフォーマンスをテスト
    (func (export "wasm_import_test")
        (loop $inc_cycle
            ;; WASM の increment 関数を直接呼び出す
            call $wasm_increment
            i32.const 4_000_000
            i32.le_u ;;
            br_if $inc_cycle  ;;
        )
        (loop $dec_cycle
            ;; WASM の decrement 関数を直接呼び出す
            call $wasm_decrement
            i32.const 4_000_000
            i32.le_u ;;
            br_if $dec_cycle  ;;
        )
    )
)
