"use strict";
module.exports = function({ $std_Json, $std_String }) {
  class $Closure2 {
    constructor({  }) {
      const $obj = (...args) => this.handle(...args);
      Object.setPrototypeOf($obj, this);
      return $obj;
    }
    async handle(req) {
      const folder = ((obj, args) => { if (obj[args] === undefined) throw new Error(`Json property "${args}" does not exist`); return obj[args] })((JSON.parse((req.body ?? ""))), "folder");
      return ({"status": 200, "body": (await $std_String.fromJson(folder))});
    }
  }
  return $Closure2;
}
//# sourceMappingURL=inflight.$Closure2-1.js.map