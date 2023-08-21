(module
  (func $even_check (param $n i32) (result i32)
    local.get $n
    i32.const 2
    i32.rem_u
    i32.const 0
    i32.eq
  )
  (func $eq_2 (param $n i32) (result i32)
    local.get $n
    i32.const 2
    i32.eq
  )
  (func $multiple_check (param $n i32) (param $m i32) (result i32)
    local.get $n
    local.get $m
    i32.rem_u
    i32.const 0
    i32.eq
  )
  (func (export "is_prime") (param $n i32) (result i32)
  (local $i i32)
  (if (i32.eq (local.get $n) (i32.const 1))
    (then
      i32.const 0 ;; 1は素数ではない
      return
    )
  )
  ;; $n が 2 かどうかを調べる
  (if (call $eq_2 (local.get $n))
    (then
      i32.const 1
      return
    )
  )
  ;; 2 は素数
  (block $not_prime
    (call $even_check (local.get $n))
      br_if $not_prime ;; (2 以外の)偶数は素数ではない
      (local.set $i (i32.const 1))
      (loop $prime_test_loop
          (local.tee $i
            (i32.add (local.get $i) (i32.const 2))  ;; $i += 2
          )
          local.get $n    ;; stack = [$n, $i]
          i32.ge_u        ;; $i >= $n
          if              ;; $i >= $n の場合,$n は素数
            i32.const 1
            return
          end
          (call $multiple_check (local.get $n) (local.get $i))
          br_if $not_prime ;; $n が$i の倍数の場合は素数ではない
          br $prime_test_loop ;; ループの先頭に戻る
      );; $prime test loop ループの終わり
    ) ;; $not prime ブロックの終わり
    i32.const 0 ;; false を返す
  )
)
