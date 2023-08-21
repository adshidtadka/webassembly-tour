const fs = require(`fs`);
const export_bytes = fs.readFileSync(__dirname + `/table_export.wasm`);
const test_bytes = fs.readFileSync(__dirname + `/table_test.wasm`);
let i = 0;
let increment = () => {
  i++;
  return i;
};
let decrement = () => {
  i--;
  return i;
};
const importObject = {
  js: {
    // tbl の初期値は null で,2 つ目の WASM モジュールのために設定される
    tbl: null,
    // JavaScript の increment 関数
    increment: increment,
    // JavaScript の decrement 関数
    decrement: decrement,
    // 初期値は null で,2 つ目のモジュールで作成された関数が設定される
    wasm_increment: null,
    // 初期値は null で,2 つ目のモジュールで作成された関数が設定される
    wasm_decrement: null,
  },
};

(async () => {
  // 関数テーブルを使うモジュールをインスタンス化
  let table_exp_obj = await WebAssembly.instantiate(
    new Uint8Array(export_bytes),
    importObject
  ); // エクスポートされたテーブルを tbl 変数に割り当てる
  importObject.js.tbl = table_exp_obj.instance.exports.tbl;
  importObject.js.wasm_increment = table_exp_obj.instance.exports.increment;
  importObject.js.wasm_decrement = table_exp_obj.instance.exports.decrement;
  let obj = await WebAssembly.instantiate(
    new Uint8Array(test_bytes),
    importObject
  );

  // 分割代入構文を使って exports から JavaScript 関数を作成
  ({ js_table_test, js_import_test, wasm_table_test, wasm_import_test } =
    obj.instance.exports);

  i = 0; // iを再び0に初期化
  let start = Date.now();
  js_table_test();
  let time = Date.now() - start; // 実行にかかった時間を計算
  console.log(`js_table_test time=` + time);

  i = 0; // iを再び0に初期化
  start = Date.now(); // 開始タイムスタンプを取得 // JavaScript の直接の import 呼び出しをテストする関数を実行
  js_import_test();
  time = Date.now() - start; // 実行にかかった時間を計算
  console.log(`js_import_test time=` + time);

  i = 0; // iを再び0に初期化
  start = Date.now(); // 開始タイムスタンプを取得 // WASM のテーブル呼び出しをテストする関数を実行
  wasm_table_test();
  time = Date.now() - start; // 実行にかかった時間を計算
  console.log(`wasm_table_test time=` + time);

  i = 0; // iを再び0に初期化
  start = Date.now(); // 開始タイムスタンプを取得 // WASM の直接の import 呼び出しをテストする関数を実行
  wasm_import_test();
  time = Date.now() - start; // 実行にかかった時間を計算
  console.log(`wasm_import_test time=` + time);
})();
