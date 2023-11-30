"use strict";
exports.handler = async function(event) {
  return await (
          (await (async () => {
            const $Closure2Client = 
          require("./inflight.$Closure2-1.js")({
            $std_Json: require("/opt/homebrew/lib/node_modules/winglang/node_modules/@winglang/sdk/lib/std/json.js").Json,
            $std_String: require("/opt/homebrew/lib/node_modules/winglang/node_modules/@winglang/sdk/lib/std/string.js").String,
          })
        ;
            const client = new $Closure2Client({
            });
            if (client.$inflight_init) { await client.$inflight_init(); }
            return client;
          })())
        ).handle(event);
};