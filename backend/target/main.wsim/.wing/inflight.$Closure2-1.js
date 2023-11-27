"use strict";
module.exports = function({ $std_Json }) {
  class $Closure2 {
    constructor({  }) {
      const $obj = (...args) => this.handle(...args);
      Object.setPrototypeOf($obj, this);
      return $obj;
    }
    async handle(req) {
      const f = ((obj, key) => { if (!(key in obj)) throw new Error(`Map does not contain key: "${key}"`); return obj[key]; })(req.vars, "folder");
      return ({"status": 200, "body": ((args) => { return JSON.stringify(args[0], null, args[1]?.indent) })([[String.raw({ raw: ["", "a"] }, f), String.raw({ raw: ["", "b"] }, f)]])});
    }
  }
  return $Closure2;
}
//# sourceMappingURL=inflight.$Closure2-1.js.map