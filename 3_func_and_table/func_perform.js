const fs = require(`fs`);
const bytes = fs.readFileSync(__dirname + `/func_perform.wasm`);

let i = 0;
let importObject = {
  js: {
    external_call: function () {
      // インポートされる JavaScript 関数
      // 変数 i をインクリメントして返す
      i++;
      return i;
    },
  },
};

(async () => {
  const obj = await WebAssembly.instantiate(
    new Uint8Array(bytes),
    importObject
  );
  // obj.instance.exports からの wasm_call と js_call の分割代入
  ({ wasm_call, js_call } = obj.instance.exports);
  let start = Date.now();
  // WebAssembly モジュールから wasm_call を呼び出す
  wasm_call();
  let time = Date.now() - start;
  console.log(`wasm_call time=` + time); // 実行時間(ミリ秒)
  start = Date.now();
  // WebAssembly モジュールから js_call を呼び出す
  js_call();
  time = Date.now() - start;
  console.log(`js_call time=` + time); // 実行時間(ミリ秒)
})();
