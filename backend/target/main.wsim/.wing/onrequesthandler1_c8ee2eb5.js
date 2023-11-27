"use strict";
exports.handler = async function(event) {
  return await (
          (await (async () => {
            const $Closure2Client = 
          require("./inflight.$Closure2-1.js")({
            $std_Json: require("/Users/eyalkeren/.nvm/versions/node/v18.17.0/lib/node_modules/winglang/node_modules/@winglang/sdk/lib/std/json.js").Json,
          })
        ;
            const client = new $Closure2Client({
            });
            if (client.$inflight_init) { await client.$inflight_init(); }
            return client;
          })())
        ).handle(event);
};